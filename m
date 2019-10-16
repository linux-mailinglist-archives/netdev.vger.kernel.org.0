Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFBCD98B9
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 19:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbfJPRrt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 13:47:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52274 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfJPRrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 13:47:48 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03C8314239BC4;
        Wed, 16 Oct 2019 10:47:47 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:47:47 -0400 (EDT)
Message-Id: <20191016.134747.1774326347358314168.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com, brouer@redhat.com, dvyukov@google.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: Stable request
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
References: <20190823.144250.2063544404229146484.davem@davemloft.net>
        <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
        <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 10:47:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Wed, 16 Oct 2019 16:26:50 +0100

> On 04/10/2019 16:17, Edward Cree wrote:
>> On 23/08/2019 22:42, David Miller wrote:
>>> From: Xin Long <lucien.xin@gmail.com>
>>> Date: Fri, 23 Aug 2019 19:33:03 +0800
>>>
>>>> We need a similar fix for ipv6 as Commit 0761680d5215 ("net: ipv4: fix
>>>> listify ip_rcv_finish in case of forwarding") does for ipv4.
>>>>
>>>> This issue can be reprocuded by syzbot since Commit 323ebb61e32b ("net:
>>>> use listified RX for handling GRO_NORMAL skbs") on net-next. The call
>>>> trace was:
>>>  ...
>>>> Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
>>>> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
>>>> Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com
>>>> Reported-by: syzbot+4a0643a653ac375612d1@syzkaller.appspotmail.com
>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>> Applied, thanks.
>> Just noticed that this only went to net-next (and 5.4-rc1), when actually
>>  it's needed on all kernels back to 4.19 (per the first Fixes: tag).  The
>>  second Fixes: reference, 323ebb61e32b, merely enables syzbot to hit it on
>>  whatever hardware it has, but the bug was already there, and hittable on
>>  sfc NICs.
>> David, can this go to stable please?
> Hi, did this get missed or was my request improper in some way?

Sorry, I'm just getting over a cold and very backlogged on this kind of stuff.

I'll get to this while I can Ed.
