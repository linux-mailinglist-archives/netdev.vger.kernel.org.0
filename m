Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF651AF542
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgDRWCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:02:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40687C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:02:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E88821276E50A;
        Sat, 18 Apr 2020 15:02:45 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:02:43 -0700 (PDT)
Message-Id: <20200418.150243.1729778196680981792.davem@davemloft.net>
To:     julien.beraud@orolia.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: stmmac: fix enabling socfpga's
 ptp_ref_clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415122432.70972-1-julien.beraud@orolia.com>
References: <20200415122432.70972-1-julien.beraud@orolia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:02:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Beraud <julien.beraud@orolia.com>
Date: Wed, 15 Apr 2020 14:24:31 +0200

> There are 2 registers to write to enable a ptp ref clock coming from the
> fpga.
> One that enables the usage of the clock from the fpga for emac0 and emac1
> as a ptp ref clock, and the other to allow signals from the fpga to reach
> emac0 and emac1.
> Currently, if the dwmac-socfpga has phymode set to PHY_INTERFACE_MODE_MII,
> PHY_INTERFACE_MODE_GMII, or PHY_INTERFACE_MODE_SGMII, both registers will
> be written and the ptp ref clock will be set as coming from the fpga.
> Separate the 2 register writes to only enable signals from the fpga to
> reach emac0 or emac1 when ptp ref clock is not coming from the fpga.
> 
> Signed-off-by: Julien Beraud <julien.beraud@orolia.com>

Applied.
