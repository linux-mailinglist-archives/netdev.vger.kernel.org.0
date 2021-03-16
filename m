Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF30833E0C4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCPVp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhCPVpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:45:41 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412A0C06174A;
        Tue, 16 Mar 2021 14:45:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 742724D04126B;
        Tue, 16 Mar 2021 14:45:37 -0700 (PDT)
Date:   Tue, 16 Mar 2021 14:45:33 -0700 (PDT)
Message-Id: <20210316.144533.1015318495899101097.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1fea8225-69b0-5a73-0e9d-f5bfdecdc840@huawei.com>
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
        <20210315.164151.1093629330365238718.davem@redhat.com>
        <1fea8225-69b0-5a73-0e9d-f5bfdecdc840@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 16 Mar 2021 14:45:37 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Tue, 16 Mar 2021 10:40:56 +0800

> On 2021/3/16 7:41, David Miller wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> At least for the fast path, taking two locks for lockless qdisc hurts
> performance when handling requeued skb, especially if the lockless
> qdisc supports TCQ_F_CAN_BYPASS.

The bad txq and gro skb cases are not "fast path", sorry
