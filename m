Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759515ED266
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiI1BC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiI1BCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584091DB57D;
        Tue, 27 Sep 2022 18:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2796461BEF;
        Wed, 28 Sep 2022 01:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BC2C433D6;
        Wed, 28 Sep 2022 01:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664326942;
        bh=NF19G0GHakdi9PoRJpWc5n7cXcIUFzCnv9eq/h2pLEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XevUr4e3FCNI6Sp7E0pMrDRbcCzXQs5gpptgPowQY1jDRZftEcieov9BbqUkVjR00
         swzRcX+BniaJTQAvMHH07NjwGL2U1t7BtcgLlDKRNO61RBe5+Hmsamp/PArBkvmuh+
         W6q7f0rZ9FqQT4pEYg7ZswAR2xd/0WFu9t3Dc8eib9sdU3JaApRTtxOiHFP28D4QCv
         7gsDNKdM4EBgkARxgyYXoUbexiUq5p+lDh2mWdi5/gK99uR4+fI7JW3xAEiCL1U9Ck
         4IvTxc7pRGlqlwGiLEacyyInl8bt6Ebc1FZjnd2G363ZVAXUj/inXYCIWsgWsXZJY4
         0/i/cQ6tkybYg==
Date:   Tue, 27 Sep 2022 18:02:20 -0700
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
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v7 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220927180220.2169ff2a@kernel.org>
In-Reply-To: <20220926112500.990705-6-o.rempel@pengutronix.de>
References: <20220926112500.990705-1-o.rempel@pengutronix.de>
        <20220926112500.990705-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 13:24:58 +0200 Oleksij Rempel wrote:
> +static int pse_get_pse_attributs(struct net_device *dev,

nit: missing e in attributes
