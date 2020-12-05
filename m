Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EEE2CF8E5
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgLECLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 21:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLECLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 21:11:11 -0500
Date:   Fri, 4 Dec 2020 18:10:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607134231;
        bh=Wihp0CP5/ytFd5Rm0dUOP/FjezpNeB+NDXag1e0eVA0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kg2r6mSd7xipLBouQW2l87L0PVuI4wqTvmHKaI9AyHT6oPjVLKzS9bInP1r14tX47
         BrtbfP4Zq1s//3FQ0NY0Ku1+7L8CztXus3h6HcldumNvzZfcA8GhDWopz4Z9PvBEaI
         D60vQboqkJT6n3PALGSQ5vdSX5VT2h8WM+Bcn0fYba5me5lSLfNjax3Y1PaA6YRwrX
         LotBOxLXYVYZQK6LU0UgV19Nc+plCGDA4SaNS1CGsphzaNNb64Ltelp/fVc7YAzzeg
         iYWRlKzCul8pgkdjkm2DK5O/R92od2aVQ5XV4kr0dX3qsU67UoPBaM6djIRsjtVuC4
         Jq3TcOi0UXoqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201204181029.6d356002@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205014927.bna4nib4jelwkxe7@skbuf>
References: <20201203042108.232706-1-saeedm@nvidia.com>
        <20201203042108.232706-9-saeedm@nvidia.com>
        <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
        <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201205014927.bna4nib4jelwkxe7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 03:49:27 +0200 Vladimir Oltean wrote:
> So there you go, it just says "the reference plane marking the boundary
> between the PTP node and the network". So it depends on how you draw the
> borders. I cannot seem to find any more precise definition.

Ah, you made me go search :)

I was referring to what's now section 90 of IEEE 802.3-2018.

> Regardless of the layer at which the timestamp is taken, it is the
> jitter that matters more than the reduced path delay. The latter is just
> a side effect.
