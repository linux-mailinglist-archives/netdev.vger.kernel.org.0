Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF7634E824
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhC3M7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhC3M65 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:58:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB5160200;
        Tue, 30 Mar 2021 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617109137;
        bh=XD13IlVE5uT31vxwz23Jmf3sYXSwPZBETQyhziZVg1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5qO9v1/5yE7DNsd35X75e1Llwq33tg4kigypRa3ZhYgV00jzvR9GlwBCVFsbNk0v
         oMnKd3KVAbRmQ1sjqyQ92YOZncHMmpKCLiTh4dPeiztw7uFlbD1bJ05GHujP9ADwJh
         6ZdZRkEYDQ60hyfQYFS0uVB/yMEOtRvgq9X3SLO1pV+/bJJYUFfoLZAvysDjxUL3D8
         S9JfwoBK5zGUZ0DMA6urCc6Z+xnlM/C3/f7EhVPixFnTWgP93un8Lru5r6WBRTfU9d
         K13Y0M6X1NZ37mnWnoGFNOuQLte4Qkf53UBYgWPq/EeMtt2wYORmDVKx07mNQTLBYB
         NswLspENY0LWg==
Date:   Tue, 30 Mar 2021 13:58:51 +0100
From:   Will Deacon <will@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/18] iommu: remove DOMAIN_ATTR_PAGING
Message-ID: <20210330125851.GL5908@willie-the-truck>
References: <20210316153825.135976-1-hch@lst.de>
 <20210316153825.135976-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153825.135976-13-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:38:18PM +0100, Christoph Hellwig wrote:
> DOMAIN_ATTR_PAGING is never used.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Li Yang <leoyang.li@nxp.com>
> ---
>  drivers/iommu/iommu.c | 5 -----
>  include/linux/iommu.h | 1 -
>  2 files changed, 6 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
