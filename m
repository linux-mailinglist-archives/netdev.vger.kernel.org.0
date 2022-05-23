Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936FC5317AA
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiEWTuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiEWTuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:50:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F1A3A70E;
        Mon, 23 May 2022 12:50:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A30D521A7F;
        Mon, 23 May 2022 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653335404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=grSoxHsygAEuhD8w/ISJC61YzM57thfB37aO/VnwoOA=;
        b=xaFWelr6iTqD9Edz9ntXYh0Atxo8QNk9oVmZel6mw9yUDvTc1kOPdjm2phkiMyjuwYxwqU
        aKb4CDXGJjM/hJkK+u+WrFEhiDAW9cHP7V4SXCIODPeOsISlI5GgvXCcaPWVGDozLHTABV
        1LkxvDEeoPImHQDm/GQkMctcbzGa4Sw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653335404;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=grSoxHsygAEuhD8w/ISJC61YzM57thfB37aO/VnwoOA=;
        b=9knqA39Le9+RW7wqVlbSxdC2dagFtgl316qsrP+mFSFPf33HNlcHEmPC0UX/t/9nw/G0wo
        OXXx4l4763WnwpDQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 81F762C141;
        Mon, 23 May 2022 19:50:04 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B0A6660299; Mon, 23 May 2022 21:50:01 +0200 (CEST)
Date:   Mon, 23 May 2022 21:50:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ipsec] Revert "net: af_key: add check for pfkey_broadcast
 in function pfkey_process"
Message-ID: <20220523195001.5zjuwu2cpdfnb5vb@lion.mk-sys.cz>
References: <fbb31dc72fb38a69a2aca6c25f1be71d6a8bcc96.1653321424.git.mkubecek@suse.cz>
 <772f9381-1180-319e-3afa-cca900291c94@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uifvrkrs2xmnsp7p"
Content-Disposition: inline
In-Reply-To: <772f9381-1180-319e-3afa-cca900291c94@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uifvrkrs2xmnsp7p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 23, 2022 at 10:23:22AM -0700, Florian Fainelli wrote:
> On 5/23/22 09:01, Michal Kubecek wrote:
> > This reverts commit 4dc2a5a8f6754492180741facf2a8787f2c415d7.
> >=20
> > A non-zero return value from pfkey_broadcast() does not necessarily mean
> > an error occurred as this function returns -ESRCH when no registered
> > listener received the message. In particular, a call with
> > BROADCAST_PROMISC_ONLY flag and null one_sk argument can never return
> > zero so that this commit in fact prevents processing any PF_KEY message.
> > One visible effect is that racoon daemon fails to find encryption
> > algorithms like aes and refuses to start.
> >=20
> > Excluding -ESRCH return value would fix this but it's not obvious that
> > we really want to bail out here and most other callers of
> > pfkey_broadcast() also ignore the return value. Also, as pointed out by
> > Steffen Klassert, PF_KEY is kind of deprecated and newer userspace code
> > should use netlink instead so that we should only disturb the code for
> > really important fixes.
> >=20
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>=20
> Maybe you can add a comment above the call such that future tool-based
> patches submissions to give the author a chance to read the comment above
> and ask oneself twice whether this is relevant or not?

Good point, I'll send a v2 with a warning comment in a moment.

Micha

--uifvrkrs2xmnsp7p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmKL5WMACgkQ538sG/LR
dpUyTgf+MZsHUlikQ7Lx5YrlaBX7wCQq8g/HHgUJzLGSQ94n1J5vLjfhVh3o17uw
YUB+ve9hUdUSqREbw7PYbCjFZay0F0+d8scwoZiLn/35xYGqcJzCfQNuwAXWbYc7
rW/e8yJbTaGR7ZeZQHPkxevyrClXhaSHSXDx+gyYyolx39I9CKLav/Rhe7742Zk0
6ttZ3ut++LhWkkHwF29qbeafZL8InuP8w48TT+jjcANNH1pD3t1On52IMJej6UPt
VIz+9/OKY0Bj54DGeyHUzoXGZM7cVtkenLp5Fx6+nDaPhzmycUnWk+vN96VG3Z7J
J7BSjpsNzF+Ncc04Ya/6YpVtjK0yfg==
=QpRs
-----END PGP SIGNATURE-----

--uifvrkrs2xmnsp7p--
