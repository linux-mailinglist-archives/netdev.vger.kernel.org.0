Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54B6C22A
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfGQUe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:34:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfGQUe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:34:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9BBFD14DE872E;
        Wed, 17 Jul 2019 13:34:55 -0700 (PDT)
Date:   Wed, 17 Jul 2019 13:34:53 -0700 (PDT)
Message-Id: <20190717.133453.1936834327934239339.davem@davemloft.net>
To:     edumazet@google.com
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [Patch net v2] net_sched: unset TCQ_F_CAN_BYPASS when adding
 filters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANn89iKKidoeN8fwZLcem8BRK1FTJptwfYkO3Jn61ya7PKQLJA@mail.gmail.com>
References: <20190716205730.19675-1-xiyou.wangcong@gmail.com>
        <20190717.120446.101023323109287941.davem@davemloft.net>
        <CANn89iKKidoeN8fwZLcem8BRK1FTJptwfYkO3Jn61ya7PKQLJA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 13:34:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 Jul 2019 21:19:51 +0200

> On Wed, Jul 17, 2019 at 9:04 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Cong Wang <xiyou.wangcong@gmail.com>
>> Date: Tue, 16 Jul 2019 13:57:30 -0700
>>
>> > For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
>> > notably fq_codel, it makes no sense to let packets bypass the TC
>> > filters we setup in any scenario, otherwise our packets steering
>> > policy could not be enforced.
>>  ...
>>
>> Eric I think your feedback was addressed, please review to confirm.
> 
> Yes, this seems good to me, thanks.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Great, applied and queued up for -stable.
