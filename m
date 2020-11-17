Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EEE2B6E87
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgKQTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgKQTWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:22:19 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727ABC0613CF;
        Tue, 17 Nov 2020 11:22:19 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 0AHJM3sH032224
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 17 Nov 2020 20:22:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1605640924; bh=HJKfBHVGuG+6si5HTCaPfCM55EVijHkpJJ21PZ4zPrY=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=dF+xwgZQF1qoyi44ChY+kh5qV5r2poRpudbyRZ4XZiEqRWrWXKRiwPfqoIEbb4+I8
         FkMWeI/sXNT2uD4Oaf7bql3WMKGMTa8wHWrR+DW76yY2GImqS1rzu/z2w+2B1JCrje
         z0M3S3ozxlVxO6P52K8bQ7TIjDYBR+R8NPLyhs5Y=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kf6YF-000EoC-90; Tue, 17 Nov 2020 20:22:03 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Filip Moc <dev@moc6.cz>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Set DTR quirk for MR400
Organization: m
References: <20201117173631.GA550981@moc6.cz>
Date:   Tue, 17 Nov 2020 20:22:03 +0100
In-Reply-To: <20201117173631.GA550981@moc6.cz> (Filip Moc's message of "Tue,
        17 Nov 2020 18:36:31 +0100")
Message-ID: <87d00bu6uc.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Filip Moc <dev@moc6.cz> writes:

> LTE module MR400 embedded in TL-MR6400 v4 requires DTR to be set.
>
> Signed-off-by: Filip Moc <dev@moc6.cz>
> ---
>  drivers/net/usb/qmi_wwan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index afeb09b9624e..d166c321ee9b 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1047,7 +1047,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_FIXED_INTF(0x05c6, 0x9011, 4)},
>  	{QMI_FIXED_INTF(0x05c6, 0x9021, 1)},
>  	{QMI_FIXED_INTF(0x05c6, 0x9022, 2)},
> -	{QMI_FIXED_INTF(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE=
  (China Mobile) */
> +	{QMI_QUIRK_SET_DTR(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD =
LTE (China Mobile) */
>  	{QMI_FIXED_INTF(0x05c6, 0x9026, 3)},
>  	{QMI_FIXED_INTF(0x05c6, 0x902e, 5)},
>  	{QMI_FIXED_INTF(0x05c6, 0x9031, 5)},

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

This fix should probably go to net+stable.


Thanks,
Bj=C3=B8rn
