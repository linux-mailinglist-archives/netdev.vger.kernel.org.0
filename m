Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665B251604F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 22:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244970AbiD3UW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 16:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237108AbiD3UW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 16:22:57 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0754C8BF3F;
        Sat, 30 Apr 2022 13:19:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id m20so21256129ejj.10;
        Sat, 30 Apr 2022 13:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=POF+6d8762FMOUGJIUlV1M6qmWu0Pr8vnEd2cruJn/Q=;
        b=GguguRy2ohBkyOzRgJXUL5P1WS54HQv7SPDnAuU7MEYfgc73wwidWcB5/eCDb/o6qN
         RK12GmeHg9/VmD61o9af2NbQ9uApw9HDDRPRLLjnHlku63WdF6wo5YZ3+nS8sUEbaKzp
         gwbn0LuvD7IrUoboyREiqHJxwTvSFuyqDWFxDM1AL3PILyrtXXKPOUANo9R48aPRwnfD
         LBnNNTm1vKERAJTVJJSxc4w1M5l/pom72Bzfb13uLsz/FA667wgnnI3N5RtPhuf6NTnk
         hsb7Mqfbonu6IQri7w05qGQFVDZxszD+9MgW7ANf4flb1fSFYbIEWB4IjQsoL4O65c7p
         Ov/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=POF+6d8762FMOUGJIUlV1M6qmWu0Pr8vnEd2cruJn/Q=;
        b=nb22NC2y2/9Oy51Mi82ydRQQZrnwC4dUnJfW54m2oM63XEmjKNKwCRoBZB/sdOpI3k
         w3NAzu/7TaNQ51SeqZ0aZrSlu4OvhBOQDdllyaIH5rbBionNhRcX1Ae+al6Ts2sD+sk7
         leCjc5qHaF6KAMMLj45X0f16nhQJa38wtMhLej81K01Ng+Ejjeq5lVTyqwhw/G5pYAaN
         zJhrIBp1vnRfLqUhjMQczAJDVdsWnhiW9/0wP6Xw/Hnx48fG595fmH/kKjBoJnZDxADE
         6MppX3cTcRUJU+8AgQJTvyyeAx/YAtlzi3nUdA+l+YgxZ6JwJPCvweklR8vbQwojZNyc
         4X4Q==
X-Gm-Message-State: AOAM5306mKZCUQ2GJJLsqJ/Or+BPQndiN7xpUfRhtSP6VAIuWx8uDm1N
        KjyMSQCJjV9KKippLV47cQg=
X-Google-Smtp-Source: ABdhPJzvyvxchjnijiU3tXHOtd78aybClSnMqXpfP33YYcQnledJ3xLrAykgTzMo+dqTSywxOtIW9g==
X-Received: by 2002:a17:907:1b10:b0:6e4:bac5:f080 with SMTP id mp16-20020a1709071b1000b006e4bac5f080mr5052303ejc.24.1651349972319;
        Sat, 30 Apr 2022 13:19:32 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6f21:fd00:3167:a16c:5aa:91c3? (dynamic-2a01-0c22-6f21-fd00-3167-a16c-05aa-91c3.c22.pool.telefonica.de. [2a01:c22:6f21:fd00:3167:a16c:5aa:91c3])
        by smtp.googlemail.com with ESMTPSA id hg8-20020a1709072cc800b006f3ef214db1sm1904785ejc.23.2022.04.30.13.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Apr 2022 13:19:31 -0700 (PDT)
Message-ID: <f68dfd23-ae83-e4d9-cb08-51a097bac06b@gmail.com>
Date:   Sat, 30 Apr 2022 22:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220228233057.1140817-1-pgwipeout@gmail.com>
 <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
 <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
 <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com>
 <Ym1bWHNj0p6L9lY8@lunn.ch>
 <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
In-Reply-To: <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.04.2022 18:31, Peter Geis wrote:
> On Sat, Apr 30, 2022 at 11:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>> Good Morning,
>>>
>>> After testing various configurations I found what is actually
>>> happening here. When libphy is built in but the phy drivers are
>>> modules and not available in the initrd, the generic phy driver binds
>>> here. This allows the phy to come up but it is not functional.
>>
>> What MAC are you using?
> 
> Specifically Motorcomm, but I've discovered it can happen with any of
> the phy drivers with the right kconfig.
> 
>>
>> Why is you interface being brought up by the initramfs? Are you using
>> NFS root from within the initramfs?
> 
> This was discovered with embedded programming. It's common to have a
> small initramfs, or forgo an initramfs altogether. Another cause is a
> mismatch in kernel config where phylib is built in because of a
> dependency, but the rest of the phy drivers are modular.
> The key is:
> - phylib is built in
> - ethernet driver is built in
> - the phy driver is a module
> - modules aren't available at probe time (for any reason).
> 
> In this case phylib assumes there is no driver, when the vast majority
> of phys now have device specific drivers.It seems this is an unsafe
> assumption as this means there is now an implicit dependency of the
> device specific phy drivers and phylib. It just so happens to work
> simply because both broadcom and realtek, some of the more common
> phys, have explicit dependencies elsewhere that cause them to be built
> in as well.
> 
Because you mention the realtek phy driver:
Users reported similar issues like you if r8169 MAC driver is built-in
(or r8169 module is in initramfs) but realtek phy driver is not.
There's no direct code dependency between r8169 and realtek phy driver,
therefore initramfs-creating tools sometimes missed to automatically
include the phy driver in initramfs. To mitigate this r8169 has the following:
MODULE_SOFTDEP("pre: realtek");
This isn't strictly needed but some initramfs-creating tools consider
such soft dependencies when checking what should be included in initramfs.
If some other MAC is used with a Realtek PHY, then you may still see the
described issue.
As Andrew wrote: Eventually it's a userspace responsibility to ensure that
all needed modules are included in initramfs.

>>>> What normally happens is that the kernel loads, maybe with the MAC
>> driver and phylib loading, as part of the initramfs. The other modules
>> in the initramfs allow the root filesystem to be found, mounted, and
>> pivoted into it. The MAC driver is then brought up by the initscripts,
>> which causes phylib to request the needed PHY driver modules, it loads
>> and all is good.
>>
>> If you are using NFS root, then the load of the PHY driver happens
>> earlier, inside the initramfs. If this is you situation, maybe the
>> correct fix is to teach the initramfs tools to include the PHY drivers
>> when NFS root is being used?
>>
>>      Andrew

