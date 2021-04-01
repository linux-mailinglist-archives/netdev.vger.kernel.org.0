Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5831F35126C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 11:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhDAJhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:37:04 -0400
Received: from verein.lst.de ([213.95.11.211]:39030 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhDAJgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 05:36:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9A5C868B05; Thu,  1 Apr 2021 11:36:42 +0200 (CEST)
Date:   Thu, 1 Apr 2021 11:36:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Will Deacon <will@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 11/18] iommu/fsl_pamu: remove the snoop_id field
Message-ID: <20210401093642.GE2934@lst.de>
References: <20210316153825.135976-1-hch@lst.de> <20210316153825.135976-12-hch@lst.de> <20210330125816.GK5908@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330125816.GK5908@willie-the-truck>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 01:58:17PM +0100, Will Deacon wrote:
> pamu_config_ppaace() takes quite a few useless parameters at this stage,
> but anyway:

I'll see it it makes sense to throw in another patch at the end to cut
it down a bit more.

> Acked-by: Will Deacon <will@kernel.org>
> 
> Do you know if this driver is actually useful? Once the complexity has been
> stripped back, the stubs and default values really stand out.

Yeah.  No idea what the usefulness of this driver is.  Bascially all it
seems to do is to setup a few registers to allow access to the whole
physical memory.  But maybe that is required on this hardware to allow
for any DMA access?
