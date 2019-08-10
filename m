Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3188AF6
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 13:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfHJLM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 07:12:57 -0400
Received: from mout.gmx.net ([212.227.15.15]:58525 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfHJLM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 07:12:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565435553;
        bh=VYZbAjv0vWAfXOCBhNJs/6WPV7XCNfBYVLbv1rim6Lw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=GwC+nAt3idEY5K745agHF8oZWlxlYBkSsl05yvl4kaWpRH2C0Xijv07yxngSpUtkJ
         Mjz0vJQYVpYfVSxGGE560m9j82d8iNd3a8QVIDVtOYPmH0gfyEKX4/naObPQ323R2P
         fZo5Y5ZLqxRZViLXZYcXxIyujui99xfgKrjRTc+U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([109.90.233.87]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MFdDB-1i8lEK09Cf-00Ecay; Sat, 10
 Aug 2019 13:12:33 +0200
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: nps_enet: Fix function names in doc comments
Date:   Sat, 10 Aug 2019 13:11:56 +0200
Message-Id: <20190810111159.3389-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FevDCI+NuyDs/gMz/C8oKjv1ZEooXHIOuh9e8SvJQGrAvtFBJAc
 ymUajJD4xXJ40VIhqOXJsM2STUjX3HLmMVVqWRpBz2Mgj/EdsLHzeQ5qON8lRMicfjrob4y
 tjWv8PVskE/9uPqQjWNOTetJv6Z/3zKta8zLbIAStOYTHB/6J2jXsfh/UMI84HZBc5V1FYU
 ygWjBmGOGVg287v8T7XMQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V4ee+rfTwRo=:HhmIFjBEOrV6Cu85ng/rYT
 /a5rgQYSGulVyG1v995bTQI280rbYUdOPPKoTqZwlNlcYCeU9xRlrF50bysFmicmb0R6CZ3JJ
 cPNPexLqOn5KOS1fb7r4cj3to+W8CzO03jgqoLWL32aXmMAm8cVrJd5YNaUpPd2fBAcAuWiVB
 ngCUkwhw5ptR7UhbnjSklJIAYbeb6b9g3FLn9MOt70p9IyBKPILTNIilkrH0zCuIRXjLCZhRp
 AtEUujerjE+skEhlSpX8UT/E8eDXKmnoTHAE6+M4D53I1tQTjx4c+68UlVoWxoF6R4TWlOTvy
 kXtmbD31Jg7h+iPrhNa9RvhV2XjmseVa4pVt+G4USwtpMHwo3RO2JG/l8JlctkYZIzkJl7+0p
 YKc3MYuc7JZa3kX1BLBeh86OuH+JIFCb+3yjQAqotAGh/sLmOHMxakTpl7NKsCCWdaHvBwoqg
 gAopK8/GIVmTaYimw0knB+pH9sw6Sld96WYiVEPPPyt5t8bvsuCdpJMamffOW9CA8W9gc/ZR1
 kbaFFg74FGqd1vgrESlbzu+/OVYk8ld75ZN6n8/Gd7qhUS9aHWDnZ2Nr2rvTrUsUBz/yhxOI+
 WdtictSlJ36avfhCGKVBSk97uEliCkZjb8pr115i2+zF136fyu0ovs6z8UToshIdT3If9PgAw
 SZxyKPN7+0WGiUnfAIqTQD0tkVxYq6/cRlM6krOrXQShmvns1P0brq28xryN9UZX+vqQVWhk6
 7BLVSJ7dEs/gEqGi4fvax8yRUutvSFqx+3E/yBPqWCdqD51I3Y0F/3czxpi/rSovf8fCGRFtD
 GEva8RQR6n9gnweJFzXiVr/+/fhKRi8rHA1xRe0GMSbbqK0JR+w9ViCZ0S8BkjOoN6WGFu3SF
 sDl2gOB+z+2jiJPzQ6FCcZkWbVsDTpxFae+59jqnZnbqaSSoR0VXe53RKNOMVJ1OQqNO+pI08
 vVqfu6J0wlGdQewtGhArS1AJONq+tMkMrZlWRdawqzO1aQxCVpbBkbA0fREhqCgIenbRlFo2/
 MKGDoF7+tS6MauxKgD4xvlbuvWr3w+AVEvV2gLXTHAGBKh6gZkmzz+bvuLoY9+12NsznWaWvy
 /NbtiT2VsnMhC8fPiDmr5k3kLCTmTPRyGekgZDQ/shZmDvpPTWmFFFB71SJLN3C3Qzi21y2BK
 7OQDM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust the function names in two doc comments to match the corresponding
functions.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 drivers/net/ethernet/ezchip/nps_enet.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.h b/drivers/net/ethernet=
/ezchip/nps_enet.h
index 133acca0bf31..092da2d90026 100644
=2D-- a/drivers/net/ethernet/ezchip/nps_enet.h
+++ b/drivers/net/ethernet/ezchip/nps_enet.h
@@ -167,7 +167,7 @@ struct nps_enet_priv {
 };

 /**
- * nps_reg_set - Sets ENET register with provided value.
+ * nps_enet_reg_set - Sets ENET register with provided value.
  * @priv:       Pointer to EZchip ENET private data structure.
  * @reg:        Register offset from base address.
  * @value:      Value to set in register.
@@ -179,7 +179,7 @@ static inline void nps_enet_reg_set(struct nps_enet_pr=
iv *priv,
 }

 /**
- * nps_reg_get - Gets value of specified ENET register.
+ * nps_enet_reg_get - Gets value of specified ENET register.
  * @priv:       Pointer to EZchip ENET private data structure.
  * @reg:        Register offset from base address.
  *
=2D-
2.20.1

