Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDE33AE36
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhCOJKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhCOJJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 05:09:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7701CC061574;
        Mon, 15 Mar 2021 02:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a9gg6oJQhPPM7u3VKZMtdQzIuN1q3Wx++payqsoQUyo=; b=mFecxq7ONcsePC6b0VSW3y9V6t
        PVSk5CTm0jpk4ChPtmaYl9/Pwho3AkaNrtLDTUjN8pJaDVS0q9LjQy4FQ4/zNolRtK5KmIkXpYmZG
        glLOI7o2kH5qU0A57FX81pbhx18d8uALXHe1TvXBG00Lj9H/jGkO1ZDUBGseO/2ihCMcY8EYKtHqO
        P5CumkZonUW2+fOXpswXn98pf42x2mXffxiIcICa7g5hKQ6XkWKFWHErwDk51QE7+JF705Wg1geCp
        4miqNpwdhMR1s4jjQJryKg/Br36ZPhbSFwCrN168mt6j75oZ1y22dtOwx4g7e0wW+SADD8jx2I3yn
        kI8DmPiw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLjD4-00HUP1-8A; Mon, 15 Mar 2021 09:08:25 +0000
Date:   Mon, 15 Mar 2021 09:08:22 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 01/11] file: Export __receive_fd() to modules
Message-ID: <20210315090822.GA4166677@infradead.org>
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-2-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315053721.189-2-xieyongji@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 01:37:11PM +0800, Xie Yongji wrote:
> Export __receive_fd() so that some modules can use
> it to pass file descriptor between processes.

I really don't think any non-core code should do that, especilly not
modular mere driver code.
