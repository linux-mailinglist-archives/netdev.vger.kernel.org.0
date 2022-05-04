Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0D651A305
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351811AbiEDPH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351542AbiEDPHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39692AE23;
        Wed,  4 May 2022 08:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E93161B6B;
        Wed,  4 May 2022 15:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E58C385AA;
        Wed,  4 May 2022 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651676626;
        bh=gS9cgRft2gHupLhQNBtsqLQ0zVLeGAsSN5zeFP4h4k0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sBTekUaifCimlhjajkdL2NZyWiN3UFz7vjqLSot0sBDx9tF8DMYExUV2qDoaPNn5b
         KYO/QdA7xVibP7boWTEEtGaJGWb+tPRd3xB1YLqOwY7orcA7r6m4ILsbaf7rmMCy1e
         zIvneMbbhxbXioMm7LBxTjne2J0GLD4i525V1CTJMxU8AM94aF2R9HWSPxK43y80Xt
         rFOOsJnWrxpu7lJszvL6UPaFYbQ7mCfcQCdphzeLNRJwC3Qb9dAJoV3siInlSIlqVf
         2EedtYa8TST1srSugZyIjH+iBTS0FYtdUhxy14vaJEjJKP2wDfRWRZuwDo5V8Hk3xh
         SLciCY6XIkF2A==
Date:   Wed, 4 May 2022 16:03:38 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: Re: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Message-ID: <YnKVytydpZeNWsBP@sirena.org.uk>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
 <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YyVuIp0t4l9kBDGR"
Content-Disposition: inline
In-Reply-To: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
X-Cookie: Mother is the invention of necessity.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YyVuIp0t4l9kBDGR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 04, 2022 at 04:44:47PM +0300, Andy Shevchenko wrote:
> Switch mpc5xxx_get_bus_frequency() to use fwnode in order to help
> cleaning up other parts of the kernel from OF specific code.

Acked-by: Mark Brown <broonie@kernel.org>

--YyVuIp0t4l9kBDGR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJylckACgkQJNaLcl1U
h9BYbQf/d+R2/K8I9P6XsFeNBBDkbkBKu4u+dnvyBvda1uA0bN681S7UN/+65MPC
sNd9OZXoE0bx/AnrXyZlW+IJC2jWyLcwL9rGR4hrIkW1w50MqD6WWl6XRe+cmYSF
W+/goNVZ9EcqhviJXuhSTy7Cu14LU7V4uFUWR/MOcjmFD0hxnUJNub6xJsdUsf8I
pAEjZJB7TEiPpN6SXvENzukmdyQewPL6RqLTTIki9dUXE9fn1ixsvQX0bBd5yY1e
vWYnszaplvlFBXwDLftPDtQ+880HVZK0VrXJpCfPW2MqfFsDovNNQyZdlR4T0W9w
rUS8W2LQXMCfj7BSLZ+tUgPA+OoNKg==
=mP8/
-----END PGP SIGNATURE-----

--YyVuIp0t4l9kBDGR--
