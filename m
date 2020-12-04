Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA32E2CF7A5
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgLDXnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgLDXnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:43:21 -0500
Date:   Fri, 4 Dec 2020 15:42:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607125375;
        bh=kHIX3SVj27Xyd32M1QCHO0JnCHUvF3gIbg+Db/cJgLA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GwPqyGNU+1SRxr2TJNXI8+TvzY9iDHRwVUryjpOmPSluCzTOMfcaYUWzzhW1oAPAx
         sinx3VpmeSWGLIckCRMvlkEGamsbgXwbw5uJSgH5UHE9hLg0zCiBgecR6cXn3Rhdt/
         vhxv/XyKcz6qC9KtGqlVVPNsSgD5LwS74MD5N91moaiNqvnmeoSouLOs6g+eP2pH9l
         UG+GUYUeaTpDLESB7fvm/7GOlXlyfcBR+AOoElMHKnC26qV99UxgLZlY7y6pLPqb12
         3FRZWjjwOiGyX9eqfWX8r7Gg4KaG/WDX3gUia74Q5U8aPpkVlQiR66CFjrLBtxrpxc
         H+iUv/wT0LnpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: bridge: vlan: fix error return code in
 __vlan_add()
Message-ID: <20201204154254.4c982c31@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <b90689c4-ffa9-d3ca-2cd4-f39e84446639@nvidia.com>
References: <1607071737-33875-1-git-send-email-zhangchangzhong@huawei.com>
        <b90689c4-ffa9-d3ca-2cd4-f39e84446639@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 12:47:07 +0200 Nikolay Aleksandrov wrote:
> On 04/12/2020 10:48, Zhang Changzhong wrote:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Fixes: f8ed289fab84 ("bridge: vlan: use br_vlan_(get|put)_master to deal with refcounts")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Applied, thanks!
