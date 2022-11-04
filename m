Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB1619F91
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiKDSRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiKDSRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182A84AF10;
        Fri,  4 Nov 2022 11:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC6A622CF;
        Fri,  4 Nov 2022 18:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82585C433D6;
        Fri,  4 Nov 2022 18:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667585871;
        bh=+s7AlmNkXcrzJIwGGzPCZdQ14D8AJ39RrEPQjJrIyYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YUWF7rkaCq/e75m/fyfFCNq0yiaFrK73pgw2ggsLo3+PYU4/CefGpboFPMZRvpNmX
         YaZ8cIXXkWYu6pXN/y4vbm/cTSpICeCinzWfO06s2jTKgtEDuBpbsaRHHy0mHkfZQQ
         EwZlXm2sADM3umEjqOp1qqkMCsFm4bsef4Wvc8XMWz/hqmJUlbY/xxvR7u39MaEchp
         1zaK5lxZkPLfcIvJqGJg9WlOqP+MfZiz85g54ohKCnhGsSpYv6F6zLRs5NrrJzH9Ff
         KACYrnRjlPd22REl3/0IRTBwnqGQQIn1Ro5vchScGt9p/rDLbmaErQ2XpLY2e1DvhG
         xHHGyJxxkkdzw==
Date:   Fri, 4 Nov 2022 11:17:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Remove unused variable mismatch
Message-ID: <20221104111750.2b323850@kernel.org>
In-Reply-To: <20221104140723.226857-1-colin.i.king@gmail.com>
References: <20221104140723.226857-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 14:07:23 +0000 Colin Ian King wrote:
> Variable mismatch is just being incremented and it's never used anywhere
> else. The variable and the increment are redundant so remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Good sir, you don't have to CC netdev on wireless patches.
Especially trivial ones. I'm saying this because you're a
major contributor and I presume you send patches based on
some scripted integration with get_maintainer so I hope
this could nudge you to improve get_maintainer itself? :)

Perhaps any entry which has a tree specified should mask
off entries higher up?
