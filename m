Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23946CEFBC
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjC2QsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC2QsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:48:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602E24C33;
        Wed, 29 Mar 2023 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qGUhqh38sUtokyMSpPcb4CdSlFTGlU/NbfLzgbzoywk=; b=b7lEbX43vQ2DE7V11q5p0b/xBY
        koNXyY9SFer/maej+YxWg2M7jxb1gWJss/YoxpJDdm56zLW+tmWw5frqnbsPy7fPHh2B2+Tx4CkhU
        UiQ8dHHenwNj5i1zifu7yzVGwgS5VsqY01IoEIWAfMSGMakU86uw2PtUHGPPiHztJopo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phYxv-008mhr-P0; Wed, 29 Mar 2023 18:48:03 +0200
Date:   Wed, 29 Mar 2023 18:48:03 +0200
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
Subject: Re: [RFC PATCH net-next v3 13/15] net: dsa: mt7530: add support for
 10G link modes for CPU port
Message-ID: <1a2572a9-c4ce-4478-be36-c1b1d0237dca@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <495231a9d84159878116c2cb181537da674edc27.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495231a9d84159878116c2cb181537da674edc27.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 05:00:21PM +0100, Daniel Golle wrote:
> The built-in switch of the MT7988 SoC is internally connected using
> a stateless 10G link. Add support for 10G interface modes to silence
> a warning otherwise occurring when the switch driver is setup.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
