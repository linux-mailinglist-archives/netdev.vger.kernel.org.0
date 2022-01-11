Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C9348BB3D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 00:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbiAKXIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 18:08:43 -0500
Received: from ale.deltatee.com ([204.191.154.188]:50574 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244879AbiAKXIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 18:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=TIGVeVRFFto9U8rrsZTboK3dXuBBSA/4ShVJmxcPczw=; b=afngLBoxuqvBzyZsmssqQ4P38X
        mCM56+S28Ds9cs1MIIL9eX/nS4ypMjuVQq0SIolY3enG8whn4KmK8d1o5Z9ZiLel9JXrmvNVZ9FGE
        Oxc0o8x++jBeY21fP2IHYVaSAr7LU+LYs6tiOM/+YBugMvcsjBcc5/PgRhP3zMMgpOtrojZpjpdUo
        wpQOdhDtfYk5lOHhak8KS6SH5MGM/tbejrIZpgLr62nIHCe3KOvrhodPHLT50WnOGE5ZTURomJ8w4
        Mz7VL2jqUKBSBKMyGmRBcoBnAB2dA4vNq2yjkPVIipPGH7BvqQgPRHLLReU9mBeOxiYq5I3UlOCQs
        ClMyfHLg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1n7QFo-009oCP-Cn; Tue, 11 Jan 2022 16:08:37 -0700
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com> <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com> <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com> <Yd311C45gpQ3LqaW@casper.infradead.org>
 <20220111225306.GR2328285@nvidia.com>
 <9fe2ada2-f406-778a-a5cd-264842906a31@deltatee.com>
 <20220111230224.GT2328285@nvidia.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5c3dd9bd-abda-6c9b-8257-182f84f8f842@deltatee.com>
Date:   Tue, 11 Jan 2022 16:08:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220111230224.GT2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: nvdimm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-block@vger.kernel.org, ming.lei@redhat.com, jhubbard@nvidia.com, joao.m.martins@oracle.com, hch@lst.de, linux-kernel@vger.kernel.org, willy@infradead.org, jgg@nvidia.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: Phyr Starter
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-01-11 4:02 p.m., Jason Gunthorpe wrote:
> On Tue, Jan 11, 2022 at 03:57:07PM -0700, Logan Gunthorpe wrote:
>>
>>
>> On 2022-01-11 3:53 p.m., Jason Gunthorpe wrote:
>>> I just want to share the whole API that will have to exist to
>>> reasonably support this flexible array of intervals data structure..
>>
>> Is that really worth it? I feel like type safety justifies replicating a
>> bit of iteration and allocation infrastructure. Then there's no silly
>> mistakes of thinking one array is one thing when it is not.
> 
> If it is a 'a bit' then sure, but I suspect doing a good job here will
> be a lot of code here.
> 
> Look at how big scatterlist is, for instance.

Yeah, but scatterlist has a ton of cruft; numerous ways to allocate,
multiple iterators, developers using it in different ways, etc, etc.
It's a big mess. bvec.h is much smaller (though includes stuff that
wouldn't necessarily be appropriate here).

Also some things apply to one but not the other. eg: a memcpy to/from
function might make sense for a phy_range but makes no sense for a
dma_range.

> Maybe we could have a generic 64 bit interval arry and then two type
> wrappers that do dma and physaddr casting? IDK.
> 
> Not sure type safety of DMA vs CPU address is critical?

I would argue it is. A DMA address is not a CPU address and should not
be treated the same.

Logan
