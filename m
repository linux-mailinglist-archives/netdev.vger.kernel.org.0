Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627402CDE26
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgLCS7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgLCS7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 13:59:42 -0500
Date:   Thu, 3 Dec 2020 10:59:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607021942;
        bh=6qjonLW+y/pJUd4Pie3YEWk0eAif/YF2x0cPtfSSJs8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKAeh2VGKo+eiJEDlqVSr82K4qJy/2svNNqpba/HMXByuHxLYi4nPZlRaAjMBgpsc
         tmrOkkIad2rI27PienU/3EIvIykzpwpgy9LYOhqw262wN5umStSKbw08vVL1SdcP9G
         P1DLL2HYUm9iA8XYBMUoOZa+lIFATE3dASiYz3Xijv8XuFRGjQS/4OoG/klISSa3Xj
         sOB/QyLqD+LnS2lNYkWW//u6Ro11UxZ6yZPJi/TT32NBwiiDpBcN+I4UORp0WDT9OD
         +aMBn2CYRgWRFCgzIJNUy8+VRxEOIMPgaXBA4lva3KdtdAL0hLg2PzXra4fum11xdQ
         nGKEKRPoo7tfg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Wang Hai <wanghai38@huawei.com>, davem@davemloft.net,
        rmk+kernel@armlinux.org.uk, mcroce@microsoft.com,
        sven.auhagen@voleatech.de, atenart@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Fix error return code in mvpp2_open()
Message-ID: <20201203105900.0552a1cc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203152346.GP2324545@lunn.ch>
References: <20201203141806.37966-1-wanghai38@huawei.com>
        <20201203152346.GP2324545@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 16:23:46 +0100 Andrew Lunn wrote:
> On Thu, Dec 03, 2020 at 10:18:06PM +0800, Wang Hai wrote:
> > Fix to return negative error code -ENOENT from invalid configuration
> > error handling case instead of 0, as done elsewhere in this function.
> > 
> > Fixes: 4bb043262878 ("net: mvpp2: phylink support")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wang Hai <wanghai38@huawei.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
