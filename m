Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2757E216
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 15:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiGVNMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 09:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVNMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 09:12:08 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5AB6393A
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 06:12:05 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id w188so1327932oiw.8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 06:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HiMK+ix2bOcz/8bYyY1Tmf0kEt/tYxdd+jsqoDwcKBo=;
        b=S737dPGEE/1+GuQcdyQ18RfdvG+l1EOtxGeemJUDV4KAo0GYPf3tHP0j55AoJ2vylQ
         Y1VHgnW98+ApJCa2pV4C4MDb2NoDvIuLrl9j7XZbX/8aLfOLyglHmjA9PHRzLxaiFFU3
         ptwBe3YZN057XneAY+hhqw/mS3Je78ops8JEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HiMK+ix2bOcz/8bYyY1Tmf0kEt/tYxdd+jsqoDwcKBo=;
        b=U6CrxnOf/LZos8AIzX8YGH8Pqdz45rVGo5C5YeP+NAg8G8tDS3VonG33fdO3g3A+0N
         MKgcQ9ybSaK/kbC3Xk2iI+u1IbrMJ24l5WE2lGos1GWPS8okJ1mCFRe1aw4X1aK2EK0L
         kpW3vDd41ltnfyrG4R/xb6XY6+osTzxXHH5zP9Nd6CdTrUj2e36n0rnui7pM0ZmrkGTf
         vapesCERvaMG154wsnU4YE+Y2YMhmc1J1UpXqKwrduKpJiPCVM9g1abcDhZqq4jQVWL8
         dzBNCFqEV14CCM2Mw+FHSnnLxiE6YGRrXufjsKM7WVxBb3FoIQHCNxgG+lZ/VUm092Rk
         Tf1A==
X-Gm-Message-State: AJIora8EaHqwNzPYm+uReyjUIGlSJGKj/gm9vmAnzf6Bfhbs/Rz2MwPw
        4JoIvpU97vCKcep15FKyjczB8Q==
X-Google-Smtp-Source: AGRyM1svb+Z6lmNvDMDgNowYwKcoDfXDU+9Ru8JDjUdHBfTiLfTEuL31PsQofvkNn+4cYOnwmUPXDg==
X-Received: by 2002:a05:6808:1687:b0:32c:3e3e:89b1 with SMTP id bb7-20020a056808168700b0032c3e3e89b1mr154036oib.60.1658495524972;
        Fri, 22 Jul 2022 06:12:04 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q206-20020acaf2d7000000b0033a3e6e7ce9sm1751509oih.10.2022.07.22.06.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 06:12:04 -0700 (PDT)
Message-ID: <a23bd6b6-2244-1e58-20d1-5713d304acfd@ieee.org>
Date:   Fri, 22 Jul 2022 08:12:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: ipa: fix build
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Alex Elder <elder@kernel.org>
References: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
 <5a1c541c-3b61-a838-1502-5224d4b8d0a4@ieee.org>
 <16b633abfdcdcb624054187a5fc342bfeb9831f9.camel@redhat.com>
 <20220721094107.5766c21b@kernel.org>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20220721094107.5766c21b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/22 11:41 AM, Jakub Kicinski wrote:
> On Thu, 21 Jul 2022 16:50:20 +0200 Paolo Abeni wrote:
>>> Interesting...  This didn't happen for me.
>>>
>>>
>>> Can you tell me more about your particular build environment
>>> so I can try to reproduce it?  I haven't tested your fix yet
>>> in my environment.
>>
>> Possibly ENOCOFFEE here, but on net-next@bf2200e8491b,
>>
>> make clean; make allmodconfig; make
>>
>> fails reproducibly here, with gcc 11.3.1, make 4.3.
>>
>> Do you have by chance uncommited local changes?
> 
> Oh, poops. You're right. I think all - the build bots, Alex and I
> build with O=builddir, in which case the build works. I'll let the
> build bot catch up to your fix and apply it. Sorry about that!

I'm glad you know this, I was just about to start figuring
out what the difference was:
- gcc vs clang
- module vs built-in
- x86 vs aarch64
And I didn't even think about "O=<builddir>"...

Is this the right fix?  It's A-OK with me if it is.

(I'm about to try to reproduce it now without "O="...)

Thank you.

					-Alex
