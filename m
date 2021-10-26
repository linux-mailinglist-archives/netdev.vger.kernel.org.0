Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F086D43B2D1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbhJZNDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:03:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:54331 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236114AbhJZNDW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 09:03:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635253258; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=1k3zGJ4rl06XKaEt7rtFd3UZK/aFUbT8lcdHtHYHL0c=; b=F0eL2IAln6m1iQiHWFECXfqygUyqRVoUbgnbeY7Pq7V5pFH+MUI+w+kuSkfif0AO8LmFM0sb
 ecfHXCYLjy0cfP+EfF8jh2BCmNEujWt5/0LVZjhVkUqo39rUHrVxOunJ2fuSEo0I1USVTbJZ
 KRRKCg0B5J0wOliNMHbCW8uS37A=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6177fbe7b03398c06ce69e26 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Oct 2021 13:00:23
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 51B74C43619; Tue, 26 Oct 2021 13:00:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.92.1.38] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 52593C4338F;
        Tue, 26 Oct 2021 13:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 52593C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH] net: phy: fixed warning: Function parameter not described
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211026102957.17100-1-luoj@codeaurora.org>
 <YXfaAfSfPTaTTpVf@shell.armlinux.org.uk>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <1e2c14d5-0d9c-e288-f2c6-0b29c5ce93e0@quicinc.com>
Date:   Tue, 26 Oct 2021 21:00:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXfaAfSfPTaTTpVf@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/26/2021 6:35 PM, Russell King (Oracle) wrote:
> On Tue, Oct 26, 2021 at 06:29:57PM +0800, Luo Jie wrote:
>> Fixed warning: Function parameter or member 'enable' not
>> described in 'genphy_c45_fast_retrain'
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>   drivers/net/phy/phy-c45.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
>> index b01180e1f578..db709d30bf84 100644
>> --- a/drivers/net/phy/phy-c45.c
>> +++ b/drivers/net/phy/phy-c45.c
>> @@ -614,6 +614,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_loopback);
>>   /**
>>    * genphy_c45_fast_retrain - configure fast retrain registers
>>    * @phydev: target phy_device struct
>> + * @enable: enable fast retrain or not
>>    *
>>    * Description: If fast-retrain is enabled, we configure PHY as
>>    *   advertising fast retrain capable and THP Bypass Request, then
> Patch itself is fine, but I wonder why we've started getting
> Description: prefixes on new functions in this file whereas the
> bulk of the descriptions in the file do not use that prefix.

Thanks Russell for the review. i see the prefix "Description" is also 
used in the

file phy.c.

> In any case, for this patch:
>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>
> Thanks.
>
