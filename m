Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB83433A52
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFCVyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:54:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCVyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:54:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57747133E97B7;
        Mon,  3 Jun 2019 14:54:04 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:54:03 -0700 (PDT)
Message-Id: <20190603.145403.767083490900611093.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.torgue@st.com, biao.huang@mediatek.com,
        boon.leong.ong@intel.com, hock.leong.kweh@intel.com
Subject: Re: [PATCH net-next v5 3/5] net: stmmac: add xpcs function hooks
 into main driver and ethtool
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559332694-6354-4-git-send-email-weifeng.voon@intel.com>
References: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
        <1559332694-6354-4-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:54:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Sat,  1 Jun 2019 03:58:12 +0800

> +static bool mac_adjust_link(struct stmmac_priv *priv,
> +			    int *speed, int *duplex)
> +{
> +	bool new_state = false;
> +
> +	u32 ctrl = readl(priv->ioaddr + MAC_CTRL_REG);

Again please don't break up the local variable declarations like this.
