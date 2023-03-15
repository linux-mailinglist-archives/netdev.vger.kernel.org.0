Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18A6BA4AF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 02:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCOBcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 21:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCOBcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 21:32:14 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F084A27D75;
        Tue, 14 Mar 2023 18:31:46 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id E384F24E2A5;
        Wed, 15 Mar 2023 09:31:42 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 15 Mar
 2023 09:31:42 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 15 Mar
 2023 09:31:41 +0800
Message-ID: <51102144-1533-d2f7-5fde-e01160a6f49e@starfivetech.com>
Date:   Wed, 15 Mar 2023 09:31:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 0/8] Add Ethernet driver for StarFive JH7110 SoC
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230313034645.5469-1-samin.guo@starfivetech.com>
 <20230313173330.797bf8e7@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230313173330.797bf8e7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re: [PATCH v6 0/8] Add Ethernet driver for StarFive JH7110 SoC
From: Jakub Kicinski <kuba@kernel.org>
to: Samin Guo <samin.guo@starfivetech.com>
data: 2023/3/14

> On Mon, 13 Mar 2023 11:46:37 +0800 Samin Guo wrote:
>> This series adds ethernet support for the StarFive JH7110 RISC-V SoC.
>> The series includes MAC driver. The MAC version is dwmac-5.20 (from
>> Synopsys DesignWare). For more information and support, you can visit
>> RVspace wiki[1].
> 
> I'm guessing the first 6 patches need to go via networking and patches
> 7 and 8 via riscv trees? Please repost those separately, otherwise
> the series won't apply and relevant CIs can't run on it.

Hi Jakub,

	Thanks a lot, I will repost those separately.

Best regards,
Samin
