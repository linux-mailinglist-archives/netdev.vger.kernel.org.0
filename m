Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC643E9C9D
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 04:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhHLCkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 22:40:24 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:21807 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233657AbhHLCkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 22:40:23 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628735999; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=gGtLADnj2gs/ip4HZpP6uDr7CN7RCI+Ft8v06A1nAnY=; b=U4Y5olVO0egUvGe4Wt2gJMSNDR+5AAyTEtKDoeaKCItCfQlN/75LH2Q4954Xtpqj8qdRnQ1D
 80xanQ/PQkjhzKgaRVWP6SYDxI0JdJkYxhxUxugmdD7drK27AOlZZsMcc0GKi3qdNoBg84J5
 7x8uwMHzyGJ6L6sIKdZHBpcc8YU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 611489fe66ff107904cfb3bc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 12 Aug 2021 02:39:58
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AE1E8C43144; Thu, 12 Aug 2021 02:39:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.92.0.248] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E638AC433D3;
        Thu, 12 Aug 2021 02:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E638AC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
Subject: Re: [PATCH v2 1/3] net: mdio: Add the reset function for IPQ MDIO
 driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robert.marko@sartura.hr,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
References: <20210810133116.29463-1-luoj@codeaurora.org>
 <20210810133116.29463-2-luoj@codeaurora.org> <YRPlZGXWJGoLRSSN@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <fb49c1e3-c4f6-0d72-0def-8cae734fc3ff@codeaurora.org>
Date:   Thu, 12 Aug 2021 10:39:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRPlZGXWJGoLRSSN@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/11/2021 10:57 PM, Andrew Lunn wrote:
>> +	ret = clk_prepare_enable(priv->mdio_clk);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
> This can be simplified to just:
>
>       return clk_prepare_enable(priv->mdio_clk);
>
>       Andrew
Thanks Andrew for the comments, will update it in the next patch set.
