Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542786D8D3C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjDFCFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjDFCFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758F0903B;
        Wed,  5 Apr 2023 19:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04267618D1;
        Thu,  6 Apr 2023 02:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9081FC433EF;
        Thu,  6 Apr 2023 02:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746671;
        bh=OWM5Ic08/5NmNu4rDAFXtBjTzY74EnIlq8Hi/M/ZYic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vc90SRI2/ojalG9Je7bD5EXyHKPENJVUsI0rtT5KKGA8wIKFLtrelVW73ISQkDyCp
         Uet5tOVeYMYnctEWX0w8dJ4UungplvvahNx1oAjtrz1KlmSk2HfqqvjfSsmx2PMxb6
         9q4XriG8yFTAzd0UC28ipfU0AZpBRygRvf7zQ8EPSqSHlXIc6MWcGV7zPdsjrfH6im
         P/73CRK1wcUEMepOfrjntzhMWGDe3ZOxFZgr3nfBKicBnj5zD3/E8Bti9276s0OHnU
         Rum6usFt+2rZeVbI6yNyOH1pfnL6xzxzcXJlAac29mzN/PT8x6glp1Ip8ZCOtKvEqb
         P5axvM37A2XWQ==
Date:   Wed, 5 Apr 2023 19:04:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] net: stmmac: Add queue reset into
 stmmac_xdp_open() function
Message-ID: <20230405190429.5db41f58@kernel.org>
In-Reply-To: <20230406014004.3726672-1-yoong.siang.song@intel.com>
References: <20230406014004.3726672-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 09:40:04 +0800 Song Yoong Siang wrote:
> v2: Add reviewed-by tag

You don't have to repost to add tags, maintainers will collect 
the tags sent to the list when applying the patch. I'm taking v1.
