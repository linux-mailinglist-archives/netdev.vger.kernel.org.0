Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0455E26B2DF
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgIOWyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgIOWyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:54:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480EBC06174A;
        Tue, 15 Sep 2020 15:54:12 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l191so2786270pgd.5;
        Tue, 15 Sep 2020 15:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L2C+dPVYyO3cziOHeg11PzVDpTrm1r0ahIYEXV+L+xc=;
        b=HUWDM7k/ixTdF6CPF7+ArffV1FkahQu/o3t73DVNDxpN8sq0yefJBxvdHHq1zw5+Yf
         VYYYBHIAQVz1S/SAwzN9be6AgCX36neUCGnEk9mNSZJ55Q9ypT3UUDKcSIUjBT19l0m7
         5T8rA7QmUkexPq9BE97Q2epTtgVSISRGbIy/cIjFxnBmB0ToQvNK3/y/a0ZGiPY3L/nY
         Zhc6v0U+ktjmICD49V9hUOt7X5YWagZOFmezFJHALY7OU40KcYCxr84ryfE9sfuhvHmh
         V2BTU1Uv2czdmygZ1Ha8bIIXoEgh7vtL2Bzt6MW66cNGVb2H0gkVQcNkog+/UqHUWNzR
         OpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2C+dPVYyO3cziOHeg11PzVDpTrm1r0ahIYEXV+L+xc=;
        b=spVszMOOSVhc2bXE++bM91GmIop3h4SMDGVcXggkhRqC2SmCzRjt3H2DasCbXsEhqm
         3sz1HVfaSpuXl5T01+QT6+PGB3l5kLDPootFJeqx+ukcGCjl4c6UTciboS3CggWkUd8Y
         dJInrxbJN5gs966LHGa4H5tZUQTIjOdmteniUdo9p4QMRCLP3lSP+4TOfQEWQdx9Qn4k
         cHoG19lvD4ypnVq9G6YKjWeOCPwGB/ofw14oPl2p64Pd9gdz5nghSu96hChOcMUUu6LH
         RiaSd7yyDZh9JUAWcrZRH6eMFj5iMcb3JYWoJUUZi+5hceD6b76VL0wp1p15uVQBx8CF
         Qpfg==
X-Gm-Message-State: AOAM533y3XO63hZBuXQRwXo3co7GaFFioXchnKqRAGPcLGg6xVVASbNT
        rh6yQeFRzrUHGn0bKpTie8E=
X-Google-Smtp-Source: ABdhPJxCnEU8TcwxkbvBJv/LF2Lme7WXHa52bedmzBRgFfASi/GMqcvRIQjYS6TJINzG4WJGyl8UBQ==
X-Received: by 2002:a63:1a05:: with SMTP id a5mr16980916pga.145.1600210451660;
        Tue, 15 Sep 2020 15:54:11 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e19sm14910651pfl.135.2020.09.15.15.54.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 15:54:10 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: stmmac: Add ethtool support for get|set
 channels
To:     David Miller <davem@davemloft.net>, vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com, kuba@kernel.org,
        Joao.Pinto@synopsys.com, arnd@arndb.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        sadhishkhanna.vijaya.balan@intel.com, chen.yong.seow@intel.com
References: <20200915012840.31841-1-vee.khee.wong@intel.com>
 <20200915.154302.373083705277550666.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b945fcc5-e287-73e2-8e37-bd78559944ab@gmail.com>
Date:   Tue, 15 Sep 2020 15:54:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200915.154302.373083705277550666.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2020 3:43 PM, David Miller wrote:
> From: Wong Vee Khee <vee.khee.wong@intel.com>
> Date: Tue, 15 Sep 2020 09:28:37 +0800
> 
>> This patch set is to add support for user to get or set Tx/Rx channel
>> via ethtool. There are two patches that fixes bug introduced on upstream
>> in order to have the feature work.
>>
>> Tested on Intel Tigerlake Platform.
> 
> Series applied, thank you.

patch #2 does not have a proper Fixes: tag format, it should be:

Fixes: cafebabed00d ("some super subject")
-- 
Florian
