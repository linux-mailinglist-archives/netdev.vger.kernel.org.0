Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223AE1C2A8B
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 09:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgECH1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 03:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgECH1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 03:27:36 -0400
X-Greylist: delayed 804 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 May 2020 00:27:36 PDT
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B21C061A0C;
        Sun,  3 May 2020 00:27:36 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 0437DwHZ022534
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 3 May 2020 09:13:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1588490040; bh=TZDbNan2WwMW7qqj6Vfc61R0Z8dFpNE2zQBNw2PBk8A=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=oNNeOQl5ZRxh0mPbUrx6iYN3x1bNTAAgv2GwW83UtMSnYP94dhspo5Z9at75q2Cml
         67eGrm2pBa4gMqhbBAImCNGvY7alv8pTrMGiW8apCtBfgWrKtmukSwsxHbs1jjeWTl
         Oz8+kXsi/74KXUHQK5/wexh3l8b00tUSxckac50M=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jV8p4-00070Y-Hh; Sun, 03 May 2020 09:13:58 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Matt Jolly <Kangie@footclan.ninja>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add support for DW5816e
Organization: m
References: <20200502155228.11535-1-Kangie@footclan.ninja>
Date:   Sun, 03 May 2020 09:13:58 +0200
In-Reply-To: <20200502155228.11535-1-Kangie@footclan.ninja> (Matt Jolly's
        message of "Sun, 3 May 2020 01:52:28 +1000")
Message-ID: <87v9ldlccp.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matt Jolly <Kangie@footclan.ninja> writes:

> Add support for Dell Wireless 5816e to drivers/net/usb/qmi_wwan.c
>
> Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 6c738a271257..4bb8552a00d3 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1359,6 +1359,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G=
 LTE Mobile Broadband Card (rev3) */
>  	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
>  	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
> +	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
>  	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
>  	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproducti=
on config */
>  	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM s=
upport*/

Looks fine to me.  Please add to the stable queue as well,  Thanks.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
