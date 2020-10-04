Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18F9282B73
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 17:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJDPad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 11:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDPad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 11:30:33 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03EFC0613CE;
        Sun,  4 Oct 2020 08:30:32 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 094FTfgN022348
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 4 Oct 2020 17:29:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1601825382; bh=otlkCb4M1uogpYT/wrOGg/R30bdTqv6TKwIuGVESdeU=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=mdGzJrrpxRS+ybmc2gxees5gkDanuPK5BB6jUNJc/M6lLs/tXp8d/eE718pN+yTMJ
         KRmn5IRiqa7ABXsOMA/Tc9CPDcmy9GwF7JAssYzdonA314uCudF3AG2I7At16rwTQY
         Sl/V3NlsBoVxfdLvnSSICzLLnZxlh5GQM5UtTPHA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kP5xD-000lRZ-0n; Sun, 04 Oct 2020 17:29:39 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: serial: qmi_wwan: add Cellient MPL200 card
Organization: m
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
Date:   Sun, 04 Oct 2020 17:29:38 +0200
In-Reply-To: <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
        (Wilken Gottwalt's message of "Sat, 3 Oct 2020 11:39:55 +0200")
Message-ID: <87d01yovq5.fsf@miraculix.mork.no>
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
> index 07c42c0719f5..0bf2b19d5d54 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c

This is not a 'usb: serial' driver. Please resend with a less confusing
subject prefix.

> @@ -1432,6 +1432,7 @@ static const struct usb_device_id products[] =3D {
>  	{QMI_GOBI_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
>  	{QMI_GOBI_DEVICE(0x12d1, 0x14f1)},	/* Sony Gobi 3000 Composite */
>  	{QMI_GOBI_DEVICE(0x1410, 0xa021)},	/* Foxconn Gobi 3000 Modem device (N=
ovatel E396) */
> +	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},	/* Cellient MPL200 (rebranded Qual=
comm 0x05c6) */
>=20=20
>  	{ }					/* END */
>  };


This table is supposed to be organized by device type.  The last section
is for Gobi2k and Gobi3k devices.  Please try to put new devices into
the correct section.

Thanks



Bj=C3=B8rn
