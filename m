Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580084A7E40
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 04:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349178AbiBCDMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 22:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiBCDMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 22:12:37 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B396BC061714;
        Wed,  2 Feb 2022 19:12:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id c9so993057plg.11;
        Wed, 02 Feb 2022 19:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NAhMrFZQeNDBkJpbYRD6IEkL9w93Ap7KlDmraSYx1To=;
        b=gWQCeVgbHHp1TMiq2/9/gqCh0Tw3UZdPzKPORGgtGQP/Ro4jIiE86rtEI/0in+CsHR
         8olIJ1zgba4PzHge8/UMjLTWcThmU3pXiTRIKbOWk0HMvlLw3nnZi3X9YfmZCDMzoGah
         2J16SFfcuIO12thlzBYmATFIn67Y1mQfGBqOyDpkLRm8rTUt5OLUmlqCxzr2JAT+XWxI
         6dc1Zwn12QAGSVfomgyF8vUL51WKYFfeGNsw1qG826Q0S53Vm/6H7NjLOP67sekUzNr7
         0OB1e3vFTm1sQkCm9JGt2sL8zC2Y77uAlM2AzmtIInaIJhfkjNDIoJHUx+MQqn5EpFVP
         sFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NAhMrFZQeNDBkJpbYRD6IEkL9w93Ap7KlDmraSYx1To=;
        b=gg/zOTrxU6k3/2qeOjb9qru0ARasWb0KLYb4X54cuTWBZW7oVeTKtNsveLuOJfeImq
         AIU/v+NbtirrkvslVwD6GSfKU0STPxKBiDVo35I46pWGzo8WQMUwVgxGMWQukye8D8mK
         JK2xtQtWRIt+F4FgeoP8U6jD1DrEKOQoBK7AvfWxTyPyVTRWdjbYD+RbP+W97/JLwkQI
         fBt/gBV6roKrehPEFOmxwdDnhcjopwaOS3I/RPEoDj7pak5/R2dDrZr23Mvr/oI2HF0Q
         8Gh4t4gEFE8+Uzn0+RA24nJ/+n70Qc8h7nCKf685B6guWNFxevGk8uDqnhJd0MAF9QOu
         KP7A==
X-Gm-Message-State: AOAM530jzZuoaSFNbbND1llT5+bTrBBSyqeIeomPpBNacRLBhIJ9Mw2m
        ojWioxZzrVSTxUbK10cnNGU=
X-Google-Smtp-Source: ABdhPJy3gc/WNtFS/PIoGEfVJysFHHBkocWMwmoO+TbrVAJjrDVKY9dQRcFBh9P6XZ+mh5uAPxbGIw==
X-Received: by 2002:a17:902:c412:: with SMTP id k18mr34478958plk.68.1643857956962;
        Wed, 02 Feb 2022 19:12:36 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id c11sm18455840pgl.92.2022.02.02.19.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 19:12:36 -0800 (PST)
Message-ID: <c732e1ce-8c9c-b947-8d4b-78903920a5b2@gmail.com>
Date:   Wed, 2 Feb 2022 19:12:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YfspazpWoKuHEwPU@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/2022 5:01 PM, Andrew Lunn wrote:
>> As a person responsible for boot firmware through kernel for a set of
>> boards I continue to do the following to keep Linux from mucking with
>> various PHY configurations:
>> - remove PHY reset pins from Linux DT's to keep Linux from hard resetting PHY's
>> - disabling PHY drivers
>>
>> What are your thoughts about this?
> 
> Hi Tim
> 
> I don't like the idea that the bootloader is controlling the hardware,
> not linux.

This is really trying to take advantage of the boot loader setting 
things up in a way that Linux can play dumb by using the Generic PHY 
driver and being done with it. This works... until it stops, which 
happens very very quickly in general. The perfect counter argument to 
using the Generic PHY driver is when your system implements a low power 
mode where the PHY loses its power/settings, comes up from suspend and 
the strap configuration is insufficient and the boot loader is not part 
of the resume path *prior* to Linux. In that case Linux needs to restore 
the settings, but it needs a PHY driver for that.

If your concern Tim is with minimizing the amount of time the link gets 
dropped and re-established, then there is not really much that can be 
done that is compatible with Linux setting things up, short of 
minimizing the amount of register writes that do need the "commit phase" 
via BMCR.RESET.

I do agree that blindly imposing LED settings that are different than 
those you want is not great, and should be remedied. Maybe you can 
comment this part out in your downstream tree for a while until the LED 
binding shows up (we have never been so close I am told).
-- 
Florian
