Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A678F296528
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370033AbgJVTQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508751AbgJVTQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 15:16:56 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01A224656;
        Thu, 22 Oct 2020 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603394216;
        bh=b+HpGV/SQiY/H5FbibSh4WTK4U78aHJqHe+3GHGYePQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p0gQU1GmG5L7gwBk7Wj659fEPpi94yqsY17dOdbSsdcGnLNKypv9o0twA0uIupPmd
         MDQf7aSjlEtI/Kr0JPUJzz4Qtjg+RctZ2PDqwci8MsoTL0kk0P1YDA8/C+gnAeODVc
         hTrDnM98YL45OPdcVG5mBtaAQns3kpWA+/8QRg3g=
Date:   Thu, 22 Oct 2020 12:16:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Netfilter fixes for net
Message-ID: <20201022121653.1238a843@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 19:29:18 +0200 Pablo Neira Ayuso wrote:
> Hi Jakub,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Update debugging in IPVS tcp protocol handler to make it easier
>    to understand, from longguang.yue
> 
> 2) Update TCP tracker to deal with keepalive packet after
>    re-registration, from Franceso Ruggeri.
> 
> 3) Missing IP6SKB_FRAGMENTED from netfilter fragment reassembly,
>    from Georg Kohmann.
> 
> 4) Fix bogus packet drop in ebtables nat extensions, from
>    Thimothee Cocault.
> 
> 5) Fix typo in flowtable documentation.
> 
> 6) Reset skb timestamp in nft_fwd_netdev.

Pulled, please remember about that [PATCH net] tag if you can, thanks!
