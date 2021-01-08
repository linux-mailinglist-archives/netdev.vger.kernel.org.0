Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA2D2EF5A6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbhAHQS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbhAHQS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:18:56 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4E4C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:18:16 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u4so4710790pjn.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lx9S8jUser5JNl6N1HoDJv2+WgVe68bnJmAJ82Z+I/w=;
        b=BPGSXof5QaMpB6SfGWl8y+QeBQpccgw+VGiCqSg5CkUXcQLe1SCOpbwIDWWBhO0S48
         OmXIgLWQBALD/X88oV+llXVxSioW8o04CVZKVhd+SXmyR2lzvfS4mS3JBqganvyubvmj
         FxM2hJa22q75AP53ysNvTeeyoYh9SA7pOoBOMmNDjTEvbVLWXHr7yDqGByE3EIDdnkUg
         x/ass2mTojn41XCWwNYR9FisUHweWz1icfJfmet4e2bWhOFWpRWhciAVmAvxb73O3ooC
         BXaYLo5bsatZfo3/JSDCoBkIsXz3tU8cMgwF/ZIHiEfg7nzYaegEPwyiCora0P36zvAw
         HHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lx9S8jUser5JNl6N1HoDJv2+WgVe68bnJmAJ82Z+I/w=;
        b=Lk052lFqwQCDxVA4mjrUCDKjWevduC06V7anOKJ1iRPn+NTT1NHmGrntN1Z6PtwrH6
         s9iz4dxTQfXZHS+Epq64NHDrxzNZfp229h2MKaE1Emg06S3Gu69MaWzsSRhoGYIN6tYs
         PHrJ+TD0Pr6hfI9VwhtDurVCBCO+q7Om7ESkVH3jadToaZ4HDfsgYOdOj5zPI01/CGTT
         emNhdfA8hYiP5HcPXb4/ajZ3KT2STlg3GvHKgTEXUB9udV8JoJSLLg1OGNGe4uGgWOM1
         ElhOyoBeg1imDkkaXKckhXEf5QN80/XLXStFGgXKMXHVWNz5gYpU1j6bNrnl2vdRdZUP
         MfIw==
X-Gm-Message-State: AOAM531p0WNbmS8RqpenygyBE8v8FY6+wWHd3RYWHNQd9Hfh6YqbOwMZ
        Kh0l+wKJ5CexJp/qAkcK2+sMng==
X-Google-Smtp-Source: ABdhPJxAHh68FMWVElE2OP1n5/1BGh3FB/6fmSqf8rb676qfvu16Im90Y/DWdrw3JSF4+jr7AtEWww==
X-Received: by 2002:a17:90a:bb8c:: with SMTP id v12mr4510453pjr.227.1610122695701;
        Fri, 08 Jan 2021 08:18:15 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g85sm9201047pfb.4.2021.01.08.08.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:18:14 -0800 (PST)
Date:   Fri, 8 Jan 2021 08:18:06 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 v2 1/1] build: Fix link errors on some systems
Message-ID: <20210108081806.2219efda@hermes.local>
In-Reply-To: <875z478tjq.fsf@nvidia.com>
References: <20210107071334.473916-1-roid@nvidia.com>
        <20210107082604.5bf57184@hermes.local>
        <875z478tjq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 14:08:57 +0100
Petr Machata <petrm@nvidia.com> wrote:

> Stephen Hemminger <stephen@networkplumber.org> writes:
> 
> > On Thu,  7 Jan 2021 09:13:34 +0200
> > Roi Dayan <roid@nvidia.com> wrote:
> >  
> >> +#define _IS_JSON_CONTEXT(type) ((type & PRINT_JSON || type & PRINT_ANY) && is_json_context())
> >> +#define _IS_FP_CONTEXT(type) (!is_json_context() && (type & PRINT_FP || type & PRINT_ANY))  
> >
> > You could fold the comparisons? and why are the two options doing comparison in different order?
> >
> > #define _IS_JSON_CONTEXT(type) (is_json_context() && (type & (PRINT_JSON | PRINT_ANY))
> > #define _IS_FP_CONTEXT(type)   (!is_json_context() && (type & (PRINT_FP || PRINT_ANY))  
> 
> (s/||/|/)

Agree.
This was just an email edit, never tried

