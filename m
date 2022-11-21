Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F8C632EA6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiKUVSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiKUVSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:18:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FDFBE86C
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 13:18:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A572FB81658
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 21:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36AFC433C1;
        Mon, 21 Nov 2022 21:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669065517;
        bh=ufuqDz0rB+Qolz1CiCkr1MwuVFrxFpuXYO353eidAv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MsCXeNbLUFLTIuhPJhK/SfXaGIfinPY3OyT5AkJU8h+JXg0oR4T2xJj1OF29Et2bA
         S1kqcTRoQHgHqP52bZtPh2WnP1XkXiTmBk//jCf3KWCwIBowO2x95XJRP4hs2eoCoe
         oCo9SupElFDr2WQm3rlGTOwCRxqRWfFkSKIw5kK/iTjMPbYqiL/1FoSgwc1EEtk7wr
         8DNXfoPUUM0/+ddPpjXDF4HxghHYQzDfPoW4udUCtHFk1TqFmpZRBTTjAQ4l8BEror
         hp2Olu7IhfpNJ7IT9e6QmZGu0Bm0WfWDLSnn5QiuzKZ1R2yV1rudD8NsR2Qmod3BkT
         gIyI3zWEG9oSw==
Date:   Mon, 21 Nov 2022 22:18:33 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, sujuan.chen@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 5/5] net: ethernet: mtk_wed: add reset to
 tx_ring_setup callback
Message-ID: <Y3vrKcqlmxksq1rC@lore-desk>
References: <cover.1669020847.git.lorenzo@kernel.org>
 <9c4dded2b7a35a8e44b255a74e776a703359797b.1669020847.git.lorenzo@kernel.org>
 <20221121121718.4cc2afe5@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+pfbH8gjKuM0iZEF"
Content-Disposition: inline
In-Reply-To: <20221121121718.4cc2afe5@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+pfbH8gjKuM0iZEF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 21 Nov 2022 09:59:25 +0100 Lorenzo Bianconi wrote:
> > +#define mtk_wed_device_tx_ring_setup(_dev, _ring, _regs, _reset) \
> > +	(_dev)->ops->tx_ring_setup(_dev, _ring, _regs, _reset)
>=20
> FWIW I find the "op macros" quite painful when trying to read a driver
> I'm not familiar with. stmmac does this, too. Just letting you know,
> it is what it is.

ack, fine. I maintained the approach currently used in the driver.
Do you prefer to run the function pointer directly?

Regards,
Lorenzo

--+pfbH8gjKuM0iZEF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY3vrKQAKCRA6cBh0uS2t
rDBsAQDDnwwLlP2N+Db3WFKNt4X7ol+xmnZ/w0PJ3DlvcSr5tQEAxK9J5aaWbD2U
kR3yP8VXnxSaP+M9qHBf6jfelwfymwQ=
=cwY6
-----END PGP SIGNATURE-----

--+pfbH8gjKuM0iZEF--
