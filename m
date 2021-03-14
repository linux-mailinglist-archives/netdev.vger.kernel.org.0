Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E2333A5DA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhCNP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:58:29 -0400
Received: from verein.lst.de ([213.95.11.211]:50887 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhCNP6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 11:58:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7C42968B05; Sun, 14 Mar 2021 16:58:13 +0100 (CET)
Date:   Sun, 14 Mar 2021 16:58:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        freedreno@lists.freedesktop.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/17] iommu: remove DOMAIN_ATTR_NESTING
Message-ID: <20210314155813.GA788@lst.de>
References: <20210301084257.945454-1-hch@lst.de> <20210301084257.945454-16-hch@lst.de> <3e8f1078-9222-0017-3fa8-4d884dbc848e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8f1078-9222-0017-3fa8-4d884dbc848e@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 11:44:52AM +0100, Auger Eric wrote:
> As mentionned by Robin, there are series planning to use
> DOMAIN_ATTR_NESTING to get info about the nested caps of the iommu (ARM
> and Intel):
> 
> [Patch v8 00/10] vfio: expose virtual Shared Virtual Addressing to VMs
> patches 1, 2, 3
> 
> Is the plan to introduce a new domain_get_nesting_info ops then?

The plan as usual would be to add it the series adding that support.
Not sure what the merge plans are - if the series is ready to be
merged I could rebase on top of it, otherwise that series will need
to add the method.
