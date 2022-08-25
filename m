Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFAF5A17FB
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242557AbiHYRbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiHYRbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 13:31:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758629E13F;
        Thu, 25 Aug 2022 10:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B8BB82834;
        Thu, 25 Aug 2022 17:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C30AC433D6;
        Thu, 25 Aug 2022 17:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661448659;
        bh=a9J1RUT2O0gF/w4I74g6da70M3ycn+P0csL4g8CFH8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SB62L6xXboFqqNr5wL2QhiJh0sDkXssz/JfPQ2SnE8oRgC40TFvQ2PxVRwnFnObSi
         9wUMcM7BzgULfifWuRU+2++WltXru0bzGuFg/Qr+3hzlH16cJWrlJ+YmoWxELXtxEI
         I38qKq7h2p3ucimebU8j0gG8f2w1Ygg4vhiCEi5f9AXBJop/aI5Dkhfm8w3ZtGO495
         0DGp82m3hgOHucM5i/dDpWsXikUqt3aMPfzZeIpZWt2JmjApQwnSE7Vn65aj9K7YXZ
         d2keLqBSUkHXDm9h3qY95gD2tQa+zIkqh9/S/NzeZg495VXZhDQ3Ih0xqrIgAJcZBx
         7XjJEfHuKd5pA==
Date:   Thu, 25 Aug 2022 10:30:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <20220825103058.7c2ff52f@kernel.org>
In-Reply-To: <YwenJaYmzEJGZGUW@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
        <20220817162703.728679-10-bigeasy@linutronix.de>
        <20220817112745.4efd8217@kernel.org>
        <Yv5aSquR9S2KxUr2@linutronix.de>
        <20220818090200.4c6889f2@kernel.org>
        <Yv5v1E6mfpcxjnLV@linutronix.de>
        <20220818104505.010ff950@kernel.org>
        <YwOd7Ex7W21WzQ8N@linutronix.de>
        <20220822110543.4f1a8962@kernel.org>
        <YwenJaYmzEJGZGUW@linutronix.de>
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

On Thu, 25 Aug 2022 18:45:25 +0200 Sebastian Andrzej Siewior wrote:
> On 2022-08-22 11:05:43 [-0700], Jakub Kicinski wrote:
> > Guess so, but it shouldn't be extra work if we're delaying the driver
> > conversion till 6.1?  
> 
> I posted v2 of this series excluding 9/9 as you asked for. I will send
> it later, splitted (as in net only), once the prerequisite is in Linus'
> tree.

Thanks!
