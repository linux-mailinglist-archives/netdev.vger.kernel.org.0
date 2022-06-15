Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED98854C10B
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbiFOFNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbiFOFNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:13:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4C225EA9;
        Tue, 14 Jun 2022 22:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B5DD61690;
        Wed, 15 Jun 2022 05:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35617C341C4;
        Wed, 15 Jun 2022 05:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655269984;
        bh=tOUHCnRD2qpFsF/6tTi/ZdtHNkm1pbLqUvuCuMU2AxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y8yxhcDfSUPamWsXkqOweap8OdyfaPcJqsiUwE33JM4ttlcD2I2Arv4cmbnghs3f9
         8k006K7xi0K03LE5Z3XCN39sNA4z6OjPy6p0pktpvJWgo05h6BiLs9UEg/SE6rA2vh
         iVRIupriW3Cv24H+K+gJ1RSD+cTUC0OPomVLzC6VP2qtlZEvIaJaU6N4Eu1HDuWgq+
         iTK0V2S5F1vF3sfLaFOZgUtkoppODAqsrhP4WLel/9l1fQNgb1AGxUgdxa18oCwsoI
         nVBNtb73zlZcfu2FV1Ll5h/x57E+fRTmy/7lrnOu2tm9qoYeYhCOdOsN//i2IEfbfW
         4NnHNPs/iVdVA==
Date:   Tue, 14 Jun 2022 22:13:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM: dts: at91: ksz9477_evb: fix port/phy validation
Message-ID: <20220614221303.37b0700b@kernel.org>
In-Reply-To: <20220610081621.584393-1-o.rempel@pengutronix.de>
References: <20220610081621.584393-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 10:16:21 +0200 Oleksij Rempel wrote:
> Latest drivers version requires phy-mode to be set. Otherwise we will
> use "NA" mode and the switch driver will invalidate this port mode.
>=20
> Fixes: 65ac79e18120 ("net: dsa: microchip: add the phylink get_caps")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This got an Awaiting Upstream in patchwork along the way, but based on
Krzysztof's comment I think net is right here. So it's commit
56315b6bf7fc ("ARM: dts: at91: ksz9477_evb: fix port/phy validation")
in net now =F0=9F=A4=B7
