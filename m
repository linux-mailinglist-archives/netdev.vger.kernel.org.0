Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC14F370375
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhD3W2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhD3W2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 18:28:51 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B39CC06174A;
        Fri, 30 Apr 2021 15:28:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7EF194F7E7593;
        Fri, 30 Apr 2021 15:28:01 -0700 (PDT)
Date:   Fri, 30 Apr 2021 15:28:01 -0700 (PDT)
Message-Id: <20210430.152801.713225083548143754.davem@davemloft.net>
To:     michael.wei.hong.sit@intel.com
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, tee.min.tan@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Introducing support for DWC xpcs Energy
 Efficient Ethernet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210429084636.24752-1-michael.wei.hong.sit@intel.com>
References: <20210429084636.24752-1-michael.wei.hong.sit@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 30 Apr 2021 15:28:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Date: Thu, 29 Apr 2021 16:46:34 +0800

> The goal of this patch set is to enable EEE in the xpcs so that when
> EEE is enabled, the MAC-->xpcs-->PHY have all the EEE related
> configurations enabled.
> 
> Patch 1 adds the functions to enable EEE in the xpcs and sets it to
> transparent mode.
> Patch 2 adds the callbacks to configure the xpcs EEE mode.

net-next is closed, please resubit this when it opensd back up.

Thank you.
