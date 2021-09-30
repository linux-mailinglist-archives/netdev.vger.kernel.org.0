Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C445D41DC47
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349746AbhI3ObS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348126AbhI3ObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:31:16 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C11C06176A;
        Thu, 30 Sep 2021 07:29:33 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u18so26243464lfd.12;
        Thu, 30 Sep 2021 07:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7zNReFsiR9GlBgh8OErMyFvjMC9S/ZuWsLI5xMLDm3g=;
        b=Ojt/7NUyCNR6hCeEnHzXa/311xlbRLS1wsz6K/2egRaJTaA/tefSdMEWJZgM6UHnRZ
         TwgX4sga/4VmfUL+dpz7G2pKAuwG5IynkudrRrpAhLG4gO1s+YnhumOr+VgaQvqDruVh
         yrqKoDD6yilLh+IvGpsZzP29Yh5bm4YDY/X7LvCtm0CCOXBHb8hpChqKLyJ66538f9la
         FROpP7npOMpQcmMFkcSCl+ozspYF++0c9G05G1UUsMslIXJ59Cjq9kXf+LIrHCBAtCiK
         TyqqE1YxmxqJwarabLwdmjZLO+JjIf9RQIxpXwWSEOBqnIA+m5Ho6MvgoJuso7/s0K59
         mopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7zNReFsiR9GlBgh8OErMyFvjMC9S/ZuWsLI5xMLDm3g=;
        b=kJF4LaqBfVPCwwWatkUI0PFLxfWkA714Tj9AyCm6Fs/3PKd2w32gv5hBuzZJKF5UEw
         KL2+RbW7mJbMy9bwGlHcs3TLF4R9SZ92fz/D2VCX6ePjzBM7dyjUfgkBIYr7kYl2MWmS
         6gt6lfaJO+aNXOhLk54q5dXcAmxlV/q2fWcnjdPYzkvpok8v7DW1jUBnDHAZfWUa5UfQ
         voLAxwWb5xlbUJQpk6gJ6zFIR5Gm2w/OYIVPXkM1qBC6GC8i2q06Dil+C3ujR8j49P8n
         lzGAqGCmaaH1sVesPCReUJiQbDDv5nFrMWdE7OAtm8vC61AKWApmM4qswWlGMwMINGs8
         gUtA==
X-Gm-Message-State: AOAM531HCCd+hQLSZpf4DHtbK1HBUNzNJGdFf7GA6jdt27QXusPJEZW8
        H5n4/bBhzjyR/z5tJBGgwJY=
X-Google-Smtp-Source: ABdhPJxOQmm8wk1i7Zs7d0uMFPmNY/Lj1ybxC07H58iZoDKaVyFbXrbTTXKpFCUAJZyq6BLv1PNyuw==
X-Received: by 2002:a05:6512:10ca:: with SMTP id k10mr6102844lfg.315.1633012167031;
        Thu, 30 Sep 2021 07:29:27 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id d26sm397469ljj.45.2021.09.30.07.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 07:29:26 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bgmac: support MDIO described in DT
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210920123441.9088-1-zajec5@gmail.com>
 <168e00d3-f335-4e62-341f-224e79a08558@gmail.com>
 <79c91b0e-7f6a-ef40-9ab2-ee8212bf5791@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <780a6e7f-655a-6d79-d086-2eefd7e9ccb6@gmail.com>
Date:   Thu, 30 Sep 2021 16:29:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <79c91b0e-7f6a-ef40-9ab2-ee8212bf5791@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.09.2021 19:57, Rafał Miłecki wrote:
> On 20.09.2021 18:11, Florian Fainelli wrote:
>> I believe this leaks np and the use case is not exactly clear to me
>> here. AFAICT the Northstar SoCs have two MDIO controllers: one for
>> internal PHYs and one for external PHYs which how you would attach a
>> switch to the chip (in chipcommonA). Is 53573 somewhat different here?
>> What is the MDIO bus driver that is being used?
> 
> of_get_child_by_name() doesn't seem to increase refcount or anything and
> I think it's how most drivers handle it. I don't think it should leak.
> 
> BCM53573 is a built with some older blocks. Please check:
> 
> 4ebd50472899 ("ARM: BCM53573: Initial support for Broadcom BCM53573 SoCs")
>      BCM53573 series is a new family with embedded wireless. By marketing
>      people it's sometimes called Northstar but it uses different CPU and has
>      different architecture so we need a new symbol for it.
>      Fortunately it shares some peripherals with other iProc based SoCs so we
>      will be able to reuse some drivers/bindings.
> 
> e90d2d51c412 ("ARM: BCM5301X: Add basic dts for BCM53573 based Tenda AC9")
>      BCM53573 seems to be low priced alternative for Northstar chipsts. It
>      uses single core Cortex-A7 and doesn't have SDU or local (TWD) timer. It
>      was also stripped out of independent SPI controller and 2 GMACs.
> 
> Northstar uses SRAB which is some memory based (0x18007000) access to
> switch register space.
> BCM53573 uses different blocks & mappings and it doesn't include SRAB at
> 0x18007000. Accessing switch registers is handled over MDIO.

Florian: did my explanations help reviewing this patch? Would you ack it
now?
