Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E5A28276C
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 01:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgJCXmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 19:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgJCXms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 19:42:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9891FC0613D0;
        Sat,  3 Oct 2020 16:42:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58E3411E3E4C6;
        Sat,  3 Oct 2020 16:25:58 -0700 (PDT)
Date:   Sat, 03 Oct 2020 16:42:40 -0700 (PDT)
Message-Id: <20201003.164240.1313265831717025751.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com, chen.yong.seow@intel.com,
        mgross@linux.intel.com, vee.khee.wong@intel.com
Subject: Re: [PATCH v2 net] net: stmmac: Modify configuration method of EEE
 timers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001155609.5372-1-weifeng.voon@intel.com>
References: <20201001155609.5372-1-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:25:58 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Thu,  1 Oct 2020 23:56:09 +0800

> From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>
> 
> Ethtool manual stated that the tx-timer is the "the amount of time the
> device should stay in idle mode prior to asserting its Tx LPI". The
> previous implementation for "ethtool --set-eee tx-timer" sets the LPI TW
> timer duration which is not correct. Hence, this patch fixes the
> "ethtool --set-eee tx-timer" to configure the EEE LPI timer.
> 
> The LPI TW Timer will be using the defined default value instead of
> "ethtool --set-eee tx-timer" which follows the EEE LS timer implementation.
> 
> Fixes: d765955d2ae0 ("stmmac: add the Energy Efficient Ethernet support")
> Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> 
> Changelog V2
> *Not removing/modifying the eee_timer.
> *EEE LPI timer can be configured through ethtool and also the eee_timer
> module param.
> *EEE TW Timer will be configured with default value only, not able to be
> configured through ethtool or module param. This follows the implementation
> of the EEE LS Timer.

Please put the Changelog above the various signoffs and other tags, as those
should be at the end of the commit log message.

Just out of curiousity, where did you see put the changelog after the
tags, and thus caused you to use this layout?  If you decided that on
your own, this is pretty much always a bad idea.  Look to other
patches which have been accepted as a guide for how to format your commit
log message.

Applied, thank you.
