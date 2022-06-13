Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E32554A2D3
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 01:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbiFMXjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 19:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiFMXjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 19:39:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B362D1C1
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 16:39:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 596D91F460
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655163554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=J7hFfUr0nQYhNKewymmL2NrwLGWuEGMV6Y2IWrLOL9M=;
        b=mMicdpWpM/bVRd/X8znemOhXG6cfOJn9xjBwCNK+q6ttdCVN1bq4gyp9sAYjVHxwZ9ceT1
        Qded2237IeaxpTtQguIDALyWiV7tOtkTH7pVUqqbz7/TWJ7fxB7HL8N+hSLQRuObZzp/oH
        JDpw//yRxEWO+QbxKubn2jaukRz/ReM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655163554;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=J7hFfUr0nQYhNKewymmL2NrwLGWuEGMV6Y2IWrLOL9M=;
        b=0U/joif8SYJFIP6XuxicgcGqCFZ9QB9yq1GawZwSzSvLaN2uzl//zSkVvgYVGk3zPffmfb
        KCUIViiwTOHtNfDw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4F4812C141
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:39:14 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 24A0C60901; Tue, 14 Jun 2022 01:39:14 +0200 (CEST)
Date:   Tue, 14 Jun 2022 01:39:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Subject: ethtool 5.18 released
Message-ID: <20220613233914.6vtzswnm7n7oyish@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6mnkmkmcv56k56q2"
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


--6mnkmkmcv56k56q2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

ethtool 5.18 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.18.tar.xz

Release notes:

        * Feature: get/set cqe size (-g and -G)
        * Fix: fix typo in man page
        * Fix: fix help text alignment
        * Fix: improve attribute label (--show-fec)

Michal

--6mnkmkmcv56k56q2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKnypkACgkQ538sG/LR
dpUStQgAm4ebZxpGioe0e2XG+fIBXQ1o2opOi5IucqzP/wOq+vFZbYKPVteRoE98
mENIGk4wf7TwBAMdXJxcMFNxGJJCB8xBmtTaamyeIYMbw8P7DoO75Knb/Ajei/65
CXLEIZsjwxs2Nkg9ifij4IgIck8opRTn2IYvfoJMlZoho+Y6ZIOvNq0qz5Pc0Gz2
BlR2RUznbTNHzG68JKgwi9szRMad05g0Dbbiq2EwaAGgPG4PxI3q95jFQl+6IF5J
VQrJkLBrXoDjUJeUGjVYqagfiQFY+P/OKAsahZYMqLBrakn1vOheorycI90sWpAO
v2T+EmRZfPHpOwOtplgFjMWVN41WBA==
=qB97
-----END PGP SIGNATURE-----

--6mnkmkmcv56k56q2--
