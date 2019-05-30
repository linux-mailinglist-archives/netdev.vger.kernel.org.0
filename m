Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583BC30274
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfE3S43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:56:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfE3S43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:56:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E04E14D9DD7D;
        Thu, 30 May 2019 11:56:28 -0700 (PDT)
Date:   Thu, 30 May 2019 11:56:28 -0700 (PDT)
Message-Id: <20190530.115628.608991171678851481.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     dsahern@gmail.com, dsahern@kernel.org, netdev@vger.kernel.org,
        idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
References: <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
        <20190530.110149.956896317988019526.davem@davemloft.net>
        <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:56:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 30 May 2019 11:27:23 -0700

> On Thu, May 30, 2019 at 11:01 AM David Miller <davem@davemloft.net> wrote:
>>
>> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>> Date: Thu, 30 May 2019 08:18:10 -0700
>>
>> > On Thu, May 30, 2019 at 8:16 AM David Ahern <dsahern@gmail.com> wrote:
>> >>
>> >> On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
>> >> > Huge number of core changes and zero tests.
>> >>
>> >> As mentioned in a past response, there are a number of tests under
>> >> selftests that exercise the code paths affected by this change.
>> >
>> > I see zero new tests added.
>>
>> If the existing tests give sufficient coverage, your objections are not
>> reasonable Alexei.
> 
> I completely disagree. Existing tests are not sufficient.
> It is a new feature for the kernel with corresponding iproute2 new features,
> yet there are zero tests.

Ok, that's tree, and I agree.
