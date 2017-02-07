
"""
A non-euclidean, hyperdimentional, cross-platform (win/osx/linux/bsd/quantum computers/etc) 
drawing package with extendend support for brownian motions and impossible colours - myoxocephalus
"""

import win32api
import win32con
import win32gui
from threading import Thread

class m0bsMagiskeTegneLib(object):
    def __init__(self):
        self.lines = []
        self.initialized = False
        Thread(target=self.createWindow).start() # Yolo

    def createWindow(self):
        self.wndClass = win32gui.WNDCLASS()
        self.wndClass.style = win32con.CS_HREDRAW | win32con.CS_VREDRAW
        self.wndClass.lpfnWndProc = self.wndProc
        self.wndClass.hInstance = win32api.GetModuleHandle()
        self.wndClass.hCursor = win32gui.LoadCursor(None, win32con.IDC_ARROW)
        self.wndClass.hbrBackground = win32gui.GetStockObject(win32con.WHITE_BRUSH)
        self.wndClass.lpszClassName = "TransparentNonInteractiveWindow"

        self.hWindow = win32gui.CreateWindowEx(
            win32con.WS_EX_COMPOSITED | win32con.WS_EX_LAYERED | win32con.WS_EX_NOACTIVATE | win32con.WS_EX_TOPMOST | win32con.WS_EX_TRANSPARENT,
            win32gui.RegisterClass(self.wndClass),
            None,
            win32con.WS_DISABLED | win32con.WS_POPUP | win32con.WS_VISIBLE,
            0,
            0,
            win32api.GetSystemMetrics(win32con.SM_CXSCREEN),
            win32api.GetSystemMetrics(win32con.SM_CYSCREEN),
            None,
            None,
            self.wndClass.hInstance,
            None)
        win32gui.SetLayeredWindowAttributes(self.hWindow, 0x00ffffff, 255, win32con.LWA_COLORKEY | win32con.LWA_ALPHA)
        win32gui.SetWindowPos(self.hWindow, win32con.HWND_TOPMOST, 0, 0, 0, 0,
                              win32con.SWP_NOACTIVATE | win32con.SWP_NOMOVE | win32con.SWP_NOSIZE | win32con.SWP_SHOWWINDOW)
        win32gui.PumpMessages()
        self.initialized = True

    @staticmethod
    def getScreenSize():
        return win32api.GetSystemMetrics(win32con.SM_CXSCREEN), win32api.GetSystemMetrics(win32con.SM_CYSCREEN)

    def drawLine(self, start, end, color, width):
        line = {'start' : start, 'end' : end, 'color' : color, 'width' : width }
        self.lines.append(line)

        if self.initialized:
            win32gui.InvalidateRect(self.hWnd, None, True)
            win32gui.UpdateWindow(self.hWnd)

    def toScreenCoord(self, hWnd, start, end):
        return win32gui.ScreenToClient(hWnd, (start[0], start[1])), win32gui.ScreenToClient(hWnd, (end[0], end[1]))

    def render(self, hWnd):
        for line in self.lines:            
            (x0, y0), (x1, y1) = self.toScreenCoord(hWnd, line['start'], line['end'])

            pen = win32gui.CreatePen(win32con.PS_SOLID, line['width'], win32api.RGB(line['color'][0], line['color'][1], line['color'][2]))
            win32gui.SelectObject(self.hdc, pen)
            win32gui.MoveToEx(self.hdc, x0, y0)
            win32gui.LineTo(self.hdc, x1, y1)

    def wndProc(self, hWnd, message, wParam, lParam):
        if message == win32con.WM_PAINT:
            self.hdc, paint = win32gui.BeginPaint(hWnd)

            self.render(hWnd)
            
            win32gui.ReleaseDC(hWnd, self.hdc)
            win32gui.EndPaint(hWnd, paint)
            return 0

        elif message == win32con.WM_DESTROY:
            win32gui.PostQuitMessage(0)
            return 0

        else:
            return win32gui.DefWindowProc(hWnd, message, wParam, lParam)


if __name__ == '__main__':
    # Hent skjermstørrelse
    screenSize = m0bsMagiskeTegneLib.getScreenSize()
    drawPos0 = [0, 0] # Venstre, Topp
    drawPos1 = [screenSize[0], screenSize[1]] # Høyre, Bunn
    drawPos2 = [screenSize[0], 0] # Høyre, Topp
    drawPos3 = [0, screenSize[1]] # Venstre, Bunn

    mtl = m0bsMagiskeTegneLib()
    mtl.drawLine(start=drawPos0, end=drawPos1, color=(255, 0, 0), width=5)
    mtl.drawLine(start=drawPos2, end=drawPos3, color=(255, 0, 0), width=5)
