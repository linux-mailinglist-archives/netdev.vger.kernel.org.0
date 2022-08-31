Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F25A7601
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiHaFwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHaFwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:52:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A7689CD7;
        Tue, 30 Aug 2022 22:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D97ACB81EB8;
        Wed, 31 Aug 2022 05:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0ABC433D6;
        Wed, 31 Aug 2022 05:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661925153;
        bh=GXJhsXioaeItELh4r9S+ygL+acNayJ70WftLbnCmEmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u8yz04WUOax4ApjcQdF5lGZAHeR9cAaJJ8G7+2ItW4k3pm7ubdnQMLr+R+5HI3Puq
         5xjQsmlGqM/iponW0TmmqACSvO1/ktfDQDcS2OIZmZ62IDrYIsLeXktXLxKCuES3OZ
         /kmrjr63Ka/8G2txhsFXTekCck7PIVOWmVP91SuGI+JBFnK48LwlbN61PfHrPYdXGF
         FgXCdTw4o83pBrINFmj3FawhfxwOy/b8kfILw3mFF6B0gOpkJLnXQ4yXAtnwL2ioAM
         SCQyttrLqIIxmbOUWiBqchlGi/R0Me3Y1DLwX4fHrEcgGJ82isr6e56+zIb1S6be13
         b2dWVq70uyA2g==
Date:   Tue, 30 Aug 2022 22:52:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 2/7] net: add framework to support Ethernet
 PSE and PDs devices
Message-ID: <20220830225231.7d4305e4@kernel.org>
In-Reply-To: <20220828063021.3963761-3-o.rempel@pengutronix.de>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
        <20220828063021.3963761-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 28 Aug 2022 08:30:16 +0200 Oleksij Rempel wrote:
> This framework was create with intention to provide support for Ethernet PSE
> (Power Sourcing Equipment) and PDs (Powered Device).
> 
> At current step this patch implements generic PSE support for PoDL (Power over
> Data Lines 802.3bu) specification with reserving name space for PD devices as
> well.
> 
> This framework can be extended to support 802.3af and 802.3at "Power via the
> Media Dependent Interface" (or PoE/Power over Ethernet)

scripts/kernel-doc says:

include/linux/pse-pd/pse.h:42: warning: Function parameter or member 'lock' not described in 'pse_controller_dev'
