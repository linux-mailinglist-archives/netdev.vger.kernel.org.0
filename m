Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9A643830A
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhJWKLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 06:11:40 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61213 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhJWKLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 06:11:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634983761; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=8r0u4wEsrbWPZjLz0OfeebwILxlsOucWP5LkIJgPIaI=; b=TUd7J1WQvwRlXMzw3B6zONnrK+TXtg8zKBr8AhmQJVKHR+o/HhlAAaUD4+rtHSJek6lA0wrS
 03cOYQGPv1ILML335e2P8BPZ1urHBAIXzdMxo4rfS+X5epdZLGfFha8mRZKO1aMOlqoW6Zum
 Yo0zlasGW5G93DQuKnUxipH88wY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6173df4114914866fa632253 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 10:09:05
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9DE20C4360D; Sat, 23 Oct 2021 10:09:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.192.232.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 80F58C4338F;
        Sat, 23 Oct 2021 10:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 80F58C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v6 01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR
 with MDIO_MMD_PCS
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211023095453.22615-1-luoj@codeaurora.org>
 <20211023095453.22615-2-luoj@codeaurora.org>
 <YXPcczBI2Keg8i8s@shell.armlinux.org.uk>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <7755cacf-09e3-19f5-6976-10c323eee750@quicinc.com>
Date:   Sat, 23 Oct 2021 18:08:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXPcczBI2Keg8i8s@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/23/2021 5:57 PM, Russell King (Oracle) wrote:
> On Sat, Oct 23, 2021 at 05:54:40PM +0800, Luo Jie wrote:
>> Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> This is still wrong. Andrew reviewed it, and then I did. I gave you a
> reviewed tag as well.
Thanks Russell for the review comment, i will add it in the next patch 
set V7.
