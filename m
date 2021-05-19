Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB65388EBE
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbhESNQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 09:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhESNQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 09:16:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4304EC06175F;
        Wed, 19 May 2021 06:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oqsAPUWXIGMYpUjPUFn+8YbwmjYEi12f9Rt7EvYL5AE=; b=loS0BerXYT08KWDBPBZNF6Biv
        w5tzVd3y0T+YnKzKN2R5UlXEy6uN6u1vOoN6q2AwsRxrFAF1Fv9UXNEo6k1pMN9P+EYAvamcC1q24
        NScW+K5XWO6AEqbjH0J86VkDYDdibZiLVHsvI22Q3UnzKAS/Ni5kDSuBmheMj0oHxoEeaFfm5mZ+Z
        aXMtRgZyt2t+Q9eFqu64oHGKo8TQqYYNuL27VNU543eYdYfhvJLMj3lTFVlPNT33zqWsMhypwg4K3
        5r0QfhktmXjjZi+CLCDoxXXTQIOe8Aq/qGR/6Ze6vGPUpaYtE9SB88uMt8TnVMUsi0t3rtAhvVtxh
        FVYvoMFgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44172)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ljM2c-0005oK-Kg; Wed, 19 May 2021 14:15:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ljM2b-00022p-D8; Wed, 19 May 2021 14:15:13 +0100
Date:   Wed, 19 May 2021 14:15:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <20210519131512.GA30436@shell.armlinux.org.uk>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
 <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
 <YKTJwscaV1WaK98z@unreal>
 <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com>
 <YKT7bLjzucl/QEo2@unreal>
 <CAMdYzYpVYuNuYgZp-sNj4QFbgHH+SoFpffbdCNJST2_KZEhSug@mail.gmail.com>
 <YKUK8hBImIUFV35I@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKUK8hBImIUFV35I@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 03:56:18PM +0300, Leon Romanovsky wrote:
> I'm sorry that I continue to ask, but is net/phy/* usable without MODULE?

Simple answer: it is.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
