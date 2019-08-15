Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3C8E7C6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfHOJIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:08:15 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:23210 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730928AbfHOJIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 05:08:14 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 7D43EA153C;
        Thu, 15 Aug 2019 11:08:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id 2PtRDRrQpjUK; Thu, 15 Aug 2019 11:08:07 +0200 (CEST)
Subject: Re: [PATCH] net: ethernet: mediatek: Add MT7628/88 SoC support
To:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Daniel Golle <daniel@makrotopia.org>
References: <20190717125345.Horde.JcDE_nBChPFDDjEgIRfPSl3@www.vdorst.com>
 <a92d7207-80b2-e88d-d869-64c9758ef1da@denx.de>
 <20190814092621.Horde.epvj8zK96-aCiV70YB5Q7II@www.vdorst.com>
 <3ff9a0fc-f5ff-3798-4409-ed5b900e0b05@denx.de>
 <20190814130856.Horde.wzHL8_VRawJ8NIIk--BD18e@www.vdorst.com>
From:   Stefan Roese <sr@denx.de>
Message-ID: <9bbc449b-bff2-448a-6b95-cc712c9353b8@denx.de>
Date:   Thu, 15 Aug 2019 11:08:05 +0200
MIME-Version: 1.0
In-Reply-To: <20190814130856.Horde.wzHL8_VRawJ8NIIk--BD18e@www.vdorst.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rene,

On 14.08.19 15:08, René van Dorst wrote:
> Quoting Stefan Roese <sr@denx.de>:
> 
>> Hi Rene,
>>
>> On 14.08.19 11:26, René van Dorst wrote:
> 
> <snip>
> 
>>> Great, Thanks for addressing this issue.
>>>
>>> I hope we can collaborate to also support mt76x8 in my PHYLINK
>>> patches [0][1].
>>> I am close to posting V2 of the patches but I am currently waiting on some
>>> fiber modules to test the changes better.
>>
>> I do have a "hackish" DSA driver for the integrated switch (ESW) in my
>> tree. If time permits, I'll work on upstreaming this one as well. And
>> yes, hopefully we can collaborate on your PHYLINK work too.
> 
> It is not only the switch driver but also the Mediatek ethernet driver that is
> converted to PHYLINK. So we have a conflict in each others work.

Yes, I am aware of this.
  
> I don't no what the right way is to go but I was thinking about 2 options
> 
> 1. Lets say your work goes in first. I rebase my patches on your changes.
>      We collaborate to create an extra PHYLINK patch ontop of my work
> for your SOC.
> 2. My patches goes in first and you adapt your patches to that.
> 
> What do you think?

It really depends on the timing, when the patches arrive in the kernel
(net-next). If yours makes it first, I'll rebase my patch on top of
your work. Otherwise you will need to rebase yours.
  
> I have latest changes here [0].
> 
> Also my modules did arrive so I can test my changes.

Thanks,
Stefan
