Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8D831656D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBJLnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:43:52 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3781 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhBJLlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:41:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023c6340000>; Wed, 10 Feb 2021 03:40:36 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 11:40:36 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 11:40:33 +0000
References: <YCO+NCjissLTG1H6@mwanda>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix a NULL vs IS_ERR() check
In-Reply-To: <YCO+NCjissLTG1H6@mwanda>
Date:   Wed, 10 Feb 2021 13:40:31 +0200
Message-ID: <ygnhczx8gngw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612957236; bh=FBeNc2L+fAZkiQczix+2+HCC51/e8lgy3251THYIsXc=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=Z7Wnd+A7WFHjkLZgXlnkBnb6LK+IH9GHzAcBrUgSWl0uIBk5htRDEDc7DoM9sbmdH
         eP2PQ/NzSNVPnpK2LzDZWNsGCQvGs6W1ZV0xX2MDoT1b/e8t5yITFSVkr7REWwcRc6
         M2EZSh4iou4x9DF8EP/NYXtfacoaUB/2VZ0Fy84XCQmIL4Pe8onWgu7F6l6VVzRY4e
         W0pD6GSqAZE7rq1xeVQF8HObd5Jlcich8GuoBKQGvkFd/7TjqzvQuLsGgFPE8PNA+w
         x/K/8MRcbOKzYoTIkjqigPpkYCrXtuc+TNod0bz3iyKJxeHhMrB0BU6VYqTIucZwQY
         4kgkmJnTrAmyw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 10 Feb 2021 at 13:06, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The mlx5_chains_get_table() function doesn't return NULL, it returns
> error pointers so we need to fix this condition.
>
> Fixes: 34ca65352ddf ("net/mlx5: E-Switch, Indirect table infrastructure")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, Dan!

Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
