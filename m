Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905B0F3EBA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbfKHEJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:09:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbfKHEJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:09:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A38D14F4FDD8;
        Thu,  7 Nov 2019 20:09:05 -0800 (PST)
Date:   Thu, 07 Nov 2019 20:09:05 -0800 (PST)
Message-Id: <20191107.200905.1686450576065616237.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [net-next] tipc: eliminate checking netns if node established
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108030237.6619-1-hoang.h.le@dektech.com.au>
References: <20191108030237.6619-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 20:09:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>
Date: Fri,  8 Nov 2019 10:02:37 +0700

> Currently, we scan over all network namespaces at each received
> discovery message in order to check if the sending peer might be
> present in a host local namespaces.
> 
> This is unnecessary since we can assume that a peer will not change its
> location during an established session.
> 
> We now improve the condition for this testing so that we don't perform
> any redundant scans.
> 
> Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied, thank you.
