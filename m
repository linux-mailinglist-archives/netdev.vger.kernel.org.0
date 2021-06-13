Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D1D3A5722
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 10:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhFMIhB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Jun 2021 04:37:01 -0400
Received: from out28-170.mail.aliyun.com ([115.124.28.170]:43791 "EHLO
        out28-170.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhFMIhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 04:37:01 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.311907|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00345262-0.000172191-0.996375;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KRgrEgd_1623573293;
Received: from zhouyanjie-virtual-machine(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KRgrEgd_1623573293)
          by smtp.aliyun-inc.com(10.147.41.138);
          Sun, 13 Jun 2021 16:34:54 +0800
Date:   Sun, 13 Jun 2021 16:34:52 +0800
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
Message-ID: <20210613163452.1f01d418@zhouyanjie-virtual-machine>
In-Reply-To: <YMIoWS57Ra19E1qT@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
        <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
        <YMGEutCet7fP1NZ9@lunn.ch>
        <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
        <YMICTvjyEAgPMH9u@lunn.ch>
        <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
        <12f35415-532e-5514-bc97-683fb9655091@wanyeetech.com>
        <YMIoWS57Ra19E1qT@lunn.ch>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

于 Thu, 10 Jun 2021 16:57:29 +0200
Andrew Lunn <andrew@lunn.ch> 写道:

> > Here is Ingenic's reply, the time length corresponding to a unit is
> > 19.5ps (19500fs).  
> 
> Sometimes, there is a negative offset in the delays. So a delay value
> of 0 written to the register actually means -200ps or something.

Ah, perhaps this explains why we still need to add fine-tuning
parameter in rgmii-id and rgmii-txid modes to ensure that the network
works properly.

> 
>    Andrew
