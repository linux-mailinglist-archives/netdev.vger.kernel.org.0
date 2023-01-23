Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE0C677FAA
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjAWP1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjAWP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:27:14 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A590612F2C;
        Mon, 23 Jan 2023 07:27:07 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 3AD4B100004;
        Mon, 23 Jan 2023 15:27:02 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Sam Creasey <sammy@sammy.net>,
        "open list:8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULT..." 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ethernet: Fix full name of the GPL
Date:   Mon, 23 Jan 2023 16:26:56 +0100
Message-ID: <2458285.UPXgfWZGIM@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <Y85eX2shWBXv+Z7E@corigine.com>
References: <20230122182533.55188-1-didi.debian@cknow.org>
 <Y85eX2shWBXv+Z7E@corigine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart11061844.SXfucPHxpH";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart11061844.SXfucPHxpH
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH] net/ethernet: Fix full name of the GPL
Date: Mon, 23 Jan 2023 16:26:56 +0100
Message-ID: <2458285.UPXgfWZGIM@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <Y85eX2shWBXv+Z7E@corigine.com>
MIME-Version: 1.0

On Monday, 23 January 2023 11:15:59 CET Simon Horman wrote:
> On Sun, Jan 22, 2023 at 07:25:32PM +0100, Diederik de Haas wrote:
> > Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> > ---
> > 
> >  drivers/net/ethernet/8390/mac8390.c      | 2 +-
> >  drivers/net/ethernet/i825xx/sun3_82586.c | 2 +-
> >  drivers/net/ethernet/i825xx/sun3_82586.h | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> as we are here would it be better to just move to an SPDX header instead?

Hi Simon,

Yes it would be better to move to SPDX header(s) instead.
But I now think [1] that I would be (technically) changing the license and I'm 
not in a position to do that.
While it may be reasonable to *assume* that GNU General Public License was 
meant, I think that's not enough when it comes to legal/license issues.

So please disregard my patch submission and apologies for the noise.

Regards,
  Diederik

[1] https://lore.kernel.org/lkml/2281101.Yu7Ql3qPJb@prancing-pony/
--nextPart11061844.SXfucPHxpH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY86nQAAKCRDXblvOeH7b
bixJAQDceaeG+lfmanfsRwogBmM8zUdG5HAtp8BjxQliqW2qbAD/T5AEa3bJJw7G
QdZ8qXE9GjesyXwrj1TaEThk/APvNwY=
=mbWi
-----END PGP SIGNATURE-----

--nextPart11061844.SXfucPHxpH--



