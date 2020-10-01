Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89335280B55
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbgJAX1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727713AbgJAX1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:27:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF2C206E5;
        Thu,  1 Oct 2020 23:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601594831;
        bh=OoQ2PbIo0rYmhv5+UfgB3bRlr888pJizIoOQ8RO+owY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O+bW+1VVGjzUOVTHf6auX3TdBQoJfvx5+c0AzRuTWldR2vlfEqa53L6TCG74G7tNm
         BWfB3azlAlhKYJi843PTLjecsb/OZkuuJoyBRLupRWCZgSHayGdFx6n6SANSzv9kDh
         lkrnTeObkzDo6l4XJXwRo2XBda6ja0a+wBhZ3Kto=
Date:   Thu, 1 Oct 2020 16:27:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net V2 09/15] net/mlx5e: Add resiliency in Striding RQ mode
 for packets larger than MTU
Message-ID: <20201001162709.40e7ce85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001195247.66636-10-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
        <20201001195247.66636-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 12:52:41 -0700 saeed@kernel.org wrote:
> Usually, this filtering is performed by the HW, except for a few cases:
> - Between 2 VFs over the same PF with different MTUs
> - On bluefield, when the host physical function sets a larger MTU than
>   the ARM has configured on its representor and uplink representor.

Just to confirm - is not multi-host affected?
