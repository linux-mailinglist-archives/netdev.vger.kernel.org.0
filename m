Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB232D1FB1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgLHA7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:59:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLHA7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:59:16 -0500
Date:   Mon, 7 Dec 2020 16:58:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607389115;
        bh=hnG/QlFw/ncP5cQbP0FgUvI8U08awhB9chKGv4L7p40=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LwRNYkBo4G2HdqPJ4OXzMP2P/ASDHzF8KVgc5FWR+4WTxRCKxnqV0B3PuRTmAynhX
         AyKKKoEVeYxwfuFRSIieyK39VD4GwpAqZFQprA12jbIToYpV/ZYOKv5TyaUB/o3nRx
         3ZVEsq+QZnblzfRHYf6tFSTpsSKsArYU9GvO5kXAIXuWBjVAHgtscuRT/WU3Bn205I
         mPSjf7WcJtaU6FUIpg7/c8a9WGSYNG29SvabQxlOgCNFX5nYe/5MXIPRsANSZxHd8k
         PZsP0Hn4+6m5popUxXApXsZnvwVmqB9VLQdSvc0W3wOzRLV3ZmGS6FCj/Q21vbDxdw
         9LKMbMBgYPtrw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] enetc: Fix reporting of h/w packet counters
Message-ID: <20201207165834.76619a28@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204171505.21389-1-claudiu.manoil@nxp.com>
References: <20201204171505.21389-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 19:15:05 +0200 Claudiu Manoil wrote:
> Noticed some inconsistencies in packet statistics reporting.
> This patch adds the missing Tx packet counter registers to
> ethtool reporting and fixes the information strings for a
> few of them.
> 
> Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks!
