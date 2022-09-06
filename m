Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07B85AF247
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239496AbiIFRRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiIFRRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:17:14 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D57795ADC;
        Tue,  6 Sep 2022 10:06:12 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id f4so8643636qkl.7;
        Tue, 06 Sep 2022 10:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8sd1XUbOAaqPt2UCp3leBFo+ZTg1rtmlDOW2QOnPSY4=;
        b=UpW2c3Q5SPY5cpVDcDaldZhV6TrTm9uikL8Sd8wiKKD4SaxIUKoPBHv2xlT/0T+O7L
         wCu7F64Ybkzrdh56zxEGQXeG/IpapGwwmx77FSCnENV9Lu9pLSapSlNaENmkBhniPZKy
         w6Xwd68F9ZzNULGVSCZJyeyNRsKXvudlclI4hJgOSnjlExEJTYgxpdIh3HftxjAmzRB8
         W4L/L2C++Ddmcov4GGvSGX1RATzP2qgW6Bi7UoCtEDbqJh1KLK/z9sOQ8XiwbNcp7tfP
         BP+CR9ko7ggnxxhmKNfrdlBr8CTO506lDq917+e8kVpuy/xtkM/vHIAloK4gcW+xfZ1a
         O8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8sd1XUbOAaqPt2UCp3leBFo+ZTg1rtmlDOW2QOnPSY4=;
        b=bDCLVGf4w3Un4RvtgTncmqc27k+NYjxmRkczagbANgAIsMHnkUG9S7wcZnC6ZXPxrc
         2BgkyqqXctbJcpN4DXjE8+gqarhU/hZu2C1WwCcacW6MFrOwL8X2OVy4BZNyhiHJ49Rh
         2CigNLj7Dn2krUeDloOTNdUfQJxLWT4GnCDPh7O/gqgkgulOIjVZjVmr2JcCYaTEBZ+1
         c3Te9iJh6b44oJnf4JotJIa9BMvZDN7Ly+x2misMod/E2FZWDO2z5YV6lghwBhwYfQkG
         nLucEHnAQ7OYy1EuPB0G1ShZieeR/ntDUAcu1t/Xp9/3PU8BeurGWAUB9qZFwgk4uYmZ
         XSAA==
X-Gm-Message-State: ACgBeo3S7oIy7vy3FQcS5kvym5ikFDGowLyveYiXrFoDCCSuWLnVhIe5
        b8YAMkFuDS/eQEF38jHEvyA=
X-Google-Smtp-Source: AA6agR5Fh76feQksNNuMqw8LuVW2nPF1DLvwm04cZ58xFgMHtAIHU/k+SKMVvtgd5SOemtCLL7r4Kg==
X-Received: by 2002:a05:620a:4089:b0:6bb:97e6:d5b1 with SMTP id f9-20020a05620a408900b006bb97e6d5b1mr37512666qko.117.1662483948729;
        Tue, 06 Sep 2022 10:05:48 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id fp5-20020a05622a508500b0031e9ab4e4cesm9876026qtb.26.2022.09.06.10.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 10:05:48 -0700 (PDT)
Message-ID: <45cdae58-632a-7cbb-c9d5-74c126ba6a3e@gmail.com>
Date:   Tue, 6 Sep 2022 10:05:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 2/2] ARM: dts: aspeed: elbert: Enable mac3
 controller
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Tao Ren <rentao.bupt@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220905235634.20957-1-rentao.bupt@gmail.com>
 <20220905235634.20957-3-rentao.bupt@gmail.com> <YxaS2mS5vwW4HuqL@lunn.ch>
 <YxalTToannPyLQpI@taoren-fedora-PC23YAB4> <Yxc1N1auY5jk3yJI@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Yxc1N1auY5jk3yJI@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/6/2022 4:55 AM, Andrew Lunn wrote:
> On Mon, Sep 05, 2022 at 06:41:33PM -0700, Tao Ren wrote:
>> Hi Andrew,
>>
>> On Tue, Sep 06, 2022 at 02:22:50AM +0200, Andrew Lunn wrote:
>>> On Mon, Sep 05, 2022 at 04:56:34PM -0700, rentao.bupt@gmail.com wrote:
>>>> From: Tao Ren <rentao.bupt@gmail.com>
>>>>
>>>> Enable mac3 controller in Elbert dts: Elbert MAC3 is connected to the
>>>> onboard switch directly (fixed link).
>>>
>>> What is the switch? Could you also add a DT node for it?
>>>
>>>>
>>>> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
>>>> ---
>>>>   arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts | 11 +++++++++++
>>>>   1 file changed, 11 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
>>>> index 27b43fe099f1..52cb617783ac 100644
>>>> --- a/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
>>>> +++ b/arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts
>>>> @@ -183,3 +183,14 @@ imux31: i2c@7 {
>>>>   &i2c11 {
>>>>   	status = "okay";
>>>>   };
>>>> +
>>>> +&mac3 {
>>>> +	status = "okay";
>>>> +	phy-mode = "rgmii";
>>>
>>> 'rgmii' is suspicious, though not necessarily wrong. This value is
>>> normally passed to the PHY, so the PHY inserts the RGMII delay. You
>>> however don't have a PHY. So i assume the switch is inserting the
>>> delay? Again, being able to see the DT properties for the switch would
>>> be useful.
>>>
>>>     Andrew
>>
>> Thank you for the quick review!
>>
>> The BMC mac3 is connected to BCM53134P's IMP_RGMII port, and there is no
>> PHY between BMC MAC and BCM53134P. BCM53134P loads configurations from
>> its EEPROM when the chip is powered.
> 
> So i assume you have the switch RGMII port doing the delays. That is
> fine.
> 
>> Could you please point me an example showing how to describe the switch in
>> dts? Anyhow I will need to improve the patch description and comments in
>> v2.
> 
> It looks like drivers/net/dsa/b53 does not support this particular
> switch. You could consider extending the driver. See
> 
> Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> 
> for documentation of the binding.

Correct the 53134 is not supported at the moment by the b53 driver, 
however it should not be too hard to support it, if you would be willing 
to add it, I would be glad to review patches.
-- 
Florian
