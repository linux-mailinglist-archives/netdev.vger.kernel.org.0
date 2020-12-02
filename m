Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6885A2CC5D6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgLBStm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:49:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgLBStl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 13:49:41 -0500
Date:   Wed, 2 Dec 2020 10:48:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606934941;
        bh=lsJ4iUPMCRSY94or+f4dLwn07OhZA5+yXBf/umZfmEQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqqu1bsVyBmcn0x5b++FhXu4cNp0myM41YSd2iN5by0BHLoV3OEPNAKAmkjI4Z3ey
         6RdrjmUjer3n2CF8v2zYGEmbJ9Jh2+jP8+PZjuk6IzgXQRSzdM3otSHgpmQO2NZKjt
         3TV43TMwC5LFT+EQZA7vrod4lK+EKRdNYcBX80hmg9lZuYblYxP4Ct6EXDtsJUSljs
         qoHksY9L6N5dlHlGgU2Q5HChnStNdkug0X3KU4BFo9Lzlwe02IbQHcuxPK7Q4gRb89
         /ZRNXsVdAWYkLfpf8CvD/suiszdkGhAjrC8YkkX1Oh4FzvYTX14yyxbw67xliniNHF
         OAZAUuwYSe7cg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2020-12-01
Message-ID: <20201202104859.71a35d1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201224208.73295-1-saeedm@nvidia.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 14:41:53 -0800 Saeed Mahameed wrote:
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.

Why is that not a separate posting prior to this one?

The patches as posted on the ML fail to build.
