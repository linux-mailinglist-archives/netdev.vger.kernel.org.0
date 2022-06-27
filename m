Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A37855C296
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbiF0Lxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238155AbiF0LvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:51:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3161365A5
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=se561GE51ZKmBBp0+K65eWxuQ3kRrlABULGZVWaItck=; b=HdX+5acP3zh2AYsW1CiBBxxNAO
        9q/oKoIEoZ6ELCqKXVmhE3PkqVem0U4c5vt4cg/4eikzoxIeoc1hhfkd8Rfl4QV4n3OSTChJ6sZiF
        MM7bvhH/Lzg8pcUWkRd9C91GmUCC3hTSKGVZNpQNSSU8V2SL6b/heBLP34yKtuldMk7bY7wskMNFs
        yCWg1+MueXzW+ACupvQi9+iaHDcohimCGoIzcUMAD6Z2YtQq3MGYbQqU6vpN2tfpbiRnNL6c7ycVc
        TxbsRDs+5TQ5lGOs6Lej8wH8IL8muvaPJUkq1WlncHjj1Y9cF8bBH9EdPO3F53wqUNI7pbDCISNRW
        UZ3ahQaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33050)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o5nAB-0000HC-St; Mon, 27 Jun 2022 12:44:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o5nA8-0003wv-TD; Mon, 27 Jun 2022 12:44:16 +0100
Date:   Mon, 27 Jun 2022 12:44:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] net: phylink: cleanup pcs code
Message-ID: <YrmYEC2N9mVpg9g6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

These two patches were part of the larger series for the mv88e6xxx
phylink pcs conversion. As this is delayed, I've decided to send these
two patches now.

 drivers/net/phy/phylink.c | 69 ++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
