Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F4C2CF71B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgLDWxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgLDWxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:53:22 -0500
Date:   Fri, 4 Dec 2020 14:52:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607122362;
        bh=GYk8vs5g7NgPc+Wfs6mhgxzmmpidBd0Gv/brg8xrcCc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=l0WE1OMOWDGHcb6d1Ce8fVyYo3Opg9eZV9t/XPS3VW6vyc/U0g5YjVGA5CXgJoSq2
         LGUcfuFa1c1UX5JZ4Jd1rPUhwxtzUo1WWXP6xNWkTlWSKkEWXyv3gBXfqP0HPLSew2
         TfO3GSwd1m9TJJGhbvd5am9VLKXuo0yP2RV/n6rh63AlB2bAfi7Qj/TU6OrejDQGsn
         A2TbJ1B0BQbYIG7UmurA88US2mSsr+WEB80G5Ye3TqRkmIMvfSq6SyiiFgxQ7slcmf
         oCwtzxZFA1daiJl4aIrNocAWB+x+9AIPGgUIm4DxwxnDXc4Liw9yIvyl2pLR6kHwwo
         gBHYPamYN/IZA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201204145240.7c1a5a1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
References: <20201203042108.232706-1-saeedm@nvidia.com>
        <20201203042108.232706-9-saeedm@nvidia.com>
        <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
        <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 13:57:49 -0800 Saeed Mahameed wrote:
> > Why not use the PTP classification helpers we already have?  
> 
> do you mean ptp_parse_header() or the ebpf prog ?
> We use skb_flow_dissect() which should be simple enough.

Not sure which exact one TBH, I just know we have helpers for this, 
so if we don't use them it'd be good to at least justify why.

Maybe someone with more practical knowledge here can chime in with 
a recommendation for a helper to find PTP frames on TX?
