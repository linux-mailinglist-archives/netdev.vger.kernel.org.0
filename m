Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5442726A8
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgIUOKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgIUOKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:10:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9059BC061755;
        Mon, 21 Sep 2020 07:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZcJZ+svvDXLNPRvQzuxxjPV241nNNPK766nLxPGo7Bk=; b=LRh7gmlHS9H3bhFCpbwKy3Tn/0
        d7ngGDurt2ZVDeYTKDGS6jXa/TLmSrh32BMO/GHFjTM93hh/JAZQE/9IzWdsShFA2pOp7A21eBeHS
        5byLl1bjHXJY1+UCa7ElnfOrwivvqtyeKxmDztOYQSugq4F4z6onwg9YQjpCmfYeTSWOwB1uE4g+c
        9pDLAwkKf3LagM9u9bIb1CFOOu1ZGaRkjPaWUyBZCbYjy166onvyigmFM5iMmrie8Vzi5hUEwaBei
        sAKjkxFURwmG5uYQH6kqege169B5b7+QkNs/mYTzikL7lhxN5TMtuLlLSO5JFRH2uQj+JLBNwsmmU
        IoMdwdyw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKMW2-0006Rh-7e; Mon, 21 Sep 2020 14:10:02 +0000
Date:   Mon, 21 Sep 2020 15:10:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/9 next] fs: Move rw_copy_check_uvector() into
 lib/iov_iter.c and make static.
Message-ID: <20200921141002.GB24515@infradead.org>
References: <9d35fdcc154749d8905d66b9419c4817@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d35fdcc154749d8905d66b9419c4817@AcuMS.aculab.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 02:55:13PM +0000, David Laight wrote:
> 
> This lets the compiler inline it into import_iovec() generating
> much better code.

The changelog is a bit short, but otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I picked this up as a prep patch for the compat iovec handling.
