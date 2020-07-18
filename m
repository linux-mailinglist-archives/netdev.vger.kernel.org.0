Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9DA224B1C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 14:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgGRMH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 08:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgGRMH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 08:07:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C780C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:07:57 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so13551131ejd.13
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gE6xlnPV+H64YPYAFmDB1NXJJoRw6LO+tbVxM9rin9U=;
        b=ndZpQLNK0y2vKffCdV+ZyjkiThP0WCrzop6m2sixMvFpbL2RqDQfwRda3YqcuJ794x
         +jzn/V0yvnY4otfiBA4E0iwjd0fMPVooVwC5oC0/zrDuEmD+BILcCIBpmIqTDq9QCy8i
         Yk3uLGY7tIYdnyTvMUpcir1ZesfI/x8UFzvG7oTi4sBWFtsjRVbF6Kr4ZbMdOe4fic+0
         34TLa1nDZdrwLD4tLXRiLZMWNC9HkAdNU3M84ND8JPZiu+80Moo+GzziiVRxNa4nCGdS
         lAnbMnHtlhJjR1qyNDpYvHfDPykFDT5Naficg3EPJQJxc+sqkq8PJyd/w9EZu06+JZ1A
         H2Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gE6xlnPV+H64YPYAFmDB1NXJJoRw6LO+tbVxM9rin9U=;
        b=TXXWGWQ4oPiw37obAkH9tpGPDdH1nTiUQyrHF+75TmC9UCRShtsBoY6ZnfoqBAdPCO
         xZ//9kUTdpIDlhNSEvBYPUi+eIxui5l5fL97+vQa4n9V5Kgb5YVmmrSuVX8F4f39k3V4
         vg9B+1FmMGCB+DNWThe7K0UbzLxwsDW5k9GdEHnOw2H/OZ3fw/cvwrufwt/8XFjZEmWV
         YZKAYk4brFPbiGK0bZZGkXF8vjeqTI5WMQd6hHAIllQXSFF/XE1+/VAAiYDa39qrCm9X
         i0gzJLaicOgpwoOQmNWTjrpjlaOwjDYi5+Y1rWBas3MHfSIjuzHJ15UPtl65pa+X+dr7
         lSew==
X-Gm-Message-State: AOAM531AXREc/Jzw0foRRxPihTUc9E8tgmoDeroxHLewhmReqvRDkdwl
        MqNInWIQ3+47D+bUkeo8y4z4OTfNY8Q=
X-Google-Smtp-Source: ABdhPJyF/GDX0IDBvb8sji7rRxjr6Qj2AHBbFXjQsYLYXxnFnS4rBypWxxSzyXS963pXuQ122oZ4jA==
X-Received: by 2002:a17:906:3850:: with SMTP id w16mr13418615ejc.205.1595074075409;
        Sat, 18 Jul 2020 05:07:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b8ae:d04f:215b:b962? (p200300ea8f235700b8aed04f215bb962.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b8ae:d04f:215b:b962])
        by smtp.googlemail.com with ESMTPSA id l22sm10450118ejr.98.2020.07.18.05.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 05:07:54 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
Date:   Sat, 18 Jul 2020 14:07:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716105835.32852035@ezekiel.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.07.2020 10:58, Petr Tesarik wrote:
> Hi Heiner,
> 
> first, thank you for looking into this!
> 
> On Wed, 15 Jul 2020 17:22:35 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 15.07.2020 10:28, Petr Tesarik wrote:
>>> Hi all,
>>>
>>> I've encountered some issues on an Asus laptop. The RTL8402 receive
>>> queue behaves strangely after suspend to RAM and resume - many incoming
>>> packets are truncated, but not all and not always to the same length
>>> (most commonly 60 bytes, but I've also seen 150 bytes and other
>>> lengths).
>>>
>>> Reloading the driver can fix the problem, so I believe we must be
>>> missing some initialization on resume. I've already done some
>>> debugging, and the interface is not running when rtl8169_resume() is
>>> called, so __rtl8169_resume() is skipped, which means that almost
>>> nothing is done on resume.
>>>   
>> The dmesg log part in the opensuse bug report indicates that a userspace
>> tool (e.g. NetworkManager) brings down the interface on suspend.
>> On resume the interface is brought up again, and PHY driver is loaded.
>> Therefore it's ok that rtl8169_resume() is a no-op.
>>
>> The bug report mentions that the link was down before suspending.
>> Does the issue also happen if the link is up when suspending?
> 
> I have tried, and it makes no difference.
> 
>> Interesting would also be a test w/o a network manager.
>> Means the interface stays up during suspend/resume cycle.
> 
> I have stopped NetworkManager and configured a static IP address for
> the interface. Still the same result.
> 
> I have verified that the firmware is loaded, both before suspend and
> after resume:
> 
> zabulon:~ # ethtool -i eth0 
> driver: r8169
> version: 5.7.7-1-default
> firmware-version: rtl8402-1_0.0.1 10/26/11
> expansion-rom-version: 
> bus-info: 0000:03:00.2
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: yes
> supports-priv-flags: no
> 
>> Unfortunately it's not known whether it's a regression, and I have no
>> test hw with this chip version.
>>
>> Also you could test whether the same happens with the r8101 vendor driver.
> 
> I was not aware of this alternative driver... Anyway, I have built
> r8101 from git (v1.035.03) for kernel 5.7.7. When loaded, it hangs the
> machine hard. I mean like not even SysRq+B works...
> 
> Petr T
> 
>>> Some more information can be found in this openSUSE bug report:
>>>
>>> https://bugzilla.opensuse.org/show_bug.cgi?id=1174098
>>>
>>> The laptop is not (yet) in production, so I can do further debugging if
>>> needed.
>>>
>>> Petr T
>>>   
>> Heiner
> 

Maybe the following gives us an idea:
Please do "ethtool -d <if>" after boot and after resume from suspend,
and check for differences.






