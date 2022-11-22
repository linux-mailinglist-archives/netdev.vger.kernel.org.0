Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A126F634360
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiKVSMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiKVSMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:12:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148AD85140;
        Tue, 22 Nov 2022 10:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9wL3DrReumJnIpFip3mqETIzbbZ50/FTBOkqMi0gBBA=; b=5joZOybnGGPJ5wv+TYwwnM26YS
        ona4UaPG05JTABx7GUPPR92aRp4QPtfVEXRcZM9Hy1SwJaI8OSl6q1AEi/jxqFGjTzc4jD7lXkP6j
        4TSKcWUh8EbRbmTqpKFiMKPNh4YP1xWl2I228YRdwGsY1F1PPTO9Lyvdgikzch+O52pE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxXje-00397n-1p; Tue, 22 Nov 2022 19:11:06 +0100
Date:   Tue, 22 Nov 2022 19:11:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Ahmad Tarmizi Noor Azura <noor.azura.ahmad.tarmizi@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>
Subject: Re: [PATCH net v2] net: stmmac: Set MAC's flow control register to
 reflect current settings
Message-ID: <Y30QukgIdFJg7X/+@lunn.ch>
References: <20221122063935.6741-1-wei.sheng.goh@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122063935.6741-1-wei.sheng.goh@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:39:35PM +0800, Goh, Wei Sheng wrote:
> Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
> correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
> is issued. This fix ensures the flow control change is reflected directly
> in the GMAC_RX_FLOW_CTRL_RFE register.

In future, please include a summary of what changed from version 1 of
the patch. This is generally placed under the --- marker.

> 
> Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
> Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
