Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E8C6287A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbfGHSnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:43:55 -0400
Received: from verein.lst.de ([213.95.11.211]:35883 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbfGHSny (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 14:43:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C7F2227A81; Mon,  8 Jul 2019 20:43:51 +0200 (CEST)
Date:   Mon, 8 Jul 2019 20:43:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: use exact allocation for dma coherent memory
Message-ID: <20190708184351.GA12877@lst.de>
References: <20190614134726.3827-1-hch@lst.de> <20190701084833.GA22927@lst.de> <74eb9d99-6aa6-d1ad-e66d-6cc9c496b2f3@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74eb9d99-6aa6-d1ad-e66d-6cc9c496b2f3@broadcom.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 11:48:44AM +0200, Arend Van Spriel wrote:
> You made me look ;-) Actually not touching my drivers so I'm off the hook. 
> However, I was wondering if drivers could know so I decided to look into 
> the DMA-API.txt documentation which currently states:
>
> """
> The flag parameter (dma_alloc_coherent() only) allows the caller to
> specify the ``GFP_`` flags (see kmalloc()) for the allocation (the
> implementation may choose to ignore flags that affect the location of
> the returned memory, like GFP_DMA).
> """
>
> I do expect you are going to change that description as well now that you 
> are going to issue a warning on __GFP_COMP. Maybe include that in patch 
> 15/16 where you introduce that warning.

Yes, that description needs an updated, even without this series.
I'll make sure it is more clear.
