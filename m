Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE32686CF4
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 00:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404518AbfHHWL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 18:11:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37735 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfHHWL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 18:11:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id b3so3995421wro.4;
        Thu, 08 Aug 2019 15:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DUFalbPLgQ79S1HKBE8+gtAVHYDFf8kRrltg8JK5gHo=;
        b=GrHFzmpFxtOscokodsO7daDjk84Q/OJ2IZS7SomAGPleaL8JE2NSe9/H13UOWgK5Lx
         Q3trityf98SqSsd2oAE7h0zZmHWKqKLpu6/gg+x0Q7lSDSgNuTbr16deZebwQpkyItcB
         FyEOSWmY6Gl7GPnZQV5Zof3vW4wAVNvZH4+D1x3X1qYdtSv6VQAj9MCnThq4YN3XyCv5
         3PmyiFqrmy/OIS+1CbT5FUz5DzmbPjaBwzbSpqXKMJSl/1Ic3nlVE+ac42rmp5MPP8YD
         bc/1lec7KWPSFPnW54hVXpjcXe47eSsaEMZtqnGFlV+m7JVBaeRP3q4Sa0K5oTmctaq9
         DBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DUFalbPLgQ79S1HKBE8+gtAVHYDFf8kRrltg8JK5gHo=;
        b=JAqdWeDzaSyC3kbgSkHz9LJXEMHiji3BvjjHYv5zxQbGlgxtrVhW4ZeusFZxC4KBTo
         6cGy+68FpGdKn+j7wvTtJj9/2f5V0PEaC12j12Da54tXvH576KHnoUjDUBxxU77MG45h
         8q/e/KlcZHIFbHsH7LN/1csmIPYI4ZmNIiGMZbHF302EM7f3efA9MXvw6FeHsjFQjiBq
         3l434WNaXeuCDbE729QYztqKDMVe9V5310HDa5pDmoCqLrCpbzcUhuvwngn3n8IN4sBP
         QMeXXUnHcNgZDnqK9PXu74XtXMpeQAcw/2m9UhlnklftrecNQ49dmQfT/HjspKtuuwjU
         jJbA==
X-Gm-Message-State: APjAAAWlQgY88zf+PFUHOErNvZOqqTPhEFjW/TemfLI0V4fygPZ7Xzhq
        S3LMyoZb/dZ/d3SE1ALoTuA=
X-Google-Smtp-Source: APXvYqwfedFez8JUUPUSTs97nv45Gikq8yuXYU80pv8ot4OF9lSma2MRIiDYVMaRG3RNKnIa9KedPg==
X-Received: by 2002:a5d:55c2:: with SMTP id i2mr19264141wrw.96.1565302286135;
        Thu, 08 Aug 2019 15:11:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:6862:4959:200d:42a? (p200300EA8F2F320068624959200D042A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:6862:4959:200d:42a])
        by smtp.googlemail.com with ESMTPSA id y18sm3425947wmi.23.2019.08.08.15.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 15:11:25 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
References: <20190806210931.3723590-1-taoren@fb.com>
 <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
 <cfd6e14e-a447-aedb-5bd6-bf65b4b6f98a@gmail.com>
 <a827c44c-3946-8f6f-e515-b476fd375cf6@fb.com>
 <14c1591b-26e1-3a2f-f6c4-beb2c8978e41@fb.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6d080f3e-48b9-a65d-b73e-576296e98738@gmail.com>
Date:   Fri, 9 Aug 2019 00:11:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <14c1591b-26e1-3a2f-f6c4-beb2c8978e41@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 23:47, Tao Ren wrote:
> Hi Heiner,
> 
> On 8/7/19 9:24 PM, Tao Ren wrote:
>> Hi Heiner,
>>
>> On 8/7/19 12:18 PM, Heiner Kallweit wrote:
>>> On 06.08.2019 23:42, Tao Ren wrote:
>>>> Hi Andrew / Heiner / Vladimir,
>>>>
>>>> On 8/6/19 2:09 PM, Tao Ren wrote:
>>>>> The BCM54616S PHY cannot work properly in RGMII->1000Base-KX mode (for
>>>>> example, on Facebook CMM BMC platform), mainly because genphy functions
>>>>> are designed for copper links, and 1000Base-X (clause 37) auto negotiation
>>>>> needs to be handled differently.
>>>>>
>>>>> This patch enables 1000Base-X support for BCM54616S by customizing 3
>>>>> driver callbacks:
>>>>>
>>>>>   - probe: probe callback detects PHY's operation mode based on
>>>>>     INTERF_SEL[1:0] pins and 1000X/100FX selection bit in SerDES 100-FX
>>>>>     Control register.
>>>>>
>>>>>   - config_aneg: bcm54616s_config_aneg_1000bx function is added for auto
>>>>>     negotiation in 1000Base-X mode.
>>>>>
>>>>>   - read_status: BCM54616S and BCM5482 PHY share the same read_status
>>>>>     callback which manually set link speed and duplex mode in 1000Base-X
>>>>>     mode.
>>>>>
>>>>> Signed-off-by: Tao Ren <taoren@fb.com>
>>>>
>>>> I customized config_aneg function for BCM54616S 1000Base-X mode and link-down issue is also fixed: the patch is tested on Facebook CMM and Minipack BMC and everything looks normal. Please kindly review when you have bandwidth and let me know if you have further suggestions.
>>>>
>>>> BTW, I would be happy to help if we decide to add a set of genphy functions for clause 37, although that may mean I need more help/guidance from you :-)
>>>
>>> You want to have standard clause 37 aneg and this should be generic in phylib.
>>> I hacked together a first version that is compile-tested only:
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__patchwork.ozlabs.org_patch_1143631_&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=iYElT7HC77pRZ3byVvW8ng&m=ZJArOJvHqNkqvs1x8l9HjfxjCN8e5xJpPz2YViBuKRA&s=EskpfBQtu9IBVeb96dv-sz76xIz4tJK5-lD4-qdIyWI&e= 
>>> It supports fixed mode too.
>>>
>>> It doesn't support half duplex mode because phylib doesn't know 1000BaseX HD yet.
>>> Not sure whether half duplex mode is used at all in reality.
>>>
>>> You could test the new core functions in your own config_aneg and read_status
>>> callback implementations.
>>
>> Thank you very much for the help! I'm planning to add these functions but I haven't started yet because I'm still going through clause 37 :-)
>>
>> Let me apply your patch and run some test on my platform. Will share you results tomorrow.
> 
> The patch "net: phy: add support for clause 37 auto-negotiation" works on my CMM platform, with just 1 minor change in phy.h (I guess it's typo?). Thanks again for the help!
> 
> -int genphy_c37_aneg_done(struct phy_device *phydev);
> +int genphy_c37_config_aneg(struct phy_device *phydev);
> 
Indeed, this was a typo. Thanks.

> BTW, shall I send out my patch v5 now (based on your patch)? Or I should wait till your patch is included in net-next and then send out my patch?
> 
Adding new functions to the core is typically only acceptable if in the
same patch series a user of the new functions is added. Therefore it's
best if you include my patch in your series (just remove the RFC tag and
set the From: properly).

> 
> Cheers,
> 
> Tao
> 
Heiner
