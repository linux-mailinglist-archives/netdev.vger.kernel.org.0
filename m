Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5AC438159
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhJWB4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 21:56:38 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:59818 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhJWB4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 21:56:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634954060; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=7dGf38pZUs6IEWVOM5eMZ7cDqKy8omQd+uK12KjLWAs=; b=T25v0YBShpmyNBKHxRvVjYIRfkye6GKjWvvCamGDug2FeaWxe0fL94fyBG/wuXVCxJbnCuJg
 SIP0s/JOOWsbv/Uhwsx1eFxOXp4j++EZY9ewIQUp0MnRKHm6mDB+jjS8DPcs7chQSUi/R9iu
 6l+Ymj2fSi2oSUBiZEdZNgpDJuM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 61736b47b03398c06c5fdd78 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 01:54:15
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 58CE0C4360D; Sat, 23 Oct 2021 01:54:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.192.232.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6871C43460;
        Sat, 23 Oct 2021 01:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C6871C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v4 02/14] net: phy: at803x: use phy_modify()
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211022120624.18069-1-luoj@codeaurora.org>
 <20211022120624.18069-3-luoj@codeaurora.org>
 <YXKrcxYAJukg71xB@shell.armlinux.org.uk>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <2ca852f6-dbd5-8909-65d2-377adb918c33@quicinc.com>
Date:   Sat, 23 Oct 2021 09:54:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXKrcxYAJukg71xB@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/22/2021 8:15 PM, Russell King (Oracle) wrote:
> On Fri, Oct 22, 2021 at 08:06:12PM +0800, Luo Jie wrote:
>> Convert at803x_set_wol to use phy_modify.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> On v3, Andrew gave you a reviewed-by. You need to carry that forward
> especially if nothing has changed.
>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Thanks Russell for this comments, will follow it.
