Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6AD506D18
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243028AbiDSNJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242638AbiDSNJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:09:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2793128E16
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:07:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B9F561F74F;
        Tue, 19 Apr 2022 13:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1650373622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhSBMJzE7fd+cDorqCLJt81EVmNwN7vRlAq3gG9k0W8=;
        b=xiRiPBiPIt2eNfpHpVnkCgOLBwHpeswMHs/TS3UvOdduJ5+1rnLrZb4PQ1ZVTO+80Avv1M
        V3YuaEryhLxL0oUOx9Adas0WCytpsBU8M+hoh0V4RSo2ic3FI/kb3xysoExRKOaJR2oTQD
        WTBXFzkidDS2nmR3jshkxgcojNy/F5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1650373622;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhSBMJzE7fd+cDorqCLJt81EVmNwN7vRlAq3gG9k0W8=;
        b=0Ek/gRcjcI7HcZjKVZibWyulfQy0pO7nHc1Ti9ugmKa+KF8bqyqloxe92K9kGa+tqeC/Tr
        4Idf5aQ3ApYggKDg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AEC452C142;
        Tue, 19 Apr 2022 13:07:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6ED736048E; Tue, 19 Apr 2022 15:07:02 +0200 (CEST)
Date:   Tue, 19 Apr 2022 15:07:02 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lipeng321@huawei.com
Subject: Re: [PATCH ethtool-next] ethtool: netlink: add support to get/set tx
 push by ethtool -G/g
Message-ID: <20220419130702.xlnodeeeycn6jja6@lion.mk-sys.cz>
References: <20220419125030.3230-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yx3cvn6mo27urzzz"
Content-Disposition: inline
In-Reply-To: <20220419125030.3230-1-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yx3cvn6mo27urzzz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 19, 2022 at 08:50:30PM +0800, Guangbin Huang wrote:
> From: Jie Wang <wangjie125@huawei.com>
>=20
> Currently tx push is a standard feature for NICs such as Mellanox, HNS3.
> But there is no command to set or get this feature.
>=20
> So this patch adds support for "ethtool -G <dev> tx-push on|off" and
> "ethtool -g <dev>" to set/get tx push mode.
>=20
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
[...]
> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
> index d8b19cf98003..79fe0bf686f3 100644
> --- a/uapi/linux/ethtool_netlink.h
> +++ b/uapi/linux/ethtool_netlink.h
> @@ -330,6 +330,7 @@ enum {
>  	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
>  	ETHTOOL_A_RINGS_TX,				/* u32 */
>  	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
> +	ETHTOOL_A_RINGS_TX_PUSH =3D 13,			/* u8  */
> =20
>  	/* add new constants above here */
>  	__ETHTOOL_A_RINGS_CNT,

Please update the uapi headers from sanitized kernel headers as
described here:

  https://www.kernel.org/pub/software/network/ethtool/devel.html

(the paragraph starting "If you need new or updated definitions..." near
the end of the page).

Michal

--yx3cvn6mo27urzzz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmJes+4ACgkQ538sG/LR
dpUJsggAzPfOB3PjYuCu+JNMxNKA1e7EF+0bg0OU8Fu/I4vEtzAI8KzO/c45MsTW
skvXZA840t20ZBEAdZa1zEamJtJYsVi2m/wC8a8pPR79L7N4ppbxvKss8WsQCc4a
+R5awgkB/cgbRballAfWFvMwhexB1Jbk8FHjz0UKPGwZsUe7UHqx3SK6ehtbcfmx
lZgGUthQ1KICgBIHk1sP2VVck05bZR3R89yFo+0IVnqmRY1+B7NcqC0e2IEJfRPA
KQf1PaegMmfO2T+mfPudFIK7BWZgzi+1Mu+T3EtUNOtbcfNvoc6THgPPKIzNoQ2r
fClufLNFe1vL/UkIyBBDqrif6HdQFA==
=y5PX
-----END PGP SIGNATURE-----

--yx3cvn6mo27urzzz--
