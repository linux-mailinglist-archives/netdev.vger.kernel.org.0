Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D861B64A1
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDWTlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWTlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:41:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA4DC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:41:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A5991277ADF8;
        Thu, 23 Apr 2020 12:41:49 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:41:48 -0700 (PDT)
Message-Id: <20200423.124148.1898132978349849298.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix adapter crash due to wrong MC size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422155007.17216-1-vishal@chelsio.com>
References: <20200422155007.17216-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:41:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Wed, 22 Apr 2020 21:20:07 +0530

> In the absence of MC1, the size calculation function
> cudbg_mem_region_size() was returing wrong MC size and
> resulted in adapter crash. This patch adds new argument
> to cudbg_mem_region_size() which will have actual size
> and returns error to caller in the absence of MC1.
> 
> Fixes: a1c69520f785 ("cxgb4: collect MC memory dump")
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"

Applied and queued up for -stable, thanks.
