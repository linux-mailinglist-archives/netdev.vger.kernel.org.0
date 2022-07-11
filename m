Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0DC570D59
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 00:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiGKWbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 18:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGKWbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 18:31:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB2F52DF5;
        Mon, 11 Jul 2022 15:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B258B81205;
        Mon, 11 Jul 2022 22:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7317C34115;
        Mon, 11 Jul 2022 22:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657578695;
        bh=ZL3TQAfBSmk88tbrJpOmYI/DhBKsXihG4ur1c9u/6CE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QtJ45TwDZh+xTseD9Q7Supflim9NOmwQnMYu1GnBsZen5AI4G88aNxeC08vWmvjSp
         fNsYmzSznBL72MKmU2EAVwkuPE+QISPpc/NP7g0ZEVAqa7TocWxGfDYz4a/U/vO8mi
         nvDV87fgN2s6Rt0pVAPruKZJBBvPjCVeASosS7loZwKJFb/2wJBhDNRZk8Y6Wmd8ze
         PNh9klXnqkV4gjjI3SYVne02mJ+IrIeshlIQyQVwXsNEZ1Ka0gReOMBRUmMMKcV71M
         VGrUcwGf2n2hst0JLqHPH7SJX+xegIde9+jvPPelECh/swLvBxIPMhbGnigPVIT+6q
         FKAIKevSOy06g==
Date:   Mon, 11 Jul 2022 15:31:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <macpaul.lin@mediatek.com>
Subject: Re: [PATCH net v3] stmmac: dwmac-mediatek: fix clock issue
Message-ID: <20220711153125.74442bce@kernel.org>
In-Reply-To: <20220708083937.27334-2-biao.huang@mediatek.com>
References: <20220708083937.27334-1-biao.huang@mediatek.com>
        <20220708083937.27334-2-biao.huang@mediatek.com>
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

On Fri, 8 Jul 2022 16:39:37 +0800 Biao Huang wrote:
> Since clocks are handled in mediatek_dwmac_clks_config(),
> remove the clocks configuration in init()/exit(), and
> invoke mediatek_dwmac_clks_config instead.
> 
> This issue is found in suspend/resume test.

Please improve the commit message so that it answers the questions
Matthias had and repost.
