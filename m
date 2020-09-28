Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2227B8F6
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgI2Anc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:43:32 -0400
Received: from mout.gmx.net ([212.227.17.22]:55555 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI2Anc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 20:43:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601340211;
        bh=G6HceT0It0VlXbkDsImh0/RDdHE+KDDap8TVy5//N4o=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=MmYSSJUU0X7XEnQJVuqHRl85qx8/CdbF+33gBF8WwqqTMoBVXavc3+ETB/XoFLjX0
         pzNTCJo9Ekuj5ez8WSTrobIz2Xh8NoAE80CTL79p7/y2O0K7wq5nzJD0mRaExyN0qI
         6SHY5FVrpmZ0vJ5+WIXINahjPFMYth/2in3qXBQA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from PC1310.gateway.sonic.net ([173.228.6.223]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MOA3F-1k3OpO1zUf-00OVuN; Tue, 29 Sep 2020 00:01:08 +0200
From:   Kevin Brace <kevinbrace@gmx.com>
To:     netdev@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>
Subject: [PATCH net 2/4] via-rhine: VTunknown1 device is really VT8251 South Bridge
Date:   Mon, 28 Sep 2020 15:00:39 -0700
Message-Id: <20200928220041.6654-3-kevinbrace@gmx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200928220041.6654-1-kevinbrace@gmx.com>
References: <20200928220041.6654-1-kevinbrace@gmx.com>
X-Provags-ID: V03:K1:cVgECJLwbgrLulrm2wVB10TNcgVKVJOgAO0l9LBFMdFcvZb8uIZ
 9BXfa90IHbQbopwmv66W/VRJcjzRbakOPkGTwlkHbdtT5psZh8zNmm0h249wsJWdmrzwrmZ
 gKVIdTe0dU1ExKIBsPkQx8dlK/NExz/EqaR7F4Cbs3lnWurvL79YMkhBXG7oskHDHwbEyB4
 jBDt8GPO0st54R6IvUx3w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wVXweYi1qFo=:/nLm24VsC9AZoZIOLZCuKD
 6M8l694fkKPlSQ18Cv+P0Uajf0p2r5Y5K5TPRiWu174G8ngFVEQmGuwJFz7kCtK7OlQ2fMWCo
 D3PDooMf3r+Ge+MkY5z6vnTfLF2ar17PpG3t9g/MupETR/ilNPYOYD1JjmzqthwBPt04p8eFD
 qHCit6PwjYczcgQZp453o/nlROIXrIE0j7eun5n2UAUKxbMHu0AzR9DDigsa7WQWNNBht7f1W
 Z6pJt8Ykom/AQqNByCUpUZFOtrWVA3fXwagbkbC+dxzPKQNgEyQ574ZwghnSdoSOoFHb0l5CZ
 swKYd54F1sVPENXWCoPiuSJg5EguPRJN70crPMEDCNk07q+uplSYChJBGRZK/yEsEA4u3BGaV
 B8NOgZokol3d+XgjbmB+h8es+o/1Sit36U/Aql5f4KD0jPBX9GEv1DAIig7qdKyCJvNoxWej2
 BXPy34OIARuql3Z3jkKLHwpJSuunlnbQRQGsiKGB8q3fXIcTYNadq96ovdzFbYP2T5+s4j1rG
 GFay9sB0/blLPnbKHIKxxS2DWrIPcyzw17IMnSRjYLr98mCNHKMASjPINRb/zYDEFDjbgqNrV
 Jw+wgKIdt+EywOyIQqNW1U02TUZwNBtLX6Z2S8sjfWbS6AI2yERdNknPiOx/0q4qSvBocIsvb
 nEN6P0q4pbfkKBnLooVAPN4WUmWF0oTYImC+1BVn7KYSuQqe3igMJnfz5MCXEEQ1Jb8tYmQqT
 ifc1+eTWHZNaHNGktdyBGbyT1XgqfsChPG/NEyVHxT5ehy4u6ayyb/H4uPYS5rfNnbc3DgzK6
 rofp+rVeQ6Yy0Eq+cPazM7z2qHzLvBwEm46HiQqOQZlSLrKqDWHXo3Rw0kxBoLgLLFKQs3KS8
 LOnfYPSuVNlV6PBXU5mddIxAJGpaPtaMKKNnpD2VGFM6VsQivn3hSi2WzCZFIIFWdNadyhM0z
 AeN+tf/IBrlC5FKodCZ3NEzdtrasgB9slohAzBsQRRNkrQxPc28byM/31tA62uIpOJXyMfVte
 6UNuqqjIXUkvcS4Q61TeZISvSjwOgt0HbhMeaIldnlEj3rJ2Y5RSpIFhUMfMLVktk6hTwKv7P
 xJJs0x6EoeE50VK4Y0X7cXzaZAJrykSCd0TA4AVX+X1+Z4mriYK50a7oGsdUpDfKxNg2c8Sep
 qk4Q05j9B8ncZCsgrhaWY2lM1r76JTPGoMHqx02SGr2IZ+2/Z0uRlwP7iW4y2zx+cR6nJ9hDM
 SOggNz2VhicoOZ/dA1r1zvTkVqCgECWCZ8qUgfA==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Brace <kevinbrace@bracecomputerlab.com>

The VIA Technologies VT8251 South Bridge's integrated Rhine-II
Ethernet MAC comes has a PCI revision value of 0x7c.  This was
verified on ASUS P5V800-VM mainboard.

Signed-off-by: Kevin Brace <kevinbrace@bracecomputerlab.com>
=2D--
 drivers/net/ethernet/via/via-rhine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/v=
ia/via-rhine.c
index a20492da3407..d3a2be2e75d0 100644
=2D-- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -243,7 +243,7 @@ enum rhine_revs {
 	VT8233		=3D 0x60,	/* Integrated MAC */
 	VT8235		=3D 0x74,	/* Integrated MAC */
 	VT8237		=3D 0x78,	/* Integrated MAC */
-	VTunknown1	=3D 0x7C,
+	VT8251		=3D 0x7C,	/* Integrated MAC */
 	VT6105		=3D 0x80,
 	VT6105_B0	=3D 0x83,
 	VT6105L		=3D 0x8A,
=2D-
2.17.1

