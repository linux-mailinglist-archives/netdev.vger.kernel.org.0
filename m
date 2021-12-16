Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4332C47757C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbhLPPOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbhLPPOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:14:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42EDC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 07:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A48F61E20
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90597C36AE4;
        Thu, 16 Dec 2021 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639667679;
        bh=4b4eBRtbDp++FTKBs7sWA/GfA18Pczuvcxnn/AipMHQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qMSp6Xwn/vC3P/i/9NEeiCFkGN8+7k2lTAiqO4QQefmm1YPHsw2gNGn8Y5CvO38Vx
         zLpF64qTRgT3PstzMqxtTzRkjc2qakeaNhqTCwHp/VRiFoO7dUqXF+qJfRrHeXPIjk
         hudKi+O/Bws26Vk27ilqlmplYCi5L/dVmIyE3P7MxHcxypQ/n7+O7/7OQlmoCf4xtW
         5t74Wt6D+Kn7ixyEYREZh21Vw8B1vGgWD2g5qdjUdvARM6IraH01kgJE8hkGydwoaT
         YCU3RpesJRrgclpTKtoQA0F+Jo4EGygcNkMYl2LRrsmLdmCP29LwMXJty4ZNw/3t7t
         B9mzH5orXPWaw==
Date:   Thu, 16 Dec 2021 07:14:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH CFT net-next 2/2] net: axienet: replace mdiobus_write()
 with mdiodev_write()
Message-ID: <20211216071438.59fbfb53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1mxqBm-00GWxu-8y@rmk-PC.armlinux.org.uk>
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk>
        <E1mxqBm-00GWxu-8y@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 12:48:50 +0000 Russell King (Oracle) wrote:
> Commit 197a68ef1837 ("net: mdio: Add helper functions for accessing
> MDIO devices") added support for mdiodev accessor operations that

Nit: wrong commit id, 0ebecb2644c8 ("net: mdio: Add helper functions for
accessing MDIO devices")?
