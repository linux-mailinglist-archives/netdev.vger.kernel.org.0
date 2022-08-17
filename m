Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4365973E3
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241069AbiHQQNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241025AbiHQQMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:12:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12C6A031F;
        Wed, 17 Aug 2022 09:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jcyKtAvjzBE4ZZ5pqDnp+JRBc0tSPSvpfYXhFfk/wyo=; b=GN+BHdb0gO/9ZOENwaDYHnsxwa
        7KMg6eHgxlMLtUQB/NyeTF+Tm3QEmXwtFvlFW9jyzBxW8DPfbN7Z5xEG81MLd0YLlHm+VOWp1V/Gx
        u0Fc9w8YzwOLdvST3xN6fXXtB1sfKpn6Q2aiFw0nI9UIAiav6XeLggIiNEGnuymx4JnorUFlqD2Lj
        vJYt38c/MXlNifsRBCpzXraFDp4lmZrYh1blPt3LTvS+iRGAZuR9YQnnmeq7D7aJHQvEfMMMMBh7O
        +Ugcgm03PzOldd1hakaV9REnsQKJZiyxr0BZpj9JM/uRpUY2sgZqxJ5f6/7W7NeZ4ps+EIEFYO1MI
        FzIq6SiQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33826)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oOLec-0005b4-7x; Wed, 17 Aug 2022 17:12:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oOLea-0005yf-3y; Wed, 17 Aug 2022 17:12:24 +0100
Date:   Wed, 17 Aug 2022 17:12:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Beniamin Sandu <beniaminsandu@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Message-ID: <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
 <20220817085429.4f7e4aac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817085429.4f7e4aac@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 08:54:29AM -0700, Jakub Kicinski wrote:
> On Sat, 13 Aug 2022 23:46:58 +0300 Beniamin Sandu wrote:
> > This makes the code look cleaner and easier to read.
> 
> Last call for reviews..

I had a quick look and couldn't see anything obviously wrong, but then
I'm no expert with the hwmon code. I build-tested it, and I'm not likely
to any time soon. I think Andrew added the hwmon code for this PHY
originally.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
