Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE5A10E977
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 12:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfLBLSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 06:18:36 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:38795 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfLBLSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 06:18:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TjimBtc_1575285500;
Received: from jingxuanljxdeMacBook-Pro.local(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TjimBtc_1575285500)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Dec 2019 19:18:21 +0800
Subject: Re: [PATCH] net: sched: fix wrong class stats dumping in sch_mqprio
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20191128063107.91297-1-dust.li@linux.alibaba.com>
 <CAM_iQpUt44esBeuDw6HJepP+KjJbCk8uYV1ofuZXfeRe52cGYA@mail.gmail.com>
From:   Dust Li <dust.li@linux.alibaba.com>
Message-ID: <c971b372-97f3-3e53-3e33-403602b4e222@linux.alibaba.com>
Date:   Mon, 2 Dec 2019 19:18:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUt44esBeuDw6HJepP+KjJbCk8uYV1ofuZXfeRe52cGYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/30/19 1:48 PM, Cong Wang wrote:
> On Wed, Nov 27, 2019 at 10:31 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>> Actually, the stack variables bstats and qstats in
>> mqprio_dump_class_stats() are not really used. As a result,
>> 'tc -s class show' for the mqprio class always return 0 for
>> both bstats and qstats. Use them to store the child qdisc's
>> stats and add them up as the stats for the mqprio class.
> This patch is on top of the previous one you sent, so please group
> and number them as "Patch X/N", otherwise it is confusing.
>
> Thanks.

OK, Thanks for your kind advice, I'll group them and re-send.


Thanks.

Dust Li

