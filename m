Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7595666E02
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240033AbjALJ0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbjALJ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:26:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364DD13D60
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 01:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA040B81DBE
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EAEC433D2;
        Thu, 12 Jan 2023 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673514962;
        bh=uVcmRM1DblHyFjmrECRONMvdtrnX547UYrdf2a0dFBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kt9hSk1Sf9wrenQuJLYqjD6SHNqGtsDcAhJ+HxGDkW3x4RVl1+MWcZrfbH/Bc0RUr
         QuCC2RsOIZHSe1wJa6pGBT9BioaqHYbLrUgA+B4C45/IaAiOdo2Or10LkTSuAE9aRm
         OSHcYNsY5E7WfIYgUKcs4SHjcAILkqjHgZqsmu0+ciMSoOt/GFNfP2irgilkkhyXMF
         qq9oe0iTON4OuPP8XUSwyyYRm4wc4teGikTOprAj9uP5+WigvFSeaSvuJIZSvpJBgF
         SBpSCQedBgT0SNQ5tuDhpuws1vcc0TdKa3fpP0Akhs+crBysHSN9rItdCxuu+8/43x
         mR5N16ezJV0+Q==
Date:   Thu, 12 Jan 2023 10:15:58 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock
 for tx queue
Message-ID: <Y7/Pzp+1ehISmg6v@lore-desk>
References: <61c985987cae6571bd25b51d414b09496d80dbe5.1673457839.git.lorenzo@kernel.org>
 <20230111213739.3e3e24a9@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zWlixwEe+EA0ycF7"
Content-Disposition: inline
In-Reply-To: <20230111213739.3e3e24a9@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zWlixwEe+EA0ycF7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 11 Jan 2023 18:26:29 +0100 Lorenzo Bianconi wrote:
> > This patch is based on the following patch not applied yet:
>=20
> The patchwork automation does not support any sort of patch dependency
> tracking (it's probably quite doable, some special tag pointing at a
> series ID in patchwork, but I ain't got the time..)
> You'll have to repost.

ack, no worries.

Regards,
Lorenzo

--zWlixwEe+EA0ycF7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY7/PzgAKCRA6cBh0uS2t
rLZRAP9/C0hecdllgkH8dmFoG7eK+JbOd3/f5liLaSzpcEVUVQD/chOCTecrxUJo
q2u+MyiYQvwGO9KJVtPOM/a5c6k3nwg=
=nZWC
-----END PGP SIGNATURE-----

--zWlixwEe+EA0ycF7--
