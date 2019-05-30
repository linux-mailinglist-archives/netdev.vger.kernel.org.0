Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78EF03016A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfE3SBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:01:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56230 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:01:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D26C14D7CE92;
        Thu, 30 May 2019 11:01:50 -0700 (PDT)
Date:   Thu, 30 May 2019 11:01:49 -0700 (PDT)
Message-Id: <20190530.110149.956896317988019526.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     dsahern@gmail.com, dsahern@kernel.org, netdev@vger.kernel.org,
        idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
References: <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
        <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com>
        <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:01:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 30 May 2019 08:18:10 -0700

> On Thu, May 30, 2019 at 8:16 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
>> > Huge number of core changes and zero tests.
>>
>> As mentioned in a past response, there are a number of tests under
>> selftests that exercise the code paths affected by this change.
> 
> I see zero new tests added.

If the existing tests give sufficient coverage, your objections are not
reasonable Alexei.
