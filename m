Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5891A3B4D
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgDIUZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:25:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgDIUZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 16:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=pZzZn6a5ZNDS0aeGgX1f2/n6FPGGNor9CYMYa2GuZNU=; b=fy4oOzGE86r0juciGSjGFcdv/E
        pY3Ho58zrrrG1nG0Qb7ivs3s7LOsN6RK6VAjeE55ocSZLQuaQEBgaaL5HhoVRB5aQa8YgEx4Xcf6L
        IYY+96HuQF6FleXLCfXWZ7OdnvOHhTIIzgalov67JLm8rWfKKTGNFu0cqweXfQ3Nf1OnxmxikNJVJ
        A3Yc4aPkrzZ8TpjL3u7482LueyElTny2QGO2WbvUcRSgrWXVgSJoCrmbUeNB+ZEyrQ9zufxQWuL4C
        dFCFM9SUHwhQg7WER6usWofbicHlpjOW+GTpNyR8Lz+STEfceziPWfcb/W2KViaS2Kb9ELJQCDKz8
        S6bYRClg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMdkG-0007tD-C0; Thu, 09 Apr 2020 20:25:52 +0000
Subject: Re: [PATCH net] docs: networking: add full DIM API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
References: <20200409175704.305241-1-kuba@kernel.org>
 <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
 <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
 <20200409124221.128d6327@kicinski-fedora-PC1C0HJN>
 <0a2f9a52-6abb-b9ca-45c1-cc74f6d276d7@infradead.org>
 <20200409131818.7f4fa0bf@kicinski-fedora-PC1C0HJN>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ee8a06a5-06fd-4d97-193c-51cc3ad41e7e@infradead.org>
Date:   Thu, 9 Apr 2020 13:25:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200409131818.7f4fa0bf@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/20 1:18 PM, Jakub Kicinski wrote:
> On Thu, 9 Apr 2020 13:06:50 -0700 Randy Dunlap wrote:
>> On 4/9/20 12:42 PM, Jakub Kicinski wrote:
>>> On Thu, 9 Apr 2020 12:27:17 -0700 Randy Dunlap wrote:  
>>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>>
>>>> Add the full net DIM API to the net_dim.rst file.
>>>>
>>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>>> Cc: davem@davemloft.net
>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>> Cc: netdev@vger.kernel.org, talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com  
>>>
>>> Ah, very nice, I didn't know how to do that!
>>>
>>> Do you reckon we should drop the .. c:function and .. c:type marking I
>>> added? So that the mentions of net_dim and the structures point to the
>>> kdoc?  
>>
>> My understanding is that if functions have an ending (), then the c:function
>> is not needed/wanted.  I don't know about the c:type uses.
>>
>> But there is some duplication that might be cleaned up some.
> 
> I think you're thinking about :c:func:, I was talking about ..
> c:function which basically renders very similar entries to kdoc.

Right.

> If you have the doc rendered check out what
> networking/net_dim.html#c.dim takes us to right now.

OK, I see that.

I don't object to those markings, but I would want to see the kernel-doc
structs etc.

thanks.
-- 
~Randy

