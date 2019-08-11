Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81926892B7
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfHKQ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:59:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46122 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfHKQ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 12:59:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so102632455wru.13
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 09:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JQgghQU9nnUkMxvKl+XgiNbcsZD9Vp1jqvCo1m/DAu4=;
        b=itzcY14opyvdIQM44HnWh4+ARHqnEvDIj7YRKoSfsvcfv+gHbsx9CtQEeSaW09PeIi
         F48IdLfExZOB82hSzwOaJtbLq4Z5cuf/Iv4cUXBjU5eiW3OPTIH+wPTuwHj4eO38EE3P
         FNede2YI1u3QEKBsku9cMKkOykeHHcTrkyKgmTgKT2JIQKR2RfrlUN5EoxSjkoUSAWnV
         SExEdQ+UauCoDx62ODtZYoGbso5VgmvYqM71NLk6orwD2yJ87IRucBv8/9aOk1bvSmz6
         wnyPhwgEZdAn4dxH+cG8rSxxu3E1wLTYXvHhdiYKdrlL0osr5cKcA82rCqN5homfsdqZ
         nvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JQgghQU9nnUkMxvKl+XgiNbcsZD9Vp1jqvCo1m/DAu4=;
        b=FDRh8MJsHZU16G3f424BAVoUE7dAnmXZcKwWN24hk9vokO94Ydq131uDSCC0F1bWwx
         JyBMHvdAXxEL3qySL7d3MjF/ai6snq55PxIjsb66Er5gscnrycSGTBjftbl+lte10AlV
         8rBH7xuMkB7i0tpYqNqTIPLU9LMp0jtusYzPFfodojJA52W6grldx5qRYevk/jMZoA3L
         Js7RJ06kuIN8TauTR9eWgrGeEkJ7B74tNtuFa1zgQuZtkIoJTAppeQ1jxGkMRkzmL8QD
         0Z9NhrjUo4X5AwoWZCbqzPBi7KPtOsgFR5XdZCfwtt8QAZTSZVf17wBvJ09QVIlksIAJ
         YYmg==
X-Gm-Message-State: APjAAAXxwxBvSzYyrENi6MjKHdSam2bhLI42tf26aeOiZe/iZTquhYve
        O0prCVEZ19DwiqjPOEewfrg=
X-Google-Smtp-Source: APXvYqyeHSx8z3AfZAIJYLB+mLriNgmaTBNROG+UMocFeoRgoPriawD/hUrJai8CHq+2wyKz8gqjQg==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr33113528wrs.348.1565542758552;
        Sun, 11 Aug 2019 09:59:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2c05:cd65:72fc:a240? (p200300EA8F2F32002C05CD6572FCA240.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2c05:cd65:72fc:a240])
        by smtp.googlemail.com with ESMTPSA id b2sm8407511wrf.94.2019.08.11.09.59.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 09:59:17 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: fixed_phy: set is_gigabit_capable
 member when needed
To:     Marek Behun <marek.behun@nic.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190811150812.6780-1-marek.behun@nic.cz>
 <20190811150812.6780-2-marek.behun@nic.cz> <20190811154001.GC14290@lunn.ch>
 <20190811180815.024870da@nic.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <76dc0ce2-238b-b27a-fff5-5fd633518cc0@gmail.com>
Date:   Sun, 11 Aug 2019 18:59:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811180815.024870da@nic.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.08.2019 18:08, Marek Behun wrote:
> On Sun, 11 Aug 2019 17:40:01 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>> On Sun, Aug 11, 2019 at 05:08:12PM +0200, Marek Behún wrote:
>>> The fixed_phy driver does not set the phydev->is_gigabit_capable member
>>> when the fixed_phy is gigabit capable.  
>>
>> Neither does any other PHY driver. It should be possible to tell if a
>> PHY supports 1G by looking at register values. If this does not work
>> for fixed_link, it means we are missing something in the emulation.
>> That is what we should be fixing.
>>
>> Also, this change has nothing to do the lp_advertise, what you
>> previously said the problem was. At the moment, i don't get the
>> feeling you have really dug all the way down and really understand the
>> root causes.
>>
>>      Andrew
> 
> Andrew,
> is_gigabit_capable is otherwise set only in the phy_probe function.
> This function is not called at all for the DSA cpu port fixed_link phy.
> Why is that? But I guess it is not important anymore, if CPU and DSA
> were converted to phylink in net-next. I shall test it and let you know.
> In any case, sorry for the spam.
> Marek
> 

A fixed phy should be bound to the genphy driver, but that happens later
in phy_attach_direct(). Maybe the fixed phy device of a CPU port gets
never attached to a net device? This would explain why phy_probe()
doesn't get called.
Following idea: We could swphy let return PHY ID 0xffffffff
(instead of current value 0x00000000). Then the fixed phy device would
be bound to the genphy driver immediately at device registration time.
As a consequence phy_probe() would call genphy_read_abilities() that
sets supported modes properly. This should allow to remove the manual
adding of supported modes in dsa_port_fixed_link_register_of().

One more thing regarding genphy_read_abilities() and fixed phys in general:
swphy sets bit BMSR_ESTATEN, then genphy_read_abilities() reads
MII_ESTATUS to check if and which 1Gbps modes are supported.
MII_ESTATUS however isn't defined in swphy. We're just fortunate
that therefore the default value 0xffff is returned and both
1Gbps modes seem to be supported.

Last but not least I think the calls to genphy_config_init() and
genphy_read_status() in dsa_port_fixed_link_register_of() are
both not needed and could be removed.

Heiner
