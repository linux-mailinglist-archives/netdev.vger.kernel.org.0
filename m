Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128141DCDC5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 15:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgEUNNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 09:13:05 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49743 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbgEUNNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 09:13:05 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49SVRL638Xz1qrgH;
        Thu, 21 May 2020 15:12:59 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49SVRH4rqzz1qql7;
        Thu, 21 May 2020 15:12:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id a19zK21Nug9N; Thu, 21 May 2020 15:12:58 +0200 (CEST)
X-Auth-Info: MRJtPQPfmgeNY8jnM+g92lxTv0p2eoLWUx7SzlP1Onc=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 21 May 2020 15:12:58 +0200 (CEST)
Subject: Re: [PATCH V6 00/20] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     David Miller <davem@davemloft.net>, andrew@lunn.ch
Cc:     lukas@wunner.de, netdev@vger.kernel.org, ynezz@true.cz,
        yuehaibing@huawei.com
References: <20200516.190225.342589110126932388.davem@davemloft.net>
 <20200517071355.ww5xh7fgq7ymztac@wunner.de> <20200517191635.GE606317@lunn.ch>
 <20200517.123014.104345884367246585.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e1814bf1-73e2-6dd7-920b-c826b00bb64d@denx.de>
Date:   Thu, 21 May 2020 15:11:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200517.123014.104345884367246585.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 9:30 PM, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sun, 17 May 2020 21:16:35 +0200
> 
>>> Nevertheless I was going to repeat the performance measurements on a
>>> recent kernel but haven't gotten around to that yet because the
>>> measurements need to be performed with CONFIG_PREEMPT_RT_FULL to
>>> be reliable (a vanilla kernel is too jittery), so I have to create
>>> a new branch with RT patches on the test machine, which is fairly
>>> involved and time consuming.
>>
>> I assume you will then mainline the changes, so you don't need to do
>> it again? That is the problem with doing development work on a dead
>> kernel.
> 
> I think the limitation is outside of his control as not all of the RT
> patches are in mainline yet.

So how shall we proceed here?

Some basic measurement results are here, for the reference [1].

[1] https://www.spinics.net/lists/netdev/msg643099.html
