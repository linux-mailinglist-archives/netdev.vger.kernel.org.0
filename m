Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2354B165368
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBTAM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:12:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBTAM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:12:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19D6B15BCDA3E;
        Wed, 19 Feb 2020 16:12:58 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:12:55 -0800 (PST)
Message-Id: <20200219.161255.733098365672070487.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     ozsh@mellanox.com, vladbu@mellanox.com, paulb@mellanox.com,
        jiri@mellanox.com, kuba@kernel.org, netdev@vger.kernel.org,
        roid@mellanox.com
Subject: Re: [PATCH net-next v3 00/16] Handle multi chain hardware misses
From:   David Miller <davem@davemloft.net>
In-Reply-To: <41b34b364a2656a6f3e37ba256161de477e7881d.camel@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
        <41b34b364a2656a6f3e37ba256161de477e7881d.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:12:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 19 Feb 2020 02:43:08 +0000

> On Sun, 2020-02-16 at 12:01 +0200, Paul Blakey wrote:
>> Hi David/Jakub/Saeed,
>> 
>> TC multi chain configuration can cause offloaded tc chains to miss in
>> hardware after jumping to some chain. In such cases the software
>> should
>> continue from the chain that was missed in hardware, as the hardware
>> may have
>> manipulated the packet and updated some counters.
>> 
> 
> [...]
> 
>> Note that miss path handling of multi-chain rules is a required
>> infrastructure
>> for connection tracking hardware offload. The connection tracking
>> offload
>> series will follow this one.
>> 
> 
> Hi Dave, 
> 
> As was agreed, i will apply this series and the two to follow to a side
> branch until all the connection tracking offloads patchsets are posted
> by Paul and reviewed/acked.
> 
> in case of no objection i will apply this patchset to allow Paul to
> move forward with the other two connection tracking patchsets.

I have no objection to this series, can you setup a pull request with this
series in it that I can pull from into net-next?

Thanks.
