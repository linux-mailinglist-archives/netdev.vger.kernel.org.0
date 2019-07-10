Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89CA64B5E
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfGJRTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:19:49 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34467 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfGJRTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:19:49 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so5116962wmd.1;
        Wed, 10 Jul 2019 10:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MkeXWKLYCNC64SA5zV8sD+8G/cnkndQu5YG84Jt6O88=;
        b=fF6eKkazm87nuisBbZKAa5Y7MKRUavLDPS8YZR/r0fq9y6T+6aUM19zi2rvVuiAdor
         VGx3BWpg1QgZw38X9gTGwcBcBPb/FXkMOVzWEoeZWxYBtOjOClSL6vkrPTQcr0eTfSA5
         OqNzIbTIXhWM5jFa2ZrI90Y2parOz2AxNCPut/5u+QO4XhHJl3tVOa4s7pwlACwHlMh2
         n9cEbK/E0arnVBDAbknA8QMtMrooD6Q6LkMEzdpvcweAXSrVYzlYe38pocps27S4u5lJ
         Ys2Z46y04UKKXjIVSR8KLaGuX1EVF3RmFi1Klv7f4WP41IcDWiGaKFvtGYP+fzHcuIm6
         X1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MkeXWKLYCNC64SA5zV8sD+8G/cnkndQu5YG84Jt6O88=;
        b=JPWHonyH4bU5PM+9CcEOkkv8bg41Avu8PPL2RrmNFe4aCzgqVE7fQ3MqrGCBlpPEu4
         Gt9KCJOVWSo90MfUoeB1h+vvanMQNT0eCcfEJhoCvQD4E7i4MS5/FgpAakvqRiOWRvA3
         g5P3wJVWbGyS3P7A6ssnIR1GDVDmu1yOIlAPNQGtcsSrMwnD6uv4uHyhFBCAyBoESptx
         wlewkCYnu1cM+fI+2v4eaDE/2UjM7xIQrzKmngx600cNSCEkyVt//5UFtmCNKRPQKX8x
         JWlnxeYHizwP/kT8bx/+1QHeUk2sJDJWJMXFqRDuHwc8wXSlru9XRd/OpZau1nmMBpuU
         CiQg==
X-Gm-Message-State: APjAAAU7m7LZy4gLIUGPcfAbpSIcP/nqHJViEWMt+TsL4nQ1CFKxq0Sp
        ILBEG111a2NJORJlL9KhzJh8XyAE
X-Google-Smtp-Source: APXvYqztq4aIlZS0tlKNJ2d+HHzOZr/RQ/qzziSxc5d/5HhAq1NsU3Hi51+N0xwBL5J1Z7UrApYQ5A==
X-Received: by 2002:a1c:e341:: with SMTP id a62mr6424245wmh.165.1562779186813;
        Wed, 10 Jul 2019 10:19:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:54ae:9c17:4aac:c628? (p200300EA8BD60C0054AE9C174AACC628.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:54ae:9c17:4aac:c628])
        by smtp.googlemail.com with ESMTPSA id f2sm2467275wrq.48.2019.07.10.10.19.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 10:19:46 -0700 (PDT)
Subject: Re: [PATCH] r8169: add enable_aspm parameter
To:     AceLan Kao <acelan.kao@canonical.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <20190708063751.16234-1-acelan.kao@canonical.com>
 <53f82481-ed41-abc5-2e4e-ac1026617219@gmail.com>
 <CAFv23Q=mA9t0j2F4fKdOkgG6sao0m7rR_9-d9OvAmSerZf_=ew@mail.gmail.com>
 <CAFv23QmqjJtUD-iAwzsXg2MCNbe_p1zOcZ7C-ywG5n-iT-N-YA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1fa4e6f0-3be0-e212-5610-21a2f149d626@gmail.com>
Date:   Wed, 10 Jul 2019 19:19:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAFv23QmqjJtUD-iAwzsXg2MCNbe_p1zOcZ7C-ywG5n-iT-N-YA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.07.2019 09:05, AceLan Kao wrote:
> Hi Heiner,
> 
> I've tried and verified your PCI ASPM patches and it works well.
> I've replied the patch thread and hope this can make it get some progress.
> 
Thanks for the feedback!

> BTW, do you think we can revert commit b75bb8a5b755 ("r8169: disable
> ASPM again") once the PCI ASPM patches get merged?
> 
Default should remain "ASPM off" as quite a few BIOS / chip version
combinations have problems with ASPM. Interested users then can use
the new sysctl interface to switch on ASPM completely or just selected
states (e.g. L0 only).

> Best regards,
> AceLan Kao.
> 
Heiner

> AceLan Kao <acelan.kao@canonical.com> 於 2019年7月9日 週二 上午11:19寫道：
>>
>> Heiner Kallweit <hkallweit1@gmail.com> 於 2019年7月9日 週二 上午2:27寫道：
>>>
>>> On 08.07.2019 08:37, AceLan Kao wrote:
>>>> We have many commits in the driver which enable and then disable ASPM
>>>> function over and over again.
>>>>    commit b75bb8a5b755 ("r8169: disable ASPM again")
>>>>    commit 0866cd15029b ("r8169: enable ASPM on RTL8106E")
>>>>    commit 94235460f9ea ("r8169: Align ASPM/CLKREQ setting function with vendor driver")
>>>>    commit aa1e7d2c31ef ("r8169: enable ASPM on RTL8168E-VL")
>>>>    commit f37658da21aa ("r8169: align ASPM entry latency setting with vendor driver")
>>>>    commit a99790bf5c7f ("r8169: Reinstate ASPM Support")
>>>>    commit 671646c151d4 ("r8169: Don't disable ASPM in the driver")
>>>>    commit 4521e1a94279 ("Revert "r8169: enable internal ASPM and clock request settings".")
>>>>    commit d64ec841517a ("r8169: enable internal ASPM and clock request settings")
>>>>
>>>> This function is very important for production, and if we can't come out
>>>> a solution to make both happy, I'd suggest we add a parameter in the
>>>> driver to toggle it.
>>>>
>>> The usage of a module parameter to control ASPM is discouraged.
>>> There have been more such attempts in the past that have been declined.
>>>
>>> Pending with the PCI maintainers is a series adding ASPM control
>>> via sysfs, see here: https://www.spinics.net/lists/linux-pci/msg83228.html
>> Cool, I'll try your patches and reply on that thread.
>>
>>>
>>> Also more details than just stating "it's important for production"
>>> would have been appreciated in the commit message, e.g. which
>>> power-savings you can achieve with ASPM on which systems.
>> I should use more specific wordings rather than "important for
>> production", thanks.
> 

