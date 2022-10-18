Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4721602656
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJRICl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJRICj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:02:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3517C84E6A;
        Tue, 18 Oct 2022 01:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r1TxYC0slJVe2mkpKf7pL1bopDnMUMi1PqaWciekznc=; b=Zlx+jYynivcCjWcnHQqo0vFWcH
        4RA26wsE8kmjTnrYuDmdB4uO+aAMan0UlfSnw7Sym074Wkmzo1T+23QGJ81jhnTKHVNxUDDeiaQUB
        hXim3dcqdj5mbv5CtplvZRbYD1ULewNaq6Qi3a56h31fXxFAKH4mB6CxRkAhQmnvooQS5/uHgyMP6
        qEDIZzCffCKoKdRvKJUE2mL3v0russVwkMizIgKv1oXEZP/AAzAN7E0xqCyWosCA8j+mqKrjEFQr4
        4ACKb51M+xESOMf6+aZy/1ufWvT8GeKTviRQBfIWZVYMjZQRBRgGprab95R9973U1tr0paXyl8+gg
        5pTo+kdg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34766)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1okhYO-0004Bh-B2; Tue, 18 Oct 2022 09:02:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1okhYJ-0000vX-NR; Tue, 18 Oct 2022 09:02:19 +0100
Date:   Tue, 18 Oct 2022 09:02:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7] net: phy: Add driver for Motorcomm yt8521
 gigabit ethernet phy
Message-ID: <Y05diwTQdqr9za3G@shell.armlinux.org.uk>
References: <20221018011439.1169-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018011439.1169-1-Frank.Sae@motor-comm.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 09:14:39AM +0800, Frank wrote:
>  Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
>  the driver on StarFive VisionFive development board, which is developed by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
>  wol(magic package).
> 
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
> ---
> patch v7:
>  Hi Russell
> 
> > As previously pointed out, dropping the MDIO bus lock in a
> > phy_select_page()..phy_restore_page() region unsafe. I think you need
> > to ensure that yt8521_fiber_config_aneg() is safe to be called under
> > the lock, and I suspect having a version of genphy_config_aneg() which
> > can be called with the lock held would be a better approach.
> 
>  with your suggestion we add yt8521_set_page() which does not hold the lock.

And so you don't understand the locking issues...

If you drop the lock, it means that some other thread (e.g. userspace) can
come in and change the page register under you, which will completely
change which register(s) you are accessing.

Please implement locking properly, don't bodge around with it. I made my
suggestion above specifically after having thought about the issues and
what would be possible to give a correct locking implementation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
