Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC4E492D5B
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbiARSdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 13:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiARSds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:33:48 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3913C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 10:33:47 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id s11so18618996ioe.12
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 10:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HYbcBty+eqU0m28cpPNJQp5pmTZpDtqmzk4bh+1XrhM=;
        b=bj8BxbGBYPKxvzgg25fr3qoCnc2ubvZVHoSSeN0GqD9UigATBE1A48rWWRqYtFpcw3
         9SEB7m8LmUd645vduZ4kIZnmFayoWOJHVGOI2+EtD8LS84vk+0qARxFMBz1O5oKFk9C8
         vzrtPrRSehymmw1Jf1leUWNJBuxxZYQ1uivNqycG3005gtylTuTDitqZ/GUYMqrSsRZA
         dzoPWz3akJULQZ3J3m5vChsDA2EM9zsHqTfjpRiOe47SIAto+1EaBWtVg1kGM62MZyhO
         Z1IAtjMCwXwWfmz4gft+jSsjhrbl0w5IMCnHGCgEFDqgjjakAFQU6KzJuPhAaHTd3gC4
         F5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HYbcBty+eqU0m28cpPNJQp5pmTZpDtqmzk4bh+1XrhM=;
        b=UiP/cwKVLFDiUUaE3N19Z5rx1j8cCKKgwCzbWiUVljVbGMpQnoqa0lXWVR5xJRSZs0
         wmbPakP2Cao1T/95SDWXM7C6FYqTzR4ir9g8/g8g0t7EL1Nerr1p3ME34M7oabCv5qxa
         5YrD0KFuDEPKm/0ciute+erOL0scbMIUzQS1Y1/gFzhbkyxsvB1sgWDukYCrLskRozJB
         Dw/ipCENDP0ZoryW9Si8XlpYEA/m1j5X7BNRVCjVypwjdIcdUQrnq2DO10URxv4B+tlA
         XIH8AMNDh+GeKVXWJmnBvXKZSWKhKxXZFeqqwCABs5IpM9T1kBuRrIv/ADXP+QMYlS2k
         4+iQ==
X-Gm-Message-State: AOAM533nwVwEewUYkT5BXKg+MDV1BYbv/vLp6XPAB0qVrRC2m67ALoNA
        NzbW5en06XQZVE492hw6LARSBQ==
X-Google-Smtp-Source: ABdhPJyTqOxapHFi2hILAj3NfIRs5SIsBeAXgjjCmSpfBUYg5pJ2qPVnlIN/zUToAZNeGVCGoZEsWQ==
X-Received: by 2002:a05:6602:1548:: with SMTP id h8mr8489488iow.91.1642530824949;
        Tue, 18 Jan 2022 10:33:44 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w6sm11983635ilv.18.2022.01.18.10.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 10:33:44 -0800 (PST)
Message-ID: <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
Date:   Tue, 18 Jan 2022 12:33:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring, v2 (RFC)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeLk3STfx2DO4+FO@lunn.ch>
 <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
 <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 12:30 PM, Jakub Kicinski wrote:
> On Tue, 18 Jan 2022 11:37:05 -0600 Alex Elder wrote:
>> I'm basically ready to go on this, either way (using a
>> misc device, or--preferably--using a netdev).
>>
>> I'm just trying to avoid getting that fully working,
>> then learning when I submit patches that someone thinks
>> it's the wrong way to go about it.
>>
>> If a netdev is acceptable, my remaining issues are:
>> - Whether/how to avoid having the device be treated
>>     as if it needed support from the network stack
>>     (i.e., as a "real" network interface, serving to
>>     send and receive packets).
>> - Similar, whether there are special configuration
>>     options that should be used, given the device's
>>     purpose.
>> - What to call this functionality.  I'll avoid "mirror"
>>     and will try to come up with something reasonable,
>>     but suggestions are welcome.
> 
> I can't claim that my opinions on this sort of stuff are very stable
> but I like Andrew's suggestion and I'd even say maybe just debugfs...
> 
> We try hard to prevent any abuse of netdevs for carrying what is not
> real networking traffic and keep the semantics clear. netdevs are not
> meant as an abstraction, they are more of an exception to the
> "everything is a file" Unix rule.
> 
> Another thing that could possibly work is devlink traps and
> DEVLINK_TRAP_ACTION_MIRROR, but again, not sure if we want to bend that
> interface which has pretty nice and clear semantics to support a vendor
> use case which is an aberration from our forwarding model in the
> first place...
> 
> So I'd do something simple in debugfs and if anyone really cares about
> the forwarding details put the real effort into modeling/controlling
> the forwarding with Linux.

This is nice, clear guidance.

I'm going to work through that design and will send one
more RFC as my proposal.  It'll be somewhat short...

Thank you very much!

					-Alex


