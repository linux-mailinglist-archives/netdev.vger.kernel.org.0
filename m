Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8795B2D5197
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgLJDlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:41:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34952 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbgLJDlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:41:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 11FDB4D259C21;
        Wed,  9 Dec 2020 19:40:42 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:40:41 -0800 (PST)
Message-Id: <20201209.194041.84161587477984240.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com
Subject: Re: [PATCH v2 net-next 1/1] net: stmmac: allow stmmac to probe for
 C45 PHY devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209224700.30295-1-vee.khee.wong@intel.com>
References: <20201209224700.30295-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:40:42 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Thu, 10 Dec 2020 06:47:00 +0800

> Assign stmmac's mdio_bus probe capabilities to MDIOBUS_C22_C45.
> This extended the probing of C45 PHY devices on the MDIO bus.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
> v2 changelog:
> - Added conditional check for gmac4.

Applied, thanks.
