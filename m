Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0EA3C2977
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhGITVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:21:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41494 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGITVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 15:21:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E28F94D310818;
        Fri,  9 Jul 2021 12:18:56 -0700 (PDT)
Date:   Fri, 09 Jul 2021 12:18:52 -0700 (PDT)
Message-Id: <20210709.121852.1733023630353535689.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, qitao.xu@bytedance.com,
        cong.wang@bytedance.com
Subject: Re: [Patch net-next] net: use %px to print skb address in
 trace_netif_receive_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpUaZg9rGz_e0+UcnaT5-iLK5G5LUeViTnpcZHWzWS5g_Q@mail.gmail.com>
References: <20210709051710.15831-1-xiyou.wangcong@gmail.com>
        <20210709.011625.1604833283174788576.davem@davemloft.net>
        <CAM_iQpUaZg9rGz_e0+UcnaT5-iLK5G5LUeViTnpcZHWzWS5g_Q@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 09 Jul 2021 12:18:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri, 9 Jul 2021 11:59:43 -0700

> On Fri, Jul 9, 2021 at 1:16 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: Cong Wang <xiyou.wangcong@gmail.com>
>> Date: Thu,  8 Jul 2021 22:17:08 -0700
>>
>> > From: Qitao Xu <qitao.xu@bytedance.com>
>> >
>> > The print format of skb adress in tracepoint class net_dev_template
>> > is changed to %px from %p, because we want to use skb address
>> > as a quick way to identify a packet.
>> >
>> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
>> > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
>>
>> Aren't we not supposed to leak kernel addresses to userspace?
> 
> Right, but trace ring buffer is only accessible to privileged users,
> so leaking it to root is not a problem.

Please explain this in your commit msgs and resubmit.

Thank you.

