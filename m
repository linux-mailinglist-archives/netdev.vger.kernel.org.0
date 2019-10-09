Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F25D0C76
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfJIKRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:17:44 -0400
Received: from canardo.mork.no ([148.122.252.1]:56653 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730888AbfJIKRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:17:37 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:2c8:bfe9:9043:eeff:fe9f:3336])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x99AHUFm013883
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 9 Oct 2019 12:17:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1570616250; bh=8TSd/oi/I3E/lJ74zyHIVWrlWRE5Ij+1becalJXfTu8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Wdv3FPsCthNkuAR3Zvr0RUxYdqIR3e6BPGuctdJOxoB2Iz31DRCg3A0vTU1GdFu8n
         wL4pWySf3jiAM2TmpCzN8uJEZqI98B9AFUQHhDUhhW6erEHiBio1goWWugsdoJtqTd
         6qJ0NwZH2iCqYF7P8ENw7LXc/mQFhF2Msv+cziQg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iI924-0003gY-QI; Wed, 09 Oct 2019 12:17:24 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1050 composition
Organization: m
References: <20191009090718.12879-1-dnlplm@gmail.com>
Date:   Wed, 09 Oct 2019 12:17:24 +0200
In-Reply-To: <20191009090718.12879-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Wed, 9 Oct 2019 11:07:18 +0200")
Message-ID: <8736g2xlxn.fsf@miraculix.mork.no>
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

Daniele Palmas <dnlplm@gmail.com> writes:

> This patch adds support for Telit FN980 0x1050 composition
>
> 0x1050: tty, adb, rmnet, tty, tty, tty, tty

Great!  I must admit I have been a bit curious about this since you
submitted the option patch.  And I'm still curious about what to expect
from X55 modems in general.  There was a lot of discussion about future
modems using PCIe instead of USB etc.  I'd appreciate any info you have
on relative performance, quirks, firmware workarounds etc.  If you are
allowed to share any of it..

Acked-by: Bj=C3=B8rn Mork" <bjorn@mork.no>

> please find below usb-devices output
>
> T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D06 Cnt=3D02 Dev#=3D 10 Spd=3D480 M=
xCh=3D 0

480 Mbps is a bit slow for this device, isn't it? :-)

I assume you've tested with higher bus speeds?  Not that it matters for
this patch.  Just curious again.

> D:  Ver=3D 2.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D1bc7 ProdID=3D1050 Rev=3D04.14
> S:  Manufacturer=3DTelit Wireless Solutions
> S:  Product=3DFN980m
> S:  SerialNumber=3D270b8241
> C:  #Ifs=3D 7 Cfg#=3D 1 Atr=3D80 MxPwr=3D500mA
> I:  If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Driver=
=3Doption
> I:  If#=3D 1 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3D42 Prot=3D01 Driver=
=3Dusbfs
> I:  If#=3D 2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Driver=
=3Dqmi_wwan
> I:  If#=3D 3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> I:  If#=3D 4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> I:  If#=3D 5 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> I:  If#=3D 6 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
>
> Thanks,
> Daniele
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 3d77cd402ba9..596428ec71df 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1327,6 +1327,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
>  	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
>  	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
> +	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
>  	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
>  	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
>  	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */


Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
