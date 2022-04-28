Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A4D513969
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiD1QMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiD1QMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:12:01 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083814A3E0;
        Thu, 28 Apr 2022 09:08:45 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C15B4200013;
        Thu, 28 Apr 2022 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651162122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xAyaWEkH2/4aW5XlKRnGGy+8F8wUwVHlINCQRdnZd4=;
        b=jq0PaPBqQNtmtxmy1ikGxVK/DCDWJTO3jwrRPwtK+B1rzJpR6TspK85e4CKPQHl2n6yS2R
        n//jY10iWXk5zgiv5kuAXo/QZGoBhK33MWV+C2Xs7spzBPecDh9UAI5hqhnFI34j0wT0kN
        fAagSyWE95uvGO5ZR6x2N4I5vhslRYhtjhewsqNkDK2RDTRdtvzTCVnsbSDfxVF4hsZ+Bq
        hkUVOlftAqLabhWJM+dIDYqvbY14HgJUfFlCLQJKh0pEDlOWGbmHgKfOTPapxiwMKzHVSF
        n4gQpjwbi2fUjT9ET5xUhnWgbn8dE6XuHtgvziiSCXm1ZqWRFg93r2PFNzrP5g==
Date:   Thu, 28 Apr 2022 18:08:39 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v3 3/4] net: mac802154: Set durations
 automatically
Message-ID: <20220428180839.74347c3d@xps13>
In-Reply-To: <8f32c05e-5830-79b3-1a3a-996ee8b58e52@datenfreihafen.org>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
        <20220201180629.93410-4-miquel.raynal@bootlin.com>
        <20220428175838.08bb7717@xps13>
        <8f32c05e-5830-79b3-1a3a-996ee8b58e52@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
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

Hi Stefan,

> > I see it's "only" in wpan-next (781830c800dd "net: mac802154: Set
> > durations automatically") and was not yet pulled in the net-next
> > tree so please let me know what you prefer: I can either provide a
> > proper patch to fit it (without upstream Fixes reference), or you can
> > just apply this diff below and push -f the branch. Let me know what you
> > prefer. =20
>=20
> No forced push to a public branch in my public repo. Please provide a fix=
up patch that I can apply on top.

Duly noted.

Thanks,
Miqu=C3=A8l
