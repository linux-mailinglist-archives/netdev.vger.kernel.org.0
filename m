Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61D21B32DC
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDUWy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUWy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:54:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836B9C0610D5;
        Tue, 21 Apr 2020 15:54:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE2AF128E92AF;
        Tue, 21 Apr 2020 15:54:58 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:54:58 -0700 (PDT)
Message-Id: <20200421.155458.2145871366975263658.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com
Subject: Re: [net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down
 sequence
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420154252.8000-2-weifeng.voon@intel.com>
References: <20200420154252.8000-1-weifeng.voon@intel.com>
        <20200420154252.8000-2-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:54:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Mon, 20 Apr 2020 23:42:52 +0800

> This patch is to enable Intel SERDES power up/down sequence. The SERDES
> converts 8/10 bits data to SGMII signal. Below is an example of
> HW configuration for SGMII mode. The SERDES is located in the PHY IF
> in the diagram below.
> 
> <-----------------GBE Controller---------->|<--External PHY chip-->
> +----------+         +----+            +---+           +----------+
> |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External |
> |   MAC    |         |xPCS|            |IF |           | PHY      |
> +----------+         +----+            +---+           +----------+
>        ^               ^                 ^                ^
>        |               |                 |                |
>        +---------------------MDIO-------------------------+
> 
> PHY IF configuration and status registers are accessible through
> mdio address 0x15 which is defined as mdio_adhoc_addr. During D0,
> The driver will need to power up PHY IF by changing the power state
> to P0. Likewise, for D3, the driver sets PHY IF power state to P3.
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Applied, thanks.
