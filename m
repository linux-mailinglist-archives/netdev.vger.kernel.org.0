Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A787D66BE33
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjAPMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjAPMwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:52:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D11A23122;
        Mon, 16 Jan 2023 04:50:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3C2FB80DFD;
        Mon, 16 Jan 2023 12:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CBCC433F0;
        Mon, 16 Jan 2023 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673873433;
        bh=wRMUs5dA+hlV56z20FbQaU9dm7pCuNaR84xsGGGxgCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8E2x9IpeZVqLMV3UBBnXzRUbpww9Qc1lfuNztQyPCNGLqTlCDpkgN2Rx2wjhu8r0
         m8w6gPm/rGP1qQ7bxkw2RGFodtcBouAwVrvyw3A9+8dIMPLqgp29Il7eNXSuBDALZ/
         88V5SHtyrPQ/5gW//3ZKRtnOjUl0yjPMSCb6RlznVX4QhpQel8hMMJaojcAdPq0TGh
         kLzyIw7Mo4SVoSp9M1Fsgoy3zLprZKKM4Tezmei83ZACCbiHmUWm1RxFtYSVZLcXLZ
         sT8tBo6IkLpe0mUkt7DgROuSVE6s5l3H2AwTNDoSuJPT28FjwjYJ/ZaaNGpUJQEhLv
         2gWIUQ4pV3czA==
Date:   Mon, 16 Jan 2023 12:50:29 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] regmap: Rework regmap_mdio_c45_{read|write} for
 new C45 API.
Message-ID: <Y8VIFexsNpJiRG11@sirena.org.uk>
References: <20230116111509.4086236-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w6utN4xgr9Oraabp"
Content-Disposition: inline
In-Reply-To: <20230116111509.4086236-1-michael@walle.cc>
X-Cookie: Serving suggestion.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w6utN4xgr9Oraabp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 16, 2023 at 12:15:09PM +0100, Michael Walle wrote:

> Mark, could you Ack this instead of taking it through your tree,
> because it future net-next changes will depend on it. There are
> currently no in-tree users for this regmap. The Kconfig symbol is
> never selected.

I can just as easily send a pull request for it?

--w6utN4xgr9Oraabp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPFSBQACgkQJNaLcl1U
h9BEbAf+NgAhrnfcXbvzmlaM/OS03N3s97yM2lw32GgpqbY/KKrmU9PYDzKjSC5O
QSKQr+ypab6PdydLSu3zHq69svN72JR3J4Rze4rIGMTXApMSk1cbwnQELkr41m50
PtVxa8o7vPbQ77jVrJUqsMIxdi6W2n0AZH1IhD+ql3yjRtLwTcqolu/uju+SU6Me
YwSkJwyVLyVxNSe92mz6edr9Vcxfiu3KAPz5F9vyrmxd1eHr2dclFyTa7EAzpOcA
cDyvHIJlDGUnICTki5bGFcYDH7I8aA2p0xLrXVdiXnMBpRHtlE59Uf05dT2rYeRd
fVTeul0X37h2RMjgc2f0G17azRVhSQ==
=LmBI
-----END PGP SIGNATURE-----

--w6utN4xgr9Oraabp--
