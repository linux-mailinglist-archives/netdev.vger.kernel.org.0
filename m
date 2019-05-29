Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F56F2E372
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfE2Rjt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 13:39:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:55335 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2Rjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 13:39:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 10:39:48 -0700
X-ExtLoop1: 1
Received: from pgsmsx108.gar.corp.intel.com ([10.221.44.103])
  by orsmga007.jf.intel.com with ESMTP; 29 May 2019 10:39:46 -0700
Received: from pgsmsx103.gar.corp.intel.com ([169.254.2.93]) by
 PGSMSX108.gar.corp.intel.com ([169.254.8.77]) with mapi id 14.03.0415.000;
 Thu, 30 May 2019 01:39:45 +0800
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH net-next v4 1/5] net: stmmac: enable clause 45 mdio
 support
Thread-Topic: [PATCH net-next v4 1/5] net: stmmac: enable clause 45 mdio
 support
Thread-Index: AQHVFfytwCWwwFk/s0y481symSRgi6aBXSwAgAD/zVA=
Date:   Wed, 29 May 2019 17:39:44 +0000
Message-ID: <D6759987A7968C4889FDA6FA91D5CBC814707D32@PGSMSX103.gar.corp.intel.com>
References: <1559149107-14631-1-git-send-email-weifeng.voon@intel.com>
 <1559149107-14631-2-git-send-email-weifeng.voon@intel.com>
 <78EB27739596EE489E55E81C33FEC33A0B9333BC@DE02WEMBXB.internal.synopsys.com>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9333BC@DE02WEMBXB.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static void stmmac_mdio_c45_setup(struct stmmac_priv *priv, int phyreg,
> > +				  u32 *val, u32 *data)
> > +{
> > +	unsigned int reg_shift = priv->hw->mii.reg_shift;
> > +	unsigned int reg_mask = priv->hw->mii.reg_mask;
> 
> Reverse christmas tree here. You also should align the function variables with
> the opening parenthesis of the function here and in the remaining series.
> 
> Otherwise this patch looks good to me.

It is already reversed Christmas tree. Somehow each of the character's width in the
email is not equal. As you can see that the first line of assignment is having more
character than the second line of assignment.
The alignment is also correct when I check it after doing a git am.

Regards,
Weifeng

> 
> Thanks,
> Jose Miguel Abreu
