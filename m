Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFCAEB3C1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 16:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfJaPSU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 31 Oct 2019 11:18:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:52388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726566AbfJaPST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 11:18:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19420B740;
        Thu, 31 Oct 2019 15:18:18 +0000 (UTC)
Date:   Thu, 31 Oct 2019 16:18:17 +0100
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sgi: ioc3-eth: don't abuse dma_direct_* calls
Message-Id: <20191031161817.b24181a2e7af3df994eec6c5@suse.de>
In-Reply-To: <20191031131501.GA4361@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
        <20191030211233.30157-2-hch@lst.de>
        <20191030230549.ef9b99b5d36b0a818d904eee@suse.de>
        <20191030223818.GA23807@lst.de>
        <20191031095430.148daca03517c00f3e2b32ff@suse.de>
        <20191031131501.GA4361@lst.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 14:15:01 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Oct 31, 2019 at 09:54:30AM +0100, Thomas Bogendoerfer wrote:
> > I didn't want to argue about that. What I'm interested in is a way how 
> > to allocate dma memory, which is 16kB aligned, via the DMA API ?
> 
> You can't.

So then __get_free_pages() and dma_map_page() is the only way ?

BTW I've successful tested your patches on an 8 CPU Origin 2k.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
