Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CF51D5CD1
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgEOXdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOXdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:33:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3A5C061A0C;
        Fri, 15 May 2020 16:33:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CEA8E1581D667;
        Fri, 15 May 2020 16:33:40 -0700 (PDT)
Date:   Fri, 15 May 2020 16:33:38 -0700 (PDT)
Message-Id: <20200515.163338.1424746250972517404.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ethernet: ti: am65-cpts: Add missing inline qualifier
 to stub functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515223317.3650378-1-natechancellor@gmail.com>
References: <20200515223317.3650378-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 16:33:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Fri, 15 May 2020 15:33:18 -0700

> When building with Clang:
> 
> In file included from drivers/net/ethernet/ti/am65-cpsw-ethtool.c:15:
> drivers/net/ethernet/ti/am65-cpts.h:58:12: warning: unused function
> 'am65_cpts_ns_gettime' [-Wunused-function]
> static s64 am65_cpts_ns_gettime(struct am65_cpts *cpts)
>            ^
> drivers/net/ethernet/ti/am65-cpts.h:63:12: warning: unused function
> 'am65_cpts_estf_enable' [-Wunused-function]
> static int am65_cpts_estf_enable(struct am65_cpts *cpts,
>            ^
> drivers/net/ethernet/ti/am65-cpts.h:69:13: warning: unused function
> 'am65_cpts_estf_disable' [-Wunused-function]
> static void am65_cpts_estf_disable(struct am65_cpts *cpts, int idx)
>             ^
> 3 warnings generated.
> 
> These functions need to be marked as inline, which adds __maybe_unused,
> to avoid these warnings, which is the pattern for stub functions.
> 
> Fixes: ec008fa2a9e5 ("ethernet: ti: am65-cpts: add routines to support taprio offload")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1026
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thanks.
