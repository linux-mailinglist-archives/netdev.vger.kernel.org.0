Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B942DC9DB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgLQAP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbgLQAP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:15:26 -0500
Date:   Wed, 16 Dec 2020 16:14:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608164086;
        bh=E0iGxseLw9nnNDVO5TrRYip0xBHTffxaiABLtNwHiqc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=W0eALqJ0qEvrdt9ifNR9vkIE2EDXgkE6AhcDhdBUV5Qz5lYQfXDUP+Tcn0gTy2xzV
         +isJuzlNA+C/dSgD5sAmFNGWMlKNFkI5d1BHHGBH6Z7I/mtaD/i7aN8DM9r2dCzySQ
         KZrzLIJYTbV6JmNGfB05kHy/xZD/YI1gSj6/3nSXqwRFPbApqedxJThpfBPv5NGu4C
         1IZxlXLyu7uzf8v1wzLVy2Pa8QlQI31M6poiWw8qxTuZAP2YvdTxFpF1Zft0UbIEEj
         5XrrR+/DZf4xLFfHdrHWyKaHyZNjNV/YQiVw0W2ZfK+/n9tI/wvGFxKTSTCtmzUT68
         AT5vbeAJP6gGw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Parav Pandit <parav@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Fix compilation warning for 32-bit
 platform
Message-ID: <20201216161445.512f2b68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <565c26195b79ca998280d83aca0a193bd1a8c23e.camel@kernel.org>
References: <20201213120641.216032-1-leon@kernel.org>
        <20201213123620.GC5005@unreal>
        <565c26195b79ca998280d83aca0a193bd1a8c23e.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 12:08:46 -0800 Saeed Mahameed wrote:
> I will change this and attach this patch to my PR of the SF support.

Looks like the SF discussion will not wind down in time to make this
merge window, so I think I'm going to take this in after all. Okay?
