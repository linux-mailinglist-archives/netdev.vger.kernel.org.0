Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB352A5F5
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfEYSCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:02:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEYSCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:02:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 282C814FC9282;
        Sat, 25 May 2019 11:02:53 -0700 (PDT)
Date:   Sat, 25 May 2019 11:02:52 -0700 (PDT)
Message-Id: <20190525.110252.292904127953775877.davem@davemloft.net>
To:     biao.huang@mediatek.com
Cc:     joabreu@synopsys.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.comi, boon.leong.ong@intel.com
Subject: Re: [v4, PATCH 0/3] fix some bugs in stmmac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558679169-26752-1-git-send-email-biao.huang@mediatek.com>
References: <1558679169-26752-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 May 2019 11:02:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Fri, 24 May 2019 14:26:06 +0800

> changes in v4:                                                                  
>         since MTL_OPERATION_MODE write back issue has be fixed in the latest driver,
> remove original patch#3                                                         
>                                                                                 
> changes in v3:                                                                  
>         add a Fixes:tag for each patch                                          
>                                                                                 
> changes in v2:                                                                  
>         1. update rx_tail_addr as Jose's comment                                
>         2. changes clk_csr condition as Alex's proposition                      
>         3. remove init lines in dwmac-mediatek, get clk_csr from dts instead.   
>                                                                                 
> v1:                                                                             
> This series fix some bugs in stmmac driver                                      
> 3 patches are for common stmmac or dwmac4:                                      
>         1. update rx tail pointer to fix rx dma hang issue.                     
>         2. change condition for mdc clock to fix csr_clk can't be zero issue.   
>         3. write the modified value back to MTL_OPERATION_MODE.                 
> 1 patch is for dwmac-mediatek:                                                  
>         modify csr_clk value to fix mdio read/write fail issue for dwmac-mediatek

Series applied, thanks.
