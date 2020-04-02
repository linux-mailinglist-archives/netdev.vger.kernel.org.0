Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B654B19BC18
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 08:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgDBG4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 02:56:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgDBG43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 02:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MifLacyZ11MXEQpqNAKw1gbH0S9sMv1empiHGWRbuAk=; b=p8hZI5g2yxLDWSFmOhjHQCg3Jo
        h0+RaCI6TyhawQRO5zJaBaiX9wQgVhKe6YkQygiw7Xl+KK0bJxa4vvWf4sQ9Fz/k88IRwtSSyMbbO
        BC86cofSIwi4QDSEZ8jzM8bxqt61KY7/FIhkyYcKAFtpzz5JPvBMyqvV7ChgaOJ/LzTA88ob9zOs2
        lzwDd0+6jcd6Al+wZb4RLti0cQ7/re3n3QgWmi/prAuqc2Dg6bfTMslUobd/kFz6JXnQUcFnSSDDa
        rJZpsrLiTqnklo671iZOjx1kBFtt2VGg1c76YpTUge7FM8hUlxXb2H8pqMKjPSTKpmDhgGQDIX/u7
        wGwzayoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJtm7-0000Ll-7I; Thu, 02 Apr 2020 06:56:27 +0000
Date:   Wed, 1 Apr 2020 23:56:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Serebrin <serebrin@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] iommu/vt-d: add NUMA awareness to intel_alloc_coherent()
Message-ID: <20200402065627.GA23242@infradead.org>
References: <1517438756.3715.108.camel@gmail.com>
 <20180202185301.GA8232@infradead.org>
 <CANn89i+FBn3fttEyU_znAd-+8BgM7VZogFeeZPA7_zubChFpBA@mail.gmail.com>
 <34c70805-44f5-6697-3ebf-2f4d56779454@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34c70805-44f5-6697-3ebf-2f4d56779454@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 03:53:38PM -0700, Eric Dumazet wrote:
> 
> 
> On 2/2/18 10:59 AM, Eric Dumazet wrote:
> > On Fri, Feb 2, 2018 at 10:53 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >> I've got patches pending to replace all that code with
> >> dma_direct_alloc, which will do the right thing.  They were
> >> submitted for 4.16, and I will resend them after -rc1.
> > 
> > I see, thanks Christoph !
> > 
> 
> Hi Christoph 
> 
> It seems 4.16 has shipped ( :) ) , and intel_alloc_coherent() still has no NUMA awareness.

Actually, that code went in and then got reverted again..

> Should I respin https://lore.kernel.org/patchwork/patch/884326/

Maybe.  We are still hoping to convert intel-iommu to the dma-iommu
framework, but I'm not sure how long that is going to take, so maybe
just respin it for now.
