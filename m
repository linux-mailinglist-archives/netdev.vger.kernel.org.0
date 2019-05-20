Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06932242BE
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfETVUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:20:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41070 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726966AbfETVUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 17:20:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=67UFBnzAcIhooBj87Gxyu93VVsiphW6C7t7vJSiFn+g=; b=ZBKI0me1jsOwkTLddaEYW8HZt/
        4M3BvguGwnK696sXVWqWwzWVGXj1UyIjPLK9VI/QRalKwEdn8BTuS0VxgsS7umz0AWQ7+/7HqivD9
        Cc3g7LcjM5aBeDfAxJtspBPAB2e6/v/8MskU3C/Tpc4IIjXiDeZAd0wVIxOiyC1Pmzt4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hSpi5-00048K-5r; Mon, 20 May 2019 23:20:41 +0200
Date:   Mon, 20 May 2019 23:20:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weifeng Voon <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net] net: stmmac: fix ethtool flow control not able to
 get/set
Message-ID: <20190520212041.GL22024@lunn.ch>
References: <1558414542-28550-1-git-send-email-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558414542-28550-1-git-send-email-weifeng.voon@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 12:55:42PM +0800, Weifeng Voon wrote:
> From: "Tan, Tee Min" <tee.min.tan@intel.com>
> 
> Currently ethtool was not able to get/set the flow control due to a
> missing "!". It will always return -EOPNOTSUPP even the device is
> flow control supported.
> 
> This patch fixes the condition check for ethtool flow control get/set
> function for ETHTOOL_LINK_MODE_Asym_Pause_BIT.
> 
> Fixes: 3c1bcc8614db (“net: ethernet: Convert phydev advertize and supported from u32 to link mode”)
> Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
> Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Voon, Weifeng <weifeng.voon@intel.com@intel.com>

Upps,  my bad. Sorry.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
