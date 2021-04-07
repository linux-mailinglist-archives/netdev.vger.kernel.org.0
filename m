Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7E7356BF9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352122AbhDGMTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:19:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352110AbhDGMTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 08:19:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lU79a-00FIwe-Go; Wed, 07 Apr 2021 14:19:26 +0200
Date:   Wed, 7 Apr 2021 14:19:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
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
Message-ID: <YG2jTq/Frtd9gOGO@lunn.ch>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And, some variable defines can not follow the reverse christmas tree
> style due to dependency, e.g.
> static void hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
>                                    struct gdma_event *event) 
> {
>         struct hw_channel_context *hwc = ctx;
>         struct gdma_dev *gd = hwc->gdma_dev;
>         struct gdma_context *gc = gdma_dev_to_context(gd);
> 
> I failed to find the reverse christmas tree rule in the Documentation/ 
> folder. I knew the rule and I thought it was documented there,
> but it looks like it's not. So my understanding is that in general we
> should follow the style, but there can be exceptions due to
> dependencies or logical grouping.

I expect DaveM will tell you to move gdma_dev_to_context(gd) into the
body of the function. Or if you have this pattern a lot, add a macro
gdma_ctx_to_context().

Reverse Christmas tree is not in the main Coding Style documentation,
but it is expected for netdev.

    Andrew
