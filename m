Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E81662C50
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfGHXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:09:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfGHXJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:09:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E21D312DAF003;
        Mon,  8 Jul 2019 16:09:07 -0700 (PDT)
Date:   Mon, 08 Jul 2019 16:09:07 -0700 (PDT)
Message-Id: <20190708.160907.199146123409419023.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.torgue@st.com, biao.huang@mediatek.com,
        boon.leong.ong@intel.com, hock.leong.kweh@intel.com
Subject: Re: [PATCH v2 net-next] net: stmmac: enable clause 45 mdio support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562348007-12263-1-git-send-email-weifeng.voon@intel.com>
References: <1562348007-12263-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 16:09:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Sat,  6 Jul 2019 01:33:27 +0800

> From: Kweh Hock Leong <hock.leong.kweh@intel.com>
> 
> DWMAC4 is capable to support clause 45 mdio communication.
> This patch enable the feature on stmmac_mdio_write() and
> stmmac_mdio_read() by following phy_write_mmd() and
> phy_read_mmd() mdiobus read write implementation format.
> 
> Reviewed-by: Li, Yifan <yifan2.li@intel.com>
> Signed-off-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Applied, thanks.
