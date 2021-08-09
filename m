Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544CB3E4622
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhHINHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:07:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:64277 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhHINHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:07:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628514436; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=syRAAEn6ukIppn65P9Lof264WUDrsD4lX0IMZ1u8oAc=; b=cJ0cuNo/ujxW630UEagllJjfsfJmWdCfEey821v38LyVPu/4j19s43tf7r6kilJxGPFbas+P
 q5LY2bGD+oDeI1dDl6zHGP+PdiKItH7ceQRSKC+N63pWEjY9f4Zf+jhevnxpN7BU+IB4AJH8
 bH2xjzinehnhuC3aGjuXwyTFCd0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6111286ab14e7e2ecb3b40a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Aug 2021 13:06:50
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B7AE4C43144; Mon,  9 Aug 2021 13:06:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.92.0.248] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD19CC433D3;
        Mon,  9 Aug 2021 13:06:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DD19CC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
Subject: Re: [PATCH] dt-bindings: net: Add the properties for ipq4019 MDIO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
References: <20210808075328.30961-1-luoj@codeaurora.org>
 <YQ/8q6gR6Eji2hKD@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <ba6f3daa-7b1c-dd66-f803-c049e1fc3e8a@codeaurora.org>
Date:   Mon, 9 Aug 2021 21:06:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQ/8q6gR6Eji2hKD@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/8/2021 11:47 PM, Andrew Lunn wrote:
> On Sun, Aug 08, 2021 at 03:53:28PM +0800, Luo Jie wrote:
>> The new added properties resource "reg" is for configuring
>> ethernet LDO in the IPQ5018 chipset, the property "clocks"
>> is for configuring the MDIO clock source frequency.
>>
>> This patch depends on the following patch:
>> Commit 2b8951cb4670 ("net: mdio: Add the reset function for IPQ MDIO
>> driver")
> Please always make binding patches part of the series containing the
> driver code. We sometimes need to see both to do a proper review.
>
> Add a comment about when the second address range and clock is
> required. Does qcom,ipq5018-mdio require them?
>
> 	  Andrew

Hi Andrew,

yes, the second address range is only required for qcom,ipq5018-mdio 
currently,

will document it in next patch set, and send it with the drive code 
patch, thanks

for the comments and review.

