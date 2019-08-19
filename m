Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4050E94EAC
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfHSUDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:03:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbfHSUDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:03:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D803145F4F77;
        Mon, 19 Aug 2019 13:03:35 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:03:32 -0700 (PDT)
Message-Id: <20190819.130332.83622783412771597.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, pablo@netfilter.org
Subject: Re: [PATCH net-next] net: flow_offload: convert block_ing_cb_list
 to regular list type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190816150654.22106-1-vladbu@mellanox.com>
References: <20190816150654.22106-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 13:03:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Fri, 16 Aug 2019 18:06:54 +0300

> RCU list block_ing_cb_list is protected by rcu read lock in
> flow_block_ing_cmd() and with flow_indr_block_ing_cb_lock mutex in all
> functions that use it. However, flow_block_ing_cmd() needs to call blocking
> functions while iterating block_ing_cb_list which leads to following
> suspicious RCU usage warning:
 ...
> To fix the described incorrect RCU usage, convert block_ing_cb_list from
> RCU list to regular list and protect it with flow_indr_block_ing_cb_lock
> mutex in flow_block_ing_cmd().
> 
> Fixes: 1150ab0f1b33 ("flow_offload: support get multi-subsystem block")
> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Applied.
