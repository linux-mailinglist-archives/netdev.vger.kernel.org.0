Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0FD69E34A
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbjBUPWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbjBUPWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:22:42 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA192006B
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:22:41 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2DCA934C21
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676992960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=JFvqcWl0929s99q9QxgaG7uwbUaBzJguC4bgqhUdHdE=;
        b=y2skk9hxn5EF8v9otBEDgy8XqzIS4soGng0g/oQzJqHPEDYTvLb2vrkRh4qr2v/NXz68YW
        q0a+q+3MGM9oN8UFCXhEmYMdc7a2RBEtRMwnADZT9E+Hv6EQ0B2i9FevEb8kupl2mhQRek
        dTn99xqgMkvp50QTeuwFeQyKf2M1ETY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676992960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=JFvqcWl0929s99q9QxgaG7uwbUaBzJguC4bgqhUdHdE=;
        b=JEw8X4IBgidEo6xMwyzjziNCHOiFzH/4zG7RXS3YxAHWr6Rarzuk0GpQ4ABFrBNvw48ayK
        q8hWUYNHkWlFo0BQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 21E9C2C142
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 15:22:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E6C316032E; Tue, 21 Feb 2023 16:22:39 +0100 (CET)
Date:   Tue, 21 Feb 2023 16:22:39 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 6.2 released
Message-ID: <20230221152239.4gsve2lqnb7vtadu@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="37hekn3od5eprj5f"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--37hekn3od5eprj5f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 6.2 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-6.2.tar.xz

Release notes:
	* Feature: link down event statistics (no option)
	* Feature: JSON output for coalesce (-c)
	* Feature: new link modes (no option)
	* Feature: JSON output for ring (-g)
	* Feature: netlink handler for RSS get (-x)
	* Fix: fix boolean value output in JSON output
	* Fix: fix build errors and warnings

Michal

--37hekn3od5eprj5f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmP04bwACgkQ538sG/LR
dpU6hAgAjVLvlykBg1krLSqQyGix3CqkPfMusTbaoqpfRNzrDMVsLqP9t9EgMGM7
3LrHyNetTYzwKkHNzu2r7CUFc+aZ/n70V77v/NoLRXuUJGIj2FjeBDuxS7wUTJGN
DTxK3jdo8xmv/iOtmeTA+Y+677YOG+n29ea2oiQ0xzgrwIGQpEUPKqbLgfao4L46
qmL8Uzkm6zgTMuMQEjAal7v4/KsX8PeLvqf69jiwLHuLgSH/3snnCHLPNjY1iauI
g0i8iG8bxIptQpCnW0ca9i0jD2w3anu9ydhVGUB7dw7ayu2SVH/Ab01sNE2iwfg6
6Ys7AcJHLeirYsBEfwaFBgTeFZRxcQ==
=pSxU
-----END PGP SIGNATURE-----

--37hekn3od5eprj5f--
