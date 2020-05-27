Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0211E4BD2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389099AbgE0R1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387880AbgE0R1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 13:27:03 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6A32065F;
        Wed, 27 May 2020 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590600423;
        bh=ucZoao9L8g/2KadzPCOColUJB6bjMcAkk4RFTHYYFIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oI4sA0zQnRFeVoNa9vcooURmaqN90ddFcnlWnez8QLmBLH3wa2rvfmFYF+x7wcear
         Vkdf8AiDz8kn23tuJ1TdoyQOxp+Jd301im4hBW+t52bynbLNIxs4NtulNUOJ6GLHLZ
         a25QElO6sCc4Vh/DJqmykwDBsS4k6njYrMYQpg20=
Date:   Wed, 27 May 2020 10:27:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [net-next 13/16] net/mlx5e: Helper function to set ethertype
Message-ID: <20200527102701.37596b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527014924.278327-14-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
        <20200527014924.278327-14-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 18:49:21 -0700 Saeed Mahameed wrote:
> From: Eli Britstein <elibr@mellanox.com>
> 
> Set ethertype match in a helper function as a pre-step towards
> optimizing it.
> 
> Signed-off-by: Eli Britstein <elibr@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:517:36: warning: incorrect type in initializer (different base types)
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:517:36:    expected restricted __be16 [usertype] n_proto
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:517:36:    got int
