Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77457B1F9
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiGTHp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiGTHpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:45:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8CF13F0A
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B38CB81E2B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 07:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07469C3411E;
        Wed, 20 Jul 2022 07:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658303119;
        bh=AlniCXIjmJIhQPHhab1IXU3VrLB1Ym4LR4ASTuUus+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=efXR05KbN/agYn9mcVb0qYORBpmoq7uAiYu8AtIgKtXRfa8DdgHN35wZCY6yvudee
         0g3JR+XR+mRwE7jW8cHGoVyGsk9JvnYj7tcmlz4CtjuxAjXjlWQgGpQlDI4hg9WMrF
         w/2OC8ddKGDYEFtbDmT0KvMjV/esVkhN0+3fT0/I+ws1/g9UlEsUsjRhA51Od7FUWA
         s98/bJzfOAElpE1I3jRozuAoM1Sp3oTxdTdPG62uBGfci2mh5NfkUxK12Yfd6Qdxur
         +c5fpQnZrhdkiaDBo0WC0K7Yr49VFNFamv8oveH6m1JMD3fo3tzHJxJN2eM1rY154W
         1pWhvFLlKBVoA==
Date:   Wed, 20 Jul 2022 09:45:13 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Ryder.Lee@mediatek.com, Evelyn.Tsai@mediatek.com
Subject: Re: [PATCH net-next] net: ethernet: mtk-ppe: fix traffic offload
 with bridged wlan
Message-ID: <YteyiWvRGSRAeAIJ@localhost.localdomain>
References: <7fa3ce7e77fb579515e0a7c5a7dee60fc5999e2b.1658168627.git.lorenzo@kernel.org>
 <20220719174038.7ee25c6d@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ylvo4zkjxaI9i2J8"
Content-Disposition: inline
In-Reply-To: <20220719174038.7ee25c6d@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ylvo4zkjxaI9i2J8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 18 Jul 2022 20:36:39 +0200 Lorenzo Bianconi wrote:
> > A typical flow offload scenario for OpenWrt users is routed traffic
> > received by the wan interface that is redirected to a wlan device
> > belonging to the lan bridge. Current implementation fails to
> > fill wdma offload info in mtk_flow_get_wdma_info() since odev device is
> > the local bridge. Fix the issue running dev_fill_forward_path routine in
> > mtk_flow_get_wdma_info in order to identify the wlan device.
>=20
> AFAIU this will conflict with 53eb9b04560c ("net: ethernet: mtk_ppe:
> fix possible NULL pointer dereference in mtk_flow_get_wdma_info")?=20
> We merge net -> net-next every Thu, please wait for that to happen=20
> and then repost. Conflicting patches are extra work for Stephen and
> for me.

ack, right, sorry for that. I will repost after the merge.

Regards,
Lorenzo

--ylvo4zkjxaI9i2J8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYteyhwAKCRA6cBh0uS2t
rMqNAP0UkJbZdsHrCjga7YxdeBzjLAcEwucNWMwf3HHYLMOHfAD+LNoP+s9tN16w
Yb6Bemq7UuLopuVdPx81XvbSFs49Pww=
=zvZO
-----END PGP SIGNATURE-----

--ylvo4zkjxaI9i2J8--
