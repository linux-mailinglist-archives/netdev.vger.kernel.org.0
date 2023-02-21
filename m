Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459D369E5B6
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbjBURPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbjBURPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:15:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6F91C301;
        Tue, 21 Feb 2023 09:15:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8652EB8101F;
        Tue, 21 Feb 2023 17:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA32C433D2;
        Tue, 21 Feb 2023 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676999700;
        bh=UpGzh0kglKEUk8q7pSGZAuLA84dxFtSqjUhmYc6/B24=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xfge/ajXDMnW8bhlpE8IxEmPeOpIWEWeeEq3jHPCQ87tht0Q4qDy3JuFq6lVneUvD
         PEb9aLdlofCO+K76mNbww1E5GeEUXhoMZJIGPh7UW2EkDzyIZr1qtudZBk/BgpKtBj
         qD5hIyUR/SiH8KfNDlVeZ3tAns2056KJfrGaPr1B1pfsAU8lKTYqbHYXYvtFiNaIeL
         wITCBjXeC7QM8bN2GZ3P0J18FoiHKXq5h2l109HQX/g/i80NPNqhNECigWP40TyYZn
         6hJ1rYypp2IxSdpC1I08mgi5IrI2SP1kg9OiBoKSOrD80H2ODspIEGdIyq1jAZLx60
         4a0mm+H7+VTSA==
Date:   Tue, 21 Feb 2023 09:14:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, alexander.duyck@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] page_pool: add a comment explaining the fragment
 counter usage
Message-ID: <20230221091458.7d026652@kernel.org>
In-Reply-To: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
References: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Feb 2023 00:21:30 +0200 Ilias Apalodimas wrote:
> When reading the page_pool code the first impression is that keeping
> two separate counters, one being the page refcnt and the other being
> fragment pp_frag_count, is counter-intuitive.
> 
> However without that fragment counter we don't know when to reliably
> destroy or sync the outstanding DMA mappings.  So let's add a comment
> explaining this part.

I discussed with Paolo off-list, since it's just a comment change 
I'll push it in.
