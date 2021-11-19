Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67510457165
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhKSPJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhKSPJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:09:34 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BED7C061574;
        Fri, 19 Nov 2021 07:06:32 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id p18so8781400wmq.5;
        Fri, 19 Nov 2021 07:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9LghidGzK5wVxoEesb/L8gTDRQW74I1XzqD+h7Ydxd8=;
        b=ThJg3WF09aFCTuH2nUMR2RjPEiyZEHH/Ew5m2/uZZSMAXSP+tUthdSO1fmjo2qKWeU
         45Hn8Hgn91hV5q+U6rorUGLM2sMuPDHYa9LJlaaq4CGvWIdUAiWRzi7l32411ezoz7Ed
         UfEhsgFqn/TYVjlTQ1x6OtTfh4ZgxcGVNdiY8dyFmAyRcy8suheoHZR/1Dey0LgdcvG+
         mankWsi9N4kQ6WRh+ekZfYzxKW7qeB6RN1v8FkSZ+4tesaMcXM8Cgfdtx8KejMMX8Vg5
         5KEZ1IPldun0lw36a/VB9DNib6XHhQiudT9RMvJEyRiGROFsOfg9l4q11bv5IhtZMxc3
         R0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9LghidGzK5wVxoEesb/L8gTDRQW74I1XzqD+h7Ydxd8=;
        b=nbCB00TCBy5D3lyYmHEG/qV2Y4ZsHAUIaF4gCWgOnkRNVNciPWtlob6uISdOjhq2CD
         vPYAcGLBKJxUIsOKdRGc6BvGMrqeVZKPrZK4H9mDZHf7GHHGQj7n5nObsBh2HlTKTbWd
         yYJ7i+sZ2jk7dEUrXjB8+d+ceM97WToKbG/zzWLzQ8I1/GUU3Nj6rlYM3j16GP+hQeam
         YPtHVkF/fpe6INCKBsVf9bRegCwbKhLk+hPIl6bD2QTFNJm81QYQh2HhyUMx0ZZ6rjIM
         EApIpSTBUYvr4r3zLz4Vr1CKwTWTwF6j5+En3nliBOKk8kyKWLdB2Nedw/NCkmd47sWQ
         lFKw==
X-Gm-Message-State: AOAM531z1V463rK4bEw729uHnPaT1CJgXXWKrXtMCepiKp1A02wENoJb
        7dRl8ccy9KPltv1zLXA+bdQ=
X-Google-Smtp-Source: ABdhPJzu9ei/pAU2yn2kzxvlKTIuV+OQKa9BIy8XnEer1U+7uUmszt8b/HqJvarFM0xoXQ8IPgXm6g==
X-Received: by 2002:a1c:6a0e:: with SMTP id f14mr409487wmc.58.1637334391087;
        Fri, 19 Nov 2021 07:06:31 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id u23sm29930wru.21.2021.11.19.07.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 07:06:30 -0800 (PST)
Message-ID: <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
Date:   Fri, 19 Nov 2021 16:06:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On 11/19/21 15:47, Arnd Bergmann wrote:
> On Fri, Nov 19, 2021 at 12:36 PM Alejandro Colomar
> <alx.manpages@gmail.com> wrote:
>>
>> Alejandro Colomar (17):
>>   linux/container_of.h: Add memberof(T, m)
>>   Use memberof(T, m) instead of explicit NULL dereference
>>   Replace some uses of memberof() by its wrappers
>>   linux/memberof.h: Move memberof() to separate header
>>   linux/typeof_member.h: Move typeof_member() to a separate header
>>   Simplify sizeof(typeof_member()) to sizeof_field()
>>   linux/NULL.h: Move NULL to a separate header
>>   linux/offsetof.h: Move offsetof(T, m) to a separate header
>>   linux/offsetof.h: Implement offsetof() in terms of memberof()
>>   linux/container_of.h: Implement container_of_safe() in terms of
>>     container_of()
>>   linux/container_of.h: Cosmetic
>>   linux/container_of.h: Remove unnecessary cast to (void *)
> 
> My feeling is that this takes the separation too far: by having this many header
> files that end up being included from practically every single .c file
> in the kernel,
> I think you end up making compile speed worse overall.
> 
> If your goal is to avoid having to recompile as much of the kernel
> after touching
> a header, I think a better approach is to help untangle the dependencies, e.g.
> by splitting out type definitions from headers with inline functions (most
> indirect header dependencies are on type definitions) and by focusing on
> linux/fs.h, linux/sched.h, linux/mm.h and how they interact with the rest of the
> headers. At the moment, these are included in most .c files and they in turn
> include a ton of other headers.

Yes, I would like to untangle the dependencies.

The main reason I started doing this splitting
is because I wouldn't be able to include
<linux/stddef.h> in some headers,
because it pulled too much stuff that broke unrelated things.

So that's why I started from there.

I for example would like to get NULL in memberof()
without puling anything else,
so <linux/NULL.h> makes sense for that.

It's clear that every .c wants NULL,
but it's not so clear that every .c wants
everything that <linux/stddef.h> pulls indirectly.

But I'll note that linux/fs.h, linux/sched.h, linux/mm.h are
interesting headers for further splitting.


BTW, I also have a longstanding doubt about
how header files are organized in the kernel,
and which headers can and cannot be included
from which other files.

For example I see that files in samples or scripts or tools,
that redefine many things such as offsetof() or ARRAY_SIZE(),
and I don't know if there's a good reason for that,
or if I should simply remove all that stuff and
include <linux/offsetof.h> everywhere I see offsetof() being used.



Thanks,
Alex

-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
