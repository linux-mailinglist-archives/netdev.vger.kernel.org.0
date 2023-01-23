Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010D26777E0
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjAWJyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjAWJyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:54:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9CB1BEF
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ks3Zy2w+721nFvWcoOhY4+Fbsx/0HaaDGDx0sjmqNq0=; b=jbA4FFkmqxKM6De2N22lS15dar
        wOnqY/2k3aF8DvGRP3PvV83nIZf/dwl6UbaxSNZ4DT35roA1A9xEQT9+/VYYQdsMK/sio7auXUNPe
        ud+cP6cydCvsXJPTLWmX5o4YDzHaE53Hm/KBREvszXa+alwSBh5wKSaP2Uy0QyzytKOeWHMW5AsAK
        j3SaHtlPpNgIFtRtAtCNHD07CUVpCTh5Gty8PnvBMQIncF4mlEk7BrM078V5gR1n9qxUTBW0f/LSw
        5Zh3kt5hEIxOVAUKQWFg++IBuSR0M+k29BXh41AIYEvKbkTK47y+IToWnMHiIYeoZT07wht30Vw2q
        ze1Ejc6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36264)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pJtXA-00044c-Gk; Mon, 23 Jan 2023 09:54:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pJtX5-0004Ek-4I; Mon, 23 Jan 2023 09:54:31 +0000
Date:   Mon, 23 Jan 2023 09:54:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v3 net 3/3] mtk_sgmii: enable PCS polling to allow SFP
 work
Message-ID: <Y85ZV6QxV9GdYItH@shell.armlinux.org.uk>
References: <20230122212153.295387-1-bjorn@mork.no>
 <20230122212153.295387-4-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230122212153.295387-4-bjorn@mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 10:21:53PM +0100, Bjørn Mork wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> Currently there is no IRQ handling (even the SGMII supports it).
> Enable polling to support SFP ports.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> [ bmork: changed "1" => "true" ]
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
