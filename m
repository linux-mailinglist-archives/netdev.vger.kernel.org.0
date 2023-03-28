Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990026CB325
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 03:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjC1B26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 21:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1B25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 21:28:57 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDC119A7;
        Mon, 27 Mar 2023 18:28:53 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 565F824E28D;
        Tue, 28 Mar 2023 09:28:50 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 28 Mar
 2023 09:28:50 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 28 Mar
 2023 09:28:49 +0800
Message-ID: <19c7497a-d98f-d46f-2912-8ff69276d7d6@starfivetech.com>
Date:   Tue, 28 Mar 2023 09:28:47 +0800
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
 <b20de6ba-3087-2214-eea2-bdd111d9dcbc@starfivetech.com>
 <20230327173802.0ceb89df@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230327173802.0ceb89df@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [PATCH v8 4/6] dt-bindings: net: Add support StarFive dwmac
From: Jakub Kicinski <kuba@kernel.org>
to: Guo Samin <samin.guo@starfivetech.com>
data: 2023/3/28

> On Mon, 27 Mar 2023 09:53:22 +0800 Guo Samin wrote:
>> Thanks,  I will resent with [PATCH net-next v9].
>> My series of patches will depend on Hal's minimal system[1] and william's syscon patch[2], and this context comes from their patch.
>>
>> [1]: https://patchwork.kernel.org/project/linux-riscv/cover/20230320103750.60295-1-hal.feng@starfivetech.com
>> [2]: https://patchwork.kernel.org/project/linux-riscv/cover/20230315055813.94740-1-william.qiu@starfivetech.com
>>
>> Do I need to remove their context?
> 
> If the conflict is just on MAINTAINERS it should be safe to ignore.
> Resend your patches on top of net-next as if their patches didn't
> exist. Stephen/Linus will have not trouble resolving the conflict.

I see, I'll send net-next as you suggest.

Best regards,
Samin
