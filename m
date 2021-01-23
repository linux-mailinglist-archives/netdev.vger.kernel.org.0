Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6254C30129A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbhAWDZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:25:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbhAWDZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:25:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6802323A3A;
        Sat, 23 Jan 2021 03:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372278;
        bh=a/EKypTkdGXFmFdEsTbUplIXvRMhv/7MIzNdxqCDv3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sjOTXtnjf6yVeyqIdx9KtKflvG7ZKI1IuOyhZSqF4/KhbCg0eH3OGz4eXOnZbJzW0
         0RZsG7WJ7qaXzPgeE9TJyXfeh8P822kZ0kZoBsK5aEGrTMYc9va7woF3Xn4ypEXVUu
         mXYU2ddygiJSenBPNECxPSmX/bO/qapJVQ8jFVSGAmGuSI95O8HDiavdtmb/57VFdg
         AOjRO0DZBJ2COgysckXyvlz6gyrtvee6HzZoKNEenGBu1uTSMeXjrytmjQK9VfWpiD
         mKvAl3CgtiJBQeX8utDMVrDyXaeMILWtEmeDLDhsFoFiSUltnJqWJgN5jBnwwDbJMi
         RajGikPA5hn+g==
Date:   Fri, 22 Jan 2021 19:24:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] vmxnet3: Remove buf_info from device
Message-ID: <20210122192437.69f99a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122083051.16258-1-doshir@vmware.com>
References: <20210122083051.16258-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 00:30:51 -0800 Ronak Doshi wrote:
> +	tq->buf_info = kcalloc_node(tq->tx_ring.size, sizeof(tq->buf_info[0]),
> +				    GFP_KERNEL | __GFP_ZERO,
> +				    dev_to_node(&adapter->pdev->dev));

no need to pass __GFP_ZERO to kcalloc
