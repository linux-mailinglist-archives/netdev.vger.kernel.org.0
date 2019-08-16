Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88F90603
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfHPQnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:43:05 -0400
Received: from verein.lst.de ([213.95.11.211]:56730 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfHPQnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 12:43:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 951D168B05; Fri, 16 Aug 2019 18:43:01 +0200 (CEST)
Date:   Fri, 16 Aug 2019 18:43:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicoleotsuka@gmail.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        tobias.klausmann@freenet.de
Subject: Re: regression in ath10k dma allocation
Message-ID: <20190816164301.GA3629@lst.de>
References: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

do you have CONFIG_DMA_CMA set in your config?  If not please make sure
you have this commit in your testing tree, and if the problem still
persists it would be a little odd and we'd have to dig deeper:

commit dd3dcede9fa0a0b661ac1f24843f4a1b1317fdb6
Author: Nicolin Chen <nicoleotsuka@gmail.com>
Date:   Wed May 29 17:54:25 2019 -0700

    dma-contiguous: fix !CONFIG_DMA_CMA version of dma_{alloc, free}_contiguous()

