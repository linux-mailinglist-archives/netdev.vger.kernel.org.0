Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41EBB9C03
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 05:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404897AbfIUDDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 23:03:01 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35933 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730800AbfIUDDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 23:03:01 -0400
Received: by mail-ot1-f65.google.com with SMTP id 67so7848713oto.3;
        Fri, 20 Sep 2019 20:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6gFD/fDRv/9BVI9TlIlHkBgJAj7cIjjTmLQI72YYXcA=;
        b=FxJnbU/8qi91ikGeF2YAGu5W/1MPutptBXbL8re5lWxx+cWXoxbobbRKcumzlelA6P
         WpFRjCVPALLTnqdzLBJfXl8lnQaWmpU/dHbVxodCDPiMuCZd2uxztCJmV3yPRfnarKFd
         iKPRuSkJEU50iPEaxqL5HbCQOi7iUlUxXNzuQUFeR5565ICTrAxsLp1JDJh70H57rTGJ
         KNRyJkGgxvzdv1T5gSG6AMZqr6PuBpAYmrcCoiF9GEnl4FnSD0zWOr1IrlPgSrMFBFyi
         Oq5O1FjToa/c+/3UeUn0ClVH4hD9td56yn9fnRHoTCM2SR7YNB3sVdK0y7LGGNTsu4fr
         kItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6gFD/fDRv/9BVI9TlIlHkBgJAj7cIjjTmLQI72YYXcA=;
        b=Z78K2ILDW7W4+qkl1HDI34D/Df1dRbmU9AAz8UdLFzf1aOObswQLyKGHvOQdx7KYtE
         vtrS49NqUOcej2b1D/iY5RR+9k7Q/nlME4ZTTT3LcAbtGHBwqgVm03LT9uszBFEGtDpI
         pMCiJMTpYXaIEQvNyHv7UeqYTn03L5cppN0ERFEbmlAzoq02qjHYk2M/2/2rHWK7nRzQ
         75b05v8G6Wf29VjiixUBr0Y589ch7Bt/abaYd6EHwDSt0BtqQgy2qZrgt54MrGrhyZ+V
         TkLRj6mQVq+o9Px3rcfJn6Qz/B2TAbWLE+XC+x+nbmw6yuvLt+knBHlGWViCFHN3U647
         5AJA==
X-Gm-Message-State: APjAAAWL14xnd7me+tsFbCWhpDHLvdZQY4i673MH5tntSLnaovjXg3Tf
        Ir6GRngAomsMHKcCwYi/FyxT6gGhENA=
X-Google-Smtp-Source: APXvYqyXPVkDY7hQglG0MvS65/Unv3MrmHtIShSvZEG+9S/nXwMYGG5g6aOny/42LS499QCusEQFug==
X-Received: by 2002:a05:6830:10d8:: with SMTP id z24mr2271108oto.281.1569034980487;
        Fri, 20 Sep 2019 20:03:00 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o184sm1244843oia.28.2019.09.20.20.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Sep 2019 20:02:58 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: net: dwmac: fix 'mac-mode' type
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, andrew@lunn.ch
References: <20190917103052.13456-1-alexandru.ardelean@analog.com>
 <20190920181141.52cfee67@cakuba.netronome.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f189cdbc-b399-7700-a39a-ba185df4af49@gmail.com>
Date:   Fri, 20 Sep 2019 20:02:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190920181141.52cfee67@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2019 6:11 PM, Jakub Kicinski wrote:
> On Tue, 17 Sep 2019 13:30:52 +0300, Alexandru Ardelean wrote:
>> The 'mac-mode' property is similar to 'phy-mode' and 'phy-connection-type',
>> which are enums of mode strings.
>>
>> The 'dwmac' driver supports almost all modes declared in the 'phy-mode'
>> enum (except for 1 or 2). But in general, there may be a case where
>> 'mac-mode' becomes more generic and is moved as part of phylib or netdev.
>>
>> In any case, the 'mac-mode' field should be made an enum, and it also makes
>> sense to just reference the 'phy-connection-type' from
>> 'ethernet-controller.yaml'. That will also make it more future-proof for new
>> modes.
>>
>> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> 
> Applied, thank you!
> 
> FWIW I had to add the Fixes tag by hand, either ozlabs patchwork or my
> git-pw doesn't have the automagic handling there, yet.

AFAICT the ozlabs patchwork instance does not do it, but if you have
patchwork administrative rights (the jango administration panel I mean)
then it is simple to add the regular expression to the list of tags that
patchwork already recognized. Had tried getting that included by
default, but it also counted all of those tags and therefore was not
particularly fine grained:

https://lists.ozlabs.org/pipermail/patchwork/2017-January/003910.html
-- 
Florian
