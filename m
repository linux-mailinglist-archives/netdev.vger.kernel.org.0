Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBAC337ACB
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCKR0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhCKR0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 12:26:37 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93897C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:26:37 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id c10so19623915ilo.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 09:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vWFZnSI4fjpP6NU9dzwqzAIildDi5xJ9YhZRlXp99p0=;
        b=kbCzRhDkcw7edOjdu5Djo5PKGjeUjIL5OpioQ2frXcN+28UYmm4T4yRs3OLbHzIoC4
         TmcJ9Q9AHUFXwMqaKKowTCrHtjBwFPBpeoVGoAU0LCmDwsE+gw4eZcY7HzR20huAsFXo
         GTM6iKuYRcN+ecCxgJmGV8SUzaEVdzZouRXI47Rgir2oP8VMZD3zuRWVL7JqanQOjloj
         7onjU2r0fCyaD/kKP8S5UeqDTCB2s7WV6xS3CzvkHEaTY67AcEeoTr0SNjr3pwSQB+SQ
         cCX3uzu6JBTbxvwLmfKEvmB4HOsH1yI4GI5tpdVf3CAikbi3L+AFQgznbYVcNDeUcPMz
         qObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vWFZnSI4fjpP6NU9dzwqzAIildDi5xJ9YhZRlXp99p0=;
        b=SUkYLZSmYYLwTqttjfvmzCVWZZFHiwWHKNiU6uOBuJCmb0EpmMZyAZd0/TUdOKHNIn
         Cp44+vkDReS0uBWEfqHGw8GDZJKZudlYN/mdvta6r6YK7TZhNePRFjR+mjgAwvBpbpah
         htCpxCFymXy4TQaqDG3Nm1Rcl10+6K0LpVYnFKlc0TbFdo/qwjHkJqqQ79gErFkJFQBl
         84Q76ZkJlJIum7ko/OuiVk9g/vU+RnBXd/Szra2URThqdF/PDSAMeDNXGGJ60HwrwtCN
         qszm1xixwFq1/C5jdlrd8Oue14HgBg6ff4cGgo3XCuK4hbVpRqIYuLbrrGRcCMdOmsIn
         c94w==
X-Gm-Message-State: AOAM5329UQ8nqCvKLYYpztFjLBk8Kr/XY+JDT92pJL+zhA96BwoIz2MJ
        nKrlACjUr66Bdtd6XxJd4504Yg==
X-Google-Smtp-Source: ABdhPJxU+noZwRpmQOeVN97CJ6ZDHv+8w4K/YZtng/MXM+LgskPMj/Jvfr46NPDeUiTMV1xrzxK4MA==
X-Received: by 2002:a92:50c:: with SMTP id q12mr7590083ile.59.1615483596910;
        Thu, 11 Mar 2021 09:26:36 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v8sm1611079ilg.21.2021.03.11.09.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 09:26:36 -0800 (PST)
Subject: Re: [PATCH net-next v3 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, David.Laight@ACULAB.COM, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210309124848.238327-1-elder@linaro.org>
 <bb7608cc-4a83-0e1d-0124-656246ec4a1f@linaro.org>
 <20210310002731.adinf2sgzeshkjqd@skbuf>
From:   Alex Elder <elder@linaro.org>
Message-ID: <65399001-78bb-a810-0e65-2f692810fafa@linaro.org>
Date:   Thu, 11 Mar 2021 11:26:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310002731.adinf2sgzeshkjqd@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 6:27 PM, Vladimir Oltean wrote:
> Hi Alex,
> 
> On Tue, Mar 09, 2021 at 05:39:20PM -0600, Alex Elder wrote:
>> On 3/9/21 6:48 AM, Alex Elder wrote:
>>> Version 3 of this series uses BIT() rather than GENMASK() to define
>>> single-bit masks.  It then uses a simple AND (&) operation rather
>>> than (e.g.) u8_get_bits() to access such flags.  This was suggested
>>> by David Laight and really prefer the result.  With Bjorn's
>>> permission I have preserved his Reviewed-by tags on the first five
>>> patches.
>>
>> Nice as all this looks, it doesn't *work*.  I did some very basic
>> testing before sending out version 3, but not enough.  (More on
>> the problem, below).
>>
>> 		--> I retract this series <--
>>
>> I will send out an update (version 4).  But I won't be doing it
>> for a few more days.
>>
>> The problem is that the BIT() flags are defined in host byte
>> order.  But the values they're compared against are not always
>> (or perhaps, never) in host byte order.
>>
>> I regret the error, and will do a complete set of testing on
>> version 4 before sending it out for review.
> 
> I think I understand some of your pain. I had a similar situation trying

I appreciate your saying that.  In this case these were
mistakes of my own making, but it has been surprisingly
tricky to make sense of exactly how bits are laid out
under various scenarios, old and new.

> to write a driver for hardware with very strange bitfield organization,
> and my top priority was actually maintaining a set of bitfield definitions
> that could be taken directly from the user manual of said piece of
> hardware (and similar to you, I dislike C bitfields). What I came up

That seems like a reasonable thing to do.  The conventional
layout of big endian bytes and bits in network documentation
is great, but it is also different from other conventions
used elsewhere, and sometimes that too can lead to confusion.

For example, network specs list tend to show groups of 4 bytes
in  a row with high-order byte *and bit* numbered 0:

  high order byte
|       0       |          1          |    2    |     3    |
|0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|   ...   |  ...  |31|
  ^-- high bit

While SCSI shows 1 byte rows, high-order bit numbered 7:

Byte| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
  0  | ^-- high bit                  |
  1  |

> with was an entirely new API called packing() which is described here:
> https://www.kernel.org/doc/html/latest/core-api/packing.html

I was not aware of that.  And I have now looked at it and have
a few comments, below.

> It doesn't have any users except code added by me (some in Ethernet fast
> paths), and it has some limitations (mainly that it only has support for
> u64 CPU words), but on the other hand, it's easy to understand, easy to
> use, supports any bit/byte layout under the sun, doesn't suffer from
> unaligned memory access issues due to its byte-by-byte approach, and is
> completely independent of host endianness.
> That said, I'm not completely happy with it because it has slightly
> higher overhead compared to typical bitfield accessors. I've been on the
> fence about even deleting it, considering that it's been two years since
> it's in mainline and it hasn't gained much of a traction. So I would
> rather try to work my way around a different API in the sja1105 driver.
> 
> Have you noticed this API and decided to not use it for whatever reason?

I had not noticed it before you brought it to my attention.

> Could you let me know what that was? Even better, in your quest to fix
> the rmnet driver, have you seen any API that is capable of extracting a
> bitfield that spans two 64-bit halves of an 128 bit word in a custom bit
> layout?

I have not seen an interface that attempts to handle things that
span multiple 64-bit units of memory.

Your document uses big endian 64-bit word (not u64) as its "no
quirks" example (listing high-order bytes first, and numbering
bytes--and bits--starting at higher numbers).  My only objection
to that is that you should probably call it __be64.  Otherwise
I'm just pointing out that it is a convention, and as pointed
out above, it isn't universal.

For my purposes, all registers are 32 bits.  So to use your
packing() interface I would have to implement 32-bit versions
of the function.  But that's not really a big deal.  I do
see what you're doing, defining exactly what you want to
do in the arguments passed to packing(), and allowing the
one function to both encode and extract values in a 64-bit
register regardless of endianness.

Having looked at this, though, I prefer the functions and
macros defined in <linux/bitfield.h>.  Probably the biggest
reason is a bias I have about the fact that a single mask
value represents both the position and width of a field
within a register.  I independently "invented/discovered"
this and implemented it for my own use, only to learn later
it had already been done.  So I switched to the functions
that were already upstream.

The "bitfield.h" functions *require* the field mask to
be a runtime constant.  That is great, because it means
that determining the width and position of fields from
the mask can be done at compile time, and can be done
as efficiently as possible.  The downside is that it
would occasionally be nice to be able to supply a variable
mask value.  I've had to go to some lengths in the IPA
driver to get a result that compiles in some cases.

But because you asked, I'll list some other reasons why
I prefer those functions over your packing() function.
- As mentioned, a single mask defines both the position and
   size of a field.  It is specified in "natural" host byte
   order, but provides options for encoding or extracting
   values for big- or little-endian objects as well.
- I prefer to have the size of the integral types (and the
   operations on them) to be explicit.  I.e., yes, "int"
   is supposed to be the most efficient type on a machine,
   but in working with the hardware I like declaring exactly
   what size object I'm dealing with.  The "bitfield.h"
   functions have that, for every standard word size.
- I think that your one function, although convenient,
   is too general-purpose.  I'd rather *at least* have
   one function for encoding values and a second for
   decoding.
- In contrast, the "bitfield.h" functions each do one
   thing--either encode or extract, on an object of a
   known size and endianness.  The arguments passed are
   minimal but sufficient to perform each operation.
- I prefer having the encoding function *return* the
   encoded value rather than passing the address of
   an object to be updated.
- Although I recognize exactly the problem it solves,
   the QUIRKS flags you have aren't a lot more intuitive
   to me than the __LITTLE_ENDIAN_BITFIELD symbol is.
   At least the names you use offer a little more clarity.

None of these are strong criticisms.  In fact I like that
you created a function/system to solve this problem.  But
you requested some reasoning, so I wanted to offer some.

In this particular RMNet series, I followed conventions
I used for the IPA driver.  In that case, there are many
registers with fields, so it was important to follow
some consistent patterns.  For this case, not nearly as
much generality is needed, so I could probably get away
with simpler masks, possibly without even using the
u16_encode_bits() functions.  Not sure what I'll settle
on but I plan to post version 4 of the series early
next week.

Thanks for your note.  I do appreciate having someone
say "hey, I've been there."  And I'm glad to now be
aware of the packing() function.
	
					-Alex
