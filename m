Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DC3677E46
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjAWOmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjAWOmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:42:23 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0885822014;
        Mon, 23 Jan 2023 06:42:20 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 6824360002;
        Mon, 23 Jan 2023 14:42:17 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        "open list:ISDN/mISDN SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mISDN: Fix full name of the GPL
Date:   Mon, 23 Jan 2023 15:42:17 +0100
Message-ID: <2808655.2KCpM3mDq9@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <20230122111707.68ddead6@hermes.local>
References: <20230122181836.54498-1-didi.debian@cknow.org>
 <20230122111707.68ddead6@hermes.local>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart18650867.2nVj0xKjmy";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart18650867.2nVj0xKjmy
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] mISDN: Fix full name of the GPL
Date: Mon, 23 Jan 2023 15:42:17 +0100
Message-ID: <2808655.2KCpM3mDq9@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <20230122111707.68ddead6@hermes.local>
MIME-Version: 1.0

On Sunday, 22 January 2023 20:17:07 CET Stephen Hemminger wrote:
> > - *             This file is (c) under GNU PUBLIC LICENSE
> > + *             This file is (c) under GNU GENERAL PUBLIC LICENSE
> > *
> > * Thanks to    Karsten Keil (great drivers)
> > *              Cologne Chip (great chips)
> 
> No, this is not the current practice.
> Instead replace this with proper SPDX header.

You are correct. On top of that, my initial view of a spelling issue was wrong.
Due to [1] I now see it as a legal issue as it would (technically) change the
license, which I don't know how and I think I also can't resolve.
Consequently I want to retract my patch.

Sorry for the noise.

Diederik

[1] https://lore.kernel.org/lkml/ad99d227-ce82-319b-6323-b70ac009d0e7@roeck-us.net/
--nextPart18650867.2nVj0xKjmy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY86cyQAKCRDXblvOeH7b
bq6yAPwKkyP4eLa0wlsK9MLxzgnZQJHoW4nf29eAr0NOeWlQtQD/e2R9FG7Wr110
y9vGQ4DVCPo2cD2SOEeSAJSwj1OVYgU=
=bMFg
-----END PGP SIGNATURE-----

--nextPart18650867.2nVj0xKjmy--



