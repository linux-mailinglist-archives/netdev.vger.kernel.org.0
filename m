Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CD3676CAB
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 13:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjAVMJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 07:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVMJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 07:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AAE18176;
        Sun, 22 Jan 2023 04:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F70460BB8;
        Sun, 22 Jan 2023 12:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0EBC433EF;
        Sun, 22 Jan 2023 12:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674389382;
        bh=T0RMawtfeLWYRS29q6KiwNJBY0Mqii5zhUzrcZ1hlOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=idc1lXaUwHxDTM8i2sAyiYggmThJuVvFcd0+c2Wn2eeRAMCexSlzIZ9VT9Ob7NzwC
         RIPcjCvsaa+9tFOY5SbfvcUdXGyNxMca9zNvHphm8DwZEFinxaiUN31bcDbTLB2ndz
         uF/sK/TBJxGaIrUKXrZekCxwrl2zWJWsYhCucC79x0QoS7RryYL0o/2iXwADXGFsbu
         iJYjB+44HX42srxP41X0EKZ3wB9jcq/jg+HQOWCxWChui47HlV1Vbct05yKOkRPEAU
         q39st4NHWaFI3/CaBQTgcoSUXpP6EAsM4TkffO82pO5tCZi2PW9PFhtVQMAKtOGZXr
         qQYBZo0lHJ5cw==
Date:   Sun, 22 Jan 2023 13:09:38 +0100
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
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 5/7] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <Y80ngqGcHIp3b8Rz@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <31e46f564a30e0d3d1e06edb27045be9f318ff0b.1674234430.git.lorenzo@kernel.org>
 <20230120192059.66d058bf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0tACK8m4bRM0/8/P"
Content-Disposition: inline
In-Reply-To: <20230120192059.66d058bf@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0tACK8m4bRM0/8/P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 20 Jan 2023 18:16:54 +0100 Lorenzo Bianconi wrote:
> > +static int libbpf_netlink_resolve_genl_family_id(const char *name,
> > +						 __u16 len, __u16 *id)
> > +{
> > +	struct libbpf_nla_req req =3D {
> > +		.nh.nlmsg_len	=3D NLMSG_LENGTH(GENL_HDRLEN),
> > +		.nh.nlmsg_type	=3D GENL_ID_CTRL,
> > +		.nh.nlmsg_flags	=3D NLM_F_REQUEST,
> > +		.gnl.cmd	=3D CTRL_CMD_GETFAMILY,
> > +		.gnl.version	=3D 1,
>=20
> nlctrl is version 2, shouldn't matter in practice

ack, I will fix it.

Regards,
Lorenzo

--0tACK8m4bRM0/8/P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY80nggAKCRA6cBh0uS2t
rPC7AQDu6l1kKMwrf9Bhnb/F1h4rjFppYj8nmw/lsCuNWc4JSwD+OxLIp1k3DkBy
Ts1xkVfkP6+VjvYnGb9NCb5k9adttwU=
=1C3N
-----END PGP SIGNATURE-----

--0tACK8m4bRM0/8/P--
