Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031253FC8B5
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbhHaNuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:50:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:19644 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhHaNtN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 09:49:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630417697; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=HeUHkfUk/Hs2C59A6/TUUJIsZA1M5PNUO7ZWX+hYyNo=; b=ABNU6t0RiexPnZLCP2pePQGwMNaJIKBaJTiq0gRAjKoP3rLAYE+StwFPpSFw8Kkey12bSAGT
 Sc1A64rU5Q48Mhmq3jqvzefKfLNWVUMxQWJr9nE1Cphxc96P7krhwsrAuUjnHanPU6sJFPdO
 Yxb5YCssrhNFQvoFybMrcUhFVXo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 612e331e4cd90150378c566a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 31 Aug 2021 13:48:14
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 422AAC43460; Tue, 31 Aug 2021 13:48:14 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=ham autolearn_force=no version=3.4.0
Received: from [192.168.10.117] (unknown [183.192.232.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4500C4338F;
        Tue, 31 Aug 2021 13:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E4500C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH v1 2/3] net: phy: add qca8081 ethernet phy driver
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20210830110733.8964-1-luoj@codeaurora.org>
 <20210830110733.8964-3-luoj@codeaurora.org>
 <20210830113950.GX22278@shell.armlinux.org.uk>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <cea89489-fd38-c6c7-cae9-c9b9a198c662@codeaurora.org>
Date:   Tue, 31 Aug 2021 21:48:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830113950.GX22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/30/2021 7:39 PM, Russell King (Oracle) wrote:
> On Mon, Aug 30, 2021 at 07:07:32PM +0800, Luo Jie wrote:
>> +/* AN 2.5G */
>> +#define QCA808X_FAST_RETRAIN_2500BT		BIT(5)
>> +#define QCA808X_ADV_LOOP_TIMING			BIT(0)
>>
>> +/* Fast retrain related registers */
>> +#define QCA808X_PHY_MMD1_FAST_RETRAIN_CTL	0x93
>> +#define QCA808X_FAST_RETRAIN_CTRL_VALUE		0x1
> These are standard 802.3 defined registers bits - please add
> definitions for them to uapi/linux/mdio.h.
>
> Thanks.
will add definitions for the standard registers in the next patch set, 
thanks Russell for the comments.
