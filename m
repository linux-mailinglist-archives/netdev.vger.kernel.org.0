Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780D6206274
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404279AbgFWVCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404269AbgFWVCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:02:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 909C220724;
        Tue, 23 Jun 2020 21:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592946125;
        bh=wnnmpWirqmXLuwEnv6K/iiJ+7OIhuxHFlJsKUQTvh7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V6iRCQcVjUTv0grlx8Si663OskhtQSqdfYqw05XW8qitDOAvAc1ns1f/y7y+HYwm8
         O+1ZjVh9EnqZMwojf38UEpI0ZTSnEjzs6kJ2Z1DiaGGBHXAT8SIBjM1+WYWS/EKRdg
         Of2ZVDsV36KFlczzM4BNPuKffw4ESnSL8VAp7lYg=
Date:   Tue, 23 Jun 2020 14:02:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alaa Hleihel <alaa@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [net-next 06/10] net/mlx5e: Move including net/arp.h from
 en_rep.c to rep/neigh.c
Message-ID: <20200623140204.6c11cd20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623195229.26411-7-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
        <20200623195229.26411-7-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 12:52:25 -0700 Saeed Mahameed wrote:
> From: Alaa Hleihel <alaa@mellanox.com>
> 
> After the cited commit, the header net/arp.h is no longer used in en_rep.c.
> So, move it to the new file rep/neigh.c that uses it now.
> 
> Fixes: 549c243e4e01 ("net/mlx5e: Extract neigh-specific code from en_rep.c to rep/neigh.c")

ditto

> Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
> Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
