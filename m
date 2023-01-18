Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D841A671217
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjARDn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjARDny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:43:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C452453983;
        Tue, 17 Jan 2023 19:43:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24050B8164A;
        Wed, 18 Jan 2023 03:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C289C433EF;
        Wed, 18 Jan 2023 03:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674013429;
        bh=0ILKWOlamb3ppN+hUK/M6c0wITie324WG6pz/EbdT6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NPsKqjHLBwdy9unr2PXkGQacLhWf7BFNap8y4qq9e4QGG7oeu/SN/zX5wOn/EOvIA
         GtbQKRKzvRoBXVxCkF1wuM1Z9UFf+xiMcRCLRX+irBD7moeyATxYDQxM8o8LG90RsU
         LuRgjYgoeRZklfmX+3AkxNglQHoPsXi/7VPAGoZUEbkOxs4bPtQvWldXuG7/WeFXNH
         IlSbbK5QBcNuoVeyIEhogIgb/wTEMgxEEiRDSVZE0//ZeadXVDS4C5MMo0wA7ArMS/
         vYj8W2oydlT7PsD4LhdmZrQwpXFgqtyRWyIsUYYVvwgOr9NRGpr2QjAKnM8NQgLsr9
         3A4TxqRgfHmoA==
Date:   Tue, 17 Jan 2023 19:43:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        edumazet@google.com, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ning Cai <ncai@quicinc.com>
Subject: Re: [PATCH net] net: stmmac: enable all safety features by default
Message-ID: <20230117194348.3f098a18@kernel.org>
In-Reply-To: <20230116193722.50360-1-ahalaney@redhat.com>
References: <20230116193722.50360-1-ahalaney@redhat.com>
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

On Mon, 16 Jan 2023 13:37:23 -0600 Andrew Halaney wrote:
> I've been working on a newer Qualcomm platform (sa8540p-ride) which has
> a variant of dwmac5 in it. This patch is something Ning stumbled on when
> adding some support for it downstream, and has been in my queue as I try
> and get some support ready for review on list upstream.
> 
> Since it isn't really related to the particular hardware I decided to
> pop it on list now. Please let me know if instead of enabling by default
> (which the original implementation did and is why I went that route) a
> message like "Safety features detected but not enabled in software" is
> preferred and platforms are skipped unless they opt-in for enablement.

Could you repost and CC Wong Vee Khee, and maybe some other Intel folks
who have been touching stmmac recently? They are probably the best to
comment / review.
