Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0DE2DA604
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgLOCMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgLOCLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:11:53 -0500
Date:   Mon, 14 Dec 2020 18:11:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607998273;
        bh=OdTrpSpg+tQ1M+R+8rS3NlHlNsM4q2GGZm94ZY3rEjI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lV0aiDQ0vtOZR5PeQSmUde3W8ui5aXUbMdCtNYgT7vicmUr8G5cUp1Gt3HWfRRV79
         bBI+bPzpbEPbmYsTAMz+NfGzjE0QrlkcjL5eJgRRBveUUwpyb8eRClgkwiGQ4+jtKG
         lpN2lHqUcgwxvNnvE9lQqt7HODKoH9E7K/+XpV1l9mDf3vdCe8zzqVuXTlf0biUM9a
         ieEjh5w5j0hQrPeTE7BUKTqr6X+mrKShzuHK8yTH2PraiIXeIriTyMtjzAwzre8z9d
         wHQfFyUkB0OgooIj6WiiJaV0PeNg3YQ9/kh7Fji2ZQg1xjfm6UCl45gQCXnBxc3DWB
         uJQTJRz0ZdRBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] Netfilter/IPVS updates for net-next
Message-ID: <20201214181112.0e87337e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Dec 2020 00:05:03 +0100 Pablo Neira Ayuso wrote:
> 1) Missing dependencies in NFT_BRIDGE_REJECT, from Randy Dunlap.
> 
> 2) Use atomic_inc_return() instead of atomic_add_return() in IPVS,
>    from Yejune Deng.
> 
> 3) Simplify check for overquota in xt_nfacct, from Kaixu Xia.
> 
> 4) Move nfnl_acct_list away from struct net, from Miao Wang.
> 
> 5) Pass actual sk in reject actions, from Jan Engelhardt.
> 
> 6) Add timeout and protoinfo to ctnetlink destroy events,
>    from Florian Westphal.
> 
> 7) Four patches to generalize set infrastructure to support
>    for multiple expressions per set element.

Pulled, thanks!
