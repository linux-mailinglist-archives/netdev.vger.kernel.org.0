Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5482624B0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgIIB73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIB72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:59:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CD0C061573;
        Tue,  8 Sep 2020 18:59:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c196so884414pfc.0;
        Tue, 08 Sep 2020 18:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i6vFWRATUewCpPOCeqQP4fBvdgN+chU/ovOOEnHG4tM=;
        b=oDXkbJj5EmvD5KJ++1BKzoRWMqxWPHJqll+tsD6Xoryn95LLMmjFzsehnI+d4ox+if
         j/yZPEX/KDspv75w95F3wVCiVdaAUrnu64+hi886Q6/OOJZgMywW3Jq7/pRao4dRpvVM
         NdJ1EGy4KJYARDLcEwdqUG9z9zt5Ujr5s3M0Ww9DxHvse3mLUAk29ZKGtLerAItJiM/q
         m6rxOW3d/vBUDe7NDc9rbhaPRcuUFWcU4qdtIz8yTug5RFnpFYSm033JEjoFEY7U+zuf
         B9LThY5jpaBUr3FF71P573tIBT6/PNJzNJ6qZ4TpHAQcW4je7f1rqzEk65xbkUTO5UqR
         u+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6vFWRATUewCpPOCeqQP4fBvdgN+chU/ovOOEnHG4tM=;
        b=WHuJEitSQ0Uwre9UVIu883bZB1RAiCe6CGNVh7ttib8UtjtUU9V3JKkZAZ22SvpD5l
         4eP3Uoi1E6cFVqrbMhe4KHcYeQFXc/HtRUocXOP769/lkw3HcQAsYW1t2wFgIz6WgAXv
         KwGEdobXr778zXQj0QspDrxPCWwJvEYqDZRR8ihZ1yoe4oq1Ntxg7FyRX1nGNAxMhDVq
         S5W//f2zgwlwo9W6QE3+tBvbz1703mvU8blwsReN7ZX/2BrCtfgqqdtpRI9WVsVK2PX/
         xM+RYy/zgu3lMoWBNWDheRYnXIIXAVhjMArc+/HAEA5GmNeAA1lKHjmawnHzXuqbDFre
         5s+w==
X-Gm-Message-State: AOAM531dW0rMKyy9dRcNtrHCaTSxLPDljmoDuU008jTtDM0X+IpA9r6+
        mIcbTaBbH3E+zxO834eigeCmA9vsHZE=
X-Google-Smtp-Source: ABdhPJymH0ovvuo+Rmn6YvaBWJESjWa8TuRFOZOuf6NLVqsaNBzyxNRDfIqQVRLD5LF2cFpkoL23Gw==
X-Received: by 2002:a17:902:441:b029:d0:89f4:621f with SMTP id 59-20020a1709020441b02900d089f4621fmr1946007ple.7.1599616767794;
        Tue, 08 Sep 2020 18:59:27 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p9sm390769pjm.1.2020.09.08.18.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 18:59:26 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] dt-bindings: net: phy: smsc: document reference
 clock
To:     Marco Felsch <m.felsch@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
 <20200908112520.3439-4-m.felsch@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8b5aec15-18c2-73fb-ad14-19703a2ffdda@gmail.com>
Date:   Tue, 8 Sep 2020 18:59:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200908112520.3439-4-m.felsch@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2020 4:25 AM, Marco Felsch wrote:
> Add support to specify the reference clock for the phy.
> 
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
