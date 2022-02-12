Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1020B4B3211
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354418AbiBLAhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:37:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbiBLAhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:37:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29418D82
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 16:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7144B82DF8
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 00:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC2BC340E9;
        Sat, 12 Feb 2022 00:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644626256;
        bh=vk/6jxkhRtsUgUIgwQxn7WV3gENIyFxHdMtH89aOfmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qvXAMT/3ngjmDJXf8TaA18GNzrvlkABtrAhkWpqBGI2Cesb9Ogys3P3xAkGpEYwYM
         X2dqQtTtiwL8ue2sum8xMInomdd5edFVvdv5p9hSre9h6m2mxU9azwFDv9hsf4tamA
         ABPLyvzlXvFESBnoQIwNYWk9qgQp4Ix/FyLHBCESIdYeNu4+1y+1dxdHQ1nqTAfrB1
         dcH+5NLj1D2PA6xM35Kepr9Qn7u8oJcQDFztZhhyGBOw8/l6+SPaEO/YFMko1YV0t5
         qGhitf5JAPs4xcsltxuNTxg9maGxXH/WT4G3Z638TG7IMPnscf/lkVz3d8XniHU5WB
         qIHxoP35w0rzQ==
Date:   Fri, 11 Feb 2022 16:37:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 08/13 v2] net: ixp4xx_eth: Drop platform data support
Message-ID: <20220211163735.09176e2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211223238.648934-9-linus.walleij@linaro.org>
References: <20220211223238.648934-1-linus.walleij@linaro.org>
        <20220211223238.648934-9-linus.walleij@linaro.org>
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

On Fri, 11 Feb 2022 23:32:33 +0100 Linus Walleij wrote:
> All IXP4xx platforms are converted to device tree, the platform
> data path is no longer used. Drop the code and custom include,
> confine the driver in its own file.
> 
> Depend on OF and remove ifdefs around this, as we are all probing
> from OF now.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Delete a small chunk of code I missed
> 
> Network maintainers: I'm looking for an ACK to take this
> change through ARM SoC along with other changes removing
> these accessor functions.

Acked-by: Jakub Kicinski <kuba@kernel.org>
