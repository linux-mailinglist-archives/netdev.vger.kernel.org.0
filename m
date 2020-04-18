Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFEB1AF200
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 18:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgDRQCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 12:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgDRQCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 12:02:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5199BC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:02:21 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g6so2727566pgs.9
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 09:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OiivdM0L1Upy7dKfpmkkEhqPcQJ7m3Ww6U3GpH7JbOc=;
        b=SjCVrrUwmak0cgST+Iywsl4Dzfoj/ACntpy97tTCfIaap871NrAwFrIwVR9K1ZBvWa
         Fi/TKHi3I/R3APREMT4IJ5y8qAGIZBinVQ9qJNH5wecC/ZAimRakXMbxmqOZZfBAX61p
         hV1bKgNPZ3FYsPKna6woYlgRvpOmZxLbQ/17Jq5Q5o+NWQhlH2tAGNPn4BoaoDqu/Rg8
         BQiVA+lONGcD8RcbKyXDwQEuiiXZrNX2BenC5YrTZR7SMILdi9H/5oFg+ReJV2K23aWO
         mslmf7mJNYPQu4XXuF7TLmqD7hJjPVvVz02xMDUpZzLFPytAhOrXpCQeFCtGcFxBn045
         udmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OiivdM0L1Upy7dKfpmkkEhqPcQJ7m3Ww6U3GpH7JbOc=;
        b=CvrZPjbo/591cUUrHOejJGrSWdUBvWQP4kzo1eO7vvceSHKa75Ss/Wll2+X90rtszw
         Aou7LJR0OtDxSQFTJcPjjDMSqJPtbqCdnWitorvtjTU5qZDvcKZc6gUqm/pAhz0hT2qN
         UONpKfZnmdNc2Jph7KS2zIvvb7f9vAZG0eSBHSGC03qtQz4UA22FA39Lva5ymxvVWQO4
         kmzn5ouK2Zt8XVqiWo8U0dzKUc+/ELpNt0IxkZPvCN9tJf/vUN78mD6Vpe0hwcykVotN
         hiKl4A1CbV5BwNhyBPIIzwIo5FYeob/TmthiLsDts9foefPWat5PIawXUNwC68K17gEM
         LQPA==
X-Gm-Message-State: AGi0PuafNo+O9SHe8DiPJrCml1o93AjLxiTYgqlgQymVcSRy1MYZ14pA
        PHe/UC6u27CdqGRMCoPGOi8=
X-Google-Smtp-Source: APiQypKYpA3uRWIDCUJ9CM5dYlGaxPageCKwyuzHAhaH0klfeIudwztkd28eCQNz3BN26hAWoOrLFg==
X-Received: by 2002:a63:6a84:: with SMTP id f126mr8411538pgc.14.1587225740821;
        Sat, 18 Apr 2020 09:02:20 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d17sm21012011pgk.5.2020.04.18.09.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 09:02:19 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: fec: Allow the MDIO
 preamble to be disabled
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-4-andrew@lunn.ch>
 <bde059d8-5a95-d32b-7e28-ac7385cc0415@gmail.com>
 <20200418142758.GC804711@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <32ef6ee0-f535-c09f-f76d-c394f6763aef@gmail.com>
Date:   Sat, 18 Apr 2020 09:02:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418142758.GC804711@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/2020 7:27 AM, Andrew Lunn wrote:
>> This is a property of the MDIO device node and the MDIO bus controller as
>> well, so I would assume that it has to be treated a little it like the
>> 'broken-turn-around' property and it would have to be a bitmask per MDIO
>> device address that is set/clear depending on what the device support. If it
>> is set for the device and your controller supports it, then you an suppress
>> preamble.
> 
> Again, i don't see how this can work. You need all the devices on the
> bus to support preamble suppression, otherwise you cannot use it. As
> with a maximum clock frequency, we could add the complexity to check
> as bus scan time that all devices have the necessary property, but i
> don't think it brings anything.

With your current patch I can define 'suppress-preamble' for the FEC 
MDIO node, and if there is at least one device on the bus that does not 
support preamble suppression, they are not going to work, so if nothing 
else you need to intersect between the device capability and the MDIO 
bus controller capability. Same comments as patch #2 about we could 
approach this.
-- 
Florian
