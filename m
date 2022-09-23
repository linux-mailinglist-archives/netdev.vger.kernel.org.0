Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05F65E85C4
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 00:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiIWWUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 18:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiIWWUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 18:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42707F1638;
        Fri, 23 Sep 2022 15:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 941A76236F;
        Fri, 23 Sep 2022 22:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795A1C4347C;
        Fri, 23 Sep 2022 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663971614;
        bh=iphMsQwCEatyNiW8kPPPZHeJUjzUh9AETptyz2n+4pQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgkYSbzwAxpeO6IKnmqmCnCF5Mi4ZnNhCqntVcIu7RAM0rWIAZ7xIGrJ1ct0mRxQj
         uhveXCXo92QY31Eg2uF3WjoYOZls1dHpki99JXGRzBVf7Bv2CW0mVdQTgBcLJiElOT
         I9AJcyqC8DWyF2vZY3YNAUpahrel4uhfHppVe7UFt829fZtzI35PdIzFg6m8UMy2Ir
         IxFX+42sHuqY0R9OEzODR6abHIKjeye/yY4B1Sv/mbR7cCa/y9SJRLeVgZ3r/8QZf0
         p2MYkAWN2nzG8ehF4gXszeYuWjvt07VZu4GfEKEUiHdZQ2AsTdkyg1XBuIlHZqvYmd
         Fwbu/RF/D7F6g==
Date:   Sat, 24 Sep 2022 00:20:09 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 2/3] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
Message-ID: <Yy4xGT7XGGredCB2@lore-desk>
References: <cover.1663778601.git.lorenzo@kernel.org>
 <9567db2fdfa5bebe7b7cc5870f7a34549418b4fc.1663778601.git.lorenzo@kernel.org>
 <Yy4mVv+4X/Tm3TK4@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sLfwbTjTW3kWkbf7"
Content-Disposition: inline
In-Reply-To: <Yy4mVv+4X/Tm3TK4@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sLfwbTjTW3kWkbf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,

Hi Nathan,

>=20
> On Wed, Sep 21, 2022 at 06:48:26PM +0200, Lorenzo Bianconi wrote:
> > Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> > destination nat addresses/ports in a new allocated ct entry not inserted
> > in the connection tracking table yet.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> This commit is now in -next as commit 0fabd2aa199f ("net: netfilter: add
> bpf_ct_set_nat_info kfunc helper"). Unfortunately, it introduces a
> circular dependency when I build with my distribution's (Arch Linux)
> configuration:
>=20
> $ curl -LSso .config https://github.com/archlinux/svntogit-packages/raw/p=
ackages/linux/trunk/config
>=20
> $ make -skj"$(nproc)" INSTALL_MOD_PATH=3Drootfs INSTALL_MOD_STRIP=3D1 old=
defconfig all modules_install
> ...
> WARN: multiple IDs found for 'nf_conn': 99333, 114119 - using 99333
> WARN: multiple IDs found for 'nf_conn': 99333, 115663 - using 99333
> WARN: multiple IDs found for 'nf_conn': 99333, 117330 - using 99333
> WARN: multiple IDs found for 'nf_conn': 99333, 119583 - using 99333
> depmod: ERROR: Cycle detected: nf_conntrack -> nf_nat -> nf_conntrack
> depmod: ERROR: Found 2 modules in dependency cycles!

I guess the issue occurs when we compile both nf_conntrack and nf_nat as mo=
dule
since now we introduced the dependency "nf_conntrack -> nf_nat".
Discussing with Kumar, in order to fix it, we can move bpf_ct_set_nat_info(=
) in
nf_nat module (with some required registration code similar to register_nf_=
conntrack_bpf()).
What do you think?
Sorry for the inconvenience.

Regards,
Lorenzo


> ...
>=20
> The WARN lines are there before this change but I figured they were
> worth including anyways, in case they factor in here.
>=20
> If there is any more information I can provide or patches I can test,
> please let me know!
>=20
> Cheers,
> Nathan

--sLfwbTjTW3kWkbf7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYy4xGQAKCRA6cBh0uS2t
rKXhAQDcu0w8dCuHn4bG7U4C5FsuDOebt3TwzaIVlpsaRhO8wQD/XWcM/WxnbB2F
zk7Ls9BMjW35soUbeeWNPzWr5rpGiQE=
=EKFJ
-----END PGP SIGNATURE-----

--sLfwbTjTW3kWkbf7--
