Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF10113784
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfEDEn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:43:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfEDEn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:43:59 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E215114D8E233;
        Fri,  3 May 2019 21:43:54 -0700 (PDT)
Date:   Sat, 04 May 2019 00:43:49 -0400 (EDT)
Message-Id: <20190504.004349.367133794422105963.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, eranbe@mellanox.com, jiri@mellanox.com
Subject: Re: [Patch net-next v2] net: add a generic tracepoint for TX queue
 timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
References: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:43:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed,  1 May 2019 19:56:59 -0700

> Although devlink health report does a nice job on reporting TX
> timeout and other NIC errors, unfortunately it requires drivers
> to support it but currently only mlx5 has implemented it.
> Before other drivers could catch up, it is useful to have a
> generic tracepoint to monitor this kind of TX timeout. We have
> been suffering TX timeout with different drivers, we plan to
> start to monitor it with rasdaemon which just needs a new tracepoint.
> 
> Sample output:
> 
>   ksoftirqd/1-16    [001] ..s2   144.043173: net_dev_xmit_timeout: dev=ens3 driver=e1000 queue=0
> 
> Cc: Eran Ben Elisha <eranbe@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thanks Cong.
