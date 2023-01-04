Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435E165DB77
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbjADRqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbjADRqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:46:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E55517070;
        Wed,  4 Jan 2023 09:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kgv5xJTMYBes8sfoQjemKe9ruol1NM3cm77eq+o8GtA=; b=3MrjuwYl4M3hggJ3oeSipYUhcP
        JcFKuOrUOVWCOV0p2XQvxxySQ1xLU6ZCOWt/jW645tyn+dA/O/dsIHbi1YYt/V0SVbwS101jTcpqB
        yPXdIWDzzMtDYH/AZ0eU0sSWrVyI8cBDYqGNBp0ks6T+24H7I6BoW3Al0LgmbtSeZw5U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pD7pf-0019XD-5t; Wed, 04 Jan 2023 18:45:43 +0100
Date:   Wed, 4 Jan 2023 18:45:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        macpaul.lin@mediatek.com, netdev@vger.kernel.org
Subject: Re: [PATCH v7 1/2] stmmac: dwmac-mediatek: remove the
 dwmac_fix_mac_speed
Message-ID: <Y7W7R3J07ufApGbw@lunn.ch>
References: <20230104085857.2410-1-biao.huang@mediatek.com>
 <20230104085857.2410-2-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104085857.2410-2-biao.huang@mediatek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 04:58:56PM +0800, Biao Huang wrote:
> In current driver, MAC will always enable 2ns delay in RGMII mode,
> but that's not the correct usage.
> 
> Remove the dwmac_fix_mac_speed() in driver, and recommend "rgmii-id"
> for phy-mode in device tree.
> 
> Fixes: f2d356a6ab71 ("stmmac: dwmac-mediatek: add support for mt8195")
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
