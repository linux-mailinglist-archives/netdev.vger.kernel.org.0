Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFD96515BC
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 23:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiLSW4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 17:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiLSW4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 17:56:08 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC20128
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 14:56:03 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8C4D138B3D
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1671490562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jmksmAQ+VFdP4SlD+4VSlRIiaApxBLxcRbwQxcYvltU=;
        b=qr7pYePvOIfGlfC6rY9E6KFWLvs7nzxGuiYkKqjxWTZdgXHIT7Q1LqacwWWFc4yIdlOQtj
        fXAMm9n9WQhpxMJP3wT9SW/itVNNJYo0oPYgi2XbBgQ6zne8/rRIvHCaTk4sHv2+Q0J86l
        5l/4HP5D7gSh4cfoN5uiLXb04a5RU6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1671490562;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=jmksmAQ+VFdP4SlD+4VSlRIiaApxBLxcRbwQxcYvltU=;
        b=gA1PyNRDZ1LiljCUKGDkOrWqgyp6y+5MqSe08KBY/I3pZ1ywGxuhUkm219dZcFnwH5iD7f
        ST6+P+bdJyTDRTDw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8389F2C146
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:56:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5BCE66032F; Mon, 19 Dec 2022 23:56:00 +0100 (CET)
Date:   Mon, 19 Dec 2022 23:56:00 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 6.1 released
Message-ID: <20221219225600.r54vejiqapn266cm@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="shsd5fnrtebxy7qv"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--shsd5fnrtebxy7qv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 6.1 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-6.1.tar.xz

Release notes:
	* Feature: update link mode tables
	* Feature: register dump for NXP ENETC driver (-d)
	* Feature: report TCP header-data split (-g)
	* Feature: support new message types in pretty print
	* Fix: fix compiler warnings
	* Fix: man page syntax fixes

Michal

--shsd5fnrtebxy7qv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmOg6/wACgkQ538sG/LR
dpXV8wf7BatDjej89uaQZjEsA7DW7BP7HhZR7dshWHWKqO9PUcXS3lXbxegxFlLp
tcGcFYHtF6Ej69oofB/CfwCMCq5J7avbj5LlycegQQqQQE1AuU5HvqYqLIerwHqw
N+2kptYq3Kq09hLvbrh2/rQUu8SDlmzwvOaApB5RS4140cUEYf+J4TxDo8Q6myWc
JR/W+9Kdz2UNf3el3Zhj8/C6FPS2OXK7wHstWxvnELle8PmNfcsABgnFIZRdOkVV
BYfnW2/8Zc+fi1l73gKjCHihea850Rbbb9Xj48FWWhGI0XurVRUomNe2kgYPbMAH
kaz3wJmsywMG/v4YXL0KFWeA4dUnuA==
=egR0
-----END PGP SIGNATURE-----

--shsd5fnrtebxy7qv--
