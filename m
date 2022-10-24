Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E4E609F12
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiJXKbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiJXKbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:31:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4558F3335D
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:31:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B1E131FD66;
        Mon, 24 Oct 2022 10:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666607470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXa1ahBEXTNEByQZKb8q7VWoPUh/iBrjUQzdw2pnW/w=;
        b=nqZgJInsG1Q+dZK+4lcHUxYA+HgUuxs+9pgiDZCamri5t0LZmOjoM5vbS78cEgbGY5ScEL
        8qn3dEUCNj3CEZSQXQcTboqa4loJrqupSbuK4kRhCXjOXWqgm740bAA8pNd06tr4zzlDX9
        Qq1/jgouqHva2njsXO/1AXuMG6Hn560=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666607470;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXa1ahBEXTNEByQZKb8q7VWoPUh/iBrjUQzdw2pnW/w=;
        b=DShoosqgRGHZv79ayy4Oarm/uM+ud2DdADNJaZHkRyWQDoNJiOQoyzLc93DP5RGx/kBbeh
        xb5Ghe5+HWSu80Bg==
Received: from lion.mk-sys.cz (unknown [10.163.44.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A70D12C141;
        Mon, 24 Oct 2022 10:31:10 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8BBFC604C3; Mon, 24 Oct 2022 12:31:10 +0200 (CEST)
Date:   Mon, 24 Oct 2022 12:31:10 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Alexandru Tachici <alexandru.tachici@analog.com>,
        NETDEV ML <netdev@vger.kernel.org>
Subject: Re: ethtool: missing ETHTOOL_LINK_MODE_10baseT1L_Full_BIT
Message-ID: <20221024103110.4oypxzog7aug2jgo@lion.mk-sys.cz>
References: <4f4d4ddb-62c7-d073-91d1-2dbb9127b8fa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xvohivna64fztwdr"
Content-Disposition: inline
In-Reply-To: <4f4d4ddb-62c7-d073-91d1-2dbb9127b8fa@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xvohivna64fztwdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 23, 2022 at 12:17:12AM +0200, Xose Vazquez Perez wrote:
>=20
> It was defined in the kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D3254e0b9eb5649ffaa48717ebc9c593adc4ee6a9
> but missing in ethtool.

I'll send a patch updating ethtool later today but one of the advantages
of the way this part of the netlink interface is designed is that you do
not actually need special support for the new link modes in ethtool
utility. In other words, as long as running kernel supports the new
mode, any sufficiently recent ethtool (with netlink support) should
display and set it correctly.

Michal

--xvohivna64fztwdr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmNWaWkACgkQ538sG/LR
dpVgIgf8Dx9THsvezDyA50+UwxMOuL7Y+2rjd/1ZuP3KPVSK4QuW3WSEhZsa+k+C
ousDnq8j8Pdah51UYmEo/unHge7IqIcT+Cl5H4/XplTKtP8YL9iP08i3NnLFL7yB
WPkaGX3KjOLZNJXjzNnYttb6DF529xZOtFr9mxEAiydSzJKEWVt0XOnOCqzoF8yy
xYoUSraLIxwett1X+P2RPJEKnKFbBIIpGWGNDc6egFOgKWY51Ga6Tj/O9kAw4BLb
iAA8hnNHaSy9NaFoYljxMQORq2eHEX7ZUpeuaptpIlXeNXdXYLMSoyt0VIV1c3TQ
DZo5ypkJSbjp8rctZEcwEWBI+r5/6A==
=DN33
-----END PGP SIGNATURE-----

--xvohivna64fztwdr--
