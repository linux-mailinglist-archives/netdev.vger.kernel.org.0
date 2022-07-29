Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FBF58545B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiG2RVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiG2RVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:21:24 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F9F7F51E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:21:24 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id n133so6500663oib.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=48xpsfUfYzMAhf4n0qBQeYIP2Eaow/G0xxnR89oFbIQ=;
        b=isQpOklwiylZzvyfYjo1NGrbCuaQgsw11zN+t6BJWitKiC+E6QfECHlbbm5ymwR6Fz
         c97pVGmQOam1WVDyDW7G2TT0dfCjDrJPqElf4+QzI9aa1VoYRQy2/O7whI9tAcvut1Wb
         MXRdPnMU2OlWNmTpEz7U7Z323BK/aOBp79HsbROHBgtlKnbdILwymXJNfeHKG3GHLAhj
         pZiyNnhefivr7gE6EALO6pKYui95xJWjgEjzbWgWPOyzK0yaS1jXJPjbN2X27zkR2Jey
         mGrswqHxyeqyZM6W9hQ3kMXUNgnyiyrHGN9I4PpiavCRHNHOe6R5vNbRLQr79qzlpWNX
         urqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=48xpsfUfYzMAhf4n0qBQeYIP2Eaow/G0xxnR89oFbIQ=;
        b=kTtu3Fmp9wdWuGhhvlTDFWOuHnP8mJDRa5UNlKFYyIDihjYwh0T8Hj+AJKhIyTgKfp
         XBc122wtmXQKK7/M2WD2KnndC2+iKI9riRHvIjIPn+JIJSJb7IccMu/rS5SSzjbqDQrD
         cmQjhtj2hwNg9H4goGbtwf06hJ467eV0r9X0YlpX6fl2A6IZd2ZNDPoo5yWjdVcmhCjr
         +LtXXpffvYMlUnSuBIG4eD6WkHvcBJO10TMhHkju08ZoBIU+l+qdeFqQs8xRCP2SsLOP
         fcZTsajczQC3OfQMlVEi/awumonT8Cfoo0qzHXZyOV6nMVEj0aDybLrSGrFIlRDqSIEE
         cVbQ==
X-Gm-Message-State: AJIora9DCe2YgRySGQAfEI0MCU0fFWEgRu6hJ35VyRKdIGvUySKaV3Kr
        vdIY6iMbQWuwApO4bEcp7Fs=
X-Google-Smtp-Source: AGRyM1sNqtShcwAGoRtPfP55j+cFutB21WsE1SbqKSQ6vgkCbRpb29E6C06u3ug7bO6NL3COFqYXqg==
X-Received: by 2002:a05:6808:1aaf:b0:32e:fec8:b67c with SMTP id bm47-20020a0568081aaf00b0032efec8b67cmr2312930oib.118.1659115283447;
        Fri, 29 Jul 2022 10:21:23 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id 67-20020a9d0dc9000000b0061c862ac067sm1330924ots.62.2022.07.29.10.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 10:21:23 -0700 (PDT)
Message-ID: <9d3f9a10-097f-0630-193d-fe6115ac7e74@gmail.com>
Date:   Fri, 29 Jul 2022 11:21:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute-next v4 2/3] lib: Introduce ppp protocols
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, stephen@networkplumber.org
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-3-wojciech.drewek@intel.com>
 <e00f3b23-7d9d-d8f1-646c-eaf843f744b5@gmail.com>
 <20220729160351.GD10877@pc-4.home>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220729160351.GD10877@pc-4.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 10:03 AM, Guillaume Nault wrote:
> On Fri, Jul 29, 2022 at 08:58:07AM -0600, David Ahern wrote:
>> On 7/29/22 2:50 AM, Wojciech Drewek wrote:
>>> PPP protocol field uses different values than ethertype. Introduce
>>> utilities for translating PPP protocols from strings to values
>>> and vice versa. Use generic API from utils in order to get
>>> proto id and name.
>>>
>>> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
>>> ---
>>> v4: ppp_defs.h removed
>>> ---
>>>  include/rt_names.h |  3 +++
>>>  lib/Makefile       |  2 +-
>>>  lib/ppp_proto.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 56 insertions(+), 1 deletion(-)
>>>  create mode 100644 lib/ppp_proto.c
>>>
>>
>> Ubuntu 20.04 with gcc 9.4 and clang 10.0 - both fail the same:
>>
>> $ make
>>
>> lib
>>     CC       ppp_proto.o
>> In file included from ppp_proto.c:9:
>> ../include/uapi/linux/ppp_defs.h:151:5: error: unknown type name
>> ‘__kernel_old_time_t’
>>   151 |     __kernel_old_time_t xmit_idle; /* time since last NP packet
>> sent */
>>       |     ^~~~~~~~~~~~~~~~~~~
>> ../include/uapi/linux/ppp_defs.h:152:5: error: unknown type name
>> ‘__kernel_old_time_t’
>>   152 |     __kernel_old_time_t recv_idle; /* time since last NP packet
>> received */
>>       |     ^~~~~~~~~~~~~~~~~~~
>> make[1]: *** [../config.mk:58: ppp_proto.o] Error 1
>> make: *** [Makefile:77: all] Error 2
> 
> Works for me on Debian 11 (Bullseye), where __kernel_old_time_t is
> defined in /usr/include/asm-generic/posix_types.h (package
> linux-libc-dev).
> 
> I guess the Ubuntu 20.04 failure happens because it's based on
> Linux 5.4, while __kernel_old_time_t was introduced in v5.5 (by
> commit 94c467ddb273 ("y2038: add __kernel_old_timespec and
> __kernel_old_time_t")).
> 
> Not sure how to resolve this. This series doesn't need the
> struct ppp_idle that depends on __kernel_old_time_t.
> 

I can fix this by importing posix_types.h from kernel headers.

