Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE4764B43B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiLMLaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLMLaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:30:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795C0B0B;
        Tue, 13 Dec 2022 03:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wTliCIUA9M4KMvDQxTYvjOzNAyuBpTA7+qAEQcAV1xI=; b=yBbX9KeHOK1dP/0r7d76dtnU09
        Hct8B4/7K5EmLby6RB+zLXIDLMfxHhN4sIqorfJIpLRphopq6zhiowh+A5HU0dGzIfH//05HIunk+
        Q0vEvqhQhZhWX7usY+r8e2DThKeYE2jgxDGWTTOgOzY2trb5F/XXayHpY7B9jG2lAn1r2CYt3mD7t
        qTVPZaUENJf7w2lx23oKAraG1Qsi3/bLnSyIGQgUwfXFzPYpRuvcEAzLjjgc9zvAxkAs0FgG7cuFi
        /xW8uzJX/nUR3d57COVb6HpefsoSmb5glbtpAcVhqgMd6LfzcIeF+00OLIaiAFgHE7IBboszUzoqd
        4dGCneaw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35688)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p53U5-0006lw-Vq; Tue, 13 Dec 2022 11:30:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p53U0-0006PO-5A; Tue, 13 Dec 2022 11:30:00 +0000
Date:   Tue, 13 Dec 2022 11:30:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: remove reduntant assignment
Message-ID: <Y5hiOBaSDsx5RsmV@shell.armlinux.org.uk>
References: <Y5b/Tm4GwPGzd9sR@shell.armlinux.org.uk>
 <Y5f6h8q7rlnk1jnD@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5f6h8q7rlnk1jnD@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 04:07:35AM +0000, Daniel Golle wrote:
> Russell King correctly pointed out that the MAC_2500FD capability is
> already added for port 5 (if not in RGMII mode) and port 6 (which only
> supports SGMII) by mt7531_mac_port_get_caps. Remove the reduntant
> setting of this capability flag which was added by a previous commit.
> 
> Fixes: e19de30d20 ("net: dsa: mt7530: add support for in-band link status")
> Reported-by: Russell King <linux@armlinux.org.uk>

Please update the name and email address as per my reviewed-by below
(the "(Oracle)" bit is important since I now work for Oracle.)

> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
