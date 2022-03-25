Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8E94E7BB1
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiCYXqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiCYXqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:46:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38273EA89;
        Fri, 25 Mar 2022 16:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 123ADB82A50;
        Fri, 25 Mar 2022 23:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1740BC004DD;
        Fri, 25 Mar 2022 23:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648251892;
        bh=ZyMC6fbFlYU/PkHi9cncbg9r6EHkz37Dwn4euUXnZyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M0GoX+TYV4C1naD9hAKg3aptecN7dSySiB7ogNjiV67GVX0UIcnfcBqQRLxLnxtX9
         TavpXP8pn86rgmcnRLvEkP7kQyCYpF6mJUZRvusq4YvgAJkn4ACNqQkwg/708CxQpQ
         gMYsWOjREir0D8Ct3RkNIyoutINUxA4V8xPIKExJ2cI7EGYHDq5IjoOZQSJ2uNbE1l
         t0eJIDdkBwpoOXv3e6zN8eayC3vP4wWbFKOIa3H6xRLNFTtpyKdnFDA3dldw0+4hPx
         e4hLWuQp945aXScQ/RWOKConcgBs9SPYokDt9x3/xF6YitDJdJLLfzOhUnhz1lOeGP
         mm9nDnnIdj5vw==
Date:   Fri, 25 Mar 2022 23:44:49 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mukesh Savaliya <msavaliy@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Bayi Cheng <bayi.cheng@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Min Guo <min.guo@mediatek.com>, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix missing '/schemas' in $ref paths
Message-ID: <Yj5T8XTNzVdUVdgC@sirena.org.uk>
References: <20220325215652.525383-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HrwSCBfCqyC9bmT7"
Content-Disposition: inline
In-Reply-To: <20220325215652.525383-1-robh@kernel.org>
X-Cookie: <Omnic> another .sig addition
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HrwSCBfCqyC9bmT7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 25, 2022 at 04:56:52PM -0500, Rob Herring wrote:
> Absolute paths in $ref should always begin with '/schemas'. The tools
> mostly work with it omitted, but for correctness the path should be
> everything except the hostname as that is taken from the schema's $id
> value. This scheme is defined in the json-schema spec.

Acked-by: Mark Brown <broonie@debian.org>

--HrwSCBfCqyC9bmT7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmI+U/AACgkQJNaLcl1U
h9CFYAf+NTzlj9OtpA+ECH/bBXaiDRhtZILMKOeDoKeC8fyu6D0U1vs6lWHs8FKl
10FhlTXfAsax0EvZi3lZLGRnC8iwORpu8Cb9ajSUcDVAfTAOgbJVUU499h/6nHly
camU8y7wc5dnpXPdeBYrd1s5M37xyeFjAv3EDcmj0ipOO2vdneS1PIYNF1Cp/MXx
Hf2RclxbzDZrPoLFqlvIsSLUrM6I43akjeG3HTdMvP65joxz8LJ7kmQmvs3RmhOy
gwqeDorNUa+4csNNWmkXUq6yZfzDfyZYTV2WIbVHA/WHiQLVGhBGzDEVb/hMOxVi
A9QU42GTIrFjPONvkS2imhMc6FfSuw==
=wjTk
-----END PGP SIGNATURE-----

--HrwSCBfCqyC9bmT7--
