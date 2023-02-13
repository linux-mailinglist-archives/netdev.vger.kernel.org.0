Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9B369506D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 20:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjBMTKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 14:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjBMTKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 14:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661BE15CA0;
        Mon, 13 Feb 2023 11:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C5A9B818D1;
        Mon, 13 Feb 2023 19:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43438C4339C;
        Mon, 13 Feb 2023 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676315419;
        bh=QZT4nkw5tiU/kSW6DeOu7c5zVljrfMg5dq4AfXBk5G4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZmzlsct3LQGj6WqJFGDr3W4TBUk/M7QqONs9Dhdq+7wwR1zGn2Jj8l0WwnWQXj87
         GEZ8giN6DfKDA7gIov5YbUYT3Ise8JZQAGhcRIuG32/AhDSe7c78JF9rOBGhbj/nrp
         Gj9dzQvpml0B3OnrwLIZoAR3DrS2wKXvkfTvlN3cAzqQnfKt9toPNoNa0tUQrYD2nP
         CgydvBLj86ijP8nR/g0BNUkpWkLWJna0TojVppucLwjL2i1FbTlDXkZlvn2VtbGass
         EU9fjSB1Fk8hrmCiDhj1Wn4HMFkcw43pF+iQ+ECCy3v2kwBD8nuR1tSY4DbAsPfBJm
         d1U2A7dnqZX+w==
Date:   Mon, 13 Feb 2023 19:10:14 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Marc Bornand <dev.mbornand@systemb.ch>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v2] Set ssid when authenticating
Message-ID: <Y+qLFmZS4W6SvE9c@spud>
References: <20230213105436.595245-1-dev.mbornand@systemb.ch>
 <5a1d1244c8d3e20408732858442f264d26cc2768.camel@sipsolutions.net>
 <NTBtzDurDf0W90JuEPzaHfxCYkWzyZ5jjPwcy6LpqebS6S1NekVcfBU3sNWczfvhHEJGOSyzQrb40UfSIK8AFZpd71MExKldK7EFnMkkdUk=@systemb.ch>
 <3a9e70f9fe5ac0724730cb445b593fdb7eeeaae9.camel@sipsolutions.net>
 <IpEe-tq4Ss3KPNzL__A-DUEgn0MKIil7Hf02MWSUxV_mYXALCfMWfoZLQCiV6Rr5JGawMTI0FnKfNuQihm9WzLf-eGfeDOfU8sV9fzmBz8w=@systemb.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q0hWsXs2KtDgx7dR"
Content-Disposition: inline
In-Reply-To: <IpEe-tq4Ss3KPNzL__A-DUEgn0MKIil7Hf02MWSUxV_mYXALCfMWfoZLQCiV6Rr5JGawMTI0FnKfNuQihm9WzLf-eGfeDOfU8sV9fzmBz8w=@systemb.ch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q0hWsXs2KtDgx7dR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2023 at 07:04:22PM +0000, Marc Bornand wrote:
> On Monday, February 13th, 2023 at 18:37, Johannes Berg <johannes@sipsolutions.net> wrote:
> > As an aside - there's little point in encrypting the mail sent to me
> > when you send it also to a public list :) Just makes it more annoying to
> > use.

> Really Sorry, The mail service I am using is currently not letting me deactivate
> encryption for recipients with a wkd, I think I will try to contact support
> and ask there.

It's proton isn't it?

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/process/email-clients.rst#n354

Good luck with their support, I'm curious how you get on!


--q0hWsXs2KtDgx7dR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+qLFgAKCRB4tDGHoIJi
0uiZAQCoC9GFuzxwZHOpzHF/OJ1oDqG6plMl6vsh9YSHhz4a3AD/fcQawYmivS/4
Tzu6JpzqH16gZg6BnPf+XyOpiPca4AY=
=OQ4k
-----END PGP SIGNATURE-----

--q0hWsXs2KtDgx7dR--
