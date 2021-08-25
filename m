Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1C83F725C
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhHYJ4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234372AbhHYJ4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 05:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2CCD61153;
        Wed, 25 Aug 2021 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885349;
        bh=CJy1cRP3PcwXA1bUMtODTgzMZI8sWPjuw/TQT8Z9LZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kvyuuMxo422V81XfuNsgTXQdG3hm39SW5PhGUrw45JcXygc98vMLozMP82RcUmsQo
         VUzQiTEqRSpp8ROEbWpr2eLfukPTzYOsYlXAzH+2I3FeXxA4V1LP0/apWcvIPS79n7
         qrsG+1wPt2uBqnxJAd0IQ+pHs6jFkO9rUBGLOTvT6JZ81gnP56eu1OgkMI45oeTdBP
         uily1IR3utV4v0wrJpFKIkZtuzLeOrL/4kImeUKsL/yhS3J/BJM/gnvyE6jHdm/d14
         QVgrrOEYeV2MKnO1zmRDCO257vhiuMU9/Aqk45CzK/2+eUiQA2NseRuGvk6JHjudXF
         tl9asW0TnLq5g==
Date:   Wed, 25 Aug 2021 10:55:41 +0100
From:   Will Deacon <will@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>, jasowang@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 01/12] iova: Export alloc_iova_fast() and
 free_iova_fast()
Message-ID: <20210825095540.GA24546@willie-the-truck>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-2-xieyongji@bytedance.com>
 <20210824140758-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824140758-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 02:08:33PM -0400, Michael S. Tsirkin wrote:
> On Wed, Aug 18, 2021 at 08:06:31PM +0800, Xie Yongji wrote:
> > Export alloc_iova_fast() and free_iova_fast() so that
> > some modules can make use of the per-CPU cache to get
> > rid of rbtree spinlock in alloc_iova() and free_iova()
> > during IOVA allocation.
> > 
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> 
> 
> This needs ack from iommu maintainers. Guys?

Looks fine to me:

Acked-by: Will Deacon <will@kernel.org>

Will
