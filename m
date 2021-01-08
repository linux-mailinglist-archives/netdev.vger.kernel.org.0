Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB06A2EEBB1
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbhAHDJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbhAHDJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 22:09:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00424208B3;
        Fri,  8 Jan 2021 03:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610075306;
        bh=mBcomDStJS8PH+yb+/1HMre3zfTHkvK7t5eJLmWVAr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hH3mZhXvuYbDX1SNiRJBqcVC7Yw5DSOW8tuCT5lri+nE9rlndmHYGI1TXOY5UPSZx
         53Gzn4YLFEqc0/DYPfOO0Fqd3vZaDYmlxDN46ESX42A8fcvYUFLlxkojfhqmcQGkAO
         FXRuv76BBE/QURhcyacTgTDQi4pBq8lZvoiDPt3YHb2aUmX2wLnkaObPN7i/4/19bo
         BC1G2TlJ3JVseWav/YSc2x50G+LkT2LekHG6eCnQiXi1aadNIvXhdJPICE8W9kcDNO
         dM4WFKYRhP/i1zgbUuyfPhLeRbiILV4prbJ7j8D9+OlBNk1E5pH0AQQgnJiZOhAodI
         51+IHNH3/5wDA==
Date:   Thu, 7 Jan 2021 19:08:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 05/11] net/mlx5e: Fix SWP offsets when vlan inserted by
 driver
Message-ID: <20210107190820.5251c845@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107202845.470205-6-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
        <20210107202845.470205-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 12:28:39 -0800 Saeed Mahameed wrote:
> +	if (skb_vlan_tag_present(skb) &&  ihs)

Double space.
