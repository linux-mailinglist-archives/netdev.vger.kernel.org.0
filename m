Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2431964C2F0
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 04:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbiLND5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 22:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbiLND5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 22:57:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C9A12617
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 19:57:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C3646175D
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 03:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34E0C433EF;
        Wed, 14 Dec 2022 03:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670990267;
        bh=9Fwdb6UkaihMRSEfK001Y3G03HTv4XMJAaNO27+EnLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vJh90S4b4ebIu2I9NFRN1zPgqpQ+spLU75qN4M8N2gjtmCnDsqOShogznQ48wbBBS
         b8FRs5kQSut/hayrutyYDLcXzJhgn7tnjno2K1K7ME5LPJXHcoYuZZlkzbFGi0sxIH
         09CsSl6ufXnqwSiTr/tWTeW8EgBXnfHTr3mtdQ8h0PJ2KgcI2ANkm71pRak7MYFTsS
         Vnj1/4IccWl+r9vLdzYkV0QThMMkQo5DN1fs3djWf2y4lZvHh7fuDyK7c2hXG2d/XZ
         4Mt44siO7BXecZhoGv+CNF3kjwffi7DGh5Iy2uR/+tRWxUa1BJe/vSAuhp6u7+fvpt
         ekrSooyxJ+ypQ==
Date:   Tue, 13 Dec 2022 19:57:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cuigaosheng <cuigaosheng1@huawei.com>
Cc:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <mcoquelin.stm32@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <boon.leong.ong@intel.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] net: stmmac: fix possible memory leak in
 stmmac_dvr_probe()
Message-ID: <20221213195746.10b488c8@kernel.org>
In-Reply-To: <ae0f5e46-afb2-e103-0c24-2310ad326e55@huawei.com>
References: <20221212021350.3066631-1-cuigaosheng1@huawei.com>
        <20221213191528.75cd2ff0@kernel.org>
        <ae0f5e46-afb2-e103-0c24-2310ad326e55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Dec 2022 11:55:27 +0800 cuigaosheng wrote:
> Thanks for taking time to review this patch.
> 
> I am sorry I missed the errno, and I have submit a new patch to fix it.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221214034205.3449908-1-cuigaosheng1@huawei.com/

Perfect, thank you!
