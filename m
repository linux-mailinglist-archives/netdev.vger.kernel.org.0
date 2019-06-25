Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C655857
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfFYUDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:03:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfFYUDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:03:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07698126A7C10;
        Tue, 25 Jun 2019 13:03:50 -0700 (PDT)
Date:   Tue, 25 Jun 2019 13:03:50 -0700 (PDT)
Message-Id: <20190625.130350.859562313660296893.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     sukumarg1973@gmail.com, karn@ka9q.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: hard-coded limit on unresolved multicast route cache in
 ipv4/ipmr.c causes slow, unreliable creation of multicast routes on busy
 networks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625061507.GG18865@dhcp-12-139.nay.redhat.com>
References: <CADiZnkTm3UMdZ+ivPXFeTJS+_2ZaiQh7D8wWnsw0BNGfxa0C4w@mail.gmail.com>
        <20181218.215545.1657190540227341803.davem@davemloft.net>
        <20190625061507.GG18865@dhcp-12-139.nay.redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 13:03:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 25 Jun 2019 14:15:07 +0800

> On Tue, Dec 18, 2018 at 09:55:45PM -0800, David Miller wrote:
>> From: Sukumar Gopalakrishnan <sukumarg1973@gmail.com>
>> Date: Wed, 19 Dec 2018 10:57:02 +0530
>> 
>> > Hi David,
>> > 
>> >   There are two patch for this issue:
>> >    1) Your changes which removes cache_resolve_queue_len
>> >     2) Hangbin's changes which make cache_resolve_queue_len configurable.
>> > 
>> > Which one will be chosen for this issue ?
>> 
>> I do plan to look into this, sorry for taking so long.
>> 
>> Right now I am overwhelmed preparing for the next merge window and
>> synchronizing with other developers for that.
>> 
>> Please be patient.
> 
> Hi David,
> 
> Any progress for this issue?

I have absolutely no context from a discussion that happened back in Dec 2018

If it is important to you, please restart the discussion with a new mailing list
posting restating the problem from the beginning and reiterating all of the
points and arguments that have been made thus far.
