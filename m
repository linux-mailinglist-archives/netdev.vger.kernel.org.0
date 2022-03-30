Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630454EC97D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348722AbiC3QTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348719AbiC3QTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:19:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FECBC02;
        Wed, 30 Mar 2022 09:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B909161773;
        Wed, 30 Mar 2022 16:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E24C340EC;
        Wed, 30 Mar 2022 16:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648657048;
        bh=Q+USGHsR1S1m9ZvzFcgjt7zp0ViNdGcvN3RiBCTFNSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O8S0hjOfWVpcL2d8Ii4T6o+AuXfYtsfA5ix/uX/rPyjwS9bxhfO1i86FHjIdh+puv
         I/W7n5WESGfHjS6nF6gp5uPbz0DSJdmTwsJmdaL3RDAl0eVJBdNT4exUa1F1pmWqy/
         L5TsjMqr9tZXP8WmWGuRJBh+7CyOBurO/HruWy2Zqf2pbxXdUFXjOULx0WFZpkDRTD
         QVfwF0fhifJNU26ElPMrsxlNMoMiEQy7tfASjXepRDVYCV/+WyR1iuE1rYjYLwRcTQ
         3WMZtglRmT0m/phSC+R4aYQMOKh4xxVnG0cpZxbkZbFGBsB3JmOU/q0kciwlqmv+sV
         2kaKH/mpSSGAA==
Date:   Wed, 30 Mar 2022 17:17:19 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Dmitry Osipenko <digetx@gmail.com>, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: Fix incomplete if/then/else schemas
Message-ID: <YkSCj1wT8E/uAdbU@sirena.org.uk>
References: <20220330145741.3044896-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TNgjpwjwvAc49yPZ"
Content-Disposition: inline
In-Reply-To: <20220330145741.3044896-1-robh@kernel.org>
X-Cookie: Two is company, three is an orgy.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TNgjpwjwvAc49yPZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 30, 2022 at 09:57:41AM -0500, Rob Herring wrote:
> A recent review highlighted that the json-schema meta-schema allows any
> combination of if/then/else schema keywords even though if, then or else
> by themselves makes little sense. With an added meta-schema to only
> allow valid combinations, there's a handful of schemas found which need
> fixing in a variety of ways. Incorrect indentation is the most common
> issue.

Acked-by: Mark Brown <broonie@kernel.org>

--TNgjpwjwvAc49yPZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJEgo4ACgkQJNaLcl1U
h9CMwQf/f8YiUiMex+FwfC/kdvXglTNhRApaQRU6OtuSmz5UEnBb6O6YMmQLA4q4
P3oQ1eCCQFXxr8+P7iqLuM+N4MRXPNabE1q82boC3jBah9e8mvDKJtNZJlz/kRXD
QazSWyj0T9UQpnveVimQMjtE/So0MgZSI/KLiB/hjhG+5Be3Gq5Da9HfdMFwvtA1
nrqW5IcduprA2fSUgucuUddybp9AoCJr+cvoFPx3Zw/1Nnjb/7xWP6TYeh2EpRCp
4z1q0JIEFpwa0vCan+4S1IF9eUjHLTmhnUt3yWgERmRNK7t9GKrhobfSAuK8pmky
vpPGzlJMA9MiagHlb4EugpvmhYzNuQ==
=41nO
-----END PGP SIGNATURE-----

--TNgjpwjwvAc49yPZ--
