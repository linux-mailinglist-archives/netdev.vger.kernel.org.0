Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DF643AFB4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhJZKIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbhJZKIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:08:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A58C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 03:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=scUJbOd5Ukfi8lu2i5dhg4IrZ7zKZkP/o75IapaZveA=; b=XTHKnuSMr0YNVNQPW8WWVR6noz
        OjJ3FBLKxsON4jUadhGDbPuMI7ecDPAaf41wa+PArXGe5fSWE858vChY0+vcTDOzuFhRnyQixOVmT
        hmMEqjBCWT419CeTG9AZzgif2i99rgzbnWaDTTpecKeABza+iWiAKUV1lC914c8ZpqwrA7Se8tYbF
        oqk/w8BRD3hYN95fU8FziJV/ZwWtEZJtzY3ml1j/b8q9ZWlItWIVrXuS1Y3CD6ZhMwLBBklwgpZ8k
        QTA0NrjI7/buXSrjsSPCAZJVF+sJ2B8zoGXynQGsCfyXa+ziFnuTRAEbWx9cdPEzcyYrI4PPfi21V
        El01aZnw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53000 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfJLL-0005Cy-79; Tue, 26 Oct 2021 11:06:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfJLK-001KXT-Nu; Tue, 26 Oct 2021 11:06:06 +0100
In-Reply-To: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
References: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: phylink: add MAC phy_interface_t bitmap
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mfJLK-001KXT-Nu@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 26 Oct 2021 11:06:06 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a phy_interface_t bitmap so the MAC driver can specifiy which PHY
interface modes it supports.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/linux/phylink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index f7b5ed06a815..bc4b866cd99b 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -76,6 +76,7 @@ struct phylink_config {
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
+	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
 };
 
 /**
-- 
2.30.2

