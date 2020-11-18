Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D712B8428
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgKRStA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgKRStA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:49:00 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F897246B9;
        Wed, 18 Nov 2020 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605725339;
        bh=L/3ZL6DbNpQF471NNWS0yqhwfXXZnzfqsalBwXDaaNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TrLhsOI/tXpfQfbZ09WfCbElHt7PcnfdKVPNY13ZcU1QUoQ2XKD7p6D/G9xI2+mGZ
         wPx+/Hjuq5/cSuhx9ikihZhufpMuH9Nnk2Pr7MlOYphB1pOwWaH5M+0jMnSLUfJDD9
         1y+iz1S6DXNwKhL9xJI7D/ARrcvcqC6/qJ+Ipyzw=
Date:   Wed, 18 Nov 2020 10:48:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] nfp: tls: Fix unreachable code issue
Message-ID: <20201118104858.283cfd87@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117200646.GA10136@netronome.com>
References: <20201117171347.GA27231@embeddedor>
        <20201117200646.GA10136@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 21:06:47 +0100 Simon Horman wrote:
> On Tue, Nov 17, 2020 at 11:13:47AM -0600, Gustavo A. R. Silva wrote:
> > Fix the following unreachable code issue:
> > 
> >    drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_add':
> >    include/linux/compiler_attributes.h:208:41: warning: statement will never be executed [-Wswitch-unreachable]
> >      208 | # define fallthrough                    __attribute__((__fallthrough__))
> >          |                                         ^~~~~~~~~~~~~
> >    drivers/net/ethernet/netronome/nfp/crypto/tls.c:299:3: note: in expansion of macro 'fallthrough'
> >      299 |   fallthrough;
> >          |   ^~~~~~~~~~~
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>  
> 
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied, thanks!
