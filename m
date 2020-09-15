Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14A426B22F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgIOWnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbgIOWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:43:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF3CC06174A;
        Tue, 15 Sep 2020 15:43:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B438D1369E725;
        Tue, 15 Sep 2020 15:26:16 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:43:02 -0700 (PDT)
Message-Id: <20200915.154302.373083705277550666.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com, kuba@kernel.org,
        Joao.Pinto@synopsys.com, arnd@arndb.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        sadhishkhanna.vijaya.balan@intel.com, chen.yong.seow@intel.com
Subject: Re: [PATCH net-next 0/3] net: stmmac: Add ethtool support for
 get|set channels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915012840.31841-1-vee.khee.wong@intel.com>
References: <20200915012840.31841-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:26:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Tue, 15 Sep 2020 09:28:37 +0800

> This patch set is to add support for user to get or set Tx/Rx channel
> via ethtool. There are two patches that fixes bug introduced on upstream
> in order to have the feature work.
> 
> Tested on Intel Tigerlake Platform.

Series applied, thank you.
