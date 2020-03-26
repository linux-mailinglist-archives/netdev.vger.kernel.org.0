Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6700419466B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgCZSVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:21:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgCZSVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:21:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C25E715CB9435;
        Thu, 26 Mar 2020 11:21:20 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:21:17 -0700 (PDT)
Message-Id: <20200326.112117.296057933553903521.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     netdev@vger.kernel.org, ying.xue@windriver.com, maloy@donjonn.com,
        jmaloy@redhat.com, tuong.t.lien@dektech.com.au
Subject: Re: [net-next] tipc: Add a missing case of TIPC_DIRECT_MSG type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326025029.5292-1-hoang.h.le@dektech.com.au>
References: <20200326025029.5292-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:21:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>
Date: Thu, 26 Mar 2020 09:50:29 +0700

> In the commit f73b12812a3d
> ("tipc: improve throughput between nodes in netns"), we're missing a check
> to handle TIPC_DIRECT_MSG type, it's still using old sending mechanism for
> this message type. So, throughput improvement is not significant as
> expected.
> 
> Besides that, when sending a large message with that type, we're also
> handle wrong receiving queue, it should be enqueued in socket receiving
> instead of multicast messages.
> 
> Fix this by adding the missing case for TIPC_DIRECT_MSG.
> 
> Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
> Reported-by: Tuong Lien <tuong.t.lien@dektech.com.au>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> Acked-by: Jon Maloy <jmaloy@redhat.com>

Applied to net-next, thank you.
