Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78744D9BCB
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437164AbfJPU12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:27:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437105AbfJPU11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:27:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FD3614398687;
        Wed, 16 Oct 2019 13:27:26 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:27:26 -0700 (PDT)
Message-Id: <20191016.132726.112898872232866476.davem@davemloft.net>
To:     biao.huang@mediatek.com
Cc:     joabreu@synopsys.com, andrew@lunn.ch, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.com, boon.leong.ong@intel.com
Subject: Re: [v2, PATCH] net: stmmac: disable/enable ptp_ref_clk in
 suspend/resume flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015032444.15145-2-biao.huang@mediatek.com>
References: <20191015032444.15145-1-biao.huang@mediatek.com>
        <20191015032444.15145-2-biao.huang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 13:27:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Tue, 15 Oct 2019 11:24:44 +0800

> disable ptp_ref_clk in suspend flow, and enable it in resume flow.
> 
> Fixes: f573c0b9c4e0 ("stmmac: move stmmac_clk, pclk, clk_ptp_ref and stmmac_rst to platform structure")
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>

Applied and queued up for -stable.
