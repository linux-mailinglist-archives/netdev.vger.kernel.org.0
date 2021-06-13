Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460AD3A571A
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 10:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFMI2i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Jun 2021 04:28:38 -0400
Received: from out28-124.mail.aliyun.com ([115.124.28.124]:34219 "EHLO
        out28-124.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFMI2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 04:28:37 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1052365|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0758817-0.0072256-0.916893;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KRgdwVg_1623572789;
Received: from zhouyanjie-virtual-machine(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KRgdwVg_1623572789)
          by smtp.aliyun-inc.com(10.147.41.121);
          Sun, 13 Jun 2021 16:26:31 +0800
Date:   Sun, 13 Jun 2021 16:26:28 +0800
From:   =?UTF-8?B?5ZGo55Cw5p2w?= <zhouyanjie@wanyeetech.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <20210613162628.2a21d7ea@zhouyanjie-virtual-machine>
In-Reply-To: <YMIk0NfOPryoY607@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
        <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
        <YMGEutCet7fP1NZ9@lunn.ch>
        <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
        <YMICTvjyEAgPMH9u@lunn.ch>
        <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
        <YMIk0NfOPryoY607@lunn.ch>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

于 Thu, 10 Jun 2021 16:42:24 +0200
Andrew Lunn <andrew@lunn.ch> 写道:

> >     We are much more strict about this now than before. You have to
> > use standard units and convert to hardware values. It also makes it
> > a lot easier for DT writers, if they have an idea what the units
> > mean.
> > 
> >     Having the MAC add small delays is something you can add later,
> >     without breaking backwards compatibility. So if you cannot
> > determine what the units are now, just submit the glue driver
> > without support for this feature. If anybody really needs it, they
> > can do the needed research, maybe do some measurements, and then
> > add the code.
> > 
> > 
> > I did an experiment, when the tx delay is not set, RGMII works a  
> 
> You had rgmii-id in your device tree, so that the PHY added the
> delays?

I have tried rgmii-id and rgmii-txid. If we don’t add a fine-tuning
parameter, it still can’t work properly. In these two modes, we still
need to add about 500ps delay on the mac side to ensure it works
properly.

Thanks and best regards!

> 
> 	Andrew
