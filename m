Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299B336891
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFFADa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:03:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFADa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:03:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE580136E16AB;
        Wed,  5 Jun 2019 17:03:28 -0700 (PDT)
Date:   Wed, 05 Jun 2019 17:03:28 -0700 (PDT)
Message-Id: <20190605.170328.2300021130625279075.davem@davemloft.net>
To:     biao.huang@mediatek.com
Cc:     joabreu@synopsys.com, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, yt.shen@mediatek.com,
        jianguo.zhang@mediatek.com, boon.leong.ong@intel.com
Subject: Re: [v2, PATCH 0/4] complete dwmac-mediatek driver and fix flow
 control issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559527086-7227-1-git-send-email-biao.huang@mediatek.com>
References: <1559527086-7227-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 17:03:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Biao Huang <biao.huang@mediatek.com>
Date: Mon, 3 Jun 2019 09:58:02 +0800

> Changes in v2:                                                                  
>         patch#1: there is no extra action in mediatek_dwmac_remove, remove it            
>                                                                                 
> v1:                                                                             
> This series mainly complete dwmac-mediatek driver:                              
>         1. add power on/off operations for dwmac-mediatek.                      
>         2. disable rx watchdog to reduce rx path reponding time.                
>         3. change the default value of tx-frames from 25 to 1, so               
>            ptp4l will test pass by default.                                     
>                                                                                 
> and also fix the issue that flow control won't be disabled any more             
> once being enabled.                                                             

Series applied to net-next.
