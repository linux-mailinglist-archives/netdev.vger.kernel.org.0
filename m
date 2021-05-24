Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214FA38DED7
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 03:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhEXBWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 21:22:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53510 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232067AbhEXBWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 21:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=El+XZLB92OFWSNNtDA3CExs5QoARTgqBFwrJ+abZcbI=; b=wVz1tZsk4uVfYWfxhScxy8WxbG
        uDf3vohtq+lri3NoaDwd5mfH4kGPGjjg+OaxxHb2QmJRwp/5+UcIVPUu/t+lt0X8vwL8WeAuQ9TXY
        heDO2rAhc+03Hn/W0nnuP56sWvom59PH/uzByo5FzyKCkowVZqvdXRZOptdxbF3xCyO8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lkzH9-005tzT-LY; Mon, 24 May 2021 03:20:59 +0200
Date:   Mon, 24 May 2021 03:20:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     leoyang.li@nxp.com, davem@davemloft.net, kuba@kernel.org,
        rasmus.villemoes@prevas.dk, christophe.leroy@csgroup.eu,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] ethernet: ucc_geth: Use kmemdup() rather
 than kmalloc+memcpy
Message-ID: <YKr/e4H0fPEyK8px@lunn.ch>
References: <20210524010701.24596-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524010701.24596-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 09:07:01AM +0800, YueHaibing wrote:
> Issue identified with Coccinelle.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
