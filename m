Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFE51A5E6B
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgDLMCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 08:02:14 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36299 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgDLMCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 08:02:13 -0400
Received: by mail-lf1-f65.google.com with SMTP id w145so4552027lff.3
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 05:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qzhimHapHqm2OHL59xDWMxKmMgcfCyRa8q6rmlz/sJY=;
        b=SGuPKdm+4Vi+1sGMW41boYwOnV+NiEBg7me43RLpKCUjeVK8PaOyQQnQdY8qZWFn4T
         Z6dbMAg8fh6MhfgzhUn7t11/tbZ0y9h6JvqfQvWm/oRDj89lqa/jjFSAhg5RadpgGZpW
         9v+0etAGqe7A2oMx7VOgct+psVSyJM9SLun/vH3JXRMTns20QUrc4CPL4gtgbjKIkIOt
         VrZGaa+POgJYdnMTjhpCu558FFayJA4S4DZJAQRjfhDgRJwOZelSqysaKoQD2HqULA66
         I+w49o7myvOCBZliZKjeNJ3r51EOhZQpoDwYmacb7Kckf65TF44EuOdgsR+oCi+ibqOo
         L7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qzhimHapHqm2OHL59xDWMxKmMgcfCyRa8q6rmlz/sJY=;
        b=ii69RNmCQ05/DqmRBSY3XwPl+Z//fN1suuPTrYciPA3mck7uNu7MitYq68XhZWDPgH
         SaYgbKYOvvb72RGLPnjkLsV6lEVcW5ohhc+686PqEceUExYcBL5h9e7m/a2ImmdhhmF5
         Fp6+YBZPGnahiFmYOVeKlQWKTbETH4EncdyPDtj3zPXwVmbkXZ5g97FR6zIjCriZpepf
         uxe8Bq5q90gc6efxABdNjQaWYyq/m0GVarl3AqKDhcyuhAYY1kmYKOaeqxedsCVMJ160
         6gUSIQRCiQUIUevWdiFmNNXZbYLDUPuWK2JzVCOnaDKT9bBT7HmWVLn/Rekvk3tkcWtN
         F4vQ==
X-Gm-Message-State: AGi0PuZRLiczFkOCtLr0V+PsZIOf7Urj1zt4bFtMMCP4/9mhF7onV8uV
        GW+7/ufO4Lslo+RxnwCoa4jy3PyU
X-Google-Smtp-Source: APiQypK1m1lPai9KGxPS3XK32wqL41D5ft7Xyd29ssTRQFYeY9wQX6fCkV3V6OTydEiDsi5aSkDpcw==
X-Received: by 2002:a19:43:: with SMTP id 64mr7486113lfa.67.1586692931755;
        Sun, 12 Apr 2020 05:02:11 -0700 (PDT)
Received: from [192.168.1.134] (dsl-olubng11-54f81e-195.dhcp.inet.fi. [84.248.30.195])
        by smtp.gmail.com with ESMTPSA id c21sm5872258lfh.16.2020.04.12.05.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 05:02:10 -0700 (PDT)
Subject: Re: About r8169 regression 5.4
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Vincas Dargis <vindrg@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
From:   Lauri Jakku <ljakku77@gmail.com>
Message-ID: <962fccca-2372-23d4-ea45-89235792c558@gmail.com>
Date:   Sun, 12 Apr 2020 15:02:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200215161247.GA179065@eldamar.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

What i was meant to say that i have r8168/69 driver fixed, so that it determines correctly if the realtek.ko is loaded or not.


On 2020-02-15 18:12, Salvatore Bonaccorso wrote:
> Hi Vincas,
>
> On Sat, Feb 15, 2020 at 11:22:01AM +0200, Vincas Dargis wrote:
>> 2020-02-14 22:14, Heiner Kallweit rašė:
>>> On 14.02.2020 18:21, Vincas Dargis wrote:
>>>> Hi,
>>>>
>>>> I've found similar issue I have myself since 5.4 on mailing list archive [0], for this device:
>>>>
>>> Thanks for reporting. As you refer to [0], do you use jumbo packets?
>> Not sure, I guess not, because "1500"?
>>
>> $ ip link | fgrep enp
>> 2: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 1000
>>
>>> Best of course would be a bisect between 5.3 and 5.4. Can you do this?
>>> I have no test hardware with this chip version (RTL8411B).
>> Uhm, never done that, I'll have to research how do I "properly" build kernel in "Debian way" first.
>>
>>> You could also try to revert a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
>>> and check whether this fixes your issue.
>>> In addition you could test latest 5.5-rc, or linux-next.
>> I've tried linux-image-5.5.0-rc5-amd64  (5.5~rc5-1~exp1) package form Debian
>> experimental, issue "WARNING: CPU: 6 PID: 0 at net/sched/sch_generic.c:447
>> dev_watchdog+0x248/0x250" still occurs after some time after boot.
>>
>> I'll try first to rebuild one of the Debian kernels after reverting that
>> a7a92cf81589 patch, for starters.
> You can generate the a7a92cf81589 revert patch, and then for simple
> testing of a patch and build have a look at the Simple patching and
> building[1] section of the kernel handbook.
>
> Hope this helps,
>
> Regards,
> Salvatore
>
>  [1] https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s4.2.2
