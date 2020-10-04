Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9C4282C8D
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 20:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgJDSav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgJDSav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 14:30:51 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1303EC0613CE;
        Sun,  4 Oct 2020 11:30:51 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4C4C3D03sZzKmgH;
        Sun,  4 Oct 2020 20:30:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1601836245; bh=CAYG7SSZZB
        jOGAwT9xSUEM3/y/EavesF9UHhwXLt68U=; b=WDg9eoJkVUYUP2lWMliO44a4SW
        UNW2B6s1LGyRoUEeVtSFcIBhXSfDtGJ+KGE0fL44qtJodgA7XhJMCu0tGMJ1pAeh
        TiFxtO8iQt1xiapQzHnufJ5TmafyF12BGszDm8edOykbGp2g7YVHGPudxjci/Hsj
        ozl6x26weB3YKPIOg8x94tdHi+VE5vHYLlzWkO7w+dOtH5Or0Md6ihSaucT1KYTC
        aTPLTbrEmFFLbxivSu0pqIk9DTp+3/o5LVKISbKKrFmfteJMbXa0I5kngmE8ay8v
        CXSfRE7fcfJ7jA01jdo/pawydB5pGAQMYq55Uk6t0CqCE42PNxMuy5oZ2ZHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1601836246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YYxlYyQaZlvimy5aVx+UnV8YBwbTQYVCngLikervlkQ=;
        b=nZm8d7w9Yl3QT1g87qtWZyE3WvHB6ao811fFn3rmusStXQb9vk3o7JfBU9PiQxhSBfsEVq
        YullZxRpLZRI3W1bLNu9oXvUNIGO1NtI2p0huxwKWiuGP954bwODC64nzbBZJCpgBKDork
        2ds/gRHbSWhEozQFAvaAQxHSzv0Y9O9s7PMbvZlDtYyc+z+Q+1PNSXZQfnT/S2b0Qp8S31
        gPOy57k3v7IoXmRss/v/MM3BBlyF2l1PHLVz1SAu4KVLYW3AiDgxHyV4AkVcxFSe+uklWG
        wlPpeXIlohTQIeOS0+rbr9VWLFj87UP3tdqw9RNdpMOM1u7qLYC+4373kkn/eA==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id wqMFUn9_6WML; Sun,  4 Oct 2020 20:30:45 +0200 (CEST)
Date:   Sun, 4 Oct 2020 20:30:42 +0200
From:   Wilken Gottwalt <wilken.gottwalt@mailbox.org>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: serial: qmi_wwan: add Cellient MPL200 card
Message-ID: <20201004203042.093ac473@monster.powergraphx.local>
In-Reply-To: <87d01yovq5.fsf@miraculix.mork.no>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
        <87d01yovq5.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.51 / 15.00 / 15.00
X-Rspamd-Queue-Id: DCF4117E6
X-Rspamd-UID: d87780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 04 Oct 2020 17:29:38 +0200
Bj=C3=B8rn Mork <bjorn@mork.no> wrote:

> Wilken Gottwalt <wilken.gottwalt@mailbox.org> writes:
>=20
> > Add usb ids of the Cellient MPL200 card.
> >
> > Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> > ---
> >  drivers/net/usb/qmi_wwan.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 07c42c0719f5..0bf2b19d5d54 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
>=20
> This is not a 'usb: serial' driver. Please resend with a less confusing
> subject prefix.
>=20
> > @@ -1432,6 +1432,7 @@ static const struct usb_device_id products[] =3D {
> >  	{QMI_GOBI_DEVICE(0x1199, 0x901b)},	/* Sierra Wireless MC7770 */
> >  	{QMI_GOBI_DEVICE(0x12d1, 0x14f1)},	/* Sony Gobi 3000 Composite */
> >  	{QMI_GOBI_DEVICE(0x1410, 0xa021)},	/* Foxconn Gobi 3000 Modem device =
(Novatel
> > E396) */
> > +	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},	/* Cellient MPL200 (rebranded Qu=
alcomm
> > 0x05c6) */=20
> >  	{ }					/* END */
> >  };
>=20
>=20
> This table is supposed to be organized by device type.  The last section
> is for Gobi2k and Gobi3k devices.  Please try to put new devices into
> the correct section.

Oh sorry, looks like I got it mixed up a bit. It was my first attempt to su=
bmit
a patch set. Which is the best way to resubmit an update if the other part =
of
the patch set gets accepted? The documentation about re-/submitting patch s=
ets
is a bit thin.

Will
