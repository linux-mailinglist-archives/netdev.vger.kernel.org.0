Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266CA44B35A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 20:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243443AbhKITm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 14:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhKITm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 14:42:27 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE4BC061764;
        Tue,  9 Nov 2021 11:39:41 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q17so401997plr.11;
        Tue, 09 Nov 2021 11:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=RWFJQ1qkbsa5F3INdZSYF9XYBxAarnZZ0OkMW84AtA8=;
        b=os3xCHEjLgNEN75kaP1ani+AyRtG5xDv8q0jgPChmGcxfnL0sn/eSnSjFxtmWwVDkj
         f6KZysEn9wDsVWwxwhRSP5FVzydX0Jdf29wUwLxX6+6+nw6PWxwwKsDgfbFZYH7XQn9r
         cCjv7+PMdj5yTt3ymJw2MN/TCm8ou8KHKGw5qo32Nx/oUNRhidwHTTvpKlNyO6D7+iH1
         S0U4YQ7thms/zX97hIcGoXO0kuDC/J2V+/YfqK5qeR4v28YsMFjS1kjKzeiyra1qeB9+
         IhKWFA+YDrizIzimxU+AgmMuFZ9irUkD77hIbnO+3Or44klvSUZ2twDSUnIzKIa/BLSK
         mvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=RWFJQ1qkbsa5F3INdZSYF9XYBxAarnZZ0OkMW84AtA8=;
        b=hNI/wl7xPfG3kyEhGD0KV/gM1yzdnQuYpwQeUUsoWRaslf9kr6ri4ZzvcSl6txCN5A
         NPY28dGbdL2oy64vxdBQ3mEEftsSfvrDe1EBmyuSb5aBg5qSTY/5BSr3YBqg1U3vK0UB
         Kc9qL6GsU0PUbbYxct6aFpc0OrZaanDuHvxrcmo/ajaPhYq+gy11vDPWqOzy+NDtoMqE
         bygIH/oJPLJs0Ge0b1qY61uc/X2c1ehu1a7zJrOol9TKuiglh6Z8EP8ZCAdYkz+whghu
         69N6lG+3bSZxB1q+nXxLka0Wk4U8HXy9vUhv4AmUUQfRjBz9Ykm6t1VU1K2qPxSvO8h6
         1THQ==
X-Gm-Message-State: AOAM533F+7TGg/HIoeoUht7R9EMuF8kQHU4RfUP3NHRAXxKbpZvc7jJ2
        P/31t/ndCVc9FWgMUNiF/5+tcryu/6Q=
X-Google-Smtp-Source: ABdhPJxluh+TYNpvVp7WU8UgvTkY7srzCDOyThCkI5cSoJeP/dJDejCwfWN4KVkKLwHJA8WYTguDiw==
X-Received: by 2002:a17:902:e842:b0:142:dbc:bade with SMTP id t2-20020a170902e84200b001420dbcbademr9982447plg.45.1636486780839;
        Tue, 09 Nov 2021 11:39:40 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id 11sm19166161pfl.41.2021.11.09.11.39.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Nov 2021 11:39:40 -0800 (PST)
Subject: Re: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Randy Dunlap <rdunlap@infradead.org>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
References: <20211109040242.11615-1-schmitzmic@gmail.com>
 <20211109040242.11615-4-schmitzmic@gmail.com>
 <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org>
 <d5fa96b6-a351-1195-7967-25c26d9a04fb@gmail.com>
 <c7ab4109-9abf-dfe8-0325-7d3e113aa66c@infradead.org>
 <1ed3a71a-e57b-0754-b719-36ac862413da@gmail.com>
 <f5fb3808-b658-abfb-3b33-4ded8cd8ba57@infradead.org>
Cc:     alex@kazik.de, netdev@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <bcf2265d-cbd3-83dd-0131-a72efa97fd99@gmail.com>
Date:   Wed, 10 Nov 2021 08:39:34 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <f5fb3808-b658-abfb-3b33-4ded8cd8ba57@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert,

On 10/11/21 08:25, Randy Dunlap wrote:
>>>>> There are no other drivers that "select PCCARD" or
>>>>> "select PCMCIA" in the entire kernel tree.
>>>>> I don't see any good justification to allow it here.
>>>>
>>>> Amiga doesn't use anything from the core PCMCIA code, instead
>>>> providing its own basic PCMCIA support code.
>>>>
>>>> I had initially duplicated some of the cis tuple parser code, but
>>>> decided to use what's already there instead.
>>>>
>>>> I can drop these selects, and add instructions to manually select
>>>> these options in the Kconfig help section. Seemed a little error prone
>>>> to me.
>>>
>>> Just make it the same as other drivers in this respect, please.
>>
>> "depends on PCMCIA" is what I've seen for other drivers. That is not
>> really appropriate for the APNE driver (8 bit cards work fine with
>> just the support code from arch/m68k/amiga/pcmcia.c).
>>
>> Please confirm that "depends on PCMCIA" is what you want me to use?
>
> Hi Michael,
>
> I don't want to see this driver using 'select', so that probably only
> leaves "depends on".
> But if you or Geert tell me that I am bonkers, so be it. :)

Are you OK with adding CONFIG_PCCARD=y and CONFIG_PCMCIA=y to 
amiga_defconfig to allow APNE to still be built when changed to depend 
on PCMCIA?

Cheers,

	Michael

>
> Thanks.
