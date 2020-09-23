Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28DE275E73
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgIWRSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWRST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 13:18:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FED521BE5;
        Wed, 23 Sep 2020 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600881499;
        bh=B+fwvE75GHphwCT0VzApNWpjzoVh3fFgZKaJB7Rm9+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0G20RkdL8RsNJOsbb2bDffL4XWiFXscChF0ROxqNd/jlqdpL2Pce+raWYhtrDVnr5
         0uZNrUyGU738x72AvlvZ7HCiRFQRbX3AJvHWC5p+EgEpjui/1GPRyqO43wdTaufm4F
         nWchonUB7Xn2vStsma1W7eI3LMaJ6E7lHHz4BliI=
Date:   Wed, 23 Sep 2020 10:18:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 05/15] net/mlx5: Refactor tc flow attributes
 structure
Message-ID: <20200923101817.0b0a79c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200923062438.15997-6-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
        <20200923062438.15997-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 23:24:28 -0700 saeed@kernel.org wrote:
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> fixup! net/mlx5: Refactor tc flow attributes structure
> 
> Init the parse_attr pointer in the beginning of parse_tc_fdb_actions
> so it will be valid for the entire method.
> 
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

fixup
