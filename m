Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092AE35E876
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345818AbhDMVn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhDMVn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:43:27 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB08C061574;
        Tue, 13 Apr 2021 14:43:05 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 12so9511183wmf.5;
        Tue, 13 Apr 2021 14:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eiLeFo46Rn6jFD4qbRYug48gMNdjyaC06w0K3o+QUEo=;
        b=Lvqya2HGFFdlBx0lglvqYzcK6Tzy8OPau40Ff3+tkvM70XHAtV4s3qH6vUZEAnMI3V
         JCA/zf3fSmoihOttq1ySAOB8VRym9citz2hxqEtEkCjUW9+HkCSvgn7K7K2CkNehoZy9
         aO5RDsovV864ARfRfi5RjPWCkqGtuHambjJftaJ7uz/HJehv//so+GcYHBs9REOOnGPD
         JvCLahT5KXcfHwzfjnFAj7sWqeQaAaWeplxHv+SMpIzSLKDXZ+SSbIgnJ7gMzf4LgF/V
         2vvhwczffv3QYxY8v1835xX+VKOfJazm/4K9RoxsJKtLzM4LJydughUKCv4Im8f/v+zo
         gklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eiLeFo46Rn6jFD4qbRYug48gMNdjyaC06w0K3o+QUEo=;
        b=Vq+vJbk41F5ZZ8e7xQztjFHuqS9xCflwWGsREBg90tHq0nOSa+OU32jIwQGunIQosx
         HnnevZjik/Bo9TVmoQFX3JNwOwCx8D7/GUyy+Qav0a8UvUbrcKJJqI845kGesdyjxICH
         Y2x4orMwXKF8nc0aXSPLN+jt7Y8oyCRx5OCsybT06A1pi+7jnTLAMhPKH7sLwtJ/Nnax
         osDVoEUf/WgduFu9lz+ZaKCGmr9pOyDgGRqOGNklKv+f/L6C2Zl/BazmZzV5vhYrVNY6
         mDYdqnsNN67cYPPMav3E4JNdXRkXXP3gs9bBwo3hp2ACJ6u4SuRiQGJb4UxySgQHXN8P
         EgPQ==
X-Gm-Message-State: AOAM532jAWN9vYqL1TL8SoCrVopb1S16uslzT/fsAcmqD1M0wS7veiwl
        fMgs1Y9SLgpIL+CQ3w0L/GQhF1t+NA==
X-Google-Smtp-Source: ABdhPJyZy8wOFXIy+9w+km2telPNi/wpbmeVJ4CFAYoVcJWTFm/DoTqH7UUNA4RYN/Txqa4imSJX7g==
X-Received: by 2002:a05:600c:21c2:: with SMTP id x2mr1822992wmj.161.1618350184043;
        Tue, 13 Apr 2021 14:43:04 -0700 (PDT)
Received: from localhost ([84.39.183.235])
        by smtp.gmail.com with ESMTPSA id g3sm12716185wrp.46.2021.04.13.14.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 14:43:03 -0700 (PDT)
Subject: Re: [BUG]: WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:442
 dev_watchdog+0x24d/0x260
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek NIC <nic_swsd@realtek.com>,
        NETDEV ML <netdev@vger.kernel.org>,
        KERNEL ML <linux-kernel@vger.kernel.org>
References: <8ab3069a-734f-80ee-49a0-34e1399d44f1@gmail.com>
 <b828de51-3932-1264-dfd3-eb7af2a5c539@gmail.com>
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <b82f5f19-5612-2b24-b36a-7517722c335c@gmail.com>
Date:   Tue, 13 Apr 2021 23:43:02 +0200
MIME-Version: 1.0
In-Reply-To: <b828de51-3932-1264-dfd3-eb7af2a5c539@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/13/21 11:07 PM, Heiner Kallweit wrote:

> On 13.04.2021 22:59, Xose Vazquez Perez wrote:
>> A non-recurring bug, on 5.11.12-300.fc34.x86_64 (Fedora kernel).
>>
>> Thanks.
>>
>>
>> 0c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 06)
>>
>> [    2.968280] libphy: r8169: probed
>> [    2.968844] r8169 0000:0c:00.0 eth0: RTL8168e/8111e, 2c:41:38:9e:98:93, XID 2c2, IRQ 47
>> [    2.968849] r8169 0000:0c:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
>> [    4.071966] RTL8211DN Gigabit Ethernet r8169-c00:00: attached PHY driver (mii_bus:phy_addr=r8169-c00:00, irq=IGNORE)
>> [    4.323834] r8169 0000:0c:00.0 eth0: Link is Down
>> [    6.729111] r8169 0000:0c:00.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>
>> [106378.638739] ------------[ cut here ]------------
>> [106378.638757] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
> 
> This is a standard tx timeout and can have very different reasons.
> Few questions:
> 
> - Is this a regression? If yes, can you bisect?
> - Can you reproduce it? If yes, which type of activity triggers it?

This is the first and only time I've seen a bug in r8169 on this machine in nine years.
Nothing special, web browsing, git cloning, dnf updating, ...
It's a non-recurring bug.

Now it's running 5.11.13-300.fc34.x86_64, stable as always.


Thank you.
