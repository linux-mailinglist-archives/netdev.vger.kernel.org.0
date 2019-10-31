Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5290DEB0F5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfJaNPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:15:06 -0400
Received: from verein.lst.de ([213.95.11.211]:50952 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfJaNPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 09:15:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F162D68BE1; Thu, 31 Oct 2019 14:15:01 +0100 (CET)
Date:   Thu, 31 Oct 2019 14:15:01 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sgi: ioc3-eth: don't abuse dma_direct_* calls
Message-ID: <20191031131501.GA4361@lst.de>
References: <20191030211233.30157-1-hch@lst.de> <20191030211233.30157-2-hch@lst.de> <20191030230549.ef9b99b5d36b0a818d904eee@suse.de> <20191030223818.GA23807@lst.de> <20191031095430.148daca03517c00f3e2b32ff@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031095430.148daca03517c00f3e2b32ff@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 09:54:30AM +0100, Thomas Bogendoerfer wrote:
> I didn't want to argue about that. What I'm interested in is a way how 
> to allocate dma memory, which is 16kB aligned, via the DMA API ?

You can't.
