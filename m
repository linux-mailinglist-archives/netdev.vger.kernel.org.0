Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E1A2DD637
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgLQR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:28:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbgLQR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 12:28:58 -0500
Date:   Thu, 17 Dec 2020 09:28:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608226097;
        bh=34jQtOv66evKWGrdySsG30kExIFzcqdvIzHJ6KuNB8E=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IpWIzSHs82wnM6DgutGRxRQ5Nu0TqQWiqcgQrEUBeJG/PRMdBqpLUxLHb6vCDe67i
         rXdJSkqZ2OCYZGlQ1DJKOL8kd2CHqal3PRLd15HWMrXjczw1c9icI9+aCkiz07e4Hq
         UWhImdoiNlLveSfRqCG1eKMtMhAb0x6cSpwi3TRaAg1VGebadknHZ1Aku09fGN7yab
         hFLITuGb+oovlHXQz0dvzmSVRHuk7guCIMJP0mRWDZeLDju+USTl71D7fiECgGpag1
         HVr4mAY0Lna1a6+PHPhRBYI5F5IsEAtn35+KMpWBOnmNBb6CZ4kC6KSNXPMhLIAQWd
         pv39jFyVcjSOg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Rix <trix@redhat.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: ambassador: remove h from printk format specifier
Message-ID: <20201217092816.7b739b8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6ada03ed-1ecb-493b-96f8-5f9548a46a5e@redhat.com>
References: <20201215142228.1847161-1-trix@redhat.com>
        <20201216164510.770454d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6ada03ed-1ecb-493b-96f8-5f9548a46a5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 05:17:24 -0800 Tom Rix wrote:
> On 12/16/20 4:45 PM, Jakub Kicinski wrote:
> > On Tue, 15 Dec 2020 06:22:28 -0800 trix@redhat.com wrote:  
> >> From: Tom Rix <trix@redhat.com>
> >>
> >> See Documentation/core-api/printk-formats.rst.
> >> h should no longer be used in the format specifier for printk.
> >>
> >> Signed-off-by: Tom Rix <trix@redhat.com>  
> > That's for new code I assume?
> >
> > What's the harm in leaving this ancient code be?  
> 
> This change is part of a tree wide cleanup.

What's the purpose of the "clean up"? Why is it making the code better?

This is a quote from your change:

-  PRINTK (KERN_NOTICE, "debug bitmap is %hx", debug &= DBG_MASK);
+  PRINTK (KERN_NOTICE, "debug bitmap is %x", debug &= DBG_MASK);

Are you sure that the use of %hx is the worst part of that line?

> drivers/atm status is listed as Maintained in MAINTAINERS so changes
> like this should be ok.
> 
> Should drivers/atm status be changed?

Up to Chas, but AFAIU we're probably only a few years away from ATM as 
a whole walking into the light. So IMHO "Obsolete" would be justified.
