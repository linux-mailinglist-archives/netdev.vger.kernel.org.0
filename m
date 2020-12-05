Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA0F2CFFCA
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgLEXhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEXhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:37:13 -0500
Date:   Sat, 5 Dec 2020 15:36:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607211393;
        bh=RHoxL1EzxBg8SYMyAKZ/SmxCHS/3Mfu4ebgM6Hr4i4Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LLEvGG45JgBgr6B9eOa8F0Uxep4c3Ncs1uvvwJ46SsHsTKPBXChLMnAnoRGpD2F8V
         5rApaNcSkO0QybsOHwaPkzAFcPdj1EF6AMIkfF3vBDzcfyccTDqcoIGwFXsCarlOmj
         iKC1UrMfxs6z4v9Wc8cX2RmjyJx5Ut9//lZ7fZK3jwZtYo7p4VzN7QxvaC4yGXXNJZ
         nIkL2wdXvWH5qdmEyUOCiTmh6P7/wBuVihViEuh9Uh8kB7l5V2BSNJN4Iurc+xOEp+
         WXVEPow9caTkBOGErCaj7Tf/OB5EWZxjrrGi9UalDw0cFXyqFfUJSEdxPLkudannDx
         vdH94DI5qSnvg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [pull request][for-next] mlx5-next auxbus support
Message-ID: <20201205153632.0f588404@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205002642.GA1495499@nvidia.com>
References: <20201204182952.72263-1-saeedm@nvidia.com>
        <20201205002642.GA1495499@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 20:26:42 -0400 Jason Gunthorpe wrote:
> Jakub a few notes on shared branch process here.. 
> 
> In general Linus's advice has been to avoid unnecessary merges so
> Saeed/Leon have tended to send PRs to one tree or the other based on
> need and that PR might have a "catch up" from the other tree. I guess
> this one is special because it makes lots of changes in both trees.
> 
> Whoever pulls first means the other cannot refuse the PR, so I usually
> prefer to let netdev go first. I have more BW to manage trouble on the
> RDMA side..
> 
> I saw your other request related to the CI failures due to the wrong
> branch basis in the build bot. This means you will need to pull every
> update to the mlx5 shared branch, even if it is not immediately
> relevant to netdev, or have Saeed include the 'base commit' trailer
> and teach the build bots to respect it..
> 
> Also, I arrange the RDMA merge window PR to be after netdev (usually
> on Thursday) so that Linus sees minor RDMA stuff in the netdev
> diffstat, and almost no netdev stuff in the RDMA PR.

Makes sense, thanks for the notes.
