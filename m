Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC33DD115
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhHBHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 03:20:22 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16119 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232475AbhHBHUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 03:20:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627888812; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=FJaar6n31/KsrmSPJWQ9jmxpQoRbAsgaDgmJ7zbo9Ow=;
 b=Xj3UI//IWFjGlPK3KodqolY5rH8uPm8baqc032xrUu4Eij7uU1JvC/HbwUXBv2du2GniyKtQ
 U2KRNWkO9PXckhf3LKen80BHIUgchIiWOve53NLJ9tN/MTGSFLi+2j+A5PNm0aUL9W/0Uz3/
 DtOTvIPC4LSDUMFmntrydk3AwFk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 61079c97b653fbdadd75f06c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Aug 2021 07:19:51
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AA122C4323A; Mon,  2 Aug 2021 07:19:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 43F96C433D3;
        Mon,  2 Aug 2021 07:19:48 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 02 Aug 2021 15:19:48 +0800
From:   luoj@codeaurora.org
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gross, Andy" <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        devicetree@vger.kernel.org, Sricharan <sricharan@codeaurora.org>
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
In-Reply-To: <CAL_Jsq+=Vyy7_EQ_A7JW4ZfqpPU=6eCyUYMnPORChGvefw-yTA@mail.gmail.com>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-3-luoj@codeaurora.org>
 <CAL_Jsq+=Vyy7_EQ_A7JW4ZfqpPU=6eCyUYMnPORChGvefw-yTA@mail.gmail.com>
Message-ID: <7873e70dcf4fe749521bd9c985571742@codeaurora.org>
X-Sender: luoj@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-30 01:29, Rob Herring wrote:
> On Thu, Jul 29, 2021 at 6:54 AM Luo Jie <luoj@codeaurora.org> wrote:
>> 
>> rename ipq4019-mdio.yaml to ipq-mdio.yaml for supporting more
>> ipq boards such as ipq40xx, ipq807x, ipq60xx and ipq50xx.
>> 
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>  ...m,ipq4019-mdio.yaml => qcom,ipq-mdio.yaml} | 32 
>> ++++++++++++++++---
>>  1 file changed, 28 insertions(+), 4 deletions(-)
>>  rename Documentation/devicetree/bindings/net/{qcom,ipq4019-mdio.yaml 
>> => qcom,ipq-mdio.yaml} (58%)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml 
>> b/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
>> similarity index 58%
>> rename from 
>> Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
>> rename to Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
>> index 0c973310ada0..5bdeb461523b 100644
>> --- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
>> +++ b/Documentation/devicetree/bindings/net/qcom,ipq-mdio.yaml
>> @@ -1,10 +1,10 @@
>>  # SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>  %YAML 1.2
>>  ---
>> -$id: http://devicetree.org/schemas/net/qcom,ipq4019-mdio.yaml#
>> +$id: http://devicetree.org/schemas/net/qcom,ipq-mdio.yaml#
>>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>> 
>> -title: Qualcomm IPQ40xx MDIO Controller Device Tree Bindings
>> +title: Qualcomm IPQ MDIO Controller Device Tree Bindings
>> 
>>  maintainers:
>>    - Robert Marko <robert.marko@sartura.hr>
>> @@ -14,7 +14,9 @@ allOf:
>> 
>>  properties:
>>    compatible:
>> -    const: qcom,ipq4019-mdio
>> +    oneOf:
>> +      - const: qcom,ipq4019-mdio
>> +      - const: qcom,ipq-mdio
> 
> This is more than the commit log suggests. A generic compatible by
> itself is not sufficient. If other chips have the same block, just use
> 'qcom,ipq4019-mdio'. They should also have a compatible for the new
> SoC in case it's not 'the same'.
> 
> Also, use 'enum' rather than oneOf plus const.
> 
> Hi Rob
> Thanks for the comments, will keep the compatible "qcom,ipq4019-mdio" 
> unchanged,
> and add the new compatible name by using 'enum' in the next patch set.
> the commit log will be updated in the next patch set.
>> 
>>    "#address-cells":
>>      const: 1
>> @@ -23,7 +25,29 @@ properties:
>>      const: 0
>> 
>>    reg:
>> -    maxItems: 1
>> +    maxItems: 2
> 
> This breaks compatibility because now 1 entry is not valid.
> 
> will update it by using "minItems: 1, maxItems: 2" in the next patch 
> set.
> 
>> +
>> +  clocks:
>> +    items:
>> +      - description: MDIO clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: gcc_mdio_ahb_clk
>> +
>> +  resets:
>> +    items:
>> +      - description: MDIO reset & GEPHY hardware reset
>> +
>> +  reset-names:
>> +    items:
>> +      - const: gephy_mdc_rst
> 
> These all now apply to 'qcom,ipq4019-mdio'. The h/w had no clocks or
> resets and now does?
> 
> You don't need *-names when there is only 1.
> 
> Hi Rob
> thanks for the comment, clocks is for configuring the source clock of 
> MDIO bus,
> which is apply to ipq4019 and the new chip set such as ipq807x, ipq50xx 
> and ipq60xx,
> which is not configured because of uboot configuring it, kernel should 
> not depends on
> the configuration of uboot, so i add it.
> will remove the *-name in the next patch set.
> 
>> +  phy-reset-gpios:
>> +    maxItems: 3
>> +    description:
>> +      The phandle and specifier for the GPIO that controls the RESET
>> +      lines of PHY devices on that MDIO bus.
> 
> This belongs in the phy node since the reset is connected to the phy.
> 
> since the phylib code can't satisfy resetting PHY in IPQ chipset, 
> phylib resets phy by
> configuring GPIO output value to 1, then to 0. however the PHY reset in 
> IPQ chipset need
> to configuring GPIO output value to 0, then to 1 for the PHY reset, so 
> i put the phy-reset-gpios here.
> 
>> 
>>  required:
>>    - compatible
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
