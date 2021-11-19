Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9743C4571C2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhKSPlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:41:53 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172BEC061574;
        Fri, 19 Nov 2021 07:38:51 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id b184-20020a1c1bc1000000b0033140bf8dd5so7799761wmb.5;
        Fri, 19 Nov 2021 07:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AFmWJJSoUz1GaSVge39mjbycrDT+hCXLvixsJ9Vd/mM=;
        b=ODBGo6Iv/FduaI9j0vjuZl2NIBuAxnbGU2bcovlrBdrVJzhUS8rZrJbsWWThxKF4YM
         2piqpAuwsNCJaU29VFoQO7tYp0p/gz57fLRCb6NKGAYpsf7vZMEwatmAL2pakRYrkGS3
         5CyApPlAsK96e4LS/ADUfaZIM6u9y3xUyqMhnbblZWK2zi7mqI87xxyPxJjl4cr+/jre
         TLKuGOqq84YkD9L4lOHMJstQssFNG/qb6pVtF5F1cB7J9M9uCr9cT69YM7CQNz4GtnWJ
         HylPvDX49+FriE9yIj2XYmJ+i5Fb1PUieUloxr46vjRuxiOg6D7glHMfGbWoTqqKniMy
         hK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AFmWJJSoUz1GaSVge39mjbycrDT+hCXLvixsJ9Vd/mM=;
        b=6yRJw7p2Om+pPTZzMZJ8Fg1Lxel3+uHdqloONQTsABoQgzWQRLdN61lsB2dO9/YBmw
         7+dAmKUbJxcnN47xduxm7Tzb4HxrmQ578xBtDxBmruCNGFooerrb2EOiKP60CYXT9fBS
         hem2ec373L8SdIYISR1dDv/Wf7GKbIrwKQrcHx8TBzui3oQKo5Tm9BBEOY04iV/EwbO5
         4raOUGh4Nau3fSLwQzAIxn4zMeC5uCGzEquZrvueyGNTxBrRebbAqeGipHw0g4Ho8f+3
         Tmanp6zZwWCqHIveznLyeyxoft8XblCdqfOxG1hMZjBtQnxnjslLXU/zStZu8T0fwWeC
         nIRA==
X-Gm-Message-State: AOAM530OwdnZHrSY7YlzgTDz1mOHeK5z9tYRVTXNkWhajB6B/BSccZ7H
        tb1a/+bhIFlAFKpDOv4vz5I=
X-Google-Smtp-Source: ABdhPJyzLCj+QPqjCFbp0MdNnUqJ9A2TJYw2WJIoMils7KWBN9n8betYgJkYA9Hvx/wFV4EI5SabHA==
X-Received: by 2002:a1c:790d:: with SMTP id l13mr641345wme.101.1637336329656;
        Fri, 19 Nov 2021 07:38:49 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id g18sm15729789wmq.4.2021.11.19.07.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 07:38:49 -0800 (PST)
Message-ID: <f1a90f53-060e-2960-3926-e30b44a1be28@gmail.com>
Date:   Fri, 19 Nov 2021 16:38:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211119113644.1600-1-alx.manpages@gmail.com>
 <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
 <YZfEHZa3f5MXeqoH@smile.fi.intel.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <YZfEHZa3f5MXeqoH@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On 11/19/21 16:34, Andy Shevchenko wrote:
> On Fri, Nov 19, 2021 at 04:06:27PM +0100, Alejandro Colomar (man-pages) wrote:
>> Yes, I would like to untangle the dependencies.
>>
>> The main reason I started doing this splitting
>> is because I wouldn't be able to include
>> <linux/stddef.h> in some headers,
>> because it pulled too much stuff that broke unrelated things.
>>
>> So that's why I started from there.
>>
>> I for example would like to get NULL in memberof()
>> without puling anything else,
>> so <linux/NULL.h> makes sense for that.
> 
> I don't believe that the code that uses NULL won't include types.h.

I'm not sure about the error I got (I didn't write it down),
but I got a compilation error.
That's why I split NULL.

If one could anwer my doubt,
I would be in better position to learn how to avoid them.
See below.

On 11/19/21 16:06, Alejandro Colomar (man-pages) wrote:
> BTW, I also have a longstanding doubt about
> how header files are organized in the kernel,
> and which headers can and cannot be included
> from which other files.
>
> For example I see that files in samples or scripts or tools,
> that redefine many things such as offsetof() or ARRAY_SIZE(),
> and I don't know if there's a good reason for that,
> or if I should simply remove all that stuff and
> include <linux/offsetof.h> everywhere I see offsetof() being used.

Thanks,
Alex



-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
