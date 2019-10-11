Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44774D34C3
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfJKABG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:01:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41568 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfJKABG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UQF4cNumUbtKahglQlBwLkBLOTXfceVJww2G5C//v48=; b=o8yVlPGynvMz+eefSvU+Yb/wp
        lWTtCR3YFPa92uDCbR9O5mqki0k8kECVd750q6GWPBN4JD7U+5fnahS9879K1XGe0xHYJTr6/6gYq
        x299ufkDMbNxPY8C4HBjFE7Zw5nlT/XX4nxOjaS23ugu4lISgsqtbkCncndmHw9iqyIWqShKWdfFr
        e9IpkWe8/ojbhz6TTbZjihOJliNdHP8aQZ+yGCS5ypF5LAJBGRdFufKpZWkvK1OcACLphxfVDad1B
        iQ/C9AIRr0bUKHtwtiATpx4WiqvPcbDYPUWW3toQtLS9P0jq09XvXfLnS28TNPRHRB5b+2QPEYjE0
        pFcwYDrbA==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIiMj-0000wz-2F; Fri, 11 Oct 2019 00:01:05 +0000
Subject: Re: [PATCH] Documentation: networking: add a chapter for the DIM
 library
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        David Miller <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
References: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
 <20191010162003.4f36a820@cakuba.netronome.com>
 <4c7f5563-2ca1-d37b-7639-f3df99a0219b@infradead.org>
 <20191010165828.0540d18d@cakuba.netronome.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c3eab338-f3a9-bff3-4c24-edeb3f80b7cd@infradead.org>
Date:   Thu, 10 Oct 2019 17:01:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191010165828.0540d18d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/19 4:58 PM, Jakub Kicinski wrote:
> On Thu, 10 Oct 2019 16:34:59 -0700, Randy Dunlap wrote:
>> On 10/10/19 4:20 PM, Jakub Kicinski wrote:
>>> On Thu, 10 Oct 2019 15:55:15 -0700, Randy Dunlap wrote:  
>>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>>
>>>> Add a Documentation networking chapter for the DIM library.
>>>>
>>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>>> Cc: Tal Gilboa <talgi@mellanox.com>
>>>> Cc: "David S. Miller" <davem@davemloft.net>
>>>> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
>>>> Cc: netdev@vger.kernel.org
>>>> Cc: linux-rdma@vger.kernel.org
>>>> ---
>>>>  Documentation/networking/index.rst   |    1 +
>>>>  Documentation/networking/lib-dim.rst |    6 ++++++
>>>>  2 files changed, 7 insertions(+)
>>>>
>>>> --- linux-next-20191010.orig/Documentation/networking/index.rst
>>>> +++ linux-next-20191010/Documentation/networking/index.rst
>>>> @@ -33,6 +33,7 @@ Contents:
>>>>     scaling
>>>>     tls
>>>>     tls-offload
>>>> +   lib-dim
>>>>  
>>>>  .. only::  subproject and html
>>>>  
>>>> --- /dev/null
>>>> +++ linux-next-20191010/Documentation/networking/lib-dim.rst
>>>> @@ -0,0 +1,6 @@
>>>> +=====================================================
>>>> +Dynamic Interrupt Moderation (DIM) library interfaces
>>>> +=====================================================
>>>> +
>>>> +.. kernel-doc:: include/linux/dim.h
>>>> +    :internal:
>>>>
>>>>  
>>>
>>> CC: linux-doc, Jake
>>>
>>> How does this relate to Documentation/networking/net_dim.txt ?
>>> (note in case you want to edit that one there is a patch with 
>>> updates for that file from Jake I'll be applying shortly)
> 
> Applied now.
> 
>> There is also a small patch from Jesse:
>> https://lore.kernel.org/netdev/20191010193112.15215-1-jesse.brandeburg@intel.com/
> 
> Ack, as Jake said this duplicates part of what his patch covered, tho.

Yes, so I noticed.

> Will you try to convert and integrate the existing file instead, or do
> you think the kdoc file should be separate?

I'll take a look at doing that.

thanks.
-- 
~Randy
