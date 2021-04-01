Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84CB3512F2
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 12:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhDAKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 06:00:18 -0400
Received: from verein.lst.de ([213.95.11.211]:39115 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233990AbhDAJ7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 05:59:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C639468B05; Thu,  1 Apr 2021 11:59:45 +0200 (CEST)
Date:   Thu, 1 Apr 2021 11:59:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Will Deacon <will@kernel.org>, freedreno@lists.freedesktop.org,
        kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
Message-ID: <20210401095945.GA6726@lst.de>
References: <20210316153825.135976-1-hch@lst.de> <20210316153825.135976-17-hch@lst.de> <20210330131149.GP5908@willie-the-truck> <a6952aa7-4d7e-54f0-339e-e15f88596dcc@arm.com> <20210330135801.GA6187@willie-the-truck> <578d6aa5-4239-f5d7-2e9f-686b18e52bba@arm.com> <20210331114947.GA7626@willie-the-truck> <ef895942-e115-7878-ab86-37e8a1614df5@arm.com> <20210331153256.GA7815@willie-the-truck> <81dd27fe-28ee-c800-fe5d-aaa64cb93513@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81dd27fe-28ee-c800-fe5d-aaa64cb93513@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For now I'll just pass the iommu_domain to iommu_get_dma_strict,
so that we can check for it.  We can do additional cleanups on top
of that later.
