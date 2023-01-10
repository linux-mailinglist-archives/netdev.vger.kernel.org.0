Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD24664361
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbjAJOf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjAJOf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:35:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C556559E;
        Tue, 10 Jan 2023 06:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aqD2quvdZgIGSvM6kr0jwHm7KAbVSryagby37QcM+h0=; b=AO6EhsT1rp3Bp10qSHkkATixda
        53bTiogOzDF8BISdBPnI0dyxKRniju29hLxQSi8JN2U6jBVghGa5uEbhNQETruZZJhHPttv78eWi8
        1zX7FOE82ggYhik2EHcpWAjh+K2RWhDM0RAMBuNlLk8yfQAD0GlgwPSv/IvAS/R+OSxIUhRzk7TIN
        jjCsxJQqxz5k+OCFsfpPRF657bQmCMyTwfsivLzC8q0dQ5tEp5VACHbmYKg+Uz/K11Fy7lpavRqDK
        C3ax68HmPpWnArSjSTwfW0zbK2wUr7Zx7LOhFmC1I1GrsOOyBZiFnS8c3x7bN05cuInmycyfHjPs6
        Bzignt+g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36038)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pFFj7-00043g-Hs; Tue, 10 Jan 2023 14:35:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pFFj4-0000NN-8X; Tue, 10 Jan 2023 14:35:42 +0000
Date:   Tue, 10 Jan 2023 14:35:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: ethernet: renesas: rswitch: Modify
 initialization for SERDES and PHY
Message-ID: <Y713vpQLosOkfeey@shell.armlinux.org.uk>
References: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 02:02:02PM +0900, Yoshihiro Shimoda wrote:
> The patch [1/4] sets phydev->host_interfaces by phylink for Marvell PHY
> driver (marvell10g) to initialize the MACTYPE.

I don't yet understand the "why" behind the need for this. Doesn't your
platform strap the 88x3310 correctly, so MACTYPE is properly set?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
