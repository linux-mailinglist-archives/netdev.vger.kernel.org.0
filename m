Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76385EABE3
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfJaIyd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 31 Oct 2019 04:54:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:47156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726995AbfJaIyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 04:54:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43E79AD5F;
        Thu, 31 Oct 2019 08:54:31 +0000 (UTC)
Date:   Thu, 31 Oct 2019 09:54:30 +0100
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sgi: ioc3-eth: don't abuse dma_direct_* calls
Message-Id: <20191031095430.148daca03517c00f3e2b32ff@suse.de>
In-Reply-To: <20191030223818.GA23807@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
        <20191030211233.30157-2-hch@lst.de>
        <20191030230549.ef9b99b5d36b0a818d904eee@suse.de>
        <20191030223818.GA23807@lst.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 23:38:18 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Oct 30, 2019 at 11:05:49PM +0100, Thomas Bogendoerfer wrote:
> > On Wed, 30 Oct 2019 14:12:30 -0700
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > dma_direct_ is a low-level API that must never be used by drivers
> > > directly.  Switch to use the proper DMA API instead.
> > 
> > is the 4kb/16kb alignment still guaranteed ? If not how is the way
> > to get such an alignment ?
> 
> The DMA API gives you page aligned memory. dma_direct doesn't give you
> any gurantees as it is an internal API explicitly documented as not
> for driver usage that can change at any time.

I didn't want to argue about that. What I'm interested in is a way how 
to allocate dma memory, which is 16kB aligned, via the DMA API ?

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
