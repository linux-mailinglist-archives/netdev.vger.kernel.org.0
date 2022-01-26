Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7004A49C836
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiAZLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240416AbiAZLBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:01:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB6BC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 03:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rD7nW/YhJasAyBDWYBL35XL6wxUiUwGg2ZtkzbPwhxI=; b=eSSrRdQy5aG6sl4dZt8Jjzbb3+
        Qr42II1QOHzNVu5HpBU9FTlTmyAeP0EjBNER9EYuIT/SB/hLEKUAMKhkEXOdKHKQi4wMiY6onkMbi
        53Jc6vhiuLXLjM1BDOzEjSwBZpT0+4A0qxfPYSdr74fDahUBB6TCx0tEOLlZ2Y30FKNEIixDUVYwc
        xxuNQVjit0wPjLZRcnl8tBijtx7pHZrNVajmAgS60SLiyuil4CZXDWGthT2+iCn03/5uUBnGNNe3/
        m+HSZpjVMN8oCwrzRkFBph7oxIPaRWD3TaZkiUMUKB8NBfkLU3E8HZ2c05EnwsDLQICrJZlHELflM
        qc3xtrcg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56882)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCg3c-0003C9-2q; Wed, 26 Jan 2022 11:01:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCg3b-0004Pb-GN; Wed, 26 Jan 2022 11:01:43 +0000
Date:   Wed, 26 Jan 2022 11:01:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dave@thedillows.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net v2 6/6] ethernet: seeq/ether3: don't write directly
 to netdev->dev_addr
Message-ID: <YfEqF+IbPRhthS9p@shell.armlinux.org.uk>
References: <20220126003801.1736586-1-kuba@kernel.org>
 <20220126003801.1736586-7-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126003801.1736586-7-kuba@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 04:38:01PM -0800, Jakub Kicinski wrote:
> netdev->dev_addr is const now.
> 
> Compile tested rpc_defconfig w/ GCC 8.5.
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
