Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDEB27BA70
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgI2BoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgI2BoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:44:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86856C061755;
        Mon, 28 Sep 2020 18:44:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AAEA127A2A4D;
        Mon, 28 Sep 2020 18:27:25 -0700 (PDT)
Date:   Mon, 28 Sep 2020 18:44:12 -0700 (PDT)
Message-Id: <20200928.184412.1736634531612097860.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com, chen.yong.seow@intel.com,
        mgross@linux.intel.com, vee.khee.wong@intel.com
Subject: Re: [PATCH v1 net-next] stmmac: intel: Adding ref clock 1us tic
 for LPI cntr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200928101212.12274-1-weifeng.voon@intel.com>
References: <20200928101212.12274-1-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 18:27:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Mon, 28 Sep 2020 18:12:12 +0800

> From: Rusaimi Amira Ruslan <rusaimi.amira.rusaimi@intel.com>
> 
> Adding reference clock (1us tic) for all LPI timer on Intel platforms.
> The reference clock is derived from ptp clk. This also enables all LPI
> counter.
> 
> Signed-off-by: Rusaimi Amira Ruslan <rusaimi.amira.rusaimi@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Applied.
