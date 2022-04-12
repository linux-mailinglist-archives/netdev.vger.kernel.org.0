Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0616C4FDE42
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244975AbiDLLlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356222AbiDLLkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:40:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660854FC79
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 03:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=frZD6RZxhZJKCmfaA6+Bd+cAy86b0BJikQrdi8OEOzE=; b=0jJzFS/woDIFHow55Db1ZDsK3P
        L12Fl3QjYReEx5idhzmSgguptyZ+A18R2ZTZQBnJBWV8f8jIDEOJ024zNqvwFPyfEEobj5Y5MnUZZ
        WR8O+SuNDOx7bTxVW2xXoIF7UDjhZkgfsfZGkN2zN1wohjfzPpGBeLQ2Wu+Sp5AByeP1TLh/5GnSe
        q+d/2vXPlKw7ajUXzO20Fa0sphVUF5cG6jvewdZRT4A4QOS7AqhODa3PHI222CyHenwrQJ90OUsa0
        gwJzXE0AqadPfcOpkhpbsMXzBoEP2x0Fjyg8pwMbxfiBNZ6d/5Txr3D2jSSnZdNMvIDTSr6Pscx4K
        UzNhbT7g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58222)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1neDdO-0001g3-4J; Tue, 12 Apr 2022 11:20:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1neDdK-0002Ik-QV; Tue, 12 Apr 2022 11:20:26 +0100
Date:   Tue, 12 Apr 2022 11:20:26 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Landen.Chao@mediatek.com, dqfext@gmail.com, sean.wang@mediatek.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kabel@kernel.org, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next v2 0/9] net: dsa: mt7530: updates for phylink
 changes
Message-ID: <YlVSaqofDKfspeX9@shell.armlinux.org.uk>
References: <YlP4vGKVrlIJUUHK@shell.armlinux.org.uk>
 <164975821353.21132.17881540288519221118.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164975821353.21132.17881540288519221118.git-patchwork-notify@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 10:10:13AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by Paolo Abeni <pabeni@redhat.com>:

Hi,

I think your bot is incorrect on that point, and probably needs
servicing.

Russell.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
