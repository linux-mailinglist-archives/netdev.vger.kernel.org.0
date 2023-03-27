Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550886C996A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 03:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjC0Bxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 21:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjC0Bxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 21:53:36 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E89249EE;
        Sun, 26 Mar 2023 18:53:35 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id F3D4224E292;
        Mon, 27 Mar 2023 09:53:25 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 27 Mar
 2023 09:53:26 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 27 Mar
 2023 09:53:24 +0800
Message-ID: <b20de6ba-3087-2214-eea2-bdd111d9dcbc@starfivetech.com>
Date:   Mon, 27 Mar 2023 09:53:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v8 4/6] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
References: <20230324022819.2324-1-samin.guo@starfivetech.com>
 <20230324022819.2324-5-samin.guo@starfivetech.com>
 <20230324192419.758388e4@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230324192419.758388e4@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [PATCH v8 4/6] dt-bindings: net: Add support StarFive dwmac
From: Jakub Kicinski <kuba@kernel.org>
to: Samin Guo <samin.guo@starfivetech.com>
data: 2023/3/25

> On Fri, 24 Mar 2023 10:28:17 +0800 Samin Guo wrote:
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ebc97c6c922f..5c6d53a9f62a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19905,6 +19905,12 @@ M:	Emil Renner Berthing <kernel@esmil.dk>
>>  S:	Maintained
>>  F:	arch/riscv/boot/dts/starfive/
>>  
>> +STARFIVE DWMAC GLUE LAYER
>> +M:	Emil Renner Berthing <kernel@esmil.dk>
>> +M:	Samin Guo <samin.guo@starfivetech.com>
>> +S:	Maintained
>> +F:	Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>> +
>>  STARFIVE JH7110 MMC/SD/SDIO DRIVER
>>  M:	William Qiu <william.qiu@starfivetech.com>
>>  S:	Supported
> 
> The context is wrong here, could you regen the series on top of
> net-next (and resend with [PATCH net-next v9] in the subject while
> at it)?



Hi Jakub,

Thanks,  I will resent with [PATCH net-next v9].
My series of patches will depend on Hal's minimal system[1] and william's syscon patch[2], and this context comes from their patch.

[1]: https://patchwork.kernel.org/project/linux-riscv/cover/20230320103750.60295-1-hal.feng@starfivetech.com
[2]: https://patchwork.kernel.org/project/linux-riscv/cover/20230315055813.94740-1-william.qiu@starfivetech.com

Do I need to remove their context?


Best regards,
Samin
