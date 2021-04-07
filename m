Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A297356C74
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 14:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352333AbhDGMpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 08:45:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38052 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352293AbhDGMpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 08:45:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lU7Xz-00FJ58-BU; Wed, 07 Apr 2021 14:44:39 +0200
Date:   Wed, 7 Apr 2021 14:44:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Voon, Weifeng" <weifeng.voon@intel.com>
Cc:     "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 0/2] Enable 2.5Gbps speed for stmmac
Message-ID: <YG2pN8uupbXP7xqU@lunn.ch>
References: <20210405112953.26008-1-michael.wei.hong.sit@intel.com>
 <YGsMbBW9h4H1y/T8@lunn.ch>
 <CO1PR11MB5044B1F80C412E6F0CAFD5509D779@CO1PR11MB5044.namprd11.prod.outlook.com>
 <YGsgHWItHcLFV9Kg@lunn.ch>
 <SN6PR11MB313690E7953BF715A8F488D688769@SN6PR11MB3136.namprd11.prod.outlook.com>
 <YGy/N+cRLGTifJSN@lunn.ch>
 <SN6PR11MB3136E862F38D7C573759989188759@SN6PR11MB3136.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB3136E862F38D7C573759989188759@SN6PR11MB3136.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Intel mgbe is flexible to pair with any PHY. Only Aquantia/Marvell
> multi-gige PHY can do rate adaption right?

The Marvell/Marvell multi-gige PHY can also do rate
adaptation. Marvell buying Aquantia made naming messy :-(
I should probably use part numbers.

> Hence, we still need to take care of others PHYs.

Yes, it just makes working around the broken design harder if you want
to get the most out of the hardware.

   Andrew
