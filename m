Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93F7B96AF
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393747AbfITRlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 13:41:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59510 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393075AbfITRlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 13:41:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/VvqufFGpmqqg9EwBNt6ZCvzhwzYEFtu/lWXv6sdh+Y=; b=p98/Tel/BkuZReEL/i4p502+7
        ILUhH8ICRijtv5lldUEayz6vOH59Yn/LPIhtLzZcg3zXLSqhKjoKkJhlU+DnUySVBuM0NlhrMyH6v
        R1hL0q+HAz+mphljT6U9glCNynjfzKJtUlgXYw46NociyKWhl/5xcXPOpMdtiO6mfyJmG3imcO9ly
        QFfZ4+YzcEAENmiosO/Sd/AM3qu6yrUzgoCmAHQdIKPCrrbaUbfV0RSctBRzqnf2uJTHUZ8UVNwuU
        fO7nyUyNUCoSs6R9yKO3VXiyIb9g8HQM6v+dFLqTDBPyufIo0cPgqKkmVP9bBRNNozlBdvrvKgY0C
        FFubsVghg==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iBMuJ-0001ci-H1; Fri, 20 Sep 2019 17:41:23 +0000
Subject: Re: [PATCH] dimlib: make DIMLIB a hidden symbol
To:     Tal Gilboa <talgi@mellanox.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Arthur Kiyanovski <akiyano@amazon.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190920133115.12802-1-uwe@kleine-koenig.org>
 <670cc72f-fef0-a8cf-eb03-25fdb608eea8@mellanox.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <89be8d33-ae26-6e46-be11-a653402d3230@infradead.org>
Date:   Fri, 20 Sep 2019 10:41:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <670cc72f-fef0-a8cf-eb03-25fdb608eea8@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/19 10:02 AM, Tal Gilboa wrote:
> On 9/20/2019 4:31 PM, Uwe Kleine-König wrote:
>> According to Tal Gilboa the only benefit from DIM comes from a driver
>> that uses it. So it doesn't make sense to make this symbol user visible,
>> instead all drivers that use it should select it (as is already the case
>> AFAICT).
>>
>> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
>> ---
>>   lib/Kconfig | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/lib/Kconfig b/lib/Kconfig
>> index cc04124ed8f7..9fe8a21fd183 100644
>> --- a/lib/Kconfig
>> +++ b/lib/Kconfig
>> @@ -555,8 +555,7 @@ config SIGNATURE
>>   	  Implementation is done using GnuPG MPI library
>>   
>>   config DIMLIB
>> -	bool "DIM library"
>> -	default y
>> +	bool
>>   	help
>>   	  Dynamic Interrupt Moderation library.
>>   	  Implements an algorithm for dynamically change CQ moderation values
>>
> There's a pending series using DIM which didn't add the select clause 
> [1]. Arthur, FYI. Other than that LGTM.

That's easy enough to fix.

> [1] https://www.mail-archive.com/netdev@vger.kernel.org/msg314304.html

for the patch:
Acked-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
