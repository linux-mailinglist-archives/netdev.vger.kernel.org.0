Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7958A1F402E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgFIQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 12:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731060AbgFIQDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 12:03:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3FC05BD1E;
        Tue,  9 Jun 2020 09:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=EbgramDsClABbRh6SAXFCh3bxBrc0kj7IkVo3KuqmtM=; b=cO3c2Jp4wSWBSIYCVjEGfETKzB
        4MHEl3u1W+06LuzU/RiQYyNfWUdfKzFf+nCoV7IeleFAke6LnGCTwuJTCXkaXvbmtz3YJs6YjjkNb
        +CENmEnwphZ/uA3zSIpXHyhbSlOE4t2OK9oaLPsXeetUZPBXY1FqbofhwGy3ZEJi2lc7+X9oF1S9t
        u1A3Xc1S3aATO+IvvejggzFh1mhDM3IL1b3MgxgQNcevdtGZVJcg8ZyTqr7O1kwAg9zkGGB7S8irq
        xq++b5wewuMW2HpxmZ3e0CMJOt8qzDnyA2IZQaUtBigSEV7HiEldcvXSPDWqlxAd7zy2HxXG/vpSt
        wCdAlmPg==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jigiz-0001ZX-OG; Tue, 09 Jun 2020 16:03:41 +0000
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
To:     Matthew Wilcox <willy@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609111323.GA19604@bombadil.infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
Date:   Tue, 9 Jun 2020 09:03:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609111323.GA19604@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/20 4:13 AM, Matthew Wilcox wrote:
> On Tue, Jun 09, 2020 at 01:45:57PM +0300, Stanimir Varbanov wrote:
>> Here is the third version of dynamic debug improvements in Venus
>> driver.  As has been suggested on previous version by Joe [1] I've
>> made the relevant changes in dynamic debug core to handle leveling
>> as more generic way and not open-code/workaround it in the driver.
>>
>> About changes:
>>  - added change in the dynamic_debug and in documentation
>>  - added respective pr_debug_level and dev_dbg_level
> 
> Honestly, this seems like you want to use tracepoints, not dynamic debug.
> 

Also see this patch series:
https://lore.kernel.org/lkml/20200605162645.289174-1-jim.cromie@gmail.com/
[PATCH 00/16] dynamic_debug: cleanups, 2 features

It adds/expands dynamic debug flags quite a bit.

-- 
~Randy

