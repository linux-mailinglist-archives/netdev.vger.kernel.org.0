Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6491F363295
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 00:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhDQWqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 18:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbhDQWqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 18:46:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD02C06174A;
        Sat, 17 Apr 2021 15:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tPQBiu2Bdtxs3AC+E5Cm2VSUt8tWo9GnLe6NW3THH9A=; b=XkP7ELYUdkWzIzouAO8xPq8S7N
        GjhLlDfD3y6VNei69ths2oEltTt7VNjkaFD3kWa5YfSrMcxcQ1iVWUb/gASCBUMnk26hTvxsGcZHP
        LmMVlNo9qjiA2rXreK8yWQYyX7o6/OtiLfYOaaN9A6kBfQL7H7z+dojys6K1K5C4Hlo6Q1BwKfx6v
        3VOY2eaj9oDYuG2iFBRZJwiloByx98Wd7tPgW2ms6UJEbSMnemsL/vRvgFUw9tA9idCrdgpWi2l75
        pWbZSIdmfWoFb2mq+sdPpyKhbcnM/fMhIc2cA/kjhWA/hgymZC/OH2xGJGRDdWwwZOxlXZFOO//LW
        H9eSAzQw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXtgp-00BmXi-PV; Sat, 17 Apr 2021 22:45:26 +0000
Date:   Sat, 17 Apr 2021 23:45:23 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "arnd@kernel.org" <arnd@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210417224523.GU2531743@casper.infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
 <386d009232dc42bdaf83d4cc36b13864@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386d009232dc42bdaf83d4cc36b13864@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 09:18:57PM +0000, David Laight wrote:
> Ugly as well.

Thank you for expressing your opinion.  Again.
