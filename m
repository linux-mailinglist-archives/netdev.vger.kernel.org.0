Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE16652FCA
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 11:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbiLUKrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 05:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiLUKrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 05:47:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7191EEFC;
        Wed, 21 Dec 2022 02:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 498ADB81B29;
        Wed, 21 Dec 2022 10:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A87C433EF;
        Wed, 21 Dec 2022 10:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671619638;
        bh=aVDDiFOJK4tI1KD4ouwvUzCRM24HCXz/rMHIn+pJYrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BsWtqG42vKr4ZSW4MqJiGO60bXWpHqLTGur2mwIPQNOZIKVyNM94y+cJFVSMhgtzH
         vHb99vGAuKzJ/Kd4gzeBaOf8B5R0at23nab4n/jZvlxW9KMRA1U3FGK4RcBqFZ3gVj
         6YeR7SzFwy7a9GL3i271y1pKRPVasqALKhW4Hzddfc2agMMgj2hRHjvL0Gb1jLhFex
         FQZbger9/Dojk/+PlXp2eW2UbWPJ6XdAOBrHHMQckyvvwRjgFavN0hGxz9IY5Vh0yV
         MeHMymapK01kCl3XTmUuUrKinju6+ynUStIbQE2YhUsYF8/NZhnDIsNrauz5B+mA4f
         7XqXM+q6pudjw==
Date:   Wed, 21 Dec 2022 11:47:14 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marek Majtyka <alardam@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC bpf-next 2/8] net: introduce XDP features flag
Message-ID: <Y6LkMtURZEjfVWVv@lore-desk>
References: <cover.1671462950.git.lorenzo@kernel.org>
 <43c340d440d8a87396198b301c5ffbf5ab56f304.1671462950.git.lorenzo@kernel.org>
 <20221219171321.7a67002b@kernel.org>
 <Y6F+YJSkI19m/kMv@lore-desk>
 <CAAOQfrF963NoMhQUTdGXyzLMdAjHfUmvzvxpOL0A1Cv4NhY97w@mail.gmail.com>
 <20221220153903.3fb7a54b@kernel.org>
 <20221220204102.5e516196@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+eCb0XDvva+nTJ1R"
Content-Disposition: inline
In-Reply-To: <20221220204102.5e516196@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+eCb0XDvva+nTJ1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 20 Dec 2022 15:39:03 -0800 Jakub Kicinski wrote:
> > On Tue, 20 Dec 2022 23:51:31 +0100 Marek Majtyka wrote:
> > > Everybody is allowed to make a good use of it. Every improvement is
> > > highly appreciated. Thanks Lorenzo for taking this over. =20
> >=20
> > IIUC this comment refers to the rtnl -> genl/yaml conversion.
> > In which case, unless someone objects, I'll take a stab at it=20
> > in an hour or two and push the result out my kernel.org tree ...
>=20
> I pushed something here:
>=20
> https://github.com/kuba-moo/ynl/commits/xdp-features
>=20
> without replacing all you have. But it should give enough of an idea=20
> to comment on.

ack, thx. I will look into it.

Regards,
Lorenzo

--+eCb0XDvva+nTJ1R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY6LkMgAKCRA6cBh0uS2t
rOyiAQD5NVL/9N4NHfxoSJKlDMMG7ppq80Eax6fJ/Klm4n2WrAD9EA8vAIZ4TItH
WtCvhtFiz0xWJmKiDgKq9r6AMiTB5gs=
=nnX9
-----END PGP SIGNATURE-----

--+eCb0XDvva+nTJ1R--
