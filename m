Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9078D35C420
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbhDLKhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:37:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:60044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237219AbhDLKhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 06:37:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D664AAF17;
        Mon, 12 Apr 2021 10:36:50 +0000 (UTC)
Subject: Re: [PATCH 3/9] mm/page_alloc: Add an array-based interface to the
 bulk page allocator
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-4-mgorman@techsingularity.net>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <be02a041-22ff-4ed9-d249-e31e8983bb8d@suse.cz>
Date:   Mon, 12 Apr 2021 12:36:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325114228.27719-4-mgorman@techsingularity.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/21 12:42 PM, Mel Gorman wrote:
> The proposed callers for the bulk allocator store pages from the bulk
> allocator in an array. This patch adds an array-based interface to the API
> to avoid multiple list iterations. The page list interface is preserved
> to avoid requiring all users of the bulk API to allocate and manage enough
> storage to store the pages.
> 
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
