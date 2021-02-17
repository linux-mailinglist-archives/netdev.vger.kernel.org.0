Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8228331DB55
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 15:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhBQOUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 09:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbhBQOUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 09:20:50 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD4C0613D6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 06:20:10 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m1so3788320wml.2
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 06:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ywt1nEYmK/lJrv+dpVUIxvRl7CzNbXX4ooSFLhqf+yg=;
        b=tkLpKCMjRBlLWCCi3IoS5cMr3GooHjtpUl1PXhRx+yq6iaNDI/zagtAl1kCXum4+TW
         tGmKIZs6GifP2bcRA3uq3dTSxTE1aReJnli3OBZg9IxXzJFvr5aErZWqwJimBzZZmVPK
         Fpu39+UHCCzcKVp7EV4+d2cIqz0oVc93s1BWSCHfbK0DMjuF+BBCeohH9/jqLng37lax
         fXQEqpzyjOHmbwAJnaB+opIfTCEnnXSlBPrKOrkDBIpIEC0wra7qJ+v3APKlOH3jtcmI
         9gxJ21+sFKwrI9EhRSzjM/sTJbXmCAq/11xh1KU5psbfYw78I6hFypiY027XNWZt56Oz
         lacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ywt1nEYmK/lJrv+dpVUIxvRl7CzNbXX4ooSFLhqf+yg=;
        b=NuRQs2pB3fbU93Z7XVngSWr+OT9Q/ctX+mIgbodNy9sreMAR3UoRsmS9ZYJpzI6GCk
         HPNSaI+Pq7ufR5q0/aMGRqgbUCToNz3lSG0lxgG9A2KUUf+hbLELbGEfCGhbQLMwCaCm
         TG0zKzSJUEC33Px171WigmfLmRG1BMhvIOkcZCCwP5LiG7gXsH8+Q7V0EN6NHmiiKaQt
         1EoLuzHuXLDAKWyhuKXRmo0CroIMoz8nhme0jhww9nD/VwhKbkI009j9sPsn5YbU6iPx
         inxOlzTU9TAiTsQOu6v92Vy2ZmovhQyuxZGXWuH/2kqeq56n7NS9uvYB2S2XaSo94Qlw
         vE5Q==
X-Gm-Message-State: AOAM533KGehJB8JxybDHPK3C+O4ZjLf8uBdClKRuK/BnaytK4G5ToHYv
        JlxGctbRwcrDNptV6qHExEI=
X-Google-Smtp-Source: ABdhPJwLcpzlTBs9aGA2y+F/DF67AUTecRuO0Fc6Lk8xQLcvlqS08Cz5UmM7eN2Ha0OdD1L0zsQvNQ==
X-Received: by 2002:a05:600c:21ca:: with SMTP id x10mr7540743wmj.94.1613571608837;
        Wed, 17 Feb 2021 06:20:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3459:b70a:ad7d:c95e? (p200300ea8f395b003459b70aad7dc95e.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3459:b70a:ad7d:c95e])
        by smtp.googlemail.com with ESMTPSA id s23sm3312399wmc.29.2021.02.17.06.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 06:20:08 -0800 (PST)
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
To:     Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
 <CALW65jbEjWtb3ww=Bq5WKrjpQ=fjrxCBKyxxxi0CGRAVAkdO7g@mail.gmail.com>
 <20210217124239.sxgkhow53vox7o54@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <aa12f669-c4f5-edb3-37f5-90270b5ec52f@gmail.com>
Date:   Wed, 17 Feb 2021 15:19:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210217124239.sxgkhow53vox7o54@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.02.2021 13:42, Vladimir Oltean wrote:
> On Wed, Feb 17, 2021 at 08:38:30PM +0800, DENG Qingfang wrote:
>> On Wed, Feb 17, 2021 at 7:55 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>>> +
>>> +       /* Pad out to at least 60 bytes */
>>> +       if (unlikely(eth_skb_pad(skb)))
>>> +               return NULL;
>>
>> I just found that this will cause double free (eth_skb_pad will free
>> the skb if allocation fails, and dsa_slave_xmit will still try to free
>> it because it returns NULL.
>> Replace eth_skb_pad(skb) with __skb_put_padto(skb, ETH_ZLEN, false) to
>> avoid that.
> 

That's really a pitfall. I had to do the same in r8169:
cc6528bc9a0c ("r8169: fix potential skb double free in an error path")

> Good catch, Qingfang.
> 

