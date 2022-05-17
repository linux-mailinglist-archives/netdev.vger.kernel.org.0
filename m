Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC51452A7C4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350838AbiEQQVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350837AbiEQQVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:21:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C03B01B;
        Tue, 17 May 2022 09:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71247CE1B58;
        Tue, 17 May 2022 16:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64D1C385B8;
        Tue, 17 May 2022 16:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652804491;
        bh=ogeqVieUErlO67fl8/8RQ7QFaLv4bj+Gu9iPs7xs+Rg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cMOGvzFPAUCwO/VpuNOyulVB6vPUQYSDbEXL1iupo0szEZzj+2R6oHb7pyROivLvl
         ZInVO8nYWkwrCqpNM2uavJaL/E7vxKiWzRFCxlXgmMyGTfE1+NcsuruhNsKMzuJMM2
         UbV9f0rUyHPN1Ywi2ScRkR969oavtM1Ht7b9stIsgz9sMW+uO/vY9Ml7Uvbt0RUl95
         cZlEBdaiHuRC3v6iXxY1FqOOXJI0FTOp85O8q2WzyCZ0veft9WntygttflJKjmv1Nt
         r7HXfdTononk65gG9geCWWEGA5X4Af+eWSEj35JLcCmTjYU5p1yPYEUdzWD5uH9IOa
         +05Z+WE40IVIg==
Date:   Tue, 17 May 2022 18:21:25 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arm64: dts: armada-3720-turris-mox: Correct reg
 property for mdio devices
Message-ID: <20220517182125.4cb97623@thinkpad>
In-Reply-To: <20220516224801.1656752-2-chris.packham@alliedtelesis.co.nz>
References: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
        <20220516224801.1656752-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 10:48:00 +1200
Chris Packham <chris.packham@alliedtelesis.co.nz> wrote:

> MDIO devices have #address-cells =3D <1>, #size-cells =3D <0>. Now that we
> have a schema enforcing this for marvell,orion-mdio we can see that the
> turris-mox has a unnecessary 2nd cell for the switch nodes reg property
> of it's switch devices. Remove the unnecessary 2nd cell from the
> switches reg property.
>=20
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
