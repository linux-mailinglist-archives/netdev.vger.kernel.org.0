Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0623AED349
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 13:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfKCMF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 07:05:28 -0500
Received: from mout.web.de ([212.227.17.12]:52995 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbfKCMF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 07:05:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572782704;
        bh=lqIIHx6HsCVvJIt0JzRk1dYquXktYUstmsYeoHN+jEA=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=TLpJcvFb3yD++6l5IwhECosGwS357xWF6DtizaY7I1yiGE4fe//gAIfVRw7U5t5C8
         KLT5d9BvSzcHHyww+UH6qbEW+f4W24tJL5lCfojr+yvL1p9HW9mnwOMTL6AOzmo3jP
         3QsiOND8n/ucXTMKoCf0r6oKRl9JHhOqLiqCwU50=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.72.216]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LrJse-1hxNV602n6-0136St; Sun, 03
 Nov 2019 13:05:04 +0100
To:     netdev@vger.kernel.org, Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        =?UTF-8?Q?Lars_P=c3=b6schel?= <poeschel@lemonage.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Michael Thalmeier <michael.thalmeier@hale.at>,
        Samuel Ortiz <sameo@linux.intel.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: =?UTF-8?Q?=5bPATCH=5d_NFC=3a_pn533=3a_Delete_unnecessary_assignment?=
 =?UTF-8?B?IGZvciB0aGUgZmllbGQg4oCcb3duZXLigJ0=?=
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <44ef4be8-682e-0f1c-3927-c3d4db33442f@web.de>
Date:   Sun, 3 Nov 2019 13:04:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xuFv58h3DbXbm5GMFkAkCReKh4EeMXgexgjy20nURaIbMW6epOn
 QEHh0zi0NkE+0nV/0qf20RwhCEXYfmKlbUYtadnx0GP1+IB6diWHdIyZ4u4r85wax2b6+7K
 XpbAGEBothPic7b2eoi2m/CEM4U0SIE7in+/KPfODKzi1CcWlRaC9XmaipwORicSlHNhUoL
 jtWFAJ9t+tRjJbNwAGpBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:P+mWF51qy28=:hsEXRq1Js4X+dlLcBuIW29
 +A++7M7vNwBAKh0XWLbrHJgHny4YWo69xJRzgjNbMqCqvnPfPtiQME7Qxh07iSZxjTQ90siVD
 zYkV33D4IAluZBx221HZuzWMwkxpwLINFg4BIvvp8bj+qSiqij+k5HWeDArFk5TbFrepiju1F
 KGmcW4cMFSZvpE9IbfFvaRzsf8BrE8Zui79UNqTWWetiuurtEH2g4M4sha8I60ozKIN3AKkF5
 qwNECUzHuYN6u1Bao6/WfvqbLenp0tVffk5LYH+Yq47Timsq6gTtCgi36fFqTOVivr3bGUWay
 aFnG0H3wqe4yOYhe1TcZ+fRT+8iGREuxpn1BwpdjGhaSQebDj3xtnEMeIZo7ylnZJ4MYMXVCM
 L9aors7lTYbIB6wIwboBB9qPGFk68YvFuCs/IiW7woRUgvr5U50IfRQfkFewbZH41FN2liBuT
 Ek8bYnFcbiwAVRmv7JlQF7jwowDoAQ6xs1vy4ooa8FBYQX/yuBR/c+OA76Uro+7At7RdwL9yD
 bcqXhfKaw9/KVgH0QxaXiqsCOq9K9pu9RoB++9jR91JD3u+i2vB5gTNJBhF3Kt008Zt37QVe+
 1nehEyTo5YzJpoJrp9m4l70l+A6gaIXHDa/abi/tZS2aR8R0qJo9rCBNIMkXLKUv8wTuedhVt
 nkXSbv0bOK38w4HI+y6AiBm0BMqQSR5c6QRTINdCZ+H4HvxYib2+g0l0eOhF0gVjNWDC8rgD2
 WzsDSAve/vnd67s/b5Af2RPvpqE3i8Bm0qMxbD7HtWquifbFoFSK5UxRM3b/d6lCXqnjP3Fr6
 Of1HIFvRkmTbx6WfXOKcRXHUSSey4n1zVHLq7yWgp4/I0vFpVkbC/IF83SXuNIEhPkbA91JQD
 HCPM4Tc/WnS9WTaH9ktDhfg3KVyLa90NJ9dqSEhLwdVAEIIUZtIxmkt59OZSim4OMyOu1EhiK
 q05RInGmqAyBuLJHJc1Ty+j6151Wq7GigK+1i/TRdKfjwzrIr0o2TEfH+eCKYbrES+NSy9uRP
 tAfZOv7mP8JpXkT+pYttcW6aEDr2mxeBX0Hqz1/lipaLm/vPDn/uF+z/PiV4dw/ukTLrCnnyZ
 PDGCEZ4q0xXFTB4FUIoLfpNjgECu6FigaWiM+nAeTTE7wPoRCUbJqVoyrK9463tSjLLVIezv7
 H1DJQyNwkGU+t7BE4GKygQxyzy7vZB4ukqIbEt1NuM952K0hTPxz3wllbFiB2xhuZ3C4tVRKn
 /1AAZS+Z5kBCJM92oHZL5C65Wx8lTd3BxDimA+EcckEkAcpNcL23h0+AWq+g=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Nov 2019 12:50:19 +0100

The field =E2=80=9Cowner=E2=80=9D is set by the core.
Thus delete an unneeded initialisation.

Generated by: scripts/coccinelle/api/platform_no_drv_owner.cocci

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/nfc/pn533/i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 7507176cca0a..0207e66cee21 100644
=2D-- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -274,7 +274,6 @@ MODULE_DEVICE_TABLE(i2c, pn533_i2c_id_table);
 static struct i2c_driver pn533_i2c_driver =3D {
 	.driver =3D {
 		   .name =3D PN533_I2C_DRIVER_NAME,
-		   .owner =3D THIS_MODULE,
 		   .of_match_table =3D of_match_ptr(of_pn533_i2c_match),
 		  },
 	.probe =3D pn533_i2c_probe,
=2D-
2.23.0

