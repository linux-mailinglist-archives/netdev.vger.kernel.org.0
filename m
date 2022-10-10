Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD575F99E7
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 09:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiJJHY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 03:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiJJHYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 03:24:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FC262AB4;
        Mon, 10 Oct 2022 00:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uddCSMRwV+4pkQ0KUppPHXtUX0PlRbBbeJEhZiLPGsM=; b=Q0yjYAOICuTLtuIExw6HUXbIkT
        xDeHtKQwHtzfW7/vB7R1eUUqFnQI8lb+qFB/5neeihrHayxX3XaEiAovscfkqCaxsEKuTJJR+ZuCq
        JkuJCdswAgRfWY3mmMA7RaXjEh9ZOhAIk7Tmz0NpE/J0IPvPmE80SrvPqxnovB6aK1o1NcrTQz+ON
        nu0X+Dc8GhnoytQi3JykubB2A73EZhZm/RuxQya4TPCWtXstFbx1cEImQOWtatftC06fsojOBs1Tt
        pktZ1oeQVqMu6MzF6AZBj8FR6c7EBP2NuJwxZS01qajwyAoU3x9bK+0Zn+/gygqtVan3iZbTYw2/Y
        ZhkGno0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34654)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ohn1o-0004MA-Ds; Mon, 10 Oct 2022 08:16:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ohn1n-0001fs-PF; Mon, 10 Oct 2022 08:16:43 +0100
Date:   Mon, 10 Oct 2022 08:16:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 54/77] net: sfp: move Alcatel Lucent
 3FE46541AA fixup
Message-ID: <Y0PG28IJN9z1iqSo@shell.armlinux.org.uk>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-54-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009220754.1214186-54-sashal@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:07:31PM -0400, Sasha Levin wrote:
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> 
> [ Upstream commit 275416754e9a262c97a1ad6f806a4bc6e0464aa2 ]
> 
> Add a new fixup mechanism to the SFP quirks, and use it for this
> module.

NAK.

There is absolutely no point in stable picking up this commit. On its
own, it doesn't do anything beneficial. It isn't a fix for anything.
It isn't stable material.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
