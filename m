Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DED27B7AD
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgI1XOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgI1XNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46CBC0613AA
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 15:36:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d6so2532928pfn.9
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 15:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ptT+kHVH87AS1XwlMJP6AmlSGv7p10hMAs8v4IiNMLg=;
        b=qsyQQIMPRsBSzmFK2ZUoTfdkdF0xHWjdk8mcV4/EhfLxAjAGEQWe8fxW02KGQM3rlt
         Ev3b6URhaJEDTFZhEx6/XvUxL0a9zwtE01Hl7bhvbnXOL853R3nJK4J/5MAP8dRaPc5x
         TAmRGNTLo+Cw7c7wQ43dvDC5kVEofwkVGaV086jawKKnekSeHaltT+z6Ljf4ak7TWU6U
         ziUeiPAMo5kFoeQDm8PuCUZDI9oi29ucBZTO3SJ4BLquQ9tV+e68zQ0Z6shvsFXfFHC2
         YIvuIxlk9/uEtPqXJ/tfTvigSheWvHQRWsbSdZ33XYUQz3O1SZ0W6Zch81k2mFOB+5mf
         u3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ptT+kHVH87AS1XwlMJP6AmlSGv7p10hMAs8v4IiNMLg=;
        b=miiuPbAGhkgBctiqqdUfKSZrWMdDOYhwLLPYW7jar0h9q14x3auGC+UYGyiz2BBr2+
         uaVaB0VVlCpGFD1lm96Taf0vuzLfYYvaviveuePsSAkY9O4DxHe1C80cA/7R2E3TU6R8
         xGFa4eTIh/GYN/M6odfOJ4I1GM+BgVwV2oeFPxHZK0X4IzAN26Cm2aCTpAZQO/HtTWP/
         4WQFAtF8mZUm7ed276cSej9kUn8Zz/GOisdVWQ4rMRcvaOR8lad2H79rLOfU8NU3F6kS
         git4Q44N2PBYkoFo6oedpsiG7LxbRtAUMn11UbyBYldMC6QWMfoWb4CVlZpMR+rHpFG0
         AhyA==
X-Gm-Message-State: AOAM530gm9IkIxz7F3L8OHFdPwqgYReMTRTVRRNzmMREB8KjogBCn7MN
        zFfRKjbtDhX3Uzj69A/S+eqES8tqJU64DQ==
X-Google-Smtp-Source: ABdhPJyzjKatm29sRBtMUzIxNU5zvHadwX9k2c05RbnrzBfbC/LfmncT7rr7M9ecgTIxUgPXcieGFw==
X-Received: by 2002:aa7:8ec7:0:b029:13e:d13d:a080 with SMTP id b7-20020aa78ec70000b029013ed13da080mr1410700pfr.23.1601332612390;
        Mon, 28 Sep 2020 15:36:52 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e10sm2539345pgb.45.2020.09.28.15.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 15:36:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf> <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
Date:   Mon, 28 Sep 2020 15:36:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/2020 3:35 PM, Jakub Kicinski wrote:
> On Tue, 29 Sep 2020 00:07:30 +0200 Andrew Lunn wrote:
>> On Mon, Sep 28, 2020 at 10:05:08PM +0000, Vladimir Oltean wrote:
>>> On Mon, Sep 28, 2020 at 02:31:55PM -0700, Jakub Kicinski wrote:
>>>> On Sat, 26 Sep 2020 23:06:26 +0200 Andrew Lunn wrote:
>>>>> Not all ports of a switch need to be used, particularly in embedded
>>>>> systems. Add a port flavour for ports which physically exist in the
>>>>> switch, but are not connected to the front panel etc, and so are
>>>>> unused.
>>>>
>>>> This is missing the explanation of why reporting such ports makes sense.
>>>
>>> Because this is a core devlink patch, we're talking really generalistic
>>> here.
>>
>> Hi Vladimir
>>
>> I don't think Jakub is questioning the why. He just wants it in the
>> commit message.
> 
> Ack, I think we need to clearly say when those should be exposed.
> Most ASICs will have disabled ports, and we don't expect NICs to
> suddenly start reporting ports for all PCI PFs they may have.
> 
> Also I keep thinking that these ports and all their objects should
> be hidden under some switch from user space perspective because they
> are unlikely to be valuable to see for a normal user. Thoughts?

Hidden in what sense? They are already hidden in that there is no 
net_device object being created for them. Are you asking for adding 
another option to say, devlink show like:

devlink show -a

which would also show the ports that are disabled during a dump?
-- 
Florian
