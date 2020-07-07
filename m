Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D94216CA1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 14:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGGMQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 08:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGMQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 08:16:08 -0400
X-Greylist: delayed 654 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Jul 2020 05:16:08 PDT
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A3DC061755;
        Tue,  7 Jul 2020 05:16:07 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 067C4xPH027462
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 7 Jul 2020 14:05:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594123500; bh=LpYHzL1Fv+6r+q+/DerBNxWDzKGX9YKvtsmvkogOo+I=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=cMhTetJjnHHTM68v7z/MTjWLOy0iXztNxRx3x3KxRBHdOZRjbDqRmhXwtOyt1gUHq
         yK4NbRM0DpgXhLGO6+4Jr2LpFABkr90sXKNq7GSKbMxocqGNdt5TM+Jv3dRpgpt5Pu
         umdNqQCbLEb8vMeh3qls1TyQF0GMv9p+8qrIjf2g=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1jsmLK-000PCr-JH; Tue, 07 Jul 2020 14:04:58 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
Organization: m
References: <20200707081445.1064346-1-acelan.kao@canonical.com>
Date:   Tue, 07 Jul 2020 14:04:58 +0200
In-Reply-To: <20200707081445.1064346-1-acelan.kao@canonical.com> (AceLan Kao's
        message of "Tue, 7 Jul 2020 16:14:45 +0800")
Message-ID: <873663cyz9.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AceLan Kao <acelan.kao@canonical.com> writes:

> Add support for Quectel Wireless Solutions Co., Ltd. EG95 LTE modem
>
> T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D02 Cnt=3D02 Dev#=3D  5 Spd=3D480 M=
xCh=3D 0
> D:  Ver=3D 2.00 Cls=3Def(misc ) Sub=3D02 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D2c7c ProdID=3D0195 Rev=3D03.18
> S:  Manufacturer=3DAndroid
> S:  Product=3DAndroid
> C:  #Ifs=3D 5 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Drive=
r=3D(none)
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Drive=
r=3D(none)
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Drive=
r=3D(none)
> I:  If#=3D0x4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Drive=
r=3D(none)
>
> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 31b1d4b959f6..07c42c0719f5 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1370,6 +1370,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E +=
+ */
>  	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
>  	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
> +	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0195, 4)},	/* Quectel EG95 */
>  	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
>  	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
>  	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
