Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634AD39F81C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhFHNui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:50:38 -0400
Received: from out28-170.mail.aliyun.com ([115.124.28.170]:34264 "EHLO
        out28-170.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:50:37 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07798912|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.00689651-0.00422478-0.988879;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KPSTFJt_1623160119;
Received: from 192.168.0.103(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KPSTFJt_1623160119)
          by smtp.aliyun-inc.com(10.147.40.7);
          Tue, 08 Jun 2021 21:48:40 +0800
Subject: Re: [PATCH 2/2] net: stmmac: Add Ingenic SoCs MAC support.
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
References: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YL6zYgGdqxqL9c0j@lunn.ch>
 <6532a195-65db-afb3-37a2-f68bfed9d908@wanyeetech.com>
 <YL9gr2QQ/YEXNUmP@lunn.ch>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <62ad605f-3689-cab3-e43e-9b6954da8df3@wanyeetech.com>
Date:   Tue, 8 Jun 2021 21:48:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <YL9gr2QQ/YEXNUmP@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 2021/6/8 下午8:21, Andrew Lunn wrote:
> Please wrap your text to around 75 characters per line.


Sure.


>
> I suspect you don't understand RGMII delays. As i said, normally, the
> MAC does not add delays, the PHY does. Please take a closer look at
> this.


According to the description of ethernet-controller.yaml, "rgmii" seems

to allow MAC to add TX delay (the description in ethernet-controller.yaml

is "RX and TX delays are added by the MAC when required"), while rgmii-id

and rgmii-txid do not allow MAC to add delay (the description in

ethernet-controller.yaml is"RGMII with internal RX and TX delays provided

by the PHY, the MAC should not add the RX or TX delays in this case" and

"RGMII with internal TX delay provided by the PHY, the MAC should not add

an TX delay in this case"), I will add support for the other three RGMII 
modes

in the next version (I forgot to reply to this in the previous email).


Thanks and best regards!

