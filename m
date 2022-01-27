Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B950249E80E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244137AbiA0Qv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:51:57 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:55479 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244141AbiA0Qv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:51:57 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 364CFC0008;
        Thu, 27 Jan 2022 16:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643302315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yldgb1jJRgdr5TixNjS58O9AjaOif/VfjaBoPa/kMoY=;
        b=AVA954oRh1GHgwDI6bSPcB2SlgInevrzfz+RG2NwscCR1IROs9Esf1+PJPbtdoAk3wJOfI
        5RizSUBc5dgDc/4mUTP0O+Mp4STR3Q9xz5sDjEqFgNvsnWBy9V/jxYcl9MiBqYYiFhkKst
        6PBJ4zzV/NkIpVcu17AUIPMKPvW/yPgR+Gfmwd8RciBPB9CLIIOGml0782pQ+hFe4h6SqS
        mxa3mwEqj1jY4Ep+SttE+/JTeWyiTUQopX7CO8l3cAlJbSy6qJxzM6mIawGDdSDcW6TRS6
        QJ6QuJRsxKvQ7dJRQ0SPivGVtxFJIB/PSbHsZsQva0MeAPgv+cSC9lOINBd6wg==
Date:   Thu, 27 Jan 2022 17:51:51 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next 4/4] net: ieee802154: Add a kernel doc header to the
 ieee802154_addr structure
Message-ID: <20220127175151.1d6f70bb@xps13>
In-Reply-To: <6903cb13-2fc9-8c8a-f247-8cbeddf51103@datenfreihafen.org>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
        <20220120004350.308866-5-miquel.raynal@bootlin.com>
        <6903cb13-2fc9-8c8a-f247-8cbeddf51103@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Thu, 27 Jan 2022 17:05:42 +0100:

> Hello.
>=20
> On 20.01.22 01:43, Miquel Raynal wrote:
> > From: David Girault <david.girault@qorvo.com>
> >=20
> > While not being absolutely needed, it at least explain the mode vs. enum
> > fields.
> >=20
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
> >                              reword the comment]
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   include/net/cfg802154.h | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> >=20
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index 4193c242d96e..0b8b1812cea1 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -29,6 +29,16 @@ struct ieee802154_llsec_key_id;
> >   struct ieee802154_llsec_key;
> >   #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */ =20
> >   > +/** =20
> > + * struct ieee802154_addr - IEEE802.15.4 device address
> > + * @mode: Address mode from frame header. Can be one of:
> > + *        - @IEEE802154_ADDR_NONE
> > + *        - @IEEE802154_ADDR_SHORT
> > + *        - @IEEE802154_ADDR_LONG
> > + * @pan_id: The PAN ID this address belongs to
> > + * @short_addr: address if @mode is @IEEE802154_ADDR_SHORT
> > + * @extended_addr: address if @mode is @IEEE802154_ADDR_LONG
> > + */
> >   struct ieee802154_addr {
> >   	u8 mode;
> >   	__le16 pan_id;
> >  =20
>=20
> Same here, please fold into the addr moving patch. I see no reason why sp=
litting these would make it easier or do I miss something?

I really split every change that I could as a habit, but there is no
problem with squashing them both.

Thanks,
Miqu=C3=A8l
