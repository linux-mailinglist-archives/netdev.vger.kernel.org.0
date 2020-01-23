Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DF114652B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 10:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgAWJys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 04:54:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgAWJys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 04:54:48 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 177B7153D1F5F;
        Thu, 23 Jan 2020 01:54:43 -0800 (PST)
Date:   Thu, 23 Jan 2020 10:54:36 +0100 (CET)
Message-Id: <20200123.105436.515913650694137847.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     vladbu@mellanox.com, netdev@vger.kernel.org, jiri@resnulli.us,
        paulb@mellanox.com, ozsh@mellanox.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 00/13] Handle multi chain hardware misses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4b0bcbf60537bcdfe8d184531788a9b6084be8f6.camel@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
        <4b0bcbf60537bcdfe8d184531788a9b6084be8f6.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 01:54:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 21 Jan 2020 21:18:21 +0000

> On Tue, 2020-01-21 at 18:16 +0200, Paul Blakey wrote:
>> Note that miss path handling of multi-chain rules is a required
>> infrastructure
>> for connection tracking hardware offload. The connection tracking
>> offload
>> series will follow this one.
> 
> Hi Dave and Jakub,
> 
> As Paul explained this is part one of two parts series,
> 
> Assuming the review will go with no issues i would like to suggest the
> following acceptance options:
> 
> option 1) I can create a separate side branch for connection tracking
> offload and once Paul submits the final patch of this feature and the
> mailing list review is complete, i can send to you full pull request
> with everything included .. 
> 
> option 2) you to apply directly to net-next both patchsets
> individually. (the normal process)
> 
> Please let me know what works better for you.
> 
> Personally I prefer option 1) so we won't endup stuck with only one
> half of the connection tracking series if the review of the 2nd part
> doesn't go as planned.

I'm fine with option #1 and will wait for that to appear in one of
your future pull requests.  It looks like patch #1 got some feedback
and needs some modifications first though.

