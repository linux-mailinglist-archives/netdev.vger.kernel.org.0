Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766BE4593E1
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhKVRW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbhKVRW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:22:28 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8843C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 09:19:21 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u1so34026722wru.13
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 09:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0CJOej3oUWK3486nv5MZZ7Tw+15MsPzmSu6Cd8UnDDg=;
        b=oHaW5kcdBCzkdnDgzzZ5En9xMMWCDRTjp4bC2uuxqNu8oJJlX4bkHFFIVHygGsEpta
         MkjFqplzOBqcXyWHF9LqULt6aublg6DNd2TRI0oP5B+7HLh7mlueAhobuHHXA44rQKdb
         Vr13I/WqraOiLVKOptkwpqrX0u461s8Ad+bX+w6SBfrjfRHKwT3Q0Tg+B98VmjIh4bCZ
         ew6VLIHPQGnj4X6SeLSI1nKXmxbqEJuRVI0chUTwADnGEyo2z2go9S/0EkEZe7kA2PFh
         pv/uQo92stI+AczpY0JZQWMOx52YJw5erTNNHNHG5mroYrsfSpmOT69/w/8KvO95fQoR
         G/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0CJOej3oUWK3486nv5MZZ7Tw+15MsPzmSu6Cd8UnDDg=;
        b=E8o0wZJHmjB0LNE8/L91kYph3T887TlpA7IadHeGZkfu8U2BZ4APstX60GCy+IKpBw
         wKNbX3xp8W9UxkpSj8F+XW3Wy3hcJQuJIPznJVtl11Q0gcDoK6JYuGIxdCQp/3qwqYtf
         AdTIIyUf2Zft5/oV+LyLutEVKLHpOmvhOnRrRmJjnak81XSH4ajlXfyjF2WK9BYl5Ejx
         AVvZDXQaW/XPbUOK02QffC+0ugnlKLfVewpnoHm0y9C5WKKRbC82COhuygi015vC7wFc
         NbPccUU8S384EPj4K/u2/3Q3pzQ4iqJu5S62TUmtfx6WtqQKci9aNLnJj211iFaCWeZ+
         hjBA==
X-Gm-Message-State: AOAM531W0xfFuXK6eMhuMXh1kr33zE/GQ2hj2pce2Ial81LBbDKTdZKu
        7i27fWBpIcVxzpiHkoQLFuE=
X-Google-Smtp-Source: ABdhPJz90glnSIDpg4Umwz7Q7a8XEBOSlt8SfKoZvUL2pB47KD7vtOamKQuD4D+ztMDeg62FuOsJfQ==
X-Received: by 2002:adf:e0d0:: with SMTP id m16mr39546041wri.74.1637601560338;
        Mon, 22 Nov 2021 09:19:20 -0800 (PST)
Received: from [10.168.10.170] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id b188sm9615897wmd.45.2021.11.22.09.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 09:19:20 -0800 (PST)
Message-ID: <bce8cc03-0aba-3915-de98-cdf1c9d183f2@gmail.com>
Date:   Mon, 22 Nov 2021 18:19:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] drivers/net/ethernet/sfc/: Simplify code
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org
Cc:     Martin Habets <habetsm.xilinx@gmail.com>
References: <20211120201425.799946-1-alx.manpages@gmail.com>
 <79eee958-818e-9fb4-6b61-4b510d040a64@gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <79eee958-818e-9fb4-6b61-4b510d040a64@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward,

On 11/22/21 17:17, Edward Cree wrote:
> On 20/11/2021 20:14, Alejandro Colomar wrote:
>> That ternary operator has
>> the same exact code in both of the branches.
>>
>> Unless there's some hidden magic in the condition,
>> there's no reason for it to be,
>> and it can be replaced
>> by the code in one of the branches.
>>
>> That code has been untouched since it was added,
>> so there's no information in git about
>> why it was written that way.
>>
>> Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
>> Cc: Edward Cree <ecree.xilinx@gmail.com>
>> Cc: Martin Habets <habetsm.xilinx@gmail.com>
>> Cc: netdev@vger.kernel.org
> 
> I guess it's there for type-checking — essentially as an assert that
>   field_type == typeof(efx_##source_name.field).  Probably when it was
>   added there was no standard way to do this; now we could probably
>   use <linux/typecheck.h> or some such.
> The comment just above the macro does mention "with type-checking".

Yes, that's why I suggested there was probably some black magic 
involved.  But I couldn't read it, though.

I suggest replacing it with a static_assert(__same_type()) thingy.

Cheers,
Alex


-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
