Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E757329359
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbhCAVPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239703AbhCAVNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 16:13:52 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0251DC06178A;
        Mon,  1 Mar 2021 13:13:12 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 18so19247664lff.6;
        Mon, 01 Mar 2021 13:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=m/w3adjNG8HK/lwcehQkIZJzhEHTTJ//E8WwZiuEcSQ=;
        b=R1t9AhgQK/oPN6o22dRudRMAbs/tbTJyw2LdgFgUyY5F+1cVAGLFI6FOI3a9mfiM8T
         CfGuNk09TkCDIQJjRQaz47UUTcLwcOW8wdOiNDxXRgCDo1B8SZ8qILF45znr0ajmXazQ
         0gsMoB3fYE2J2DcDSgw/C26OQf7ZCz7PNM/usPSDaPD/pNnTiWFiVW1TTCbm9yZsjbnY
         d2gDYDGZGINUheWw3cac8Iigd1mSum5XCQAOzZbZwUw3KgMZBd4FSbBlLLcfUzsQ4zUI
         ZOwuZTJqvKIpfxioOpJyPVlGcKvoCGh2dkI1VT365ocmgGBkslKmMad7TCOZzeGd9Cdb
         9NRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=m/w3adjNG8HK/lwcehQkIZJzhEHTTJ//E8WwZiuEcSQ=;
        b=e2b0l393B1fTfuxlJxILzfcJptIwe8FutcHZ250PX4QO4VLkYb86OzIFQP4L4mwmbW
         VZrFkXVTV56+ZhnJ2XAdBBTbet5vaaINbh/w8UNj7YCKAsM7vMNehPvVn2JRl1H4LwkS
         viD9P6qC7JdOavvNIsuwG5oQ03v9H/rtJSBDSXqHnugysft5xvYHHwCgsNt9VrIlnvbH
         35gBEaTGejQHIN39B7Y3ywP71e/GCW0r4PHhhusVtRXjTL501MuzgA+lUXvAuSx8VV3K
         qRldzBrtH1Kknp+Xaeu0gpkLdYOR6fJKEDgqf2JSCBLI1C9tpjF01b/4+jfyWzPtNUHT
         cAZA==
X-Gm-Message-State: AOAM532C3iRAnNjMYVw1CreW9tQI1zIEETfcvf7mOLj3HuQB37epZJfz
        fxA8hMaRD3Z/XZD/iXGQO98=
X-Google-Smtp-Source: ABdhPJzNNmfQZEMPpLna52PhyJPzbd6jWac0WJZYj2+xt0+OEhUkv8M8RuqWrVNenAMToFs8wAgZ7g==
X-Received: by 2002:ac2:51ac:: with SMTP id f12mr10248660lfk.605.1614633190552;
        Mon, 01 Mar 2021 13:13:10 -0800 (PST)
Received: from [10.0.0.11] (user-5-173-242-247.play-internet.pl. [5.173.242.247])
        by smtp.googlemail.com with ESMTPSA id p9sm2260752ljn.16.2021.03.01.13.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 13:13:09 -0800 (PST)
Subject: Re: [PATCH v3] net: usb: qmi_wwan: support ZTE P685M modem
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, kuba@kernel.org, bjorn@mork.no
References: <20210223183456.6377-1-lech.perczak@gmail.com>
 <161419020661.3818.15606819052802011752.git-patchwork-notify@kernel.org>
From:   Lech Perczak <lech.perczak@gmail.com>
Message-ID: <bb636575-e32d-5d6f-16d1-dc75ce4f4f84@gmail.com>
Date:   Mon, 1 Mar 2021 22:13:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161419020661.3818.15606819052802011752.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-24 at 19:10, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
>
> This patch was applied to netdev/net.git (refs/heads/master):
>
> On Tue, 23 Feb 2021 19:34:56 +0100 you wrote:
>> Now that interface 3 in "option" driver is no longer mapped, add device
>> ID matching it to qmi_wwan.
>>
>> The modem is used inside ZTE MF283+ router and carriers identify it as
>> such.
>> Interface mapping is:
>> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
>>
>> [...]
> Here is the summary with links:
>    - [v3] net: usb: qmi_wwan: support ZTE P685M modem
>      https://git.kernel.org/netdev/net/c/88eee9b7b42e
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
I see that the usb-serial counterpart of this patch was queued up for 
stable [1], so just for the sake of completeness, it might be worthy to 
consider this one too. This would likely make OpenWrt folks happy -  I 
think that going for 5.4.y and upper would suffice, as 5.4 is currently 
used as stable kernel there, and most of targets are switching to 5.10 
right now.

Upstream commit is 88eee9b7b42e69fb622ddb3ff6f37e8e4347f5b2.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.11/usb-serial-option-update-interface-mapping-for-zte-p685m.patch?id=a15ddfc3cd600b31862fdde91f8988e1cfc7bffe

--
With kind regards,
Lech

