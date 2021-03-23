Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADA13465EC
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCWRGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhCWRGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616519175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KtNdINBUH3O71CX9nL3/PvcG1x/na61kKw2iN7V6Vns=;
        b=bDkmaIy9Mi5VELuaZrY5HpcrA/9/aIYFrNTN7NuLTrj/CFMJL4Vz6Gsc65flKjgJ24Tl59
        ktCIlHl1CBW/VTZ7hhxAr9egOIxtWhIn4xap4LyLaQbw2JP8rEas4TUWk3j5siSQVbhyES
        CsRJtmgBH1VuI1hH7f35U0WhOv3MgrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-3ne10P5-NzOURwCarP9VdA-1; Tue, 23 Mar 2021 13:06:11 -0400
X-MC-Unique: 3ne10P5-NzOURwCarP9VdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E479C180FCA7;
        Tue, 23 Mar 2021 17:06:08 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA96919C45;
        Tue, 23 Mar 2021 17:06:02 +0000 (UTC)
Date:   Tue, 23 Mar 2021 18:06:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323180601.7f8746a8@carbon>
In-Reply-To: <20210323160814.62a248fb@carbon>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
        <20210323104421.GK3697@techsingularity.net>
        <20210323160814.62a248fb@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Mar 2021 16:08:14 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Tue, 23 Mar 2021 10:44:21 +0000
> Mel Gorman <mgorman@techsingularity.net> wrote:
> 
> > On Mon, Mar 22, 2021 at 09:18:42AM +0000, Mel Gorman wrote:  
> > > This series is based on top of Matthew Wilcox's series "Rationalise
> > > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > > test and are not using Andrew's tree as a baseline, I suggest using the
> > > following git tree
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9
> > >     

I've pushed my benchmarks notes for this branch mm-bulk-rebase-v5r9:

 [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org#test-on-mel-git-tree-mm-bulk-rebase-v5r9

> > Jesper and Chuck, would you mind rebasing on top of the following branch
> > please? 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r2

I've rebase on mm-bulk-rebase-v6r4 tomorrow.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

