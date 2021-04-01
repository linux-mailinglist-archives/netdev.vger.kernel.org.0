Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD1351D5C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhDAS2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237010AbhDASSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A058961241;
        Thu,  1 Apr 2021 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617283623;
        bh=ZaHUJTjbwUns7JXT//LzMknWL6q18amExZVUaKXxS9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPQZOKwDhHIr5lXyEm/VCmT3W6pqy/ixtcnXbdgYlJ8ni/2f59nR0dso2anIOy/6D
         yubGrVetOumTcaiZbHX4Olh4hsU0tjohQ7KZR1tENMpRhYzw95x7arHY4ue6E+9WkX
         clEEoWENof9fvWzU58Ok8pHkvy7Zuy52OrSJHN1IH1arMaZPU9GF+HLzz4hGC+Inh/
         buLk1kGm/5OBfSi+8kmpw9NgIzV3NCqRMNsuMHTzntbgKIkhS5WbnN8KMDtIFbQ5gR
         Lneqrq3L7HQIkqlYg8jtbsLKJlGI3o+q19JOhoYOpbzuxTj5LL62tV804S9J+b0JeI
         jTztNA2TZ9zgQ==
Date:   Thu, 1 Apr 2021 14:26:58 +0100
From:   Will Deacon <will@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        freedreno@lists.freedesktop.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/18] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
Message-ID: <20210401132657.GA8997@willie-the-truck>
References: <20210316153825.135976-17-hch@lst.de>
 <20210330131149.GP5908@willie-the-truck>
 <a6952aa7-4d7e-54f0-339e-e15f88596dcc@arm.com>
 <20210330135801.GA6187@willie-the-truck>
 <578d6aa5-4239-f5d7-2e9f-686b18e52bba@arm.com>
 <20210331114947.GA7626@willie-the-truck>
 <ef895942-e115-7878-ab86-37e8a1614df5@arm.com>
 <20210331153256.GA7815@willie-the-truck>
 <81dd27fe-28ee-c800-fe5d-aaa64cb93513@arm.com>
 <20210401095945.GA6726@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401095945.GA6726@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 11:59:45AM +0200, Christoph Hellwig wrote:
> For now I'll just pass the iommu_domain to iommu_get_dma_strict,
> so that we can check for it.  We can do additional cleanups on top
> of that later.

Sounds good to me, cheers!

Will
