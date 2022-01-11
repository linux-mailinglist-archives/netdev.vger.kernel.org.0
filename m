Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA248AEF4
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240850AbiAKN4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239487AbiAKN4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:56:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5CEC06173F;
        Tue, 11 Jan 2022 05:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9x3T+OG12IkfXXX5SdbrD0z40LWuqe0Q6mgSeNzWLM8=; b=TaT6fy8pCvO5SdKMnaN7SpBmY9
        /ZLyF3tWCXHLpuit9luOiZ+ndBhQ7LL/wNEHrb38QTJZ6YpADTaPY1r1YOSR00c9Kbj2WgXFKfoye
        AWqf5FCJoK95CUarLnHHHQ+mltrKuJLW/m7eN2QQhyn7ZyRMaP6Z5ZdVjN6nHIgPoWECjHIV9dkCB
        +ZfRtOv6Aex8dBEReg0SGmxUnklwwvLlMM42PR8Xw3SOfokz55fFhdgE9ORE7rzOEVfdu079sxZ6X
        tK+DFC4Njr3sRPVXX9X+tuYJmqg8+Ur/DcvJQhMYgoFj0Bmnsfpi5Rk6ot0HbCwGDYQSQnGAGX52y
        Zz45MQfg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7HdA-003Id6-MO; Tue, 11 Jan 2022 13:56:08 +0000
Date:   Tue, 11 Jan 2022 13:56:08 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        dri-devel@lists.freedesktop.org, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Phyr Starter
Message-ID: <Yd2MeMT6LXWxJIDd@casper.infradead.org>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <f7bd672f-dfa8-93fa-e101-e57b90faeb1e@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7bd672f-dfa8-93fa-e101-e57b90faeb1e@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 12:40:10PM +0100, Thomas Zimmermann wrote:
> Hi
> 
> Am 10.01.22 um 20:34 schrieb Matthew Wilcox:
> > TLDR: I want to introduce a new data type:
> > 
> > struct phyr {
> >          phys_addr_t addr;
> >          size_t len;
> > };
> 
> Did you look at struct dma_buf_map? [1]

Thanks.  I wasn't aware of that.  It doesn't seem to actually solve the
problem, in that it doesn't carry any length information.  Did you mean
to point me at a different structure?

