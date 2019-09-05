Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8BFAA9EF
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 19:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbfIERXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 13:23:37 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40061 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732590AbfIERXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 13:23:37 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so2183638pfb.7;
        Thu, 05 Sep 2019 10:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1l6gOYgbY/8S5SuKPJEtRablfkztDo49+Znc3rixGCM=;
        b=cvmGJgqPmVAuGDHTFTtOKuLvvF8PEu2ArODEQqt+Zv61WlzcBHvgmhJZSI0HyMsrdD
         gOFAL0I1z7jXYkHBegLHwD/xvtZNMPCVDqzOeW2nSxbZrus6MnTAf0ekqUiSCQyQDdmX
         FquDXCKs6FYRdBadQLHNfAjAqnfrT8rLhaQMJDG5kUbRNheRA2/esFQsd7Ch57+r73EF
         F7/MH1x8tqLt+Lzi8wp0MKTt8jFpQrIjUU6mLwEKZPupWO5y6D1SQgNIQlhrnQ+yHc/L
         sumdRCs7n55z+pOaOHV3KMB8jTfUlFkIklgl6PgMjVgIN4CHuXk4fWjiB/CJjt6Smkcy
         RqHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1l6gOYgbY/8S5SuKPJEtRablfkztDo49+Znc3rixGCM=;
        b=B0kmpLW8L3l3xLtQpk7UyV9H3hTqXHkgMnC07v70/KXSjEYZHAeb3bcTTijZNPsBR0
         gMwOKF6ZqQhlpxovcn0TbI4cCeQ0HUl6MVtgtsejPgTdlKr4f5xfzL/k8cnrmQ0OAiKk
         tL8FtSyriSYe27W2gSpJDyWSDqwk7w1sWuvw+jXS/Dx4gENuvAxTWejk5hikvzCs4Oe+
         xokp3DNbIK7QeJZWlNMFvFU1692/JmymZZWodLA+9+5AGSZqNnkQhoWtuvks9kw3KTWm
         St4bDVu/so/CVH8uCKWTEMr0S6GSAeSEXMhGGHT4Ait2V1jiBdLzjVoUnYc0RiDarE75
         wMzQ==
X-Gm-Message-State: APjAAAX8EtBFNFh84xxsuV7TcC1/sNDYvQP5pgniFlcEzXThfO0L7VDA
        J2ydUaDeL1K+WhpG3H2w6/w=
X-Google-Smtp-Source: APXvYqwNQ6XtulxcHVwMdpNWP/D8PMBP+dZ1m8NBqJpHi1PomT2HgRYzmpDNPuTDS4nzftS7R0NQfA==
X-Received: by 2002:a62:e216:: with SMTP id a22mr5279101pfi.249.1567704216460;
        Thu, 05 Sep 2019 10:23:36 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h66sm9805651pjb.0.2019.09.05.10.23.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 10:23:35 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] ethtool: implement Energy Detect Powerdown support
 via phy-tunable
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
 <20190904162322.17542-2-alexandru.ardelean@analog.com>
 <20190904195357.GA21264@lunn.ch>
 <361eb94a4da73d1fa21893e8e294639f0fc0bcd2.camel@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <1b398b5c-ce16-fee7-6e83-c6cd6bc6c840@gmail.com>
Date:   Thu, 5 Sep 2019 10:23:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <361eb94a4da73d1fa21893e8e294639f0fc0bcd2.camel@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 11:25 PM, Ardelean, Alexandru wrote:
> On Wed, 2019-09-04 at 21:53 +0200, Andrew Lunn wrote:
>> [External]
>>
>> On Wed, Sep 04, 2019 at 07:23:21PM +0300, Alexandru Ardelean wrote:
>>
>> Hi Alexandru
>>
>> Somewhere we need a comment stating what EDPD means. Here would be a
>> good place.
> 
> ack
> 
>>
>>> +#define ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL	0x7fff
>>> +#define ETHTOOL_PHY_EDPD_NO_TX			0x8000
>>> +#define ETHTOOL_PHY_EDPD_DISABLE		0
>>
>> I think you are passing a u16. So why not 0xfffe and 0xffff?  We also
>> need to make it clear what the units are for interval. This file
> 
> I initially thought about keeping this u8 and going with 0xff & 0xfe.
> But 254 or 253 could be too small to specify the value of an interval.
> 
> Also (maybe due ti all the coding-patterns that I saw over the course of some time), make me feel that I should add a
> flag somewhere.
> 
> Bottom line is: 0xfffe and 0xffff also work from my side, if it is acceptable (by the community).
> 
> Another approach I considered, was to maybe have this EDPD just do enable & disable (which is sufficient for the `adin`
> PHY & `micrel` as well).
> That would mean that if we would ever want to configure the TX interval (in the future), we would need an extra PHY-
> tunable parameter just for that; because changing the enable/disable behavior would be dangerous.
> And also, deferring the TX-interval configuration, does not sound like good design/pattern, since it can allow for tons
> of PHY-tunable parameters for every little knob.

It seems to me that the interval is a better way to deal with that, if
you specify a non zero interval, you enable EDPD, even if your PHY can
only act on an enable/disable bit. For PHYs that do support setting a TX
internal, the non-zero interval can be translated into whatever
appropriate unit. In all cases, a 0 interval means disable.

Andrew, does that work  for you?
-- 
Florian
