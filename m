Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2C25201C0
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbiEIQAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbiEIQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:00:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92961F8C5B;
        Mon,  9 May 2022 08:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C513B8174E;
        Mon,  9 May 2022 15:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20B0C385B3;
        Mon,  9 May 2022 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652111774;
        bh=9KBLlJzB+Vn8EeWf4pniCM2esT/SEQ/l/9rRS1+kJdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gnP+8DQ6tWihM/xyf7+uFM3YtvEgh9FtTzBcVXuBL5jEo/mkJLpAT8efdz5K5umnH
         WXlaEN6NDHlu+O52I7sU/hAAesgl2I+cU2gMoYKBIY66Nd554R1E2Ky3vEL9hLaRLt
         lG6aG/AEHWwv3wBXD2klFOdGL7FRK5b6WtSKtps4cS1roQAQqb8yqjwDXPxB3DQPPv
         9MrwKXne9+eNaLSm6VBO7LzpxxmbTm6k/QZvlOjlQByBCXf7FrbkL5V9BnF1ntA/bC
         xTS0WU3nINx5AOu/ElLmQIKzrtYA9UnEI5E4fsfo/MRPdHGYlZVbnS2AQ8cjxpgknc
         yACumn3tly7GA==
Date:   Mon, 9 May 2022 16:56:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, alexandre.torgue@foss.st.com,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 0/6] arm64: add ethernet to orange pi 3
Message-ID: <Ynk5loCKWCF4/DLT@sirena.org.uk>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <YnkG9yV+Fbf7WtCh@lunn.ch>
 <YnkWwrKk4zjPnZLg@Red>
 <Ynkw9EekNj5Ih5gc@lunn.ch>
 <YnkyKiRmOEYEtO3z@Red>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zr6Z+Ap6mhoaAOIZ"
Content-Disposition: inline
In-Reply-To: <YnkyKiRmOEYEtO3z@Red>
X-Cookie: Boycott meat -- suck your thumb.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zr6Z+Ap6mhoaAOIZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2022 at 05:24:26PM +0200, LABBE Corentin wrote:
> Le Mon, May 09, 2022 at 05:19:16PM +0200, Andrew Lunn a =E9crit :

> > I'm trying to understand the differences between the two different
> > regulators. If you tell me what the PHY is, i might be able to find
> > the data sheet, and then understand why two regulators are needed and
> > if one needs to be controlled by the PHY driver, not the MDIO bus
> > driver.

> The schematic for the board is https://linux-sunxi.org/images/5/50/Orange=
Pi_3_Schematics_v1.5.pdf
> Which show a RTL8211E.

Most hardware will want all the regulators for the device turned on or
off en masse (possibly in a specific sequence) - it's rare for devices
to support only having some of their supplies enabled for extended
periods, I'd be surprised if something like a PHY did that.

--zr6Z+Ap6mhoaAOIZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ5OZUACgkQJNaLcl1U
h9Cv2wf/aIdmWmiQUzvAzeDMdKyyzMe0rAEZxUQEmobo8iKvWcHPao0ApwJso55S
RbO7x97qFZYhpLZYHS/1YByP2+PMkdAOcnpHCAda+REafYnhKSyi2+wjMdHbGTU6
87yzIt+QaGDrfC1STKmIa2/1YUIe01ktGk6fWV3uR6azy7VRtZMyZBW4WBhZg3sT
IvzG+P5fdDvQcmQEGJWOhnNgfZs9+mVmMtWsbMym1vCmK5Ub8oPL3tJDJ1YLb/8U
WosapnoYSDJNUGHaV7vs7HUnqHX/FB/DYB7rPTFOWvJSnuQCTQ4GWV++iKkn85n2
HnUc4Dak9vj5+jmP30vcnGjXahk5Qg==
=2ufh
-----END PGP SIGNATURE-----

--zr6Z+Ap6mhoaAOIZ--
