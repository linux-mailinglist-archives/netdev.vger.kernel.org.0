Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9893AE9B4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFUNIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:08:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhFUNIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 09:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vZwauemkwVd28l2j/FRyIlgC3dtVqFc07kW48PeHXL4=; b=P6wtPnCfNEgooXieezZE104G9J
        psG16da7CyrdETa3ia7vlhCuS1FZgcwN+e0VfNEyDlAVuSvqTVu0s0WuOvU4pV1kMNJUoAjs9GdvM
        s5s7nbrntL712rS0c3CtYxJ3P6vXCSroHmrEGQPXd225oPa1FfWsdmzudeZrBALFcFgU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvJcW-00AVLt-0Y; Mon, 21 Jun 2021 15:05:44 +0200
Date:   Mon, 21 Jun 2021 15:05:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V1 3/4] net: stmmac: Reconfigure the PHY WOL
 settings in stmmac_resume()
Message-ID: <YNCOqGCDgSOy/yTP@lunn.ch>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
 <20210621094536.387442-4-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621094536.387442-4-pei.lee.ling@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 05:45:35PM +0800, Ling Pei Lee wrote:
> From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> After PHY received a magic packet, the PHY WOL event will be
> triggered then PHY WOL event interrupt will be disarmed.
> Ethtool settings will remain with WOL enabled after a S3/S4
> suspend resume cycle as expected. Hence,the driver should
> reconfigure the PHY settings to reenable/disable WOL
> depending on the ethtool WOL settings in the resume flow.

Please could you explain this a bit more? I'm wondering if you have a
PHY driver bug. PHY WOL should remain enabled until it is explicitly
disabled.

	Andrew
