Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23372CAED0
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbfJCTF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:05:59 -0400
Received: from mout.gmx.net ([212.227.17.20]:44661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbfJCTF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 15:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1570129548;
        bh=OyA7tBg5YMtNIh26NGTzP1/HqFUZJ2mQdIhSvOFlGnw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=eDVx/ctHMEjEz7W53PcudI0rNhYpAT9ioynpcwDBvoqKQfy1I/0IuRo5u3jxtMBCy
         V0EQlXUvkAnW8zavP4uC4nOt5E6ZJJjeFvsyK7mrOTreeYh1IhlI8wufc5AzjmI+Ho
         +wKWmWSOZuVWlgzXIpLsqzn3IYQeELlyephBWd4E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([89.0.25.131]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Msq24-1i0mSR3X5c-00tA0e; Thu, 03
 Oct 2019 21:05:47 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: networking: devlink-trap: Fix reference to other document
Date:   Thu,  3 Oct 2019 21:05:36 +0200
Message-Id: <20191003190536.32463-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EGKFx/Jx35YJ0kLXoNLmwL6SR0zsFuPBfsJbzA/+bcHCAxRRI8Y
 gFtsnMZJ8ED5DG9mKOG/hZjaCxC1K2vlDgsU3IIAeDauAMhzsInUoL8rV1jLjMb225jZ630
 a2/UXMUm6Immi7hkE6HdKq86amZ12nY3XGG/mwljwv3J3E2G+lH8gFlJ3PvUMSdCVJbqiTd
 4Sc8lMRdsrIgleDsnVgbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1nLp46NWnVk=:fQDi8AkQzkD1ND28ZaRxvd
 wvcPhkfq07n6K0Q9tH4qyUcda2Hm/ab73uzzudTBTn+V+iHih1ACQ/QiMXj3ldED0Ms1jyU0y
 wx+raJ5NrEgwuoKSSBm8He2YIfciILfYse1aTIjiS8dV3B5LaMN+VkXCFprumrjI47Op3DqUR
 N4ovLbstYkq91Ni5GKDdImnp565BApuZofKuXrT72T3qsPfJluCgZdA8vUsOo64YTjKw4QdOR
 hNQOOKRKSop2b2FzHnA8F7FtzP88p5ixqERzQj/cshTd0qE2pa5Z6az18fpr7BORQFCEtOMA/
 NkPXc/Rrhk5lNeyTg1gAobhAvRWMEz2NKvt5geufVqTU4Ri2MOoeRF1JX+dP52y+lU1BU3ZP1
 yDcIcY8jbgDDPntMuKu1itlhaoVxkm0o54pnyLtnmST6c8ZLGWZekcwGSjwhOKGhQdJc0G5s+
 saWZCdaZ8C6VIkCzPqMXolP1z3aQZ9rQKI5j0WhoO2MuZkfDrszWnrDKonzSzH/dvyeYAPi+2
 JVEQHOLJGfnxZMvxMybjEUWAOApnQOx5TpTgydY5dqESdIU1Iyzo4y+4rpkcMy2Ds/v1nHG5q
 NOZz7UYW2Gpkr7ado4Z4Ns+YZEFkxOmp63HRIWd5HAJ5/MWP18JAPE1ES7wntGSIofn8G0q4n
 i+S2EWBUmk5RbK2jxGnZCiDGCfPqa3ByGBvpGmRo8Wp5WldLGS7VpoRtCPSbDkhzW6XAaRJOZ
 P/9D9BrqMOJy8raCPy0E0phJpfX5yH5H0zNztSTaaJxph2/v6KCmI9BajQv1+9lpCUxcE3rTw
 KfJpmsyxB/msGpXUOR7XzCafJHh57SVxeGMPqMQ2O8fLrRxQLDTtbsvmKcfW50qRNRLLWEDZl
 1rTBOuYnV7B5D2aHHG3PXDJl8oXvoUc0tu0PHhX5FLkpZrdwJjkUi7M9/kLQLSlx7re0C+m/Q
 Nby2K6n4U1TG8vA7ML6uBU4rJch8aikG3s5DXSG1axcUK3w6tzljJN2QSTm7F1PGXg0RAQLqm
 JkSkFU11pa8E3ULK1ujXL82iclhjmk4e4S25So9eSmsSAUy/9cDk+ssFiJ/csx55hJDLp2nl0
 IcZ5ZU2XP3w3GP0vH3x2COCTFWYgsiGTtP/ibYOv8gFz9AVC7aR7iX2sK1DFatpLbH0rf2sUR
 uSgMM4yCnAVrisXkbojllWgfBDfXlx38osUVjzrbVWgrruKXOXH1MjY6u1fzfL0pn2pXOhhP9
 ISc6eNkRoVAiIaFAw53WtoNCmst9YaGdAEwWwT3N0pZ+S+9+X8c3YPmwWBXA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following Sphinx warning:

Documentation/networking/devlink-trap.rst:175: WARNING: unknown document: =
/devlink-trap-netdevsim

Fixes: 9e0874570488 ("Documentation: Add description of netdevsim traps")
Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/devlink-trap.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/net=
working/devlink-trap.rst
index 8e90a85f3bd5..5c04cc542bcf 100644
=2D-- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -172,7 +172,7 @@ help debug packet drops caused by these exceptions. Th=
e following list includes
 links to the description of driver-specific traps registered by various d=
evice
 drivers:

-  * :doc:`/devlink-trap-netdevsim`
+  * :doc:`devlink-trap-netdevsim`

 Generic Packet Trap Groups
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=2D-
2.20.1

