Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079DA2EA4C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 03:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfE3BjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 21:39:19 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:8208 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726527AbfE3BjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 21:39:18 -0400
X-UUID: eb0d16995d464ece951d8d337d91a496-20190530
X-UUID: eb0d16995d464ece951d8d337d91a496-20190530
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 1220763986; Thu, 30 May 2019 09:39:13 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31N2.mediatek.inc
 (172.27.4.87) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 30 May
 2019 09:39:11 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 30 May 2019 09:39:10 +0800
Message-ID: <1559180349.24897.72.camel@mhfsdcap03>
Subject: RE: [v5, PATCH] net: stmmac: add support for hash table size
 128/256 in dwmac4
From:   biao huang <biao.huang@mediatek.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Date:   Thu, 30 May 2019 09:39:09 +0800
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9334CE@DE02WEMBXB.internal.synopsys.com>
References: <1559122268-22545-1-git-send-email-biao.huang@mediatek.com>
         <1559122268-22545-2-git-send-email-biao.huang@mediatek.com>
         <78EB27739596EE489E55E81C33FEC33A0B9334CE@DE02WEMBXB.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,
	Flow control is disabled in v5 commit.

	I tried "insmod stmmac flow_ctrl=1", and the output log shows self test
pass:
	ethtool -t eth0                                    
	The test result is PASS
 	The test extra info:
 	 1. MAC Loopback                 0
 	 2. PHY Loopback                 -95
 	 3. MMC Counters                 0
 	 4. EEE                          -95
 	 5. Hash Filter MC               0
 	 6. Perfect Filter UC            0
 	 7. MC Filter                    0
 	 8. UC Filter                    0
	 9. Flow Control                 0

	Is v5 OK? Should I resend a v6?

On Wed, 2019-05-29 at 10:30 +0000, Jose Abreu wrote:
> From: Biao Huang <biao.huang@mediatek.com>
> Date: Wed, May 29, 2019 at 10:31:08
> 
> > 1. get hash table size in hw feature reigster, and add support
> > for taller hash table(128/256) in dwmac4.
> > 2. only clear GMAC_PACKET_FILTER bits used in this function,
> > to avoid side effect to functions of other bits.
> > 
> > stmmac selftests output log:
> > 	ethtool -t eth0
> > 	The test result is FAIL
> > 	The test extra info:
> > 	 1. MAC Loopback                 0
> > 	 2. PHY Loopback                 -95
> > 	 3. MMC Counters                 0
> > 	 4. EEE                          -95
> > 	 5. Hash Filter MC               0
> > 	 6. Perfect Filter UC            0
> > 	 7. MC Filter                    0
> > 	 8. UC Filter                    0
> > 	 9. Flow Control                 1
> 
> Thanks for testing, this patch looks good to me.
> 
> Do you want to check why Flow Control selftest is failing ?
> 
> 
> Thanks,
> Jose Miguel Abreu

Thanks,
Biao


