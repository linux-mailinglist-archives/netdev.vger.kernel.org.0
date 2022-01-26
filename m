Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DAB49C216
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbiAZD2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiAZD2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:28:52 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9BCC06161C;
        Tue, 25 Jan 2022 19:28:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so4874690pjb.3;
        Tue, 25 Jan 2022 19:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=W0/VThFcJa9vLUnJjkFf1P9yWFM1rwFeXTDTDQSnGBM=;
        b=TLSext6CJMcifmjsaLFHRvpQB5XeJWpuLC+zeu2rLqFzYg6TufniIq7rniykXl4+3+
         ERpBjHOwFpjgeXz6jFdBJSN1ZMPajiCIj0cs6W/iBIHtUw5wQoQfKI97GZZKv+FRRNje
         faSsE5f0s2w6IS1wJqyoDCyDrt1HETkrf8/hnkP/53SpwE6ZK4QnGc6LWrx9YmgQziis
         +Kyq7jfRprrI4JgPRNLCKwd0rOd41QClkeb15IDB4wYM2C1VDk+sLhXS1YTeZWZS3JX+
         QZEKqj3F233Z06iptDA2Itj7x+2uPtlSgrS7HmJAF14pTCP62lMo1TRKMWHvkfaZr2kI
         PPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W0/VThFcJa9vLUnJjkFf1P9yWFM1rwFeXTDTDQSnGBM=;
        b=Xb0J5m9fgPgy7CKZAgkhgKf7AUahWad8wTGF2olLRSkroGY2waEjttYpxlPFohzMu8
         xivsEHFiaaCbjuAS9mqz/QIfpLENUUtryd4wpKIWMEf7vF6xpIqFxEEydBN+zDtev2PO
         NWt/SLUIqswx6wWMLgkbGUcJrajq7AM59VNWNUS3CWzffySFfoYn2PqwPp5L7X45zz+T
         EZBZggjg1BBBleYG6audjsPNDGVodueUBq9XzhWxe49Ox9MmWrVno0pRJkxhG8/rmkOV
         AJQYUTqZHN/xxQuJvlnETOOmpOr8Dsnv5I8l9mukx23F1VqIw9aiElpvykAtFDXi0IJU
         3cCA==
X-Gm-Message-State: AOAM532GZIp1V+rabMVbgw3v8ck5+p+sMVh46V2Wpd3x1n73srSmAMZ0
        JAinwm0+48AICFvjJpoqZS/d4LjiIjo=
X-Google-Smtp-Source: ABdhPJyACQPx1bMbYFQpthM6zfRv/NSr332diLDHCP8Sdj0N8GEYeRIai8Mm2mX1WsGsO8X451HYZw==
X-Received: by 2002:a17:902:e74d:b0:14b:4166:35c9 with SMTP id p13-20020a170902e74d00b0014b416635c9mr13841880plf.135.1643167732300;
        Tue, 25 Jan 2022 19:28:52 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l22sm390039pfc.191.2022.01.25.19.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:28:51 -0800 (PST)
Message-ID: <cba84992-17cb-9313-9d84-0ed16e122e40@gmail.com>
Date:   Tue, 25 Jan 2022 19:28:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 05/16] net: dsa: tag_qca: enable promisc_on_master
 flag
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-6-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-6-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Ethernet MDIO packets are non-standard and DSA master expects the first
> 6 octets to be the MAC DA. To address these kind of packet, enable
> promisc_on_master flag for the tagger.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
