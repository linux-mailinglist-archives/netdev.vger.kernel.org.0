Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED44591E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfFNJqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:46:43 -0400
Received: from verein.lst.de ([213.95.11.211]:45577 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbfFNJqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 05:46:42 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id D62CF227A82; Fri, 14 Jun 2019 11:46:13 +0200 (CEST)
Date:   Fri, 14 Jun 2019 11:46:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:DMA MAPPING HELPERS" <iommu@lists.linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] swiotlb: Group identical cleanup in
 swiotlb_cleanup()
Message-ID: <20190614094613.GG17292@lst.de>
References: <20190611175825.572-1-f.fainelli@gmail.com> <20190611175825.572-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611175825.572-2-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 10:58:24AM -0700, Florian Fainelli wrote:
> Avoid repeating the zeroing of global swiotlb variables in two locations
> and introduce swiotlb_cleanup() to do that.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
