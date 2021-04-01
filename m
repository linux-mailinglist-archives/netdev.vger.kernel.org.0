Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB19351248
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 11:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhDAJac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:30:32 -0400
Received: from verein.lst.de ([213.95.11.211]:38951 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhDAJaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 05:30:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3942A68B05; Thu,  1 Apr 2021 11:29:58 +0200 (CEST)
Date:   Thu, 1 Apr 2021 11:29:57 +0200
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
Subject: Re: [PATCH 05/18] iommu/fsl_pamu: remove support for multiple
 windows
Message-ID: <20210401092957.GB2934@lst.de>
References: <20210316153825.135976-1-hch@lst.de> <20210316153825.135976-6-hch@lst.de> <20210330122234.GE5908@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330122234.GE5908@willie-the-truck>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 01:22:34PM +0100, Will Deacon wrote:
> >  	 * win_arr contains information of the configured
> >  	 * windows for a domain. This is allocated only
> >  	 * when the number of windows for the domain are
> >  	 * set.
> >  	 */
> 
> The last part of this comment is now stale ^^

I've updated it, although the comment will go away entirely a little
bit later anyway.
