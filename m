Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E95A612084
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJ2FVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiJ2FVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:21:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB62056BAB;
        Fri, 28 Oct 2022 22:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3B7B82E8E;
        Sat, 29 Oct 2022 05:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAD8C433D6;
        Sat, 29 Oct 2022 05:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667020872;
        bh=omt4Vtn5IJGjWRlDYtMfSB8onXkbIQSWk86+1XXjp6k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eRJBCIVh4K43YxQaItqEpmd6OSS51R0fUP6fdf6XxS/q0Q4gVe65Pp3KORhF7B9j0
         NT35L3T6Og7uh0IHp692d9Zf7LkiEqMj4rR5rET2di97rgWPQ6yfAs0IVepiiNRJCw
         zVh4qylzT0VvR0K6UzLaWXB55ea/pBBAe/TIjonBCsE3cHRlfCRmomsZCCvsfqlHNR
         fKXsUT4xKe+yPhEKL+9KHmWJlJvZsY7nX9KVT8CVrkkQVuqKTNz0qdpBDw3aEA/hfq
         kZ89/bfggZt52j/Mv1+dGa30GDj14hzbvsloRxmKCSXF+toyCcPb0H4QL211fPrTST
         D+EqQT4o3gQxg==
Date:   Fri, 28 Oct 2022 22:21:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v6 0/5] net: ipqess: introduce Qualcomm IPQESS
 driver
Message-ID: <20221028222110.6268c502@kernel.org>
In-Reply-To: <20221028154924.789116-1-maxime.chevallier@bootlin.com>
References: <20221028154924.789116-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 17:49:19 +0200 Maxime Chevallier wrote:
> This is the 6th iteration on the IPQESS driver, that includes a new
> DSA tagger to let the MAC convey the tag to the switch through an
> out-of-band medium, here using DMA descriptors.

Run sparse on these please, any new driver needs to build cleanly 
with W=1 C=1.
