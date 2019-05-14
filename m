Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09B41C10F
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfENDjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:39:04 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:42825 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726753AbfENDjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 23:39:04 -0400
X-UUID: d78f6c5d285847fb879771b0a7456d4a-20190514
X-UUID: d78f6c5d285847fb879771b0a7456d4a-20190514
Received: from mtkcas34.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1403175480; Tue, 14 May 2019 11:38:53 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 14 May
 2019 11:38:52 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 14 May 2019 11:38:51 +0800
Message-ID: <1557805131.24897.41.camel@mhfsdcap03>
Subject: Re: [v2, PATCH 0/4] fix some bugs in stmmac
From:   biao huang <biao.huang@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>,
        <jianguo.zhang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yt.shen@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Tue, 14 May 2019 11:38:51 +0800
In-Reply-To: <20190514030016.GA19642@lunn.ch>
References: <1557800933-30759-1-git-send-email-biao.huang@mediatek.com>
         <20190514030016.GA19642@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
	Add a Fixes:tag in series v3, please review.

On Tue, 2019-05-14 at 05:00 +0200, Andrew Lunn wrote:
> On Tue, May 14, 2019 at 10:28:49AM +0800, Biao Huang wrote:
> > changes in v2:                                                                  
> >         1. update rx_tail_addr as Jose's comment                                
> >         2. changes clk_csr condition as Alex's proposition                      
> >         3. remove init lines in dwmac-mediatek, get clk_csr from dts instead.   
> 
> Hi Biao
> 
> Since these are fixes, could you provide a Fixes: tag for each one?
> 
> Thanks
> 	Andrew


