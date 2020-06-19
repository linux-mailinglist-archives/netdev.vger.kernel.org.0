Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B72002F4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgFSHqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgFSHqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 03:46:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDB4C06174E;
        Fri, 19 Jun 2020 00:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LExsgrzaNyl8ZFPNIxBm2qDBZpOXhx0RBNl8C2nzaSw=; b=s9GduRbeIzfQ6rou+EY1Ez+mFQ
        WKczu0uQfkh+8bNlk6SoQvnajAr3wdDyxlhWPRfiXZSqcjkhBdS6f2mY9UUTBFqyJ2U/liICIvOMC
        k1ROtJP+IxZe8pWr95o2iWfZmCMEZYyzoJp76ILMc/f7jzh5gYxlWmq5CAiP8MQaPnlbhvxt3+lRF
        ++RgOqoAE6HbplJO88O/VMURinrCndzkhPuR2J5KeOQyuDesAPiYYDaN3nGtqNCVDp5NB5Qf0yjvi
        z7jlLtGYc5Is0XaPCy8R8suAgPHUO2pNuDfkZO/Mc8rLDn+dYvlY+x5y2y/gyMv2/VnGMMe76cUXl
        BaMxIpZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmBjL-0001pk-JL; Fri, 19 Jun 2020 07:46:31 +0000
Date:   Fri, 19 Jun 2020 00:46:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
Message-ID: <20200619074631.GA1427@infradead.org>
References: <20200618210645.GB2212102@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618210645.GB2212102@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 12:06:45AM +0300, Alexey Dobriyan wrote:
> Rename
> 	struct notifier_block *this
> to
> 	struct notifier_block *nb
> 
> "nb" is arguably a better name for notifier block.

But not enough better to cause tons of pointless churn.  Feel free
to use better naming in new code you write or do significant changes
to, but stop these pointless renames.
