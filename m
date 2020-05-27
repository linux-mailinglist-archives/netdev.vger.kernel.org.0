Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B131E4BD6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgE0R1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgE0R1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 13:27:47 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E87BA2065F;
        Wed, 27 May 2020 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590600467;
        bh=VmiqCtP8YfKP+XdH3tuKmBIGgz0B4iUhHdDZOlJVPdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xFm0G40GbYO98N8tKQpJkGXBMQCdOWtVkEGzzxzKEf6jITIhl0DX/avR922Dd3PEV
         8l8f7osT52r62g1S4gbsRWTF3bUPXuJnodvmhxYrqjYBVv3c0XAYTptMm3WXzHqKbH
         6niyIb8NJn/6PRd15oP+ZAOwJntUwlfoEWYh6nMU=
Date:   Wed, 27 May 2020 10:27:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [net-next 14/16] net/mlx5e: Optimize performance for IPv4/IPv6
 ethertype
Message-ID: <20200527102745.58dfc1dc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527014924.278327-15-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
        <20200527014924.278327-15-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 18:49:22 -0700 Saeed Mahameed wrote:
> From: Eli Britstein <elibr@mellanox.com>
> 
> The HW is optimized for IPv4/IPv6. For such cases, pending capability,
> avoid matching on ethertype, and use ip_version field instead.
> 
> Signed-off-by: Eli Britstein <elibr@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:2035:42: warning: restricted __be16 degrades to integer
