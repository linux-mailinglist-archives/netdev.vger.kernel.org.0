Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0813DF9B7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 04:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhHDChz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 22:37:55 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:18666 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhHDChy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 22:37:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628044663; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=AdSZAOo3QXrorQizvhdg24/idcUVBek6kZg6Gp4D9Vc=; b=d4zu13j3wj5Krrky0THi9x+FClZstFcLNgtQ0HaOgtNOab6XHVyUEmMiLxETDwCxzVAPzZn3
 hGkVyItND8cMTQ3f73zMXmBn0q+Wh/OQGMpwEUGRQbWyQDNtcqV7hikuwYmsXF9knbZnPS0M
 29alZIsiS0IN1Ql1+pW7oKFPjjM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 6109fd64ebcbc9cec91f3966 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 04 Aug 2021 02:37:24
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4CAB6C43144; Wed,  4 Aug 2021 02:37:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.253.66.187] (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E5D9C433F1;
        Wed,  4 Aug 2021 02:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E5D9C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
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
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-3-luoj@codeaurora.org>
 <CAL_Jsq+=Vyy7_EQ_A7JW4ZfqpPU=6eCyUYMnPORChGvefw-yTA@mail.gmail.com>
 <7873e70dcf4fe749521bd9c985571742@codeaurora.org> <YQf1jdsUc8S7tTBy@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <0eb8f82a-c03c-8ec5-7ac4-7835dd935c73@codeaurora.org>
Date:   Wed, 4 Aug 2021 10:37:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQf1jdsUc8S7tTBy@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/2/2021 9:39 PM, Andrew Lunn wrote:
>>> since the phylib code can't satisfy resetting PHY in IPQ chipset, phylib
>>> resets phy by
>>> configuring GPIO output value to 1, then to 0. however the PHY reset in
>>> IPQ chipset need
>>> to configuring GPIO output value to 0, then to 1 for the PHY reset, so i
>>> put the phy-reset-gpios here.
> Look at the active low DT property of a GPIO.
>
>       Andrew

> thanks Andrew, will update it in the next patch set.
