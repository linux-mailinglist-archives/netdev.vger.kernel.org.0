Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADC674678
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjASW5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjASW4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FB4173F;
        Thu, 19 Jan 2023 14:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEE6761D90;
        Thu, 19 Jan 2023 22:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDE3C433F0;
        Thu, 19 Jan 2023 22:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674167976;
        bh=NzKcg98ug8ID9hmODl/qVZyxg5QFwan7Bs9Ruvccb94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dke9aIuAzfSxV8RiUl94zdppLCV+86mb+N1+2sWpP/lozDJP2GgYG+BoidFA8wCCf
         SGMPqij1p07iwMKwnbfn0hP74Qm2bFh2cufc7wAe9kPYHwlnxpMdTwEYz7A4ArP9IG
         4vX3tIw5/ZT9i3Ee2EaTOHd3TT8i9oTzZM67JnhxKAxzWCQy1U4DNqN0RVNeRk34dI
         zD0wx3M3nOfJ29aCNn/0/VfolDHAYRUMp6GNPS3FUNsNrAz2HEVbm79Cspp5kj+gBQ
         /kJi39los2sBbbqWl5s1kXKZRYFY679Kpvbd+XvxtKF6RMuuA/lk2fsAk2sVihXx2a
         bvh6f0W2NBFgw==
Date:   Thu, 19 Jan 2023 23:39:32 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC v2 bpf-next 5/7] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <Y8nGpFYVbDsKiboP@lore-desk>
References: <cover.1673710866.git.lorenzo@kernel.org>
 <e58d34cd95e39caf0efb25951bc2da9948c6f486.1673710867.git.lorenzo@kernel.org>
 <20230117165804.65118609@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HT+pcQxuV+Cc6rHk"
Content-Disposition: inline
In-Reply-To: <20230117165804.65118609@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HT+pcQxuV+Cc6rHk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 14 Jan 2023 16:54:35 +0100 Lorenzo Bianconi wrote:
> > +	struct nlattr *na =3D (struct nlattr *)(NLMSG_DATA(nh) + GENL_HDRLEN);
> > +
> > +	na =3D (struct nlattr *)((void *)na + NLA_ALIGN(na->nla_len));
> > +	if (na->nla_type =3D=3D CTRL_ATTR_FAMILY_ID) {
>=20
> Assuming layout of attributes within a message is a hard no-no.

ack, right. I will fix it.

Regards,
Lorenzo

--HT+pcQxuV+Cc6rHk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8nGpAAKCRA6cBh0uS2t
rNbgAQDOtrvJXuU1X4UMSBzDVuHwhqklptzWOTG5H9GzaRPBUwEAvzDPuVMQqIIu
kukZbbSG8QZez3de/yFhXQPj21YdPgc=
=C2Hp
-----END PGP SIGNATURE-----

--HT+pcQxuV+Cc6rHk--
