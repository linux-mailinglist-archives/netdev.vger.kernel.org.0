Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2965A251DF1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHYROa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgHYROV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:14:21 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602C0C061574;
        Tue, 25 Aug 2020 10:14:21 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kx11so1129760pjb.5;
        Tue, 25 Aug 2020 10:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nC0CGa0DhQLywOaSN+bsM9yIH3pm94jbNUPQgdZ88Zc=;
        b=UrPh53BImtLFBcv+cCSnb2qNXo6lIQxjvbEe5IvkiLrUqCkvCd0vLMoTGJ33ldyijB
         5jG3uzkNRQI4r42LVWK5lVeOtDkTlJhqLRmfH/yZ899mxP4JFtPFQjcqGSH2H7mz4Cu7
         uetACryJmuPdWieQ29zfPJMjyfXscYG+Ok97mXqWRwEkWKcRN6sbbKj9S1SETrVb4Iwg
         a63GIEAuK9eZpTX+Fr/qiLnz72/kyKwlA6kShPSGfw++voig8J1arLJD3U3fzcFHrire
         l///LWgSxJmGXZ+nRaDpYhAyoYsJCVlMpuE3OG4h9+G5S2Dhb1Tskuvfriid8xcEByoZ
         Vrjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nC0CGa0DhQLywOaSN+bsM9yIH3pm94jbNUPQgdZ88Zc=;
        b=aGaQ6hYJ4ZwnvaEPqtvMIOm2w/wMAFTrT+RR34rQse3F4i2xffTFboMsqJ6hFipMBz
         382PMdlmaCO9fQbhlABzez1gbM2MW8gNKe/hw9BGNhYX4s5g3M3eFVD0m7x5z6aRW4kR
         7a8Pz8U/E8pqQF3GGzR3LBg0PWx/xpjlqg6oVB4m+dXeDnRfdBQFgNRSkykJSeGnFbMJ
         cKSCtZ9ure9aI+hmNwCDxBp/HnOWLAd4OXPwBW9d35c2Qoyr3lgVqSEWvFfNSafp791B
         6y0RDkAz5D3esuBioj3G3JvrFnMAU0HsG8BrShMpUq1JMOJB2GglncYcdny88qQ3+Q4l
         8IMA==
X-Gm-Message-State: AOAM533JPKiJDRKgHBHO/ieHRLXyXox/JQ82Fyx0dNEScDScMW+XuFdR
        dyjwkRoGIieEwi/2x1DqPBZfqntEWD0=
X-Google-Smtp-Source: ABdhPJz0hdCt6dO/xZHDgu7EfQeIWkH/2zYpyMfqRxlMXWDKzR+FSmzEGgyr71G/fTK5jRzr117JKA==
X-Received: by 2002:a17:90a:bc09:: with SMTP id w9mr2380318pjr.43.1598375660814;
        Tue, 25 Aug 2020 10:14:20 -0700 (PDT)
Received: from [10.69.79.32] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c15sm15746867pfo.115.2020.08.25.10.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 10:14:19 -0700 (PDT)
Subject: Re: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        David Miller <davem@davemloft.net>, olteanv@gmail.com
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, bigeasy@linutronix.de,
        richardcochran@gmail.com, kamil.alkhouri@hs-offenburg.de,
        ilias.apalodimas@linaro.org, ivan.khoronzhuk@linaro.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com, Po.Liu@nxp.com
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200824143110.43f4619f@kicinski-fedora-PC1C0HJN>
 <20200824220203.atjmjrydq4qyt33x@skbuf>
 <20200824.153518.700546598086140133.davem@davemloft.net>
 <87sgcbynr9.fsf@kurt>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <efd98ac6-baaa-ae44-9630-ba1241ac315a@gmail.com>
Date:   Tue, 25 Aug 2020 10:14:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <87sgcbynr9.fsf@kurt>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2020 4:21 AM, Kurt Kanzenbach wrote:
> On Mon Aug 24 2020, David Miller wrote:
>> Agreed, Kurt can you repost this series without the TAPRIO support for
>> now since it's controversial and needs more discussion and changes?
> 
> OK. It seems like the TAPRIO implementation has to be discussed more and
> it might be good to do that separately.
> 
> I'll replace the spinlocks (which were only introduced for the hrtimers)
> with mutexes and post a sane version of the driver without the TAPRIO
> support.

Sounds great, thanks!
-- 
Florian
