Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4474924543
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbfEUA4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:56:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfEUA4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:56:45 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46BB0140F8471;
        Mon, 20 May 2019 17:56:45 -0700 (PDT)
Date:   Mon, 20 May 2019 20:56:44 -0400 (EDT)
Message-Id: <20190520.205644.1160707171896552897.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        boon.leong.ong@intel.com
Subject: Re: [PATCH net] net: stmmac: dma channel control register need to
 be init first
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558417118-28985-1-git-send-email-weifeng.voon@intel.com>
References: <1558417118-28985-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:56:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weifeng Voon <weifeng.voon@intel.com>
Date: Tue, 21 May 2019 13:38:38 +0800

> stmmac_init_chan() needs to be called before stmmac_init_rx_chan() and
> stmmac_init_tx_chan(). This is because if PBLx8 is to be used,
> "DMA_CH(#i)_Control.PBLx8" needs to be set before programming
> "DMA_CH(#i)_TX_Control.TxPBL" and "DMA_CH(#i)_RX_Control.RxPBL".
> 
> Fixes: 47f2a9ce527a ("net: stmmac: dma channel init prepared for multiple queues")
> Reviewed-by: Zhang, Baoli <baoli.zhang@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>

Applied and queued up for -stable.

Thanks.
