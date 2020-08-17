Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57DD245FDD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgHQI03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgHQI0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:20 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B0FC061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 01:26:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m20so11602739eds.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 01:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EB784NjPICkYR6SWnOZXgVJnpSq6x26Bh+bf4QaSgmE=;
        b=WW6BjLlHMZolL6jV9wGUJ2Nqna4uXwJlebSkTA9urlIi6Sa4Pa/NFLVlhsaFlRrn9E
         XQngChT6EYMcGX3cA8zMULqnTs8j60bTV+lfjDankwdHtdAkUKN1PbSGAMxLTWewd3c0
         abf5dN1kL9l6jxvEgxS3raK9zw14TFbm9RQxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EB784NjPICkYR6SWnOZXgVJnpSq6x26Bh+bf4QaSgmE=;
        b=LrdE58ORXaDv96e/kr4XCpYcw1Vgp10CruHy2QLEoeUR4TsCwdbk8CSubFo2VNZpK+
         K+2LYb7UZTmrafKInlXVH7EvZ3i+DST2ebAfaa7Mbxhhky9o+pdJh9x54EK2bCFWF1ct
         iatj3t69bNj6FgtuQ+/jCqTdhjCfmM8kEzqmFXXFO3GPLcd8h28rbgrC+SDPcTUM/4FZ
         6ALubsdRKtfxU1TDHYPTv6af5sjr2qE2+VWenoQj1c6OdwDH5QTPIapgWIjh244665y2
         W7eDIqVX4jOSg5CoZtSf4sWE8JJm7Qbs/x/FRvwaeuZBfzeIqibguVllFzYvN32W2i8E
         jFYQ==
X-Gm-Message-State: AOAM531ffdeR8lTvhLsM+qV7Ssol3qXa9suYbhy8CSNHf63rzqSAez9a
        YBe5HdZcgeq6x9EehURpEn8YFZZqqGBWffrs
X-Google-Smtp-Source: ABdhPJxsKL8nm53WAnCAbGQdXqx/yIadsPW7nUTLAsMfgGi8OvTQ7NHOoDONUkkkyNaMHrIoZuYVvQ==
X-Received: by 2002:a50:c3c4:: with SMTP id i4mr13899573edf.244.1597652778082;
        Mon, 17 Aug 2020 01:26:18 -0700 (PDT)
Received: from [172.16.11.132] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id v13sm14170727edl.9.2020.08.17.01.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 01:26:17 -0700 (PDT)
Subject: Re: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as
 __maybe_unused
To:     Christian Lamparter <chunkeey@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-9-lee.jones@linaro.org>
 <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <9776eb47-6b83-a891-f057-dd34d14ea16e@rasmusvillemoes.dk>
Date:   Mon, 17 Aug 2020 10:26:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7ef231f2-e6d3-904f-dc3a-7ef82beda6ef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/08/2020 17.14, Christian Lamparter wrote:
> On 2020-08-14 13:39, Lee Jones wrote:
>> 'ar9170_qmap' is used in some source files which include carl9170.h,
>> but not all of them.  Mark it as __maybe_unused to show that this is
>> not only okay, it's expected.
>>
>> Fixes the following W=1 kernel build warning(s)
> 
> Is this W=1 really a "must" requirement? I find it strange having
> __maybe_unused in header files as this "suggests" that the
> definition is redundant.

In this case it seems one could replace the table lookup with a

static inline u8 ar9170_qmap(u8 idx) { return 3 - idx; }

gcc doesn't warn about unused static inline functions (or one would have
a million warnings to deal with). Just my $0.02.

Rasmus
