Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B29357D5F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhDHHaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhDHHaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 03:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D5B60FF1;
        Thu,  8 Apr 2021 07:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617867012;
        bh=dqWevd8TMMouKEzqODSdYkGf0l5CEKUdFbPterV++cE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmcV+UZluXt6uUoGqr7RBAHxoOvUY3cCS7vWIzj3aQl+LUWSrJv2lYVWCXBn047Ra
         oZlt17xRyZsSAXQlHVfyjRk754uov3ff0l22xGdPD1stwp4dqYQ2jx7mFfDqGPsG+r
         OSQcfjf23acIhXkRm+442dkwxodrxsOWUqLLB86w+tgAo0kUq7aSqOr+O3rFQ3DC1c
         e/69rj3LSFGPVejOXUTmH1u5KfP9u9aSnStGq/dcNKtjlsAunOg0NLQwx7tk9XdggB
         Eb7Aj/gLYCeop9Q5kTwhhHudw7Hx/0uPq4Lojq8Dm+yvSwiOV37OnoJl6QkVmOmL+d
         w/mKdJpA9VwTA==
Date:   Thu, 8 Apr 2021 10:30:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG6w/eNahpBlmCgJ@unreal>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG1qF8lULn8lLJa/@unreal>
 <MW2PR2101MB08923F19D070996429979E38BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG2pMD9eIHsRetDJ@unreal>
 <MW2PR2101MB0892AC106C360F2A209560A8BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB0892AC106C360F2A209560A8BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 09:59:52PM +0000, Dexuan Cui wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, April 7, 2021 5:45 AM
> > > >
> > > > BTW, you don't need to write { 0 }, the {} is enough.
> > >
> > > Thanks for the suggestion! I'll use {0} in v2.
> > 
> > You missed the point, "{ 0 }" change to be "{}" without 0.
> 
> Got it. Will make the suggested change.

The numbers are not important, if you are curious, read this thread, it
talks about {}, {0}, memset(0,..) and padding :)
https://lore.kernel.org/linux-rdma/20200730192026.110246-1-yepeilin.cs@gmail.com/

> 
> FWIW, {0} and { 0 } are still widely used, but it looks like
> {} is indeed more preferred:
> 
> $ grep "= {};" drivers/net/  -nr  | wc -l
> 829
> 
> $ grep "= {0};" drivers/net/  -nr  | wc -l
> 708
> 
> $ grep "= {};" kernel/  -nr  | wc -l
> 29
> 
> $ grep "= {0};" kernel/  -nr  | wc -l
> 4
