Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93F76769C
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbfGLWkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:40:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34394 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfGLWkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:40:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94E9C14E0386D;
        Fri, 12 Jul 2019 15:40:48 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:40:47 -0700 (PDT)
Message-Id: <20190712.154047.1787144778692165503.davem@davemloft.net>
To:     lorenzo.bianconi@redhat.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, marek@cloudflare.com
Subject: Re: [PATCH net] net: neigh: fix multiple neigh timer scheduling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7b254317bcb84a33cdbe8eed96e510324d6eb97c.1562951883.git.lorenzo.bianconi@redhat.com>
References: <7b254317bcb84a33cdbe8eed96e510324d6eb97c.1562951883.git.lorenzo.bianconi@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:40:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Fri, 12 Jul 2019 19:22:51 +0200

> Neigh timer can be scheduled multiple times from userspace adding
> multiple neigh entries and forcing the neigh timer scheduling passing
> NTF_USE in the netlink requests.
> This will result in a refcount leak and in the following dump stack:
 ...
> Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIMER'
> receiving a netlink request with NTF_USE flag set
> 
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbour table")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Applied and queued up for -stable, thanks.
