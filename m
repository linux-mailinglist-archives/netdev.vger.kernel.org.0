Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB382B842B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgKRStn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:49:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgKRStm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:49:42 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10D8246B9;
        Wed, 18 Nov 2020 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605725382;
        bh=UgceN5sO4JwwPCASJv0qKdvFM3Z0kpl0YVr5qTEc694=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bFh/p/VUOc0Z5RM3ZZ+BVl6yzjLUYphdAxb8ge1SBWBFqGt0T7tfGatIgzKX/64/q
         DnJoqd2y2z+1NWStniYyY3YkwXNCxvmGpfZE0dwbF7REAJMrKKd4ol4Hx2K24N+ays
         ZBDpqN8VkeQzADLB6tr/diXJo6wWWdhGV+5B0Iq0=
Date:   Wed, 18 Nov 2020 10:49:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Filip Moc <dev@moc6.cz>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Set DTR quirk for MR400
Message-ID: <20201118104940.19996e94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <87d00bu6uc.fsf@miraculix.mork.no>
References: <20201117173631.GA550981@moc6.cz>
        <87d00bu6uc.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 20:22:03 +0100 Bj=C3=B8rn Mork wrote:
> Filip Moc <dev@moc6.cz> writes:
>=20
> > LTE module MR400 embedded in TL-MR6400 v4 requires DTR to be set.
> >
> > Signed-off-by: Filip Moc <dev@moc6.cz>
> > ---
> >  drivers/net/usb/qmi_wwan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index afeb09b9624e..d166c321ee9b 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -1047,7 +1047,7 @@ static const struct usb_device_id products[] =3D {
> >  	{QMI_FIXED_INTF(0x05c6, 0x9011, 4)},
> >  	{QMI_FIXED_INTF(0x05c6, 0x9021, 1)},
> >  	{QMI_FIXED_INTF(0x05c6, 0x9022, 2)},
> > -	{QMI_FIXED_INTF(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD L=
TE  (China Mobile) */
> > +	{QMI_QUIRK_SET_DTR(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TD=
D LTE (China Mobile) */
> >  	{QMI_FIXED_INTF(0x05c6, 0x9026, 3)},
> >  	{QMI_FIXED_INTF(0x05c6, 0x902e, 5)},
> >  	{QMI_FIXED_INTF(0x05c6, 0x9031, 5)}, =20
>=20
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>=20
> This fix should probably go to net+stable.

Done, thanks!
