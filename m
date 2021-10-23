Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B13438156
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 03:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhJWBzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 21:55:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30386 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhJWBzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 21:55:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634954015; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=BWKus6riFmjWLgZFRlxtsgG9no9xXvNiHcpiG4OSZGg=; b=EIeTsbeH1TJBApcVs1VBw/BGFzo4ehoSJoD3oFG89Q2GbF1KFwbP3C7MygBHc6gPoQLGrs9O
 XgHyDFxmDW6+X/NtV1k0W11/TYCqCaFHSI3ykjEeQoEUF9oyXF751gyVpEwyb0TQQFFNAi0W
 LeLssejygxIOMciBDvKR6kO0Tls=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 61736b125baa84c77bcfae60 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 23 Oct 2021 01:53:22
 GMT
Sender: quic_luoj=quicinc.com@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E5F49C4360D; Sat, 23 Oct 2021 01:53:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.1.4] (unknown [183.192.232.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2D92C4338F;
        Sat, 23 Oct 2021 01:53:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E2D92C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=fail (p=none dis=none) header.from=quicinc.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=quicinc.com
Subject: Re: [PATCH v4 01/14] net: phy: at803x: replace AT803X_DEVICE_ADDR
 with MDIO_MMD_PCS
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20211022120624.18069-1-luoj@codeaurora.org>
 <20211022120624.18069-2-luoj@codeaurora.org>
 <YXKq6j/CnQ/i34ZB@shell.armlinux.org.uk>
From:   Jie Luo <quic_luoj@quicinc.com>
Message-ID: <c943c86e-bbd9-746a-cfda-647b31af337f@quicinc.com>
Date:   Sat, 23 Oct 2021 09:53:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXKq6j/CnQ/i34ZB@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/22/2021 8:13 PM, Russell King (Oracle) wrote:
> On Fri, Oct 22, 2021 at 08:06:11PM +0800, Luo Jie wrote:
>> Replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS defined in mdio.h.
>>
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> On v3, Andrew gave you a reviewed-by. You need to carry those forward
> especially if the patches have not changed.
>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Thanks Russell for this reminder, will follow it.
