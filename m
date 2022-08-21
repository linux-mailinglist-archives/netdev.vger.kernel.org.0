Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE50259B6D2
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 01:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiHUXpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 19:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiHUXpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 19:45:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A0819297
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 16:45:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 83A2D5C227
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 23:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661125540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=+f8aW2THqU12URX1juVodaYJIficzOny0x1hvi9bs7o=;
        b=Ps1ay6Vf6BN6AmqvOk++Skpv/3Og9m5+rRNzjfsyFLTac8qvZcKHgEMUi0q6Vgo8KvzM3t
        7WZQfg481GML9j3S99sEWDsr50r+rEfrMBvP7djuAbNCRBH8F7LTV9fHDVHwT4nafIGbe1
        GpEUhqaAqHwvsjGtxFuZoRpp3HpYPlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661125540;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=+f8aW2THqU12URX1juVodaYJIficzOny0x1hvi9bs7o=;
        b=jnIGpKQIhP5yKH0CPRh1UQZR9ICEtC46U1NEQaT8YdSEBAz/UNqX7DPzD3l3o4Uw5EGyHU
        5DAXKTclEFEvxhAw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7B0E32C141
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 23:45:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 513FF603F0; Mon, 22 Aug 2022 01:45:39 +0200 (CEST)
Date:   Mon, 22 Aug 2022 01:45:39 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.19 released
Message-ID: <20220821234539.f7nslwyd53bsftsy@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vibay5zybqxyuyto"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vibay5zybqxyuyto
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.19 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.19.tar.xz

Release notes:
	* Feature: get/set tx push (-g and -G)
	* Feature: register dump support for TI CPSW (-d)
	* Feature: register dump support for lan743x chipset (-d)
	* Fix: fix missing sff-8472 output in netlink path (-m)
	* Fix: fix EEPROM byte write (-E)

Michal

--vibay5zybqxyuyto
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmMCw50ACgkQ538sG/LR
dpWjowf/V799c7HkvDByu4s0KTFg+JqhD1c4TXjeuzSPHYKuKxnYAa0khRNW44JY
x3QiXSCjJPTrhjssI46mnuJq96h7b/9sMlu9xdEHuuSalKKdJKQTBuZmsGplk574
wzf4emrRqwHF7GoIsawDU3t4ka6WhDh2N7XkX1sK+Un3z5arso9ZzwX5mQF3Kp1C
2712+Y64/rNTaSLKbpJsYpeUv0Gy91SVGDLTP1AmLSk2FqjVagHvg9Jien7OP0rx
1NwDCnHbFjXhGSxRtsbFyvNBbbSruV76xB5AA+U84XO0e4y3zXJMKeYXdxRQQLEA
UNZiQGLRr86lDEBxYDyvy16Ws4Ovew==
=GiG6
-----END PGP SIGNATURE-----

--vibay5zybqxyuyto--
