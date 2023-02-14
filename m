Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EC66964D4
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjBNNj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjBNNjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:39:14 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7692725280;
        Tue, 14 Feb 2023 05:39:11 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 71B851C0002;
        Tue, 14 Feb 2023 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676381950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgmWVcYY++zbdCYmjM2dw0GxHj2M4hVN45uErNbPbqY=;
        b=QGDZfWq6t8iswxp3eizIZqUbOMTzPWlDMxCG+nh17SSLE5fA+96UkTR1kLfT6spm9rAFIi
        9k9Ng6FSZclB03w8DTS1dnpUIs2FaL5Fi67fZbhoBiwT3JzwHiTJPytDyWfXEMr3HWTbh+
        AdJyoW5WRo2A9aN4CCeX0xFml2YZthaSCVC/tqbJh+KA6phPwIqPmTstIjhK/x74PFiLxg
        +4//dhigKzx1kM9kxE68mfLA4qvyED1G5VmMVYXTz/Xac2KhurklZUJ0Rj3uo9rTiR86K5
        xICG0x/g+KJ8FK4+5J3G/tbW0PedVb6OK3+cEZNgle0lMcqMvGKw49EKQnzpVw==
Date:   Tue, 14 Feb 2023 14:39:04 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan 0/6] ieee802154: Scan/Beacon fixes
Message-ID: <20230214143904.2a9eebb6@xps-13>
In-Reply-To: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
References: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

miquel.raynal@bootlin.com wrote on Mon, 13 Feb 2023 17:54:08 +0100:

> Hello,
>=20
> Following Jakub's review on Stefan's MR, a number of changes were
> requested for him in order to pull the patches in net. In the mean time,
> a couple of discussions happened with Alexander (return codes for
> monitor scans and transmit helper used for beacons).
>=20
> Hopefully this series addresses everything.

Looks like my 'Fixes' commit hash lookups lead to local tree hits rather
than matching the ones in the wpan-next tree, so these hashes won't
point at any valid commit once in the upstream trees. I am sending a v2
with nothing else than these commit hashes fixed.

Sorry for the noise.

Thanks,
Miqu=C3=A8l

>=20
> Thanks,
> Miqu=C3=A8l
>=20
> Miquel Raynal (6):
>   ieee802154: Use netlink policies when relevant on scan parameters
>   ieee802154: Convert scan error messages to extack
>   ieee802154: Change error code on monitor scan netlink request
>   mac802154: Send beacons using the MLME Tx path
>   mac802154: Fix an always true condition
>   ieee802154: Drop device trackers
>=20
>  net/ieee802154/nl802154.c | 125 ++++++++++++++------------------------
>  net/mac802154/scan.c      |  25 ++++++--
>  2 files changed, 65 insertions(+), 85 deletions(-)
>=20
