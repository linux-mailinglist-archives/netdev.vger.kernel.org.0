Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054C944F7E9
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 13:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhKNMho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 07:37:44 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:38037 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236090AbhKNMhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 07:37:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636893264; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=HVRsN9vwc/sETBKRnZmJjyWP055/SwC0n0BaeHe47UE=;
 b=FhRmIzhBeMHK3PdD79U2RHMKKmXwQFpUtLahGnTFz6UfJHR9AtDPGHXnyPL9Z5kd3OA6MSoL
 8FMu9/e+wgUXYHrtEIXJ+Unw50VthNv5OfdSr1FIVDDeSaaXvk4WzuwNB1wQYDgNqDLQ+KNS
 NIUoOpnLucZ6vusFwOU+/T0YIjw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6191023de10f164c25b3019c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 14 Nov 2021 12:34:05
 GMT
Sender: zijuhu=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E7562C43460; Sun, 14 Nov 2021 12:34:03 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: zijuhu)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C97C0C4338F;
        Sun, 14 Nov 2021 12:34:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 14 Nov 2021 20:34:01 +0800
From:   zijuhu@codeaurora.org
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, rjliao@codeaurora.org, kuba@kernel.org,
        bgodavar@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        devicetree@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Subject: Re: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add device tree
 bindings for QTI bluetooth MAPLE
In-Reply-To: <YY6eD/r3ddU7PUxJ@robh.at.kernel.org>
References: <1635837069-1293-1-git-send-email-zijuhu@codeaurora.org>
 <YY6eD/r3ddU7PUxJ@robh.at.kernel.org>
Message-ID: <18c17ac0a622f6d0b86b39b28cecea5f@codeaurora.org>
X-Sender: zijuhu@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-13 01:02, Rob Herring wrote:
> On Tue, Nov 02, 2021 at 03:11:09PM +0800, Zijun Hu wrote:
>> From: Zijun Hu <quic_zijuhu@quicinc.com>
> 
> Subject space is valuable, don't say things twice:
> 
> dt-bindings: net: bluetooth: Add Qualcomm MAPLE
> 
> Is MAPLE an SoC? Everything else used part numbers, why not here?
> 
thanks for your reply, please ignore this patch bcz part of the patch 
series is refused.

MAPLE is a name of BT controller which is integrated within a Soc, so it 
doesn't regular part number.

>> 
>> Add device tree bindings for QTI bluetooth MAPLE.
>> 
>> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
>> ---
>>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml 
>> b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
>> index f93c6e7a1b59..9f0508c4dd16 100644
>> --- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
>> +++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
>> @@ -23,6 +23,7 @@ properties:
>>        - qcom,wcn3998-bt
>>        - qcom,qca6390-bt
>>        - qcom,wcn6750-bt
>> +      - qcom,maple-bt
>> 
>>    enable-gpios:
>>      maxItems: 1
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum, a Linux Foundation Collaborative Project
>> 
>> 
