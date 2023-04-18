Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5E96E6F9B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 00:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjDRWrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 18:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjDRWrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 18:47:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6204EF4
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 15:47:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CC9621F45F;
        Tue, 18 Apr 2023 22:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681858018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wj9w3JEOVboaVMbDQ43JFppKWn9VBCDBEUqd9SXO/2c=;
        b=w77mey8Hpnix8SpoobDpwg2A21TN1wzmZqfFI1BK86ooabsK2k6M2gQbp9bpL7jwyhipWv
        scjlSgM4ESBvSPqd1JzTyI8zViGwR3Vtb+KBdh7SLB71ovmbBN1jJ+VLN0q0rcu9Nc8BtX
        OCMT1XQVeQ72e1RcmrqwADV02DDJztU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681858018;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wj9w3JEOVboaVMbDQ43JFppKWn9VBCDBEUqd9SXO/2c=;
        b=Uid9x9QABjMtMGZedXPGsRi0O3fTY7zybmmHwprg/qFNKipcpM9tnL1+sASMZoqWMq4H9u
        3KDx4QlmB/u9CpBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A03EC2C141;
        Tue, 18 Apr 2023 22:46:57 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5F3B460517; Wed, 19 Apr 2023 00:46:57 +0200 (CEST)
Date:   Wed, 19 Apr 2023 00:46:57 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v1 ethtool-next] ethtool: Add support for configuring
 tx-push-buf-len
Message-ID: <20230418224657.2iedlb5k4tef5pfp@lion.mk-sys.cz>
References: <20230328212041.4191693-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3b3rjbu2rsz5vgk2"
Content-Disposition: inline
In-Reply-To: <20230328212041.4191693-1-shayagr@amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3b3rjbu2rsz5vgk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 29, 2023 at 12:20:41AM +0300, Shay Agroskin wrote:
> This attribute, which is part of ethtool's ring param configuration
> allows the user to specify the maximum number of the packet's payload
> that can be written directly to the device.
>=20
> Example usage:
>     # ethtool -G [interface] tx-push-buf-len [number of bytes]
>=20
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Looks good to me, except for two minor issues:

1. Please update the uapi header copies in a separate commit as
described in https://www.kernel.org/pub/software/network/ethtool/devel.html

2. Please update also the man page (file ethtool.8.in).

Thank you,
Michal

--3b3rjbu2rsz5vgk2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmQ/HdYACgkQ538sG/LR
dpUk+Qf/SCnqPypwa4jNJe16vgOuBr7O8BA6QKo3ChFsymWvG0OSUuPLE0B8OzF0
2nZm72QPE9MgK208JA9mBA7uWui/VGq20cuNxzswUnYiveZUjV5nCEOrcFmy6pMB
9w/g0EhoC8DfyD1UwNYpNnzSjS1o8q3E8WuzKkfvFtxZEnIKOSBJvHOOMkOPnVpf
o6eITBVp2c9f66jQkdqdh2IVSHn4tLuWWXLFzJpKoyZk6O/HseJgtXyEYS49yRnh
NGiwAMSlBMXc1qeJVrGFDiR6M/KNLFsJgTg+oPjupi0upmueD5jE6XpGmb/6fRHR
AYQLoiGHoYYvU0jr4An471CjS+iSXA==
=weA7
-----END PGP SIGNATURE-----

--3b3rjbu2rsz5vgk2--
