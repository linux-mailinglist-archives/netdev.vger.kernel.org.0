Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D61678C09
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 00:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjAWXaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 18:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAWXaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 18:30:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8255116AFD;
        Mon, 23 Jan 2023 15:30:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 092316116D;
        Mon, 23 Jan 2023 23:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E951EC433D2;
        Mon, 23 Jan 2023 23:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674516599;
        bh=domWxXnxx3FfeQl1v33UBPNFj+bob4ka74pFOFtg76Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2CVM+3qDh+hMNvlsjx20J6175W3EVVRtwNzhVmWSkLjERRjHH8rW1lvSy2rp/uo/
         XJ9L8fl4wYeqtnRNcR3b5UdBTLgAzjdojy2sq23jbqqbntkewDaz1niwvje75pMqxU
         ZPksp76z62HXB2AFmUzDlr6onOiSN1J9HFkLbWqNzfyyQ+ZnKfdWRISSvR95vJRWOr
         0Ov+EDS27MpjDxCk6p9u8xyx9jzOrbAF+Rm9RPQkm9qmZtCIxkG3KE3Qd0Co7YoS4o
         EL2Jr7d1iqc3o/ubwmOO0oZSS80QSQh60z9rRplkXPquOt8Ykl6y6cFRKA00cj5+mE
         HozU4OxO5VsJw==
Date:   Tue, 24 Jan 2023 00:29:55 +0100
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
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
Message-ID: <Y88YczKFr8YKjPFH@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
 <20230120191126.06c9d514@kernel.org>
 <Y82//2EX6QQoZkV/@lore-desk>
 <20230123120101.555a3446@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cnQ6IPZiAYco6BFA"
Content-Disposition: inline
In-Reply-To: <20230123120101.555a3446@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cnQ6IPZiAYco6BFA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 23 Jan 2023 00:00:15 +0100 Lorenzo Bianconi wrote:
> > > FWIW I'm not 100% sure if we should scope the family to all of netdev
> > > or just xdp. Same for the name of the op, should we call the op dev_g=
et
> > > or dev_xdp_get.. =20
> >=20
> > is it likely we are going to add non-xdp info here in the near future? =
If not
> > I would say we can target just xdp for the moment.
>=20
> What brought it to mind for me was offloads like the NVMe/DDP for
> instance. Whether that stuff should live in ethtool or a netdev
> family is a bit unclear.

ack, let's keep netdev in this case.

>=20
> > > These defines don't belong in uAPI. Especially the use of BIT(). =20
> >=20
> > since netdev xdp_features is a bitmask, can we use 'flags' as type for =
definitions in
> > netdev.yaml so we can get rid of this BIT() definitions for both user a=
nd
> > kernel space?
>=20
> If you have no use for the bit numbers - definitely.

ack

Regards,
Lorenzo

--cnQ6IPZiAYco6BFA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY88YcwAKCRA6cBh0uS2t
rOF4AP9C2wVT/PPgkyjFhjEV3z+Ky+cm5rPk6r4RiIoRN2MyowD/RFwIwU4420X4
YZMgnouKUu3uTnXJn5Iduqoy0AWvkwM=
=jF9+
-----END PGP SIGNATURE-----

--cnQ6IPZiAYco6BFA--
