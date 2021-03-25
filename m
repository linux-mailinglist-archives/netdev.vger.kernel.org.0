Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96B534915A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCYMBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhCYMAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:00:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84089C06174A;
        Thu, 25 Mar 2021 05:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Ubh5rqKpCoG70VJXzMk3B9mj2PWTKZHcDRXGyWMmm0=; b=kwjzv34/Cr0CTU8of7/ZGih+VC
        p4iXCyMssCrgsb3bc9WAA0XdbdnHk3nIHiwYqbijBQE2FVv6cI4zHr/V79AUD9kTBBRMI2t6kUqte
        d1fUhP/3X3slJ05+a1qzXsJFKWTaESWQMPOGpsxKZZmttoCLJHOn1iVcU6y9u1eIXEixBCu3oDcbK
        O8vHWiklvkaBWnZSZKlgrBF9WCsN+3BHmuksXUTqubVU1Em9zgPuiJTV3blAul1mFK0rSMyDVkuGV
        Hqp1u3X2vXC4/GGTsCZdNF3J55GGTyVsQSKj9XvHOA7woFWSMMTLya0XNCyvS26gd33dh5Fx4IfrV
        rU/X2owQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lPOdm-00Cqvw-Ag; Thu, 25 Mar 2021 11:59:12 +0000
Date:   Thu, 25 Mar 2021 11:59:06 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 1/9] mm/page_alloc: Rename alloced to allocated
Message-ID: <20210325115906.GT1719932@casper.infradead.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-2-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325114228.27719-2-mgorman@techsingularity.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 11:42:20AM +0000, Mel Gorman wrote:
> Review feedback of the bulk allocator twice found problems with "alloced"
> being a counter for pages allocated. The naming was based on the API name
> "alloc" and was based on the idea that verbal communication about malloc
> tends to use the fake word "malloced" instead of the fake word mallocated.
> To be consistent, this preparation patch renames alloced to allocated
> in rmqueue_bulk so the bulk allocator and per-cpu allocator use similar
> names when the bulk allocator is introduced.
> 
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
