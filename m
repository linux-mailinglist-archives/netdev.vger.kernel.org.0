Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CCF49C831
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbiAZLBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiAZLBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:01:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C42C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 03:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kbFVcIhrxRjvEz/p8ZhdIec2qmvn1KNaNCmkjS0KhCU=; b=kmIhdtJvtjwt0gzRgLDBCNP3xJ
        0ExIn9IXsj8w8DGSJjcZe5ILw853rR3C2Xntoip/60E3Gdi64jnCgV3kwVx/jhnEX5Jd4rPh+ZLNA
        wf10Uv3s9ffk6HBfwTRbJgy4SwiZMEaSPqsHtsmEydT5OyaL4bvcRvtQX0qERCmD7DX8uJcC/pydf
        /hYbQc/8dTT2yu4WZCmJTMz786gdceA8TpgeoXhSIj9EtTkWBivlMsZeghGA20XoVWJEDqchQebxb
        tf6M0eVXV0pOMEBd4C6qRRVpevYALMv7yNnUkGCbEdCqnZqULn3U3jWIMvYyqn6DlH6DvMTjbRdVx
        COHLDKGA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56878)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCg39-0003C0-Su; Wed, 26 Jan 2022 11:01:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCg39-0004PQ-Ab; Wed, 26 Jan 2022 11:01:15 +0000
Date:   Wed, 26 Jan 2022 11:01:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dave@thedillows.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net v2 5/6] ethernet: 8390/etherh: don't write directly
 to netdev->dev_addr
Message-ID: <YfEp+9mh64QE0BYf@shell.armlinux.org.uk>
References: <20220126003801.1736586-1-kuba@kernel.org>
 <20220126003801.1736586-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126003801.1736586-6-kuba@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 04:38:00PM -0800, Jakub Kicinski wrote:
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
