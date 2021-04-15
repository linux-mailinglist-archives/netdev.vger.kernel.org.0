Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F60435FFBB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 03:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhDOByT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 21:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhDOByS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 21:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B4C6611B0;
        Thu, 15 Apr 2021 01:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618451636;
        bh=prXZY82rRsiTuFfbvzdEzwrpTxq/lv3COj6QcIvxVR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iDsUnFuA5QfIUOE9Bt3PLiMmNg4L4VJ9jbWkNip8MP0EVQUCxi8Z/bJvxXzCwOjo0
         4GvVby2AnTyR4wPvs4JkNCi3CJt8Igv+KCalxDFwdsFavQlD7oG2zlscV/I3kGVnZa
         RErzw2OnjCs1Bb3baV6VPzU07Y1L4rImbMufOqBQDdgqvGqhVHX1e308Rw0SEgIwmA
         UoYLYk2NLPatlvJKkx9huD0ga2as/FAcrCYoPq8YWbrsyjdqabD1ePy8bKtYmF0pvU
         DTGJSuAjwOpAhCtc7CaIKHa+bWKn1kVUmTRfomSV4VvPPkgMcWYzTSpHsGGpx5kLF6
         J8SHdVGEPPUHQ==
Date:   Wed, 14 Apr 2021 18:53:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next 1/2] net: hns3: PF add support for pushing link
 status to VFs
Message-ID: <20210414185355.4080a93f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ab9a508c-29f0-1ff5-bb95-fbae4a859d6b@huawei.com>
References: <1618294621-41356-1-git-send-email-tanhuazhong@huawei.com>
        <1618294621-41356-2-git-send-email-tanhuazhong@huawei.com>
        <20210413101826.103b25fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2dac0fe0-cdcb-a3c5-0c72-7873857824fd@huawei.com>
        <20210414094230.64caf43e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ab9a508c-29f0-1ff5-bb95-fbae4a859d6b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 09:11:03 +0800 Huazhong Tan wrote:
> >> They are in different contexts. here will be called to
> >> update the link status of all VFs when the underlying
> >> link status is changed, while the below one is called
> >> when the admin set up the specific VF link status.  
> > I see.  
> 
> So this error will be printed twice only if these two cases
> happen at the same, do you mean to add some keyword to
> distinguish them?

No, it's fine but please repost - looks like the patches were 
removed from patchwork already.
