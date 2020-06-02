Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0F51EB58B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBF7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgFBF7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 01:59:21 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370F8C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 22:59:21 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x6so1979327wrm.13
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 22:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uUnrnofyj06ZMmhQ3XK96fL5upjJdk6xA38GTIW2I7A=;
        b=GoZZOnqDgIMqR+3WeEcDkPM16AYBdRN+qAqN7r6exSLxVF/1VjrKJu0fw+Yd3JIcTj
         3whcZ9CtW5pnON4dl0n8Ui7sS1tvL13kX0A80eRuTGNmJR8bkXeyuY/YiprODy70EzyC
         iOrXDCCr0hgHwAnGeIMwNsjNYgKHL5AFtrFsCPemxaN8PT2yVZclhPshDpeLTl3oX42G
         TzTz1FTRMZBfhKIp4WND7AYbLlkEslmhfOTjKkq7cAdzNRb7rspAHnW15NZLC1C9hgBa
         QGIA/sz/tfmcvGX2aVvlGfdl44L/NDY9WsIVCMcIl49IUpDa7j+PJKXfrk3+sJEGF2LA
         8Qcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uUnrnofyj06ZMmhQ3XK96fL5upjJdk6xA38GTIW2I7A=;
        b=g+0El7rIVrdA2xM5eRtHNQ5JrKlqZXNkUThlWtVA5pydbw14SzK9re6gISUdQsTXTi
         pQIQOULF6AWYEKLcO/j/EpO01/tYEUnmj54QlwCnewu+2CvBo/bYh8fQX7bZDA+3wzrZ
         LLMWcP3TAndU3cpfcXNtIi2IkYr4kVDH0SdPQz5j8qqVIK8zCrfEOas1aKvBL++GK03N
         CzDTbqcwHyxUoJvh1ap/ZGx9ox+3wQN6e0L6m5PStGqvShQw4WZnHZFnnCD4tTmyC/qg
         vWZ+4g2JZxjUnYaab28TtDlDs1mrYbt/opagtJWJ1b+8mkLwdqmBWyL/lFrHnhJLTGqh
         jUZA==
X-Gm-Message-State: AOAM5338BwrpnV+Hx4YHX1m5Yq4wKBmPwpJ3V+f/74y3116RHL50LyPW
        0QGLEf56/kOcf9mLsESUBKI=
X-Google-Smtp-Source: ABdhPJxyiORpjGgaz1xzzVW0SP4lLdsKq/8rSwRXJAI1yHxBDEa3Tpa8KOtZIy/vRc27D0Ww5pXJpQ==
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr23967624wrm.93.1591077559882;
        Mon, 01 Jun 2020 22:59:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a450:3f43:b041:bc74? (p200300ea8f235700a4503f43b041bc74.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a450:3f43:b041:bc74])
        by smtp.googlemail.com with ESMTPSA id z132sm1999760wmc.29.2020.06.01.22.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 22:59:19 -0700 (PDT)
Subject: Re: netif_device_present() and Runtime PM / PCI D3
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <d7e70ee5-1c7b-c604-61ca-dff1f2995d0b@gmail.com>
 <20200531150504.GB897737@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fb84709f-568e-9d7d-0d3a-e50518052f36@gmail.com>
Date:   Tue, 2 Jun 2020 07:58:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200531150504.GB897737@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.2020 17:05, Andrew Lunn wrote:
> On Sun, May 31, 2020 at 02:07:46PM +0200, Heiner Kallweit wrote:
>> I just wonder about the semantics of netif_device_present().
>> If a device is in PCI D3 (e.g. being runtime-suspended), then it's
>> not accessible. So is it present or not?
>> The description of the function just mentions the obvious case that
>> the device has been removed from the system.
> 
> Hi Heiner
> 
> Looking at the code, there is no directly link to runtime suspend.  If
> the drivers suspend code has detached the device then it won't be
> present, but that tends to be not runtime PM, but WOL etc.
> 
Thanks, Andrew. To rephrase the question, should a driver always mark
the device as not present when it's not accessible, e.g. in PCI D3?
I think there are good reasons for it.

>> Related is the following regarding ethtool:
>> dev_ethtool() returns an error if device isn't marked as present.
>> If device is runtime-suspended and in PCI D3, then the driver
>> may still be able to provide quite some (cached) info about the
>> device. Same applies for settings: Even if device is sleeping,
>> the driver may store new settings and apply them once the device
>> is awake again.
> 
> I think playing with cached state of a device is going to be a sources
> of hard to find bugs. I would want to see a compelling use case for
> this.
> 
One example I'm aware of: r8169 allows to change WoL settings even if
device is in D3 (runtime-suspended after removing cable). Driver
stores new settings and updates device once it's resuming.

> 	Andrew
> 
Heiner
