Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2292E0CE5
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgLVPpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbgLVPpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:45:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068AC061793;
        Tue, 22 Dec 2020 07:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GEu2oMLU4SSJqQIgd19YKJ2IS6X3GTZGvv9v3EFnUDQ=; b=jPX+n/KIeKI+9jn2zhyNTtGkxf
        AsDMTzxYpxyNtj8XeJ+ssHns9uZ4d6Fvrp8K6iQiR4Fg+Yhw+Ub87tyykvC9aRZzw33GghkbTZv3s
        fRtgd6tg8G8VpyNDCJNmzg//12oUUFuNDGHIXzln6dvWpA/VeUkotpB/u1sUwSo3aKJIZ9x8LPeaD
        2YSwcSdd3fLwypE/E0GMSluQ5ljTpmC6QcobueLFoz5UJw7B83pFLGGCECXggWnTX4kIwKr3Qvx5r
        Y8pNzk2HUQ2+Gtk9E1drAq68sTc2mG6Z3o2DYWcN031P/WbGf0SirQMQ+xBWlqqePWrdJebcS/IU9
        MM6rA71A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krjpt-00026T-Pv; Tue, 22 Dec 2020 15:44:29 +0000
Date:   Tue, 22 Dec 2020 15:44:29 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v2 01/13] mm: export zap_page_range() for driver use
Message-ID: <20201222154429.GA5557@infradead.org>
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <20201222145221.711-2-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222145221.711-2-xieyongji@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 10:52:09PM +0800, Xie Yongji wrote:
> Export zap_page_range() for use in VDUSE.

Err, no.  This has absolutely no business being used by drivers.
