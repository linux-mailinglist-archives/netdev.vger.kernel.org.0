Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7AD3AE00C
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 21:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFTTir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 15:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhFTTiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 15:38:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15692C061574;
        Sun, 20 Jun 2021 12:36:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g4so8717716pjk.0;
        Sun, 20 Jun 2021 12:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=JWnPB9GYbwd6aBMbqWYxCaOlKP4zu4SVtde98qLIqJI=;
        b=oo0esJ1OLIY+21LOykr5RYOjbXsLM3QobOJ67ybNsI4MgcyEzfpGXn7FsTSN7Xe3cR
         O70ZzcEY2CSvkn2onc7Yug15v+MdiOhvTYck2Dpu1YGX84CgcUCEaImWFfM2XOPzT+c3
         CJbJ54ZHURFeYNFVCbpB6wUKEZMM4FXPgzTXt2IiBEHgU1K+KPVTKRpaI8IDqATTKOHz
         jXjQzArlDBNibbI+7tKTafcPDNg4gzj+w8TPyasFgjuLd1/zozQqprdbZaOybAPyS5ZW
         khpQ48Lrasr1s6dI25GiXx6xfCZvLqhSWQkShRQuprI79lzCGNgKgm+mrhWYZ7iQ762O
         CdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JWnPB9GYbwd6aBMbqWYxCaOlKP4zu4SVtde98qLIqJI=;
        b=cJK32jRcNTUKDYsXqRQMy0HDNA6PPJFuPsOt1Nsx9TM4FspAwdu6Oa+OhTJ4M0dCqB
         o+aLS5gl+LVkHOO0po1SAZ7JNqJ5xOMCx9SM+GEAcLZAGy1ZvX9N5GazU6eoCReqTmQ9
         PB/NCdmScf5S3X459YLji0iU+rAgZ9xS9SdqC7l6tIU+T9hdZOyXlXxPqWVV7qfl3ehu
         PtxPubDYlIqy4VrJk3+NHxTVBn1Dugoz9flX6zUJa/VcaPbLhINWNSsHoHPgwjCLdI/m
         wcsFOOXb9fpJjauJ7XS3CggIFjShgd8GTrqLeI4FLAKZCSC2hJKwsAEKXsXjpXJvp3QJ
         wkDg==
X-Gm-Message-State: AOAM532394Bv1U68PIjI9/02utdCGMLoFSUYI7JnTifW7ECxcdsI1W08
        IsISHY4M8vicxhf/huHgiRCV5eTeLZw=
X-Google-Smtp-Source: ABdhPJz5Of9xXreoBVuWwV/dVZcT9wmdoyT8yswrcHHPvHVyCy1JbvZgz72z8dAxf2Jj8MLMQGOyGA==
X-Received: by 2002:a17:90a:e2d4:: with SMTP id fr20mr34294134pjb.92.1624217791189;
        Sun, 20 Jun 2021 12:36:31 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:e4cb:9037:8dab:1327? ([2001:df0:0:200c:e4cb:9037:8dab:1327])
        by smtp.gmail.com with ESMTPSA id 10sm4538665pgl.42.2021.06.20.12.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 12:36:30 -0700 (PDT)
Subject: Re: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com>
 <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
 <CAMuHMdUSGWGMs6_wqy-CkfuKsdk=EBpEVBf3UugxCuo3qZQCKg@mail.gmail.com>
 <5e753883-d8c1-8e2a-9cd8-e6c315862fa2@gmail.com>
 <CAMuHMdXPY6w3_rg9nKkiZc1d-bEW84G8xzD0kYEqRiwj6hLWhA@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <1bab15e8-df1a-a4bc-fb3c-e0461f64197b@gmail.com>
Date:   Mon, 21 Jun 2021 07:36:26 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXPY6w3_rg9nKkiZc1d-bEW84G8xzD0kYEqRiwj6hLWhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On 20/06/21 11:47 pm, Geert Uytterhoeven wrote:
>
>>> Thanks for your patch!
>>>
>>> Note that this patch has a hard dependency on "[PATCH v5 1/2] m68k:
>>> io_mm.h - add APNE 100 MBit support" in the series, so it must not
>>> be applied to the netdev tree yet.
>> Hmm - so we ought to protect the new code by
>>
>> #ifdef ARCH_HAVE_16BIT_PCMCIA
>>
>> and set that in the m68k machine Kconfig in the first patch?
>>
>> (It's almost, but not quite like a config option :-)
> No, we just manage dependencies, so either:
>    1. Patch 2 cannot go in until patch 1 is upstream,
>    2. One subsystem maintainer gives an Acked-by for one patch,so
>      the other subsystem maintainer can apply both patches.

I haven't had any review from netdev yet - option 1 looks more feasible 
(if you want to carry a patch that's useless without its follow-up). And 
with the autoprobe failing (if I understood Alex right), I'll have to 
think of something else or drop that patch again.

Is there anything (aside from linking to the e-mail thread) that I can 
do to help netdev maintainers locate the first patch? The commit ID 
won't remain the same once accepted upstream, am I right?

Cheers,

     Michael

>
> Gr{oetje,eeting}s,
>
>                          Geert
>
