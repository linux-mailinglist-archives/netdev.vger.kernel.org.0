Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8D139874
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 19:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgAMSON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 13:14:13 -0500
Received: from canardo.mork.no ([148.122.252.1]:45357 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgAMSON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 13:14:13 -0500
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 13:14:12 EST
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 00DI3R6n015898
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 13 Jan 2020 19:03:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1578938607; bh=QjXuhahTNn2hxQHP2MQWZR/uh17Qw5zNYV3owU01MsM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=WA+ZshgV/SZ9zG0XBIKcCKMnmAUELfxCfspllhuR4I2z354Qw8wDtv9ceRtcV/P/e
         3bgEKt5F9SpzZJvA0RryFd5JvvtpWQKeh3Dx/+inH5W9sj2RM3Zc6Kbl8pWxO8uLPZ
         Sp3n4S5qXgcVVECmBMm56yJgLBo9IulfRar8l+3k=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1ir43i-0007wv-Vn; Mon, 13 Jan 2020 19:03:27 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] qmi_wwan: Add support for Quectel RM500Q
Organization: m
References: <20200113135740.31600-1-kristian.evensen@gmail.com>
Date:   Mon, 13 Jan 2020 19:03:26 +0100
In-Reply-To: <20200113135740.31600-1-kristian.evensen@gmail.com> (Kristian
        Evensen's message of "Mon, 13 Jan 2020 14:57:40 +0100")
Message-ID: <87a76rutch.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kristian Evensen <kristian.evensen@gmail.com> writes:

> RM500Q is a 5G module from Quectel, supporting both standalone and
> non-standalone modes. The normal Quectel quirks apply (DTR and dynamic
> interface numbers).
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 4196c0e32740..9485c8d1de8a 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1062,6 +1062,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0 =
 Mini PCIe */
>  	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
>  	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
> +	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
>=20=20
>  	/* 3. Combined interface devices matching on interface number */
>  	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
