Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9D65FA6F8
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 23:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJJV1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 17:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJJV1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 17:27:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E493D79EF6
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 14:27:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9958422DDE
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 21:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1665437262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=2w0zntAfFVfZ5RYUF200Jo5dgm4NoiVUgM6/4ozEB20=;
        b=GhusWm7EN1Q+wpXxZ36A5M1mLsEilbRNPR0WEk9eiuwlORedFy7gexbSZvyaDhGhCKD7GW
        5FYWHZ7wiFKM8MtwmSY1NRTsbIqYshNnz5jI6gB2dXk4JDkDDVgg2kz31UDqpFdxkfiFp1
        hIJk9jzD0bFawDFdtX96Gd24ptc/tq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1665437262;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=2w0zntAfFVfZ5RYUF200Jo5dgm4NoiVUgM6/4ozEB20=;
        b=dcLle/u8RJ/YhZyvuWgNK9CDARwSkDjVpJ2z8BBGsv1gx+bl50JwxH26eovlMpc6eihVCu
        xJV1ka9/Sl5zwUBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8EF0C2C141
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 21:27:42 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EA30060927; Mon, 10 Oct 2022 23:27:39 +0200 (CEST)
Date:   Mon, 10 Oct 2022 23:27:39 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 6.0 released
Message-ID: <20221010212739.ev7w4rqwppfcvo5u@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zuwk36bgwbm2ho2u"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zuwk36bgwbm2ho2u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 6.0 has been released. There is only one non-cosmetic change but
skipping 6.0 release felt wrong.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-6.0.tar.xz

Release notes:
	* Fix: advertisement modes autoselection by lanes (-s)

Michal

--zuwk36bgwbm2ho2u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmNEjkYACgkQ538sG/LR
dpWJgwf/U8Gk0MA6Tz3GnNVMy/Y5xjI97b61RcfO5B5oTc4zYTK0xKAcdaYJc3n+
zOJEs//Xo/V8ePlY6sqHjRVuGK8p+5ynA2H4jDwLHwOflPt/D2ANWZ+I1Bc+sGP3
Kby61pOH4BcLWucR5SDOpYVmhfbnhdZ4wSNBBUTF44Cxzgbpc2CwmnM6wIkViDrk
WtCKb0kLp1AXE4B1SzrnjvrHGk59GgrRx0bvR9EYhC3TcIg013hlvOjuDEoj1r3g
6u3sZp/79NHNttIpRA13NLd+3hKX1nEh+NLtONPwlOle+Y5gP3F1rJxl2zVwBUyS
ZPGIPHQDKIVdpuG2yDKZrEY1kSoCAQ==
=9M2R
-----END PGP SIGNATURE-----

--zuwk36bgwbm2ho2u--
