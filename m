Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6AC287074
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgJHIHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgJHIHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:07:41 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26CDC061755;
        Thu,  8 Oct 2020 01:07:40 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 09887LOr003713
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 8 Oct 2020 10:07:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1602144441; bh=tV+r+n/6hptr1Cjyk7c2jxN8WJX6lDayGAgagQDk9Xw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=DXGPI+o/dUVXiVieloQ1PRWctameELzK7jd/ESotw2hhcSjZmyntimMD5vBp6N4Ec
         CVnpb23wimIavRSTEEJoPujYT0Q+H0EvLy3Ig70Xm0DBvPx9PLlQ93S7nZpp4Kfj9q
         bTcul6ptT6eokqWwArwCKcpvlPdVMpNY/ePJSY28=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kQQxM-0017cV-Le; Thu, 08 Oct 2020 10:07:20 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: add Cellient MPL200 card
Organization: m
References: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
        <f5858ed121df35460ef17591152d606a78aa65db.1602140720.git.wilken.gottwalt@mailbox.org>
Date:   Thu, 08 Oct 2020 10:07:20 +0200
In-Reply-To: <f5858ed121df35460ef17591152d606a78aa65db.1602140720.git.wilken.gottwalt@mailbox.org>
        (Wilken Gottwalt's message of "Thu, 8 Oct 2020 09:21:38 +0200")
Message-ID: <87d01ti1jb.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wilken Gottwalt <wilken.gottwalt@mailbox.org> writes:

> Add usb ids of the Cellient MPL200 card.
>
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 07c42c0719f5..5ca1356b8656 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1375,6 +1375,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
>  	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
>  	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM s=
upport*/
> +	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Q=
ualcomm 05c6:9025) */
>=20=20
>  	/* 4. Gobi 1000 devices */
>  	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */


Thanks.  Looks nice now.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
