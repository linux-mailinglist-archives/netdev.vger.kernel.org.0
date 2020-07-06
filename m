Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F043215F92
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgGFTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:42:33 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:45095 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgGFTmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:42:33 -0400
Received: (qmail 3254 invoked by uid 89); 6 Jul 2020 19:42:30 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 6 Jul 2020 19:42:30 -0000
Date:   Mon, 6 Jul 2020 12:42:27 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-mapping: add a new dma_need_sync API
Message-ID: <20200706194227.vfhv5o4lporxjxmq@bsd-mbp.dhcp.thefacebook.com>
References: <20200629130359.2690853-1-hch@lst.de>
 <20200629130359.2690853-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629130359.2690853-2-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 03:03:56PM +0200, Christoph Hellwig wrote:
> Add a new API to check if calls to dma_sync_single_for_{device,cpu} are
> required for a given DMA streaming mapping.
> 
> +::
> +
> +	bool
> +	dma_need_sync(struct device *dev, dma_addr_t dma_addr);
> +
> +Returns %true if dma_sync_single_for_{device,cpu} calls are required to
> +transfer memory ownership.  Returns %false if those calls can be skipped.

Hi Christoph -

Thie call above is for a specific dma_addr.  For correctness, would I
need to check every addr, or can I assume that for a specific memory
type (pages returned from malloc), that the answer would be identical?
-- 
Jonathan
