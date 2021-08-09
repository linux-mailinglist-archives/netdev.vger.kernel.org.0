Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1173E4602
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhHINDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:03:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52093 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbhHINDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:03:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628514197; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=cbwIb9m2aBLsgyW6JA1PFRM6qSmHBK9Kh5nIILv8l3Q=; b=fG1QRT56QDju7Fc92D1AEAenKY1gzI4Y/8CoJ1q1bwmBaB+0LVgjZc9oXjGpMmORQmXemVN2
 iWZPWbS3a2nqIgid4WhnvtaENhlv+Oi5rZIjkL/tSfqS4RFgLi/bjW9itIHInjLXTR1PybEm
 bSh7gokq/BUFg7f3GDYkBtKZeLM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6111278676c3a9a172f32282 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Aug 2021 13:03:02
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AC847C43217; Mon,  9 Aug 2021 13:03:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.92.0.248] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ADF07C433F1;
        Mon,  9 Aug 2021 13:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ADF07C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
Subject: Re: [PATCH v1 1/2] net: mdio: Add the reset function for IPQ MDIO
 driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20210808072111.8365-1-luoj@codeaurora.org>
 <20210808072111.8365-2-luoj@codeaurora.org> <YQ/4aK3yYPvYQdhD@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <403a4418-88b4-eb4e-47fd-d75bf6cdccf2@codeaurora.org>
Date:   Mon, 9 Aug 2021 21:02:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQ/4aK3yYPvYQdhD@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/8/2021 11:29 PM, Andrew Lunn wrote:
>> +	/* Configure MDIO clock source frequency if clock is specified in the device tree */
>> +	if (!IS_ERR_OR_NULL(priv->mdio_clk)) {
> Please document the clock in the binding. Make it clear which devices
> require the clock, and which don't.
>
> 	Andrew
sure, will document it in the next patch set, thanks Andrew.
