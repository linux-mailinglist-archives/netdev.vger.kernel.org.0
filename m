Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0670404263
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 02:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348903AbhIIAuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 20:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348785AbhIIAue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 20:50:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A47C061575;
        Wed,  8 Sep 2021 17:49:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v123so224288pfb.11;
        Wed, 08 Sep 2021 17:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jygdQMiPw131dCidRv/jbT/kjv2witVO1njP9GetZBY=;
        b=ZU8FJrSTcKYVKDe1tUi6qYJRXLs5jeU0/VwMq3Nyy1VWNS8ZTcEuz2gI5M8h6Qvt6e
         xUMN6ndZ9wvLcwulHqVnV0OB92+VVZaYzndh9j0D1IhbYPoIbMgTkzd5IbPvd9/NU3l7
         8JeKMKdygrfcaFuIY6s0RQwoqiERSBUAMmLWeoepRNey/pXInd1ktZ+1O63P5fcdIRBD
         AWaGlIGuco0uW+kKFy7KUTiZtiCj7WgoduM3KFFBF2S40rPJt2IwSlv8dyrE4GKnh03r
         dEKOTPuxjpDR9VUpwFse6wtH2y6ExUyD+CG0bJCJ168O5gjfW31oWwDhcKHVnJy1vMZ1
         Ri3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jygdQMiPw131dCidRv/jbT/kjv2witVO1njP9GetZBY=;
        b=FYnW0GwFDhKyQfOciI885y2ttbCrK4zhEKuvsAqMkwLUNs+tOrmtZCO54Tr9jHXi8I
         KbZJ+T5vx+mtphvftGeS0GQZhRlQ89/4bE/PZ2cKPdvykWghk3UCwt4jXRCyM60FL5uy
         r44oJWIW4pqUOkvpREe1N1hORvXZigvyVn/wLIsMj2Mw4sI/C2pmdVlyeyvuGFfOiM5U
         V4wxyLm5qoI3Wy8MgIzrCkPYYYsd3Mvj562PcOli76wXetKy3InBr1npvgQH/tlx1v3x
         WYNBb7wpGagElc3HeTPgkGRokQrhjo3qHTEw9y5bCicH2OWSE1vqW3ieaujU3EDbxUs/
         cujQ==
X-Gm-Message-State: AOAM533GPbiA7L0yIEF3EqUGGsveI5M6qmssHIyQZsoTSGPFDaALvpD5
        TV/iSytN6abb/5eoyKzsfNQ=
X-Google-Smtp-Source: ABdhPJwQ+TEB1BgDArhmskEEy0wdi/R4u1f+o1NxVCZqbwAWoua+WjrLwCkiUC3Ae7n3FWbTogDH4w==
X-Received: by 2002:a63:2047:: with SMTP id r7mr183578pgm.398.1631148565119;
        Wed, 08 Sep 2021 17:49:25 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y11sm77788pfl.198.2021.09.08.17.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 17:49:23 -0700 (PDT)
Message-ID: <7e59ae19-ffba-9515-c6a9-c413bb89d240@gmail.com>
Date:   Wed, 8 Sep 2021 17:49:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: Circular dependency between DSA switch driver and tagging
 protocol driver
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210908220834.d7gmtnwrorhharna@skbuf>
 <e0567cfe-d8b6-ed92-02c6-e45dd108d7d7@gmail.com>
 <20210909002601.mtesy27atk7cuyeo@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210909002601.mtesy27atk7cuyeo@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2021 5:26 PM, Vladimir Oltean wrote:
> On Wed, Sep 08, 2021 at 03:14:51PM -0700, Florian Fainelli wrote:
>>> Where is the problem?
>>
>> I'd say with 994d2cbb08ca, since the tagger now requires visibility into
>> sja1105_switch_ops which is not great, to say the least. You could solve
>> this by:
>>
>> - splitting up the sja1150 between a library that contains
>> sja1105_switch_ops and does not contain the driver registration code
> 
> I've posted patches which more or less cheat the dependency by creating
> a third module, as you suggest. The tagging protocol still depends on
> the main module, now sans the call to dsa_register_switch, that is
> provided by the third driver, sja1105_probe.ko, which as the name
> suggests probes the hardware. The sja1105_probe.ko also depends on
> sja1105.ko, so the insmod order needs to be:
> 
> insmod sja1105.ko
> insmod tag_sja1105.ko
> insmod sja1105_probe.ko
> 
> I am not really convinced that this change contributes to the overall
> code organization and structure.

Yes, I don't really like it either, maybe we do need to resolve the 
other dependency created with 566b18c8b752 with a function 
pointer/indirect call that gets resolved at run-time, assuming the 
overhead is acceptable.

> 
>> - finding a different way to do a dsa_switch_ops pointer comparison, by
>> e.g.: maintaining a boolean in dsa_port that tracks whether a particular
>> driver is backing that port
> 
> Maybe I just don't see how this would scale. So to clarify, are you
> suggesting to add a struct dsa_port :: bool is_sja1105, which the
> sja1105 driver would set to true in sja1105_setup?

Not necessarily something that is sja1105 specific, but something that 
indicates whether the tagger is operating with its intended switch 
driver, or with a "foreign" switch driver (say: dsa_loop for instance).

> 
> If this was not a driver I would be maintaining, just watching as a
> reviewer, I believe "no" is what I would say to that.
> 

-- 
Florian
