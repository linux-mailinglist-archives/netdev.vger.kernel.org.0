Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938605B71E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 10:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfGAIsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 04:48:37 -0400
Received: from verein.lst.de ([213.95.11.211]:59641 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfGAIsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 04:48:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC3E268B20; Mon,  1 Jul 2019 10:48:33 +0200 (CEST)
Date:   Mon, 1 Jul 2019 10:48:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: use exact allocation for dma coherent memory
Message-ID: <20190701084833.GA22927@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 03:47:10PM +0200, Christoph Hellwig wrote:
> Switching to a slightly cleaned up alloc_pages_exact is pretty easy,
> but it turns out that because we didn't filter valid gfp_t flags
> on the DMA allocator, a bunch of drivers were passing __GFP_COMP
> to it, which is rather bogus in too many ways to explain.  Arm has
> been filtering it for a while, but this series instead tries to fix
> the drivers and warn when __GFP_COMP is passed, which makes it much
> larger than just adding the functionality.

Dear driver maintainers,

can you look over the patches touching your drivers, please?  I'd
like to get as much as possible of the driver patches into this
merge window, so that it can you through your maintainer trees.
