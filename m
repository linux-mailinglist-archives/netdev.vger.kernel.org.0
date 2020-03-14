Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533DE185814
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCOByW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbgCOByV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FhgxhvWIIVuY6B13AUlH0Smz4LynUEU/AuTeEi2VA88=; b=JXT6fiPSChn7qXiOXmjwwXvpgA
        s8s4Wg+uRCJCx5XlBEoyF6Kt31072P+FQW0bR7BJ/pNMYbms8SRs984L8eE1jqGwh0BmX3Jo0Cg1h
        p1szeizypEEEhg1Zle/Cqv3qyEJIsBjiIQplVC+xHTEO0qmMv9hM0xJo7B3KfxFLEVdM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDEBo-0002Ko-Kw; Sat, 14 Mar 2020 22:19:24 +0100
Date:   Sat, 14 Mar 2020 22:19:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/3] arm64: dts: ls1046ardb: set RGMII interfaces to
 RGMII_ID mode
Message-ID: <20200314211924.GC8622@lunn.ch>
References: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1584101065-3482-4-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584101065-3482-4-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 02:04:25PM +0200, Madalin Bucur wrote:
> The correct setting for the RGMII ports on LS1046ARDB is to
> enable delay on both Rx and Tx so the interface mode used must
> be PHY_INTERFACE_MODE_RGMII_ID.
> 
> Since commit 1b3047b5208a80 ("net: phy: realtek: add support for
> configuring the RX delay on RTL8211F") the Realtek 8211F PHY driver
> has control over the RGMII RX delay and it is disabling it for
> RGMII_TXID. The LS1046ARDB uses two such PHYs in RGMII_ID mode but
> in the device tree the mode was described as "rgmii".
> 
> Changing the phy-connection-type to "rgmii-id" to address the issue.
> 
> Fixes: 3fa395d2c48a ("arm64: dts: add LS1046A DPAA FMan nodes")
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

