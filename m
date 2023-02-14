Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DA9696C93
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjBNSQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjBNSQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:16:06 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6525BB2;
        Tue, 14 Feb 2023 10:16:00 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 6C1676602173;
        Tue, 14 Feb 2023 18:15:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676398558;
        bh=5hcGfDEKZbuq1K1R1fzKCojapW7pZt9UpkfXsZpC37k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mkJXs6fJXY0R907DKGgGIUBpVBXxy+M8+xzjMfC0pL+bEFibFu2ppPNSpU4aoo2c4
         6nxirK0aH3u6olBONZuv6ZtNVhycTbZUau/rNsS3Kn0iLJewqmtc4E4Y69ixAum8lv
         7xIul9YFjLuR74bir5EK2jXls83EwN77KOW9PKYbL1IFf2g91Iryq+atHNZ92mJdxn
         kFAx8+Flg+O0ky4nrE4hyDKfmTAJCDkAAIB4b41wMiMYN7inEsqyF40474bIzJ1qAs
         jInKQQWgMQxO/zUajXkrPZ0CCh7lwIUopAntCu8Dd7E49ApII4F7mmqpUyaW+04/CV
         jU8dok6WDTRsA==
Message-ID: <4432311d-887b-3010-b9bd-09a5867f620d@collabora.com>
Date:   Tue, 14 Feb 2023 20:15:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 11/12] riscv: dts: starfive: jh7100: Add sysmain and gmac
 DT nodes
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-12-cristian.ciocaltea@collabora.com>
 <34d5e299-3b4b-d176-0010-a9af1220f2e3@linaro.org>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <34d5e299-3b4b-d176-0010-a9af1220f2e3@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/23 11:26, Krzysztof Kozlowski wrote:
> On 11/02/2023 04:18, Cristian Ciocaltea wrote:
>> Provide the sysmain and gmac DT nodes supporting the DWMAC found on the
>> StarFive JH7100 SoC.
>>
>> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>> ---
>>   arch/riscv/boot/dts/starfive/jh7100.dtsi | 38 ++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
>> index 88f91bc5753b..0918af7b6eb0 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
>> +++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
>> @@ -164,6 +164,44 @@ rstgen: reset-controller@11840000 {
>>   			#reset-cells = <1>;
>>   		};
>>   
>> +		sysmain: syscon@11850000 {
>> +			compatible = "starfive,jh7100-sysmain", "syscon";
>> +			reg = <0x0 0x11850000 0x0 0x10000>;
>> +		};
>> +
>> +		gmac: ethernet@10020000 {
> 
> Aren't the nodes ordered by address?

Right, I missed the ordering trying to keep the related nodes together. 
Will fix.

Thanks,
Cristian

> Best regards,
> Krzysztof
> 
> 
