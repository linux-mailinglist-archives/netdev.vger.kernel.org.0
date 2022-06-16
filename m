Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20F654E195
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiFPNNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376868AbiFPNNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:13:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60922DA96;
        Thu, 16 Jun 2022 06:13:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g7so2153372eda.3;
        Thu, 16 Jun 2022 06:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ry52yRe1vJHeR/NJXumPYFRgdjE89QHepbj+xA03vDI=;
        b=aUne1e5KbwFbS5cXlUlTRO6DxbBw0amZP5ntWJeRpFwLdF61CYzBBzAVkFxkx/C2WL
         kO9F5rKbcKYUFCEmQaLzkRY93MSqFAqhDtigtCa0ROfWwWXXFX9mDoydQIBG7yk7i6h9
         rJfMi2FddN6nA2sc6dJNXHxcGNWAUIF0dVZubsaHuptVbnrH6qj+NxRMdrivQurtOYk+
         t2QeF5AgNd6/9zqK9t8c+aR4zhquLCwx1Zw2Qrb9xin7+ODrrukahYjux16M8Mxz6ohr
         /uOuJffDTI396gOrogv9MV61cU7zrUgoHMxnXz+eSo7cI9RvcBIcS6JE2sFgDi7vXS01
         3keA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ry52yRe1vJHeR/NJXumPYFRgdjE89QHepbj+xA03vDI=;
        b=DySN0tvr5N8psIWdQiFnXK/Ritzfi3x14kizOCybyMWSPvtgKe04rOFiVLQBaEDAaj
         rbFzD+UHfdDB0HZUppykyBzWuiHKjRdHT0W0R6tawCvliDlmAgVu0XxSrhXelbEtFO0R
         lqFpzEvB+Uy5xAnHw0GHvvq3u32Dxr3oxa2Ogdqh5zcIpBtbgsYbNHIy0nblZ+w0OKLj
         pgaKCo0mKIZSwLkHAy+ibG4JWYJhYpjkHFW1skU73gLnBerExjy4jtxAK4uzUqw6wafA
         AhpEhJTtqmPiZ1ndlicnbRrbPaZ2cuLcWII0Q5LkRcMTQ44lvnzQMRAfEihdzShmaUq0
         EeMA==
X-Gm-Message-State: AJIora+O/XQBU0cgifSlqLeFsnIpPlO9C6+G0uDiu3nzSiKG2q5IF7xb
        Lu8nZBmrIQ2QN+0tr4wXPJA=
X-Google-Smtp-Source: AGRyM1tYvWhTzZFvBunl3TLiXBAhnbuKKDXD8wqfxLXwHzyaRErkhmZkBfLntt91OyeMYfVg982itA==
X-Received: by 2002:a50:9f88:0:b0:42d:f7d2:1b7b with SMTP id c8-20020a509f88000000b0042df7d21b7bmr6470768edf.139.1655385207450;
        Thu, 16 Jun 2022 06:13:27 -0700 (PDT)
Received: from debian64.daheim (pd9e290fa.dip0.t-ipconnect.de. [217.226.144.250])
        by smtp.gmail.com with ESMTPSA id x13-20020aa7d6cd000000b004333e3e3199sm1724792edr.63.2022.06.16.06.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 06:13:26 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1o1nQw-003Atz-JA;
        Thu, 16 Jun 2022 15:13:26 +0200
Message-ID: <9fa854e1-ad88-9c18-ca68-5709dc1c7906@gmail.com>
Date:   Thu, 16 Jun 2022 15:13:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Content-Language: de-DE
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
 <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
 <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
 <20220616103640.GB16517@kadam>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220616103640.GB16517@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/06/2022 12:36, Dan Carpenter wrote:
> On Wed, Jun 15, 2022 at 11:03:34PM +0200, Christian Lamparter wrote:
>> On 13/06/2022 22:57, Christophe JAILLET wrote:
>>> Le 13/06/2022 à 22:02, Christian Lamparter a écrit :
>>>> On Sun, Jun 12, 2022 at 11:12 PM Christophe JAILLET
>>>> <christophe.jaillet@wanadoo.fr> wrote:
>>>>>
>>>>> If an error occurs after a successful call to p54spi_request_firmware(), it
>>>>> must be undone by a corresponding release_firmware() as already done in
>>>>> the error handling path of p54spi_request_firmware() and in the .remove()
>>>>> function.
>>>>>
>>>>> Add the missing call in the error handling path and remove it from
>>>>> p54spi_request_firmware() now that it is the responsibility of the caller
>>>>> to release the firmawre
>>>>
>>>> that last word hast a typo:  firmware. (maybe Kalle can fix this in post).
>>>
>>> More or less the same typo twice in a row... _Embarrassed_
>>>
>>>>
>>>>> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
>>>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>>> Acked-by: Christian Lamparter <chunkeey@gmail.com>
>>>> (Though, v1 was fine too.)
>>>>> ---
>>>>> v2: reduce diffstat and take advantage on the fact that release_firmware()
>>>>> checks for NULL
>>>>
>>>> Heh, ok ;) . Now that I see it,  the "ret = p54_parse_firmware(...); ... "
>>>> could have been replaced with "return p54_parse_firmware(dev, priv->firmware);"
>>>> so the p54spi.c could shrink another 5-6 lines.
>>>>
>>>> I think leaving p54spi_request_firmware() callee to deal with
>>>> releasing the firmware
>>>> in the error case as well is nicer because it gets rid of a "but in
>>>> this case" complexity.
>>>
>>>
>>> Take the one you consider being the best one.
>>
>> well said!
>>
>>>
>>> If it deserves a v3 to axe some lines of code, I can do it but, as said
>>> previously,
>>> v1 is for me the cleaner and more future proof.
>>
>> Gee, that last sentence about "future proof" is daring.
> 
> The future is vast and unknowable but one thing which is pretty likely
> is that Christophe's patch will introduce a static checker warning.  We
> really would have expected a to find a release_firmware() in the place
> where it was in the original code.  There is a comment there now so no
> one is going to re-add the release_firmware() but that's been an issue
> in the past.
> 
> I'm sort of surprised that it wasn't a static checker warning already.
> Anyway, I'll add this to Smatch check_unwind.c
> 
> +         { "request_firmware", ALLOC, 0, "*$", &int_zero, &int_zero},
> +         { "release_firmware", RELEASE, 0, "$"},

hmm? I don't follow you there. Why should there be a warning "now"?
(I assume you mean with v2 but not with v1?). If it's because the static
checker can't look beyond the function scope then this would be bad news
since on the "success" path the firmware will stick around until
p54spi_remove().

The p54* drivers would need to be updated (they are ooold) to make good
use of the firmware_cache. There must have been a good reason why it
was designed that way. Especially because the firmware_class uses devm
for the cache already internally. (thanks for Johannes for pointing this
out).

Cheers,
Christian
