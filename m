Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268911378D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfEDE7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:59:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDE7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:59:05 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1255314D99A6F;
        Fri,  3 May 2019 21:58:57 -0700 (PDT)
Date:   Sat, 04 May 2019 00:58:53 -0400 (EDT)
Message-Id: <20190504.005853.22857057952226160.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vladbu@mellanox.com
Subject: Re: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502085105.2967-1-mcroce@redhat.com>
References: <20190502085105.2967-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:59:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Thu,  2 May 2019 10:51:05 +0200

> When a matchall classifier is added, there is a small time interval in
> which tp->root is NULL. If we receive a packet in this small time slice
> a NULL pointer dereference will happen, leading to a kernel panic:
 ...
> Fix this by adding a NULL check in mall_classify().
> 
> Fixes: ed76f5edccc9 ("net: sched: protect filter_chain list with filter_chain_lock mutex")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied and queued up for -stable, thanks.
