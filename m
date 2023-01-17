Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC166D893
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbjAQItt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbjAQItr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:49:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1195FE396;
        Tue, 17 Jan 2023 00:49:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C60E8B811F3;
        Tue, 17 Jan 2023 08:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A511C433EF;
        Tue, 17 Jan 2023 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673945382;
        bh=t4WLIU04MNmLbqVeO6FrbfGvJwh92/6Ee1gfmuH0qNY=;
        h=Date:From:To:Cc:Subject:From;
        b=ScYx9hhyFijdBZhqGz3Z2T6Dfoj34Su56v/582u6Px4VGM6GdlyE7bTf1fDR2R+19
         yZMWLhkxUWC3wZXPkn1SxRfqLD9lA6O9OdtDr3qzd2Fts5PMPErxGSLebz4Zi5raYY
         kx5k1Tg+cvFktXZI/KYTSX2n2f1x6+kPlZql9hkf8nwJXB6npM9R+HoIq3eHxtolhR
         hvI7wwq8xO1PYnNWlRnf8jZBx0R7WVXgqR/QhRG53/Z1g0z7iXfvnxEFPrlER83kyH
         wLkXWRWOX//QX3Dka7dKQvUtdd83xUJkg/fuuffBKfBRW+ph7yV5O/KkVnhqzoXIYj
         2Fjbi87GnhGFQ==
Date:   Tue, 17 Jan 2023 09:49:39 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-i2c@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PULL REQUEST] i2c-fwnode-api-2023017 for netdev
Message-ID: <Y8ZhI4g0wsvpjokd@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>, netdev@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4C1artG1BI8z3fwk"
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4C1artG1BI8z3fwk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

here is an immtuable branch from I2C requested by Russell King. This
allows him to rework SFP code further.

Please pull.

   Wolfram


The following changes since commit 1b929c02afd37871d5afb9d498426f83432e71c2:

  Linux 6.2-rc1 (2022-12-25 13:41:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git/ tags/i2c-fwnode-api-2023017

for you to fetch changes up to 373c612d72461ddaea223592df31e62c934aae61:

  i2c: add fwnode APIs (2023-01-17 09:29:59 +0100)

----------------------------------------------------------------
Immutable branch adding fwnode API to the I2C core

----------------------------------------------------------------
Russell King (Oracle) (1):
      i2c: add fwnode APIs


with much appreciated quality assurance from
----------------------------------------------------------------
Mika Westerberg (1):
      (Rev.) i2c: add fwnode APIs

 drivers/i2c/i2c-core-acpi.c | 13 +-----
 drivers/i2c/i2c-core-base.c | 98 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-core-of.c   | 66 ------------------------------
 include/linux/i2c.h         | 24 +++++++++--
 4 files changed, 120 insertions(+), 81 deletions(-)

--4C1artG1BI8z3fwk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmPGYSMACgkQFA3kzBSg
KbYh9g//XjxOIRW/U9FKMyqPhvFcgUkWeYhyQLtASTXHudKocwdQld6zosWpZd/q
aVV6GduB7dqwSbLxyJVWQiZJ6F24LuU/wVp/HCLa1TBCNc2jnYZgSHkuSUjrsYaq
YfI5IdEHAUjpzcDc6ulxErnxFf3+60+CUtoYdmt4U9ZK63QlDd50g6PPhfYcos36
+hW6z+1HBaIgjBcY4s3IDUZgH5AeyaeuIwheMQO+MpG/7cLLlZafiZKH793sNxsg
Giv8DSu1MKxxSFJAMbn1PXDdL3gufLbzNjW4IDYtT6GcFq/2fcucJL9gHYGxvYPe
bkDh2BeS9f6FjsaZAmoAYSx0HgjwUvYGJ/GMg28NJGKQ6wI3ZocffJ10STnqCcBO
wWd7DvsQjh/vBK4Pp2LPetG6ceGdV/30B4Nd0qBKy2fALMCoTy0+R6FpQEOzx9MU
ybUzFhpvsrFa//jvErHVjjoVibbI5zg6az3A88RKVyFagGz1L9kz0F681TJyGWy2
CuztJJ0/OXbpWfO13Dw/1rj68uwjdcENIup7iGlP0zFLC0glB+2J6R1qKxwk0NkG
IxnJ4fvmQrB0+u4mbPBOySwPnANYq1wuMFSA5QnWUJnBXI4y7HPbiYgd0E39pUpT
y22gyH1cn1MGgYqicFBJqncD+1lkQ8d2gSVRBrSpD/ODnGNTgXw=
=PEgT
-----END PGP SIGNATURE-----

--4C1artG1BI8z3fwk--
