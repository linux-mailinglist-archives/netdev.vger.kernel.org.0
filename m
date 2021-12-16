Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB86D477584
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhLPPPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhLPPPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:15:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD672C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:15:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EFB761E20
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D447C36AE0;
        Thu, 16 Dec 2021 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639667714;
        bh=suJMjXIzNaWU9glWOPCXY5g0bmpCD7sc2a4hFn3FDUA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyZw8cwoJ+cG2BIS4GD02hv90JOjxFrZk/54exmpm+zMnJQAFhlQf0JM6e2HBaQrT
         lGIUnAMke9vIYRe3zj6lVgRctvr/vqWxv26qN6Taa03B9PDr1ChIK830EioRqtuQOb
         Z4fGsXeqM1BM7++aETfAUeWh9usp0gzOyMGr1eK4/lS7UJno9tOhOnDsdkDnIQ9Kdd
         dprap9ypHxSUdW1XpBRVHXFqlfmR2W4AMRNFWpuqhxU0CF+IqPaapBo1BlCJluqIm3
         BMVn6+kgabs1hELaCKZUDo488aqkann8iw/Qw3YJDdcodZKqqZsX7aQXk59Og9NmjS
         JHA5tB66R3D0g==
Date:   Thu, 16 Dec 2021 07:15:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
Message-ID: <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
        <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> Convert axienet to use the phylink_pcs layer, resulting in it no longer
> being a legacy driver.
> 
> One oddity in this driver is that lp->switch_x_sgmii controls whether
> we support switching between SGMII and 1000baseX. However, when clear,
> this also blocks updating the 1000baseX advertisement, which it
> probably should not be doing. Nevertheless, this behaviour is preserved
> but a comment is added.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function parameter or member 'pcs' not described in 'axienet_local'
