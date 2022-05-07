Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9761751E674
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 12:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384377AbiEGKeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 06:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiEGKd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 06:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70A33FD97;
        Sat,  7 May 2022 03:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 423326115E;
        Sat,  7 May 2022 10:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D747C385A5;
        Sat,  7 May 2022 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651919396;
        bh=4BQos/r9vVkgW+NENc66br/k2k0LDJiPTIt3lbSVigE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XSXxKqiJCrs0yUm60Vuz2hHH/N3jXR+s9+QUROTVG366WK7Swjas8a2rRgWjcxFwH
         oGnFA1i+YQMFFe1UiCJbPeHJDvoFtHxRL2ovTASwchqcQOfLHIx26B0uLzpxj6rlvP
         lpwPiAcEQ+7wH5nriCXA1Tx8PMBu/N0+qAWzDOqKkxbLR4YQl7ONAa+TKZgfz8xDD1
         fogz0Nn8IKrsM+Ly/lwE2odNWiEFj+Wuux7HF4O6yOIPEWHofo7M0fvmARUn9H5czQ
         nD9uBdnfqe3fneQcYKJ/t0g9T5y9WcC0wQmDh985JTj530ELtu0ySc2/yPIGDc3t4M
         758zF//biSy3A==
Date:   Sat, 7 May 2022 12:29:49 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, atenart@kernel.org,
        thomas.petazzoni@free-electrons.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <20220507122949.2c929211@thinkpad>
In-Reply-To: <YnLxv8PbDyBE1ODa@lunn.ch>
References: <20220504043603.949134-1-chris.packham@alliedtelesis.co.nz>
        <YnLxv8PbDyBE1ODa@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 23:35:59 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, May 04, 2022 at 04:36:02PM +1200, Chris Packham wrote:
> > Convert the marvell,orion-mdio binding to JSON schema.
> >=20
> > Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > ---
> >=20
> > Notes:
> >     Thomas, Antione & Florian I hope you don't mind me putting you as
> >     maintainers of the binding. Between you you've written the majority=
 of
> >     the mvmdio.c driver. =20
>=20
> I actually think it will be me doing any maintenance work on that
> driver.
>=20
> >     This does throw up the following dtbs_check warnings for turris-mox:
> >    =20
> >     arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004:=
 switch0@10:reg: [[16], [0]] is too long
> >             From schema: Documentation/devicetree/bindings/net/marvell,=
orion-mdio.yaml =20
>=20
> I assume this is coming from
>=20
> 		reg =3D <0x10 0>;
>=20
> This is odd. Lets see what Marek Beh=C3=BAn has to say.

Looks like a mistake on my part.

Marek
