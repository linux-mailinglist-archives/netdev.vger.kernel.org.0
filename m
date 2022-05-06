Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A9151DE69
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444235AbiEFRo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbiEFRoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8310B532E6;
        Fri,  6 May 2022 10:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0025F620D4;
        Fri,  6 May 2022 17:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB73DC385A8;
        Fri,  6 May 2022 17:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651858871;
        bh=jUYORx95YRDHeeeY52LGlWTfTnt6ibLZ3gg1qG+EM6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nkgizYeSWtOn1Z5SUsUMNTGLs/CEpROMfjVLnZQgz3A5UUaTbbRDtmCvbcM84K5AG
         +qgS9SuMNK3F7zi/Bb/Hdy5Eg1oV/7XWmCvzy0mDyrxweaR/Uw1e38byTQj63/tdSM
         copVMXd1Zrm5Uq+g9tR0CxhB8ya47FWgEiIQ/ONT50PEWMJDGuvi6tguIXSsyajpvo
         8lzQp0t68xkzVp3KD46OH0QmaEPbcwIqhz/rSjSBKUSlnH922vhnOCf6i7GcxqUpRa
         gm19BJ45d/KvfTKIUr5PZq9MbFiFQMJPFdBxY3bKYqhSG2yHLYlfSPAxwDetJJoXY6
         y+fRck3Xynmtg==
Date:   Fri, 6 May 2022 10:41:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH net-next 11/14] net: ethernet: mtk_eth_soc: add SRAM soc
 capability
Message-ID: <20220506104109.63388e33@kernel.org>
In-Reply-To: <97298a5aeaa7498893a46103de929d0a7df26e8a.1651839494.git.lorenzo@kernel.org>
References: <cover.1651839494.git.lorenzo@kernel.org>
        <97298a5aeaa7498893a46103de929d0a7df26e8a.1651839494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 14:30:28 +0200 Lorenzo Bianconi wrote:
> Introduce SRAM capability for devices that relies on SRAM memory
> for DMA descriptors.
> This is a preliminary patch to add mt7986 ethernet support.

sparse says boo. I think you dropped an __iomem somewhere.

Please heed the 24h rule.
