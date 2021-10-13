Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B3942B93E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhJMHgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhJMHg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:36:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FDFC061570;
        Wed, 13 Oct 2021 00:34:25 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634110462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BoBO8v8xV3g6Rp8um6ygnHmfr/6EsiEB9PRtDEyc70c=;
        b=D0z6yuJVThpCfxAmjHC1+UsPkR2QPNc9M/9113DqNPTRVtCRoPQWIWKsgS6sA8aJkIR/zW
        rOoC/eyzDhcy4rby/sxn0mHfix0sMm8OgGwSFxq/KmuaxBsold5f0r1FK10w4y+XFKyEl6
        sHYw24EX1O6b+NeNUQmEAQ++ogyi3nYQJxkHqD5RNOFjfVjjEdf2bwYl1ZESrwoOJ7uLHa
        wdqfJsk2prhS0n6udkzjieqvyq/vPkhCM2GgJjHoXAIbEik4uWPx0speAPDlpPKVio643p
        DKOE1ETyDnt5PAw7Cgr5rhklokRlTFa3NKEGE0JhLHy+QQg7Jq3Lw9E/qLanbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634110462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BoBO8v8xV3g6Rp8um6ygnHmfr/6EsiEB9PRtDEyc70c=;
        b=kPdQ4jvjSI3sTpH75SWW8kNT/7gIo/QLtPaBbw30lJrCGyzxjRZu3oyF1WQhzHJPo1p4dE
        DbFXfBdHNbBjRICw==
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lay Kuan Loon <kuan.loon.lay@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: introduce critical
 chip default init for non-of platform
In-Reply-To: <20211013065941.2124858-2-boon.leong.ong@intel.com>
References: <20211013065941.2124858-1-boon.leong.ong@intel.com>
 <20211013065941.2124858-2-boon.leong.ong@intel.com>
Date:   Wed, 13 Oct 2021 09:34:21 +0200
Message-ID: <87a6jd5qf6.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Oct 13 2021, Ong Boon Leong wrote:
> From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>
>
> PHY driver dp83867 has rich supports for OF-platform to fine-tune the PHY
> chip during phy configuration. However, for non-OF platform, certain PHY
> tunable parameters such as IO impedance and RX & TX internal delays are
> critical and should be initialized to its default during PHY driver probe.
>
> Tested-by: Clement <clement@intel.com>
> Signed-off-by: Lay, Kuan Loon <kuan.loon.lay@intel.com>
> Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Thanks!

Tested-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmFmi/0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpkPDEADXps/m6uU4NMKjuzLOYjb5cgHAQxP0
/6Y9CMU2v9WcI7opoiwlD6gZwFmnF6/6vNvgRYtN28ryv58XG5zOb2mvGBDFOTeI
jMmlzwiubTB6z3/PaSnaGvCAAuf5B8Q5L+BYwWpWqLpnepAql6fprBKIjgmE6Ezg
9YAz63p4Df9L1Krln3BjCA/6yCVAc5riwXSxIogm84JTFAgd6ae9UfLU2XF3opvf
0ERCa0AT6Yp6+tQrpZKTrsvzUtK6BaHmWijeJcbsZ3ayF18dNHioY7L/aeVvWbZM
GTmhohr+w1UnyRg1i/ANdjmzNtobdVaN6Op6vvUTIlItKhhxbKvI25hJ+62oAYZU
mf95hbxT94GsqW/8xbJ6VELauujcXMn63VpkuqYdcGyQuERJdC8CpdpNYMbZc8/C
r3XARRY69Gokn5dFLbUX4B3vujMgKwcPqHVpRP0xREm7E1pqkUtGzBcexeebE//L
p6vPB1vxGMbSVYBxMnQsZgJotJ11Q2EztG4qsoCos19NACYC+Ok+HsIZ8Lotsfrq
Jg2vSYRkFwSactr5+fAWKNbaXSm7Tw+Zkwh0Mjn6lFbWM5dNob36nmrVvin/ba4u
YmtF881aL38DDB4Vb88gSAdRYuprJfg/5Obn44rNY4QFxoaC2ncgXajzBCedWK2o
rRJQmgo6soysRQ==
=LFAf
-----END PGP SIGNATURE-----
--=-=-=--
