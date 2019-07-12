Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91C67676
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGLWSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:18:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfGLWSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:18:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3A42E14E01AA4;
        Fri, 12 Jul 2019 15:18:49 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:18:46 -0700 (PDT)
Message-Id: <20190712.151846.1093841226730573129.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next] net: openvswitch: do not update max_headroom
 if new headroom is equal to old headroom
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705160809.5202-1-ap420073@gmail.com>
References: <20190705160809.5202-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:18:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat,  6 Jul 2019 01:08:09 +0900

> When a vport is deleted, the maximum headroom size would be changed.
> If the vport which has the largest headroom is deleted,
> the new max_headroom would be set.
> But, if the new headroom size is equal to the old headroom size,
> updating routine is unnecessary.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

I don't think Taehee should be punished because it took several days
to get someone to look at and review and/or test this patch and
meanwhile the net-next tree closed down.

I ask for maintainer review as both a courtesy and a way to lessen
my workload.  But if that means patches rot for days in patchwork
I'm just going to apply them after my own review.

So I'm applying this now.

