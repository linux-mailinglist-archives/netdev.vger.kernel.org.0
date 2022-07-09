Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C37756C625
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiGIDJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIDJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB5F4E868;
        Fri,  8 Jul 2022 20:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E18FB82A35;
        Sat,  9 Jul 2022 03:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60158C341C0;
        Sat,  9 Jul 2022 03:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657336160;
        bh=gqZE/zorkl4bHDYMLQlcgo1V4ItKl51rzFkuKiRanME=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WyGbcXZtdGTjoPeTVSfC7TewJ8HXG1928XRnsG63Ut4AEEN5n29RhjMau9Y3WpxPX
         9/MpJJViiD9z8woeASjZKm8vOwWt+z5V2QvpApSLo4WcM3gCw/wFro79Ri3O92jAoR
         /+owXoYv6IjdE2+A5lU6jzKPvyPAuhoBZYKF22HWjlfz2Fj0UYs04MEpXXB/TImkpF
         Zw9TuPftnK8zuCA7TxGi1DN/uXtx7EE/7F0sQ/4Zfy2BAwlJh5JNDQB22k892SlI7L
         Rvgeq23vU6vOD2XPknwQPkNrAkR5hH+BBvYa8A2AOSsmqHRtfqSgf5jhik8SQijQ1G
         PMehq3D78Pwtw==
Date:   Fri, 8 Jul 2022 20:09:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
Subject: Re: [PATCH v13 net-next 0/9] add support for VSC7512 control over
 SPI
Message-ID: <20220708200918.131c0950@kernel.org>
In-Reply-To: <20220705204743.3224692-1-colin.foster@in-advantage.com>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jul 2022 13:47:34 -0700 Colin Foster wrote:
> The patch set in general is to add support for the VSC7512, and
> eventually the VSC7511, VSC7513 and VSC7514 devices controlled over
> SPI. Specifically this patch set enables pinctrl, serial gpio expander
> access, and control of an internal and an external MDIO bus.

Can this go into net-next if there are no more complains over the
weekend? Anyone still planning to review?

Linus's ack on patch 6 and an MFD Ack from Lee would be great.
