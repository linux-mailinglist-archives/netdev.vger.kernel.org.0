Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90222543268
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241179AbiFHOVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241166AbiFHOVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D4B275D2;
        Wed,  8 Jun 2022 07:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E19E61B49;
        Wed,  8 Jun 2022 14:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45131C34116;
        Wed,  8 Jun 2022 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654698063;
        bh=KAoNP2RonjZuyrd+HPQv+ZY8dqn7U1ZxChKuH/t6LrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wbs9MQd9sGKsD8YP8ICpPYn+56jvE5MLb4soG4OXbZ71czL4FwA/MBjzpJaOoMQ1N
         swO6hpk2Nl1CK6lUtTcvMYaUXyyjFVMiMcO8LTkQIXGbaVb1C0GiW/V7PskgG05ZiP
         WgLunl4OPLQZwd0WuzSWMr+bpGZnurgBXY7z30oFKLhfUZgsOhwBzgzl0Pu2+J6M5F
         GWrQOHOuX+zXKcSSugdFjEgDNFp7ZAc1dQtCpilQA6bmTOZsh9DfhOjDx8rRSkEOLG
         LngsK4ZCXvaklLJ4sjylBD7GBVkCCPSu/SXTDkna4lTYUx+OCpSCd/rxZdkNlOOcNR
         w6lOlzvv+3ALw==
Date:   Wed, 8 Jun 2022 16:20:59 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        hawk@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        jbrouer@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] Documentation: update
 networking/page_pool.rst with ethtool APIs
Message-ID: <YqCwS540gMwD7T3f@lore-desk>
References: <8c1f582d286fd5a7406dfff895eea39bb8fedca6.1654546043.git.lorenzo@kernel.org>
 <20220607210021.05263978@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="n2JhVsl7RIJhU8Em"
Content-Disposition: inline
In-Reply-To: <20220607210021.05263978@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n2JhVsl7RIJhU8Em
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon,  6 Jun 2022 22:15:45 +0200 Lorenzo Bianconi wrote:
> > Update page_pool documentation with page_pool ethtool stats APIs.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - get rid of literal markup
>=20
> This is not what Andrew and I meant, I don't think. The suggestion was
> to put the information in kdoc of the function, in the source code, and
> then render the kdoc here by adding something like:
>=20
> .. kernel-doc:: whatever/the/source/is.c
>    :identifiers: page_pool_ethtool_stats_get_strings page_pool_ethtool_st=
ats_get_count page_pool_ethtool_stats_get
>=20

ack, I misunderstood Jonathan's comments. I will fix it.

Regards,
Lorenzo

--n2JhVsl7RIJhU8Em
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYqCwSwAKCRA6cBh0uS2t
rEesAQCMqM06C2g3Y4SmicWcNkjOz5w9yU1CkkmmjhBA4oqfVQEAwIoUFCY60qUi
pzmiPaZ/bRljwRsyRaYOjus+hyPY3AE=
=uW3B
-----END PGP SIGNATURE-----

--n2JhVsl7RIJhU8Em--
