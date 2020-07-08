Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635B2218A55
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 16:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgGHOpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 10:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729595AbgGHOpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 10:45:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8730C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 07:45:11 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so3496856wml.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 07:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fc4KnEffUvQB/oNSYpWwJbyjRytXaDaN17/sCf/oA7Q=;
        b=IcAsBtUB4URdx/gIyn2x6DXUaPkUPOWMbnmGx71HioGYufhYQpt/H0YWMOBNNZ5APg
         vjCHA8+5dAzUuDwMki2CuZVIa17IHb6UJuzmcuvdLgQh0WQLispLi4STKjMY4C5lTSII
         7jBLHpSBSFPFEbpVzVgIV+iceGyTG9MG5lJ4CSQ9VRIiBtfGSUyNyZRDDRsdWX2FmivF
         5g9NJZpL4pFP55YYY1r29Ln4gdza4+H2nlHkrjZ3sKLC8smn11fqbfZgDKuf3d7fba10
         MkqYFMZ8zdwk6Jymdz238fUT7GOufE/ysURiK6b7yR3Yk0M1l5UmsXpaPinBZdteRg92
         kNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fc4KnEffUvQB/oNSYpWwJbyjRytXaDaN17/sCf/oA7Q=;
        b=hyLh7oVy3kuWxpA9cQn3cEf8wGNpZ75sFTNGXW3HK9otP38Z4somyvpV5lMremlo0Q
         NtVX8JjA/yQt4xLY5Uj9ct+WrdwJseTCmRQMknhtbeh/H54E99zrbm2qtQ1feV92+HiC
         O5vlwovep49ThTiERD61sCYp+e6IuoXtjRBn51dODuqUd8chTMZ7Hv/l2CAKw/RuG4LN
         37fPsEW9aaAwgX6jRSbWejrfHHi3BC9UV1hXQUxG7wVD34fQGvShaKefHlpyKfcpQy+j
         7ZiENaQJJN/rFv5+eKuj81X488PO0jqf5AwjOn4u0O75y8dykR2IL9d63HduBAw+FETZ
         9bOw==
X-Gm-Message-State: AOAM5328VkEqMajh9UpQizgxo3KDBcU5XihtuBmJ/CjQxB6282j2xXEX
        09eoqrAeiGL54woV1K2LqPf7tg==
X-Google-Smtp-Source: ABdhPJwHoMhCq305e6b9BY+vLJ9rM3lf/u6IzBaUyDar/cwILgegc9GMxqGWV+ZxmHRbmCsxaMEzFw==
X-Received: by 2002:a7b:c921:: with SMTP id h1mr9000961wml.29.1594219510130;
        Wed, 08 Jul 2020 07:45:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y77sm7237949wmd.36.2020.07.08.07.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 07:45:09 -0700 (PDT)
Date:   Wed, 8 Jul 2020 16:45:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
Message-ID: <20200708144508.GB3667@nanopsycho.orion>
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <20200707100556.GB2251@nanopsycho.orion>
 <20877e09-45f2-fa89-d11c-4ae73c9a7310@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20877e09-45f2-fa89-d11c-4ae73c9a7310@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 08, 2020 at 03:54:14PM CEST, jhs@mojatatu.com wrote:
>On 2020-07-07 6:05 a.m., Jiri Pirko wrote:
>> Fri, Jul 03, 2020 at 01:22:47PM CEST, jhs@mojatatu.com wrote:
>> > Hi,
>> > 
>> > Several comments:
>> > 1) I agree with previous comments that you should
>> > look at incorporating this into skbedit.
>> > Unless incorporating into skbedit introduces huge
>> > complexity, IMO it belongs there.
>> > 
>> > 2) I think it would make sense to create a skb hash classifier
>> > instead of tying this entirely to flower i.e i should not
>> > have to change u32 just so i can support hash classification.
>> 
>> Well, we don't have multiple classifiers for each flower match, we have
>> them all in one classifier.
>
>Packet data matches, yes - makes sense. You could argue the same for
>the other classifiers.
>
>> It turned out to be very convenient and
>> intuitive for people to use one classifier to do the job for them.
>
>IMO:
>For this specific case where _offload_ is the main use case i think
>it is not a good idea because flower on ingress is slow.

Eh? What do you mean by that?


>The goal of offloading classifiers to hardware is so one can reduce
>consumed cpu cycles on the host. If the hardware
>has done the classification for me, a simple hash lookup of the
>32 bit skbhash(similar to fw) in the host would be a lot less
>compute intensive than running flower's algorithm.

It is totally up to the driver/fw how they decide to offload flower.
There are multiple ways. So I don't really follow what do you mean by
"flower's algorithm"


>
>I think there is a line for adding everything in one place,
>my main concern is that this feature this is needed
>by all classifiers and not just flower.

"All" is effectively only flower. Let's be clear about that.


>
>
>> Modularity is nice, but useability is I think more important in this
>> case. Flower turned out to do good job there.
>> 
>
>For humans, agreed everything in one place is convinient.
>Note: your arguement could be used for "ls" to include "grep"
>functionality because in my scripts I do both most of the time.
>
>cheers,
>jamal
>
>
>
>> + Nothing stops you from creating separate classifier to match on hash
>> as you wanted to :)
>> 
>> 
