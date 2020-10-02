Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D3B281ECC
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 01:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBXAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 19:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 19:00:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BFCC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 16:00:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECDC811E49F8C;
        Fri,  2 Oct 2020 15:43:55 -0700 (PDT)
Date:   Fri, 02 Oct 2020 16:00:42 -0700 (PDT)
Message-Id: <20201002.160042.621154959486835359.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        hannes@stressinduktion.org, pabeni@redhat.com, nbd@nbd.name
Subject: Re: [PATCH net-next 0/5] implement kthread based napi poll
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930192140.4192859-1-weiwan@google.com>
References: <20200930192140.4192859-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:43:56 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Wed, 30 Sep 2020 12:21:35 -0700

 ...
> And the reason we prefer 1 kthread per napi, instead of 1 workqueue
> entity per host, is that kthread is more configurable than workqueue,
> and we could leverage existing tuning tools for threads, like taskset,
> chrt, etc to tune scheduling class and cpu set, etc. Another reason is
> if we eventually want to provide busy poll feature using kernel threads
> for napi poll, kthread seems to be more suitable than workqueue. 
...

I think we still need to discuss this some more.

Jakub has some ideas and I honestly think the whole workqueue
approach hasn't been fully considered yet.

If this wan't urgent years ago (when it was NACK'd btw), it isn't
urgent for 5.10 so I don't know why we are pushing so hard for
this patch series to go in as-is right now.

Please be patient and let's have a full discussion on this.

Thank you.
