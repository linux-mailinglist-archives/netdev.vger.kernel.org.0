Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D061E8C68
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgE3AAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgE3AAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:00:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D03C03E969;
        Fri, 29 May 2020 17:00:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 329431273D978;
        Fri, 29 May 2020 17:00:06 -0700 (PDT)
Date:   Fri, 29 May 2020 17:00:05 -0700 (PDT)
Message-Id: <20200529.170005.1952701912928856345.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] tipc: remove set but not used variable 'prev'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528074359.116680-1-yuehaibing@huawei.com>
References: <20200528074359.116680-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:00:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 28 May 2020 07:43:59 +0000

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> net/tipc/msg.c: In function 'tipc_msg_append':
> net/tipc/msg.c:215:24: warning:
>  variable 'prev' set but not used [-Wunused-but-set-variable]
> 
> commit 0a3e060f340d ("tipc: add test for Nagle algorithm effectiveness")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
