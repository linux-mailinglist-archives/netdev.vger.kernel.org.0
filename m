Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730223B7548
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhF2Pbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:31:50 -0400
Received: from mout01.posteo.de ([185.67.36.65]:46775 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234923AbhF2Pbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 11:31:47 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 83E2C24002C
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 17:29:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1624980558; bh=fr9bTA16NHTxEWPMHlgaxqo9ylA+FLxHWL4mY+2DfrA=;
        h=From:To:Subject:Date:From;
        b=T9IDeRNk+3l+inq0mFWpYK8DQhzFOCABzO+BL7+MiJECjfbwGOrZsNqQpG1muXPdE
         +h5TItAYjlaMbQVO25I/I8oHCpqooAA6dtlOFHMVdq0irH4Z1cL7DXpV5rZtzlWMu5
         O19heQMv6RqK7tSJTgSggNrEiKXM7UOTgkVcqPvefEtYxUd4EWeULhSnTvmDizapPD
         bKYWfIcwE6a+tjZqyf1LyeqdRXwTjz3r72OZrwsk45Q+Gx5Yjj1wv0umtgDd8DR9cu
         g4nS85xugRbJEk+RGsj54wgC0JTrujNnyjHR52WnIdATsAblr5L+PaBwYTao8EPjm6
         1om0jZ5qmL1yw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4GDpL60VlWz6tm9;
        Tue, 29 Jun 2021 17:29:17 +0200 (CEST)
From:   Marco De Marco <marco.demarco@posteo.net>
To:     bjorn@mork.no, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Add support for u-blox LARA-R6 modules family
Date:   Tue, 29 Jun 2021 15:29:17 +0000
Message-ID: <5473473.x7jBqtuPIS@mars>
In-Reply-To: <4911218.dTlGXAFRqV@mars>
References: <4911218.dTlGXAFRqV@mars>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for u-blox LARA-R6 modules family - QMI wan interface.

Signed-off-by: Marco De Marco <marco.demarco@posteo.net>


=2D--


diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d08e1de26..cb92c7c1e 100644
=2D-- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1115,6 +1115,7 @@ static const struct usb_device_id products[] =3D {
 	{QMI_FIXED_INTF(0x05c6, 0x9083, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x9084, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x90b2, 3)},    /* ublox R410M */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x90fa, 3)}, /* ublox R6XX  */
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
 	{QMI_QUIRK_SET_DTR(0x05c6, 0x9625, 4)},	/* YUGA CLM920-NC5 */




On luned=EC 28 giugno 2021 16:35:56 CEST you wrote:
> Support for u-blox LARA-R6 modules family.
>=20
> Signed-off-by: Marco De Marco <marco.demarco@posteo.net>
>=20
> ---
>=20
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index d08e1de26..cb92c7c1e 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1115,6 +1115,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x05c6, 0x9083, 3)},
>  	{QMI_FIXED_INTF(0x05c6, 0x9084, 4)},
>  	{QMI_FIXED_INTF(0x05c6, 0x90b2, 3)},    /* ublox R410M */
> +	{QMI_QUIRK_SET_DTR(0x05c6, 0x90fA, 3)}, /* ublox R6XX  */
>  	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
>  	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
>  	{QMI_QUIRK_SET_DTR(0x05c6, 0x9625, 4)},	/* YUGA CLM920-NC5 */
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index aeaa3756f..05d0379c9 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -238,6 +238,7 @@ static void option_instat_callback(struct urb *urb);
>  #define QUECTEL_PRODUCT_UC15			0x9090
>  /* These u-blox products use Qualcomm's vendor ID */
>  #define UBLOX_PRODUCT_R410M			0x90b2
> +#define UBLOX_PRODUCT_R6XX          0x90FA
>  /* These Yuga products use Qualcomm's vendor ID */
>  #define YUGA_PRODUCT_CLM920_NC5			0x9625
>=20
> @@ -1101,6 +1102,8 @@ static const struct usb_device_id option_ids[] =3D {
>  	/* u-blox products using Qualcomm vendor ID */
>  	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
>  	  .driver_info =3D RSVD(1) | RSVD(3) },
> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
> +	  .driver_info =3D RSVD(3) },
>  	/* Quectel products using Quectel vendor ID */
>  	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21,
> 0xff, 0xff, 0xff), .driver_info =3D NUMEP2 },




