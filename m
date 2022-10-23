Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47318609526
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiJWRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiJWRZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:25:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49075631C5;
        Sun, 23 Oct 2022 10:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4C45B80B2C;
        Sun, 23 Oct 2022 17:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFF7C433C1;
        Sun, 23 Oct 2022 17:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545918;
        bh=LdgQNuyUpaK4Qa2K1YgmQdW7vQY4H+d1cZ2faMsjPVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hRWmf82tgoIDbOYVYCh8F47dj9a2t107xeMsn77CljIRxNJO7rTfH/Idh9SV2xZny
         whXCMymhsyb+NXr+8mli6wQUZnRU87AmtDWI/xYRdAr4eJbv89/jCuMgAMNNYN1FSl
         6FmrYdDQqTzA2rB/48ZiOnF2U1hcj1HnsZwTxB1jBqgh2cRga1JgDxOrnYfynVaOsw
         lqS4iQGonoU8+dwgNnToGOLgWX9X/e9uFaSOazKQmHkJ2jPkuoA2dv5fOZ+fgnV2Lv
         8grGy2d9ITEzdikvgLPgc41ohBes3Di8j0Z4qXZFH1VRtE+r9H/sZS/QzS189UZ/Hh
         cUiSHLGMrYYSw==
Date:   Sun, 23 Oct 2022 19:25:14 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi@redhat.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh@kernel.org, daniel@makrotopia.org
Subject: Re: [PATCH net-next 0/6] introduce WED RX support to MT7986 SoC
Message-ID: <Y1V4+jTPXFqN3YMS@lore-desk>
References: <cover.1666368566.git.lorenzo@kernel.org>
 <20221021211006.3c9b7f29@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i43KW9vR7CAOsKUx"
Content-Disposition: inline
In-Reply-To: <20221021211006.3c9b7f29@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--i43KW9vR7CAOsKUx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 21 Oct 2022 18:18:30 +0200 Lorenzo Bianconi wrote:
> > Similar to TX counterpart available on MT7622 and MT7986, introduce
> > RX Wireless Ethernet Dispatch available on MT7986 SoC in order to
> > offload traffic received by wlan nic to the wired interfaces (lan/wan).
>=20
> Run sparse over these, please. There's warnings in them thar patches.

ack, I will fix them in v2.

Regards,
Lorenzo

--i43KW9vR7CAOsKUx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY1V4+gAKCRA6cBh0uS2t
rOp0AQDQNc0wwhW3l5aRc5qXLnkc5K1s1sE/e3sT89GFQjMUswD8D212gImgI+Nm
DUUU+WcMOeQ2LibMcVcZ+KQR8TdwQAA=
=/hsY
-----END PGP SIGNATURE-----

--i43KW9vR7CAOsKUx--
