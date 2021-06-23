Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD503B2256
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFWVWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWVWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:22:15 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22802C061574;
        Wed, 23 Jun 2021 14:19:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id v7so2875478pgl.2;
        Wed, 23 Jun 2021 14:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QMHcaBwzbupzQgelN2696MohF2m7DMfYgUokxnU4T4I=;
        b=pFTCSQjb7CwSOcGd4RT7yUNxpgAz/TJE7bp9wgoZR1sEvYLHiHgeObp874DVI+ve7k
         +vGmnHTkyGFEqTltwT8lKZzkcnj9p4ZHmqej0ZA47kyU9+SbsvySBxW4hvNv4iNF+mYo
         HKe22kSxnb1rIoMRUAcvd98RZuNq6qegiXpVyQNt/HkgsvYIQAkmeg6nSE2MJ9WDRHqj
         rGmakXoA/Js8CAdQ1etItmjeqQ4Xg8cOMpWlEhZTFdDrWOS8NggDHndd7iztT3O0qs/7
         Hma/hdNcgvNx/ugyCE0X/jQlw59EK5LjT0RIwdNatsgp/K4Fl8S+16CYKTsj5OrBsM41
         WoAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QMHcaBwzbupzQgelN2696MohF2m7DMfYgUokxnU4T4I=;
        b=Xx/gW20qrD+n0iKuHPguXbmFf2hUQ9zUh+meERVc2S77p+3uKyIKJRjDQo8KHg297C
         WDpf2i0I4I9e/j1OudwGlLyQOrYFC1vZtmwwOvezhXqapJZboPzWdq+RKkI4C5+kSaGb
         eNjTmFXFnmi+ddAlWMf9k4lMR2FSGiZcC3PHw65Axc3Nklxfu3OjDkUwebQckwSWXHf4
         gLL7aNhNChGy2vRRqjTpqNB1ejxWeuAJWrvPQWloJnfRArVxKebmD2c+hT7/pMxA+GLQ
         H1YNkfvMzbLmrmtrHDABglcf6Uf6q121lJM43DU7uX1nXMV2ZC0sbbavr///adI1xF1Z
         +31g==
X-Gm-Message-State: AOAM531m5kerC3IR2QIK+HxnV3J8Fs0lIpoXuvzDQSTbGcMGlAX8MBG4
        evRHQssVjFvLYD1muBv4OB8=
X-Google-Smtp-Source: ABdhPJzT1OIu99evO/1tNUgVVXPX+tSM/hiAVnTh1HqADtLR3CJwbzvS8U/FGU9Lj6XnVF6CzHPXGw==
X-Received: by 2002:a62:820a:0:b029:2fd:5aa9:549b with SMTP id w10-20020a62820a0000b02902fd5aa9549bmr1356699pfd.77.1624483196388;
        Wed, 23 Jun 2021 14:19:56 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e4sm699621pfa.29.2021.06.23.14.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:19:55 -0700 (PDT)
Subject: Re: [PATCH v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
To:     patchwork-bot+netdevbpf@kernel.org,
        Jian-Hong Pan <jhp@endlessos.org>
Cc:     f.fainelli@gmail.com, stefan.wahren@i2se.com, opendmb@gmail.com,
        andrew@lunn.ch, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@endlessos.org, linux-rpi-kernel@lists.infradead.org
References: <20210623032802.3377-1-jhp@endlessos.org>
 <162448140362.19131.3107197931445260654.git-patchwork-notify@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com>
Date:   Wed, 23 Jun 2021 14:19:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <162448140362.19131.3107197931445260654.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/21 1:50 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Wed, 23 Jun 2021 11:28:03 +0800 you wrote:
>> The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.
>> So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
>> GENET fail to attach the PHY as following log:
>>
>> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
>> ...
>> could not attach to PHY
>> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
>> uart-pl011 fe201000.serial: no DMA platform data
>> libphy: bcmgenet MII bus: probed
>> ...
>> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
>>
>> [...]
> 
> Here is the summary with links:
>   - [v2] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
>     https://git.kernel.org/netdev/net/c/b2ac9800cfe0

There was feedback given that could have deserved a v3, if nothing else
to fix the typo in the subject, I suppose that would do though.
-- 
Florian
