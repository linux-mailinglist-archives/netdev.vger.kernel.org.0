Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB32135CF7E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243030AbhDLRbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbhDLRbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:31:39 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96DCC061574;
        Mon, 12 Apr 2021 10:31:20 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso11624980otb.13;
        Mon, 12 Apr 2021 10:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e3VEpGhYiefaJKeY4+NLvTiF0Tsi+ZBQQ0EZDI3Jxos=;
        b=LtZNNOIN24GLzWMKQzqihFUsvq2DvB2PGVInZ/pNVLaU2OJX7hP0p8G2k9KrGB/pFZ
         tXm5vXTukZydEvmCehdvm1z+6402pypqRCHh2rHCgDEccO79Qhik86/B4qUWrSUy5rRw
         Fj0ucQcTwwpYgPlko5lGLdjIlKhF/2BirgyIyKSJKQ/wRWvPshuE7EbjfKNgbJrfcTJG
         r5XHDIjF9fh0F9RLSoCzrBHS4TQ6ET3pv8HhEMSyvzKRbVV7Z965J3kkt1vksHmAKb5D
         jnKKkB265gQdOHF313c3pVqP3Wgjbqx56n1YndlnPfpQ+fM/wpMr9rkOZCXp+NfuUkUU
         PHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=e3VEpGhYiefaJKeY4+NLvTiF0Tsi+ZBQQ0EZDI3Jxos=;
        b=Mtuc82jg62JtjWb0OuEskZCsBprQ3tHOL0i7KsPHsL6dLJmqo90IhQ0OwQncXRtcWw
         nEt7h9PAN9OOZ8d3vub/V+tL7Kf1gmWYXFTif1+CCG/pCzTJ9lBH8mNtXMyD/9+j/OB6
         7UY4Wt3ruNUIcX9KOcAg/XoJq/3u1MXb/i+HkSKK7yhkYaVB02amFX4dOKzOB7PnyUFR
         Tqpaw8Gyf8lBM/JLIV/VLy++BKKV5swXJPkKpEpMjTVDAD6ZD0LWk2kJoHqybTEc4m8t
         hBbxOIxFQjiDwNIxRpjD2qZKAghxk8PxgQ8DVVkw1kLtybHi4KNOR4fEY3xZpqKANBXg
         RREw==
X-Gm-Message-State: AOAM531AvMysaHp/bEYSd3QrpmTTqbbK5qflkE//0gI9a+22HWUt+Smv
        DCGG+vGhfvW7SrZdoXh7Z9ZOvh2RgXc=
X-Google-Smtp-Source: ABdhPJyktvCedEmcjABjRaVnLcIETPgZpNf6bFNB3wPPEfRdGnoJG9qfRl/PtwYlTtKvDqdi0633mQ==
X-Received: by 2002:a05:6830:1f0b:: with SMTP id u11mr4016794otg.104.1618248679878;
        Mon, 12 Apr 2021 10:31:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j4sm1178311oiw.0.2021.04.12.10.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 10:31:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: Linux 5.12-rc7
To:     Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net>
 <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
 <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <78c858ba-a847-884f-80c3-cb1eb84d4113@roeck-us.net>
Date:   Mon, 12 Apr 2021 10:31:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/21 9:31 AM, Eric Dumazet wrote:
> On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> Qemu test results:
>>>         total: 460 pass: 459 fail: 1
>>> Failed tests:
>>>         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
>>>
>>> The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
>>> skb->head"). It is a spurious problem - the test passes roughly every other
>>> time. When the failure is seen, udhcpc fails to get an IP address and aborts
>>> with SIGTERM. So far I have only seen this with the "sh" architecture.
>>
>> Hmm. Let's add in some more of the people involved in that commit, and
>> also netdev.
>>
>> Nothing in there looks like it should have any interaction with
>> architecture, so that "it happens on sh" sounds odd, but maybe it's
>> some particular interaction with the qemu environment.
> 
> Yes, maybe.
> 
> I spent few hours on this, and suspect a buggy memcpy() implementation
> on SH, but this was not conclusive.
> 

I replaced all memcpy() calls in skbuff.h with calls to

static inline void __my_memcpy(unsigned char *to, const unsigned char *from,
                               unsigned int len)
{
       while (len--)
               *to++ = *from++;
}

That made no difference, so unless you have some other memcpy() in mind that
seems to be unlikely.

> By pulling one extra byte, the problem goes away.
> 
> Strange thing is that the udhcpc process does not go past sendto().
> 

I have been trying to debug that one. Unfortunately gdb doesn't work with sh,
so I can't use it to debug the problem. I'll spend some more time on this today.

Thanks,
Guenter
