Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD9671171
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjARDDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjARDDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ADB4FC34;
        Tue, 17 Jan 2023 19:03:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82BE2615DC;
        Wed, 18 Jan 2023 03:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940B0C433D2;
        Wed, 18 Jan 2023 03:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674011023;
        bh=ckXeTXYwVZTD0YMYSSo4hAVgSFGF1If9RNo4+yM2iEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qgOPzdfcnv8yA+ep3tqaUpS0oJ2U41BoWNXD80MR7Yt3w0LiCuUXu6eit97G9KX5S
         3JjqAQ8A9eQx3Usk6U+afCBGOLM7/5aXbAPqJ5Av6jYgMqFbqPtmTBg3fBYm7hW0Gr
         wv2HtWXdKcdalPJcjJKMCCgU04Yjf3Vx1OlpZQM+1wWwBaHADnzfT2XKM3eyaG6ana
         Mi7wXoZ9dchywtQGYNqG0m2ei7YktYwrFykLqxp4KQ47DKqWddlujCmy1DK5K30MKn
         KKPYXiriT8CsSb0CjYWJZLyPXTHhLLdAswl7cXss+xgDXXxdmxFnmfJfesfPXN5GLa
         DZZQkmbYpKNrA==
Date:   Tue, 17 Jan 2023 19:03:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <20230117190342.0ec253ad@kernel.org>
In-Reply-To: <20230113164106.311491-1-pablo@netfilter.org>
References: <20230113164106.311491-1-pablo@netfilter.org>
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

On Fri, 13 Jan 2023 17:41:03 +0100 Pablo Neira Ayuso wrote:
> 1) Increase timeout to 120 seconds for netfilter selftests to fix
>    nftables transaction tests, from Florian Westphal.
> 
> 2) Fix overflow in bitmap_ip_create() due to integer arithmetics
>    in a 64-bit bitmask, from Gavrilov Ilia.
> 
> 3) Fix incorrect arithmetics in nft_payload with double-tagged
>    vlan matching.

FWIW pulled yesterday, thanks!
