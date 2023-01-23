Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93846774AF
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 05:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjAWEgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 23:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjAWEgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 23:36:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008AC12F34;
        Sun, 22 Jan 2023 20:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gn+EEhD9AwqmASOet+WmWkkx11j/sBtEj1r0Vez2fZ8=; b=cnSg/aTEkcd6NarLXKMWFH55Hj
        +tnCgTrOR1ZFnaARi0DacKX4/GvKX6g9aY7vLQiWcHE03/Q++qgFKL5/KLz6IvbiusZFSRqQjzodp
        hzGE5KGiQM4bkWS0tbn132VKC+JnGmdfLjVKLfVoEukfFHOTHxIuGxL0XsZKqJQ1w1131oDNRScq6
        IJHLfNnq1urBDj6F2ZAJeNs68ZIuPMrMyQ9s1xTAt83D5QmmygtC31t7L8Gz+QZmANxmvYOtIB+fs
        I0eKJDci8/bA4Wp1N3jeQ2dA4mixnjLp0Bb13foCgJQTnoy9ebMBWQ0/hSAkW4t6biPiQqK7Y2RAQ
        bHU9lDQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pJoZF-003yRD-Jz; Mon, 23 Jan 2023 04:36:25 +0000
Date:   Mon, 23 Jan 2023 04:36:25 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev, Shakeel Butt <shakeelb@google.com>
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y84OyQSKHelPOkW3@casper.infradead.org>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8v+qVZ8OmodOCQ9@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 11:03:05AM -0400, Jason Gunthorpe wrote:
> I would like to have a session at LSF to talk about Matthew's
> physr discussion starter:
> 
>  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/

I'm definitely interested in discussing phyrs (even if you'd rather
pronounce it "fizzers" than "fires" ;-)

> I've been working on an implementation and hope to have something
> draft to show on the lists in a few weeks. It is pretty clear there
> are several interesting decisions to make that I think will benefit
> from a live discussion.

Cool!  Here's my latest noodlings:
https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/phyr

Just the top two commits; the other stuff is unrelated.  Shakeel has
also been interested in this.

