Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75D3EBDEA
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhHMVen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234547AbhHMVen (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 17:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6C260F51;
        Fri, 13 Aug 2021 21:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628890455;
        bh=BZp00286AP4hzYNDCE6b3iG0Q0mGvk4gn11GGgjwHZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SvdEsnIVfqkzBpCPPFWTugA/Knfr38syWone7Jzrr4KLVCFevYT/SvxwyMC+DQJqa
         c1GdVNgIk3HdgMDQajtY8id1ucv8TQZqz2GlpbCPn/nt3eHWYPStgSHmCetExX6vNB
         5PVLaW3vuTtW3zWmRrSekasgvTDOiC3d623jCsgWsjPxrNSi6yadSYKrU5hFjfEb0f
         v4Le9+aVoawgx62kDhLwS/isC7su08nUYB5ngFS5kCfO0Ew71INaYedRZyQ5s6dkgx
         vSDKLReTYTaKWxfNEGO4VLTSymhFZGX5zUnwmwS1GjNHIadkit+j974Z6A/oYM47Qu
         Z8F5x52NoRdYA==
Date:   Fri, 13 Aug 2021 14:34:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v1 net 1/1] ptp_pch: Restore dependency on PCI
Message-ID: <20210813143414.68eacc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813173328.16512-1-andriy.shevchenko@linux.intel.com>
References: <20210813173328.16512-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 20:33:27 +0300 Andy Shevchenko wrote:
> During the swap dependency on PCH_GBE to selection PTP_1588_CLOCK_PCH
> incidentally dropped the implicit dependency on the PCI. Restore it.
> 
> Fixes: 18d359ceb044 ("pch_gbe, ptp_pch: Fix the dependency direction between these drivers")

It was breaking build for 9 years and nobody hit it? 
What's the build failure?
