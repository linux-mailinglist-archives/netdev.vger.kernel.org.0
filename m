Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FD245FD83
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 10:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353319AbhK0JM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 04:12:56 -0500
Received: from mout.gmx.net ([212.227.17.20]:57213 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352878AbhK0JK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Nov 2021 04:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638004043;
        bh=4Oa+4GBN8ZB387L7S1TaBU2khs42nwctWOZOddUDWu0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ArN6/GnhH8pypswOwvl2Yu2LQ96LK3o10AjeTSQqAuVL4ue88F0xHKfsyTe/Ob1pT
         6ZaTeq/O5t2JGwXlAvziykYr7lyEdzERr2wmr3SLsT/nclO6SzW6IkpLd3FcaCqzVn
         eiUEwokzAuiCQEowtVZ8Qu+npgnNq2ZIf5QF+1g4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from oleg-laptop.fritz.box ([87.159.241.123]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MQe5u-1nESPV36YQ-00NhFJ; Sat, 27 Nov 2021 10:07:23 +0100
From:   Ole Ernst <olebowle@gmx.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>,
        Leon Schuermann <leon@is.currently.online>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ole Ernst <olebowle@gmx.com>
Subject: [PATCH] USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub
Date:   Sat, 27 Nov 2021 10:05:45 +0100
Message-Id: <20211127090546.52072-1-olebowle@gmx.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ESfKZO9/3M7UuBJ/1NnmMVjDnCQGi1m3RmHq3ZyvIuZGS7a3Fp6
 eZ7zNI5Didt4Q/YetWd6dniF/kvWvNNbNvEtqwrSRxnuPa6zPnBFyW54FA//P5ZFB3JSM2C
 NNeGl3zUKPAkUUXq72IyyZ/vr4r5V5aelbK9oGTi/RL5Z+YuRDwJJYRKpyPKnCROhI//xUI
 ADU3YQvjIJZGCV+Ec2kQA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8B/GuLltBQ0=:ls06svWVaeu5aySA1tTTwf
 1qb55nEvl2ZzADOEPcoSMa/bP9Om4PmFOa+XFolvo3J7NYoHLlHcUb9ybIh1Lym2KAqywHSg8
 CJEvYnsY8dFfUZDeK30xVzPMDll14P0Ms9m6JYT2ueh+VmzKbaVsn3rXtm2HRAKS6kLiQGrOo
 kjwneVs/rDPxQnKKVGcgYiRDAvYMZuA6Qt4iHsvE6iZdgch6HF8giTe/QND1cF5ioom5mJ7K0
 SfJN+PtyYza8kc5Z4RsWBhNdcn7rjI2T9W6axGt6P7IxDQ5hohT+yBByvQoPd15lvRpN6VWhp
 NOJQcEE08UhCLreuWOeXDm7MAw4HIjkl4odZl49Ese9ZR1QT8pHzul1+3pek6sDlMZuqhi8XA
 JP60b4mg2xJIohnoQuQNh8j+Pj4DIv0iL0GmMJn+jgC1aKLg6x8RIIolvYT1Ajg/R1n1VJdYY
 4d+Sc9cvfh9HpbwGvkTg3O92Ju/2q1O/drzH2xn/iQ+2FWzZgLPZtoEt82MiqVG8UFn89aNam
 bUUsscLurTWuVRCqYaZdEdx76zHPkj5rZ4CYPWwWy9AQ4dqif1U7OXn6nwmE/4HO0045XNYAW
 cYad2Cq8vgO/RwFz745XGAHwPOQIJY86fg77VpFwMu6SHRTOmDJCgoOBKLf3RR0+Yq5MSqpMg
 AjGG22gqjOPd8OlTDuwqStoJCTEc1U385zkuUD4BmBncntL5ueCSHiMHFNo2CILB1SZD9swke
 kNSjy3cNP1ONUbUP6J64987KOD+PbqcJ6JX2MMhtxgguSu6Pr9wSGMZgu5e1qSDKeMPbx6apg
 xttqPDmoBM7BmLskzHge8WmvjUoE8aXc+dbIqfFo7W9atPNM2/voRiaB1Pcvzl+HRJUDtO0Fm
 IcXZN38oO4+Pt9JBXXj4s8imvEY91Bzm+BzOn7uKZZ0077L9phAaviG958xdAyjzu+k6YV6L8
 wNgGdv0SwHt+sv/SUw1Q6LYdDdD9g699VF4ut3Ug4IJWulx1szA3f5qNsL7emmHXs+pbIOOjY
 dQEwKe7bdoDhAKtk64VfauvR842sH9wZS3e7Q6Ml6USRU3VYnH2K2QxHwJUDtYHoOZuzoAwn0
 GbCns1Ub17lYvk=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another branded 8153 device that doesn't work well with LPM:
r8152 2-2.1:1.0 enp0s13f0u2u1: Stop submitting intr, status -71

Disable LPM to resolve the issue.

Signed-off-by: Ole Ernst <olebowle@gmx.com>
=2D--
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 8239fe7129dd..019351c0b52c 100644
=2D-- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -434,6 +434,9 @@ static const struct usb_device_id usb_quirk_list[] =3D=
 {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =3D
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },

+	/* Lenovo Powered USB-C Travel Hub (4X90S92381, RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0x721e), .driver_info =3D USB_QUIRK_NO_LPM },
+
 	/* Lenovo ThinkCenter A630Z TI024Gen3 usb-audio */
 	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =3D
 			USB_QUIRK_DISCONNECT_SUSPEND },
=2D-
2.34.1

