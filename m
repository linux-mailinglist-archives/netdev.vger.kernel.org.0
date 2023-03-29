Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6DE6CEF95
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjC2QiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjC2QiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:38:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E7ADB;
        Wed, 29 Mar 2023 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nqb3eOXKREvLW9BAFYXjCeVhhXMvbL63kC9zEhZdZEQ=; b=rPat5mwvB49J7zctdFuplYqikj
        uAZJOanlxahOez2qiAOXwTugc5ITra60zC3mK6Uq0b4WjWjNEEcpR6Wa6wFCo9R7wq+cakq7zokLz
        BZC4R9JLa23qoPLCL8avs9c2uBwOBIyNebwD/+VW6IKwlVcgq1+HMxlXseM3GuOiTCz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phYoQ-008mcU-RO; Wed, 29 Mar 2023 18:38:14 +0200
Date:   Wed, 29 Mar 2023 18:38:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v3 10/15] net: dsa: mt7530: introduce
 separate MDIO driver
Message-ID: <868f3eae-cca6-4234-95aa-e21c021e18a2@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <2bef9ef442261e26d4d933f101f4a25c0f3aad2a.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bef9ef442261e26d4d933f101f4a25c0f3aad2a.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:59:30PM +0100, Daniel Golle wrote:
> Split MT7530 switch driver into a common part and a part specific
> for MDIO connected switches and multi-chip modules.
> Move MDIO-specific functions to newly introduced mt7530-mdio.c while
> keeping the common parts in mt7530.c.
> In order to maintain compatibility with existing kernel configurations
> keep CONFIG_NET_DSA_MT7530 as symbol to select the MDIO-specific driver
> while the newly introduced hidden symbol CONFIG_NET_DSA_MT7530_COMMON
> is selected by CONFIG_NET_DSA_MT7530.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
