Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566AB45B914
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241237AbhKXLdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbhKXLdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:33:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CBDC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0EP66XXeGuD6B2iYTqZNaKQGgV9wDCZUiKKfjPAGnRo=; b=khUO/C8yWNoHNpIZDOXeOC3dmh
        3kM5UefVKbpUL44vnz/qbN1TnGmq6rhUDSH7FT0/iFNI9T8DJE1TDiHWONf1eFvA3OWuX1gigXTcU
        dM/9wayZYKlXSIL9YIiyOOGt3txOf6UEOhm5wPJHJkXAnysFIm7sCTfOwep/URj5QnLj9sUbI4Nzv
        he5809d2iVFwFHp04j1a6qyM37vnmfnjuC8ym7Az9PnjYj1sFSdpgy9ILpIgb2LxAyJ6W2pnj4jIR
        uaWBn/10j9YvZD0NyIXCJixunJPzbesrZGuNBKKMmnbhkWS15sxnTQ64Q65IevoK6SeDF7I/F4kaG
        DHkzgEtQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55840)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpqU6-0000WV-9Y; Wed, 24 Nov 2021 11:30:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpqU5-00019X-Gj; Wed, 24 Nov 2021 11:30:41 +0000
Date:   Wed, 24 Nov 2021 11:30:41 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Subject: Re: [PATCH net-next] MAINTAINERS: Update B53 section to cover SF2
 switch driver
Message-ID: <YZ4iYeg+47Q69oRG@shell.armlinux.org.uk>
References: <20211123222422.3745485-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123222422.3745485-1-f.fainelli@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 02:24:22PM -0800, Florian Fainelli wrote:
> Update the B53 Ethernet switch section to contain
> drivers/net/dsa/bcm_sf2*.
> 
> Reported-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
