Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413005ED7C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfGCU2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:28:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42269 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCU2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:28:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id a10so3130089wrp.9;
        Wed, 03 Jul 2019 13:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IDdbRLiXCB65ziZYGfUuZK0iXp9TkXgdisLvBRs8jaY=;
        b=mCC5Njw7GStxXaKNTXARfVVNIV+nFsxO6MmEi+jNoVd8mNoh1//b8pnNh4PLjz+6wF
         JBwW4E0zD6yjqS4DBwkqXjjNnHpDn9sbUZS05NGKW5NtHl8rVtix9gyf3k4cSeePmmTd
         OYnP6nkSuxw13YpLr1+g35oK1zTuqtBEBT3dVnr/lg0cwXq7oMFMObMbLwp4SqXGPX0X
         7OrJcyfj8Z7KoynzP3qqGMOk9fF8cQqffO6ZiRcamEZE7duWOsXUX+ab0lPr0kr1hAGg
         Pq295HlsHLgwsFhpfuvQa4Dq+O/IFRhDBhWdhvCfhZKb4xa6yN0RbWz0OW9Y6Jh+ZtxF
         IRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IDdbRLiXCB65ziZYGfUuZK0iXp9TkXgdisLvBRs8jaY=;
        b=rtwshVG1AYOQ/2Uqfjs66K1ZBt0zpmBaC1cq1845TQyrs9vnK+2WY89Zvsu2SfNLn1
         69h0AqfO92OycxSoFckhanNBNaU3B46/pSHrlgoi3ccrqJ+LPLgM2IJc6npF7bKOOGXr
         VaKHxlJXx1n4BM1h9Q96r2aGk+gAugwudSfax3L7wb+mKRh9rXQ6kkMErvBIU5e97VEm
         hVtnI6JWkNedvkXTDTcEWtaBBtq3/V7Dgt4tMQpEOxY5ixLhGcMlzJpbcZCPwRKkHSw9
         7017zNG44hB5N/zd+sUeu90rvOZ6/qlwojIfsn/sA0QuZUxHuZ6VtcKw6E3dsCcHEmIu
         2SRQ==
X-Gm-Message-State: APjAAAUsW208/tqGzN6NrWG0IhRUtHFJfSpdRCs1QLltLi1dgFDHTypp
        gGONZSgOpbh+1Yj1Ps3Na/ykNZKj
X-Google-Smtp-Source: APXvYqwbIo6riFOMJ1u6NjGAiNONXGCGelLqGoX9+1HEMIKIld8vupONM7TtIn9RDWkbcpr4UulPoQ==
X-Received: by 2002:adf:a55b:: with SMTP id j27mr24033584wrb.154.1562185710395;
        Wed, 03 Jul 2019 13:28:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id f204sm5096570wme.18.2019.07.03.13.28.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:28:29 -0700 (PDT)
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e7fa2c8c-d53e-2480-d239-e2c0b362dc4f@gmail.com>
Message-ID: <f25dedfc-d961-f278-3e55-9f0574557f84@gmail.com>
Date:   Wed, 3 Jul 2019 22:22:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e7fa2c8c-d53e-2480-d239-e2c0b362dc4f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 22:13, Heiner Kallweit wrote:
> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
>> The LED behavior of some Realtek PHYs is configurable. Add the
>> property 'realtek,led-modes' to specify the configuration of the
>> LEDs.
>>
>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>> ---
>> Changes in v2:
>> - patch added to the series
>> ---
>>  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
>>  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
>>  2 files changed, 26 insertions(+)
>>  create mode 100644 include/dt-bindings/net/realtek.h
>>
>> diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
>> index 71d386c78269..40b0d6f9ee21 100644
>> --- a/Documentation/devicetree/bindings/net/realtek.txt
>> +++ b/Documentation/devicetree/bindings/net/realtek.txt
>> @@ -9,6 +9,12 @@ Optional properties:
>>  
>>  	SSC is only available on some Realtek PHYs (e.g. RTL8211E).
>>  
>> +- realtek,led-modes: LED mode configuration.
>> +
>> +	A 0..3 element vector, with each element configuring the operating
>> +	mode of an LED. Omitted LEDs are turned off. Allowed values are
>> +	defined in "include/dt-bindings/net/realtek.h".
>> +
>>  Example:
>>  
>>  mdio0 {
>> @@ -20,5 +26,8 @@ mdio0 {
>>  		reg = <1>;
>>  		realtek,eee-led-mode-disable;
>>  		realtek,enable-ssc;
>> +		realtek,led-modes = <RTL8211E_LINK_ACTIVITY
>> +				     RTL8211E_LINK_100
>> +				     RTL8211E_LINK_1000>;
>>  	};
>>  };
>> diff --git a/include/dt-bindings/net/realtek.h b/include/dt-bindings/net/realtek.h
>> new file mode 100644
>> index 000000000000..8d64f58d58f8
>> --- /dev/null
>> +++ b/include/dt-bindings/net/realtek.h
>> @@ -0,0 +1,17 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _DT_BINDINGS_REALTEK_H
>> +#define _DT_BINDINGS_REALTEK_H
>> +
>> +/* LED modes for RTL8211E PHY */
>> +
>> +#define RTL8211E_LINK_10		1
>> +#define RTL8211E_LINK_100		2
>> +#define RTL8211E_LINK_1000		4
>> +#define RTL8211E_LINK_10_100		3
>> +#define RTL8211E_LINK_10_1000		5
>> +#define RTL8211E_LINK_100_1000		6
>> +#define RTL8211E_LINK_10_100_1000	7
>> +
>> +#define RTL8211E_LINK_ACTIVITY		(1 << 16)
> 
> I don't see where this is used.
> 
Clear now, disregard my comment.

>> +
>> +#endif
>>
> 

