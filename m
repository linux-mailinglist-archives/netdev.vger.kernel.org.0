Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5602929FEF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404104AbfEXUcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:32:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403950AbfEXUcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:32:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E292C14E2B42F;
        Fri, 24 May 2019 13:32:40 -0700 (PDT)
Date:   Fri, 24 May 2019 13:32:40 -0700 (PDT)
Message-Id: <20190524.133240.646339028966688358.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.torgue@st.com, biao.huang@mediatek.com,
        boon.leong.ong@intel.com, hock.leong.kweh@intel.com
Subject: Re: [PATCH net-next v2 1/5] net: stmmac: enable clause 45 mdio
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558625567-21653-2-git-send-email-weifeng.voon@intel.com>
References: <1558625567-21653-1-git-send-email-weifeng.voon@intel.com>
        <1558625567-21653-2-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:32:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Thu, 23 May 2019 23:32:43 +0800

> +static void stmmac_mdio_c45_setup(struct stmmac_priv *priv, int phyreg,
> +				  u32 *val, u32 *data)
> +{
> +	unsigned int reg_mask = priv->hw->mii.reg_mask;
> +	unsigned int reg_shift = priv->hw->mii.reg_shift;

Reverse christmas tree please.

Please fix this up for your entire submissions as there were several other
instances of this.

Thank you.
