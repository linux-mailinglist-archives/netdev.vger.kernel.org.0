Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E0741E5F8
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 04:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351577AbhJACQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 22:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhJACP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 22:15:59 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5D6C06176A;
        Thu, 30 Sep 2021 19:14:16 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id i132so7843988qke.1;
        Thu, 30 Sep 2021 19:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=GGYmwF1xgvF65xSTVkI/nNSL56SSFjAntwY9/8+7ZqI=;
        b=QC8TwvSsowygfb8A/LjLjXaZf0ipGHDfyqReMGZ5VR3X+rW9ozE37Ob3MdTtipmlWQ
         +bZyqKC7R2+T/AoEmHEYPYMdY89gXzX5kH7fF43glbIuCL5+a5OXE0i9B1/oQMqU+N7T
         /W/WR6p78fdA9X6mPW+PEILw0IHwnXHRsPYmc0ITBvvYA0WvTPV+zH+a4i6NMoPzfhJJ
         mUiuqkXjInPHqnNeqBBCv+GLbyBjcLIjVaW10Mh/aqO6m1kNblACB4H56NZVb1CpknIQ
         WgLMcpWfdC7u3FpP04/YIWNoZGnSvCo3QmGGcVXvzLQn/JXPh/HnJwM08kNCmoLEBO5f
         eVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GGYmwF1xgvF65xSTVkI/nNSL56SSFjAntwY9/8+7ZqI=;
        b=yZa61KU/fO3HMpH+ReJQ6Wgz6UxzXCiqzf+ut6zURXh6kxBejVoMwYVJwomqJ8vlvS
         3SkPKa51J24ZMv2F8sP5ueq6fVFAEslGjjgBBKi6G1O/OfxT8pAtgqFTiPXoPVgJkWne
         owil1Hu0x8mtKzD+i8b/A/xgTTl5fkxplXieOCSEDmmRB83AK0XqTKrvWupHDJwGcEio
         Wc0hSsnyBFfeLq5OiDoEadTGi8EDmCrGGW9NgoHkxg9HwbbpuO/a2qUBd5uU3AnA1Ak5
         UaB5yLOgLQtfbHxYQjkLZNXe5PsZOFwz9ZGBHIS/pD1WcVIELG29EklbeGxCwevATcXG
         6d/g==
X-Gm-Message-State: AOAM5311/oJilUctHWoBvWxvKK4dwx6BvFKQIwFTi2syMQ1oZRhkIu/N
        zBBG6ap/pGzC+09gfp4qELlKvuefEpA=
X-Google-Smtp-Source: ABdhPJyvUWDCqjPpydCaCo3HekY6oOalFE3yBX0FulOOBPSO0SIW/JXOrcHtfr2OlMfvTU9J/WlP3A==
X-Received: by 2002:a37:8883:: with SMTP id k125mr7387822qkd.458.1633054455347;
        Thu, 30 Sep 2021 19:14:15 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:d9af:6c0e:ad27:8053? ([2600:1700:dfe0:49f0:d9af:6c0e:ad27:8053])
        by smtp.gmail.com with ESMTPSA id w9sm2337475qki.80.2021.09.30.19.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 19:14:14 -0700 (PDT)
Message-ID: <91eb5d7e-b62c-45e6-16a3-1d9c1c780c7b@gmail.com>
Date:   Thu, 30 Sep 2021 19:14:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [RFC PATCH net-next] drivers: net: dsa: qca8k: convert to
 GENMASK/FIELD_PREP/FIELD_GET
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211001013729.21849-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211001013729.21849-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2021 6:37 PM, Ansuel Smith wrote:
> Convert and try to standardize bit fields using
> GENMASK/FIELD_PREP/FIELD_GET macros. Rework some logic to support the
> standard macro and tidy things up. No functional change intended.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
> 
> I still need to test this in every part but I would like to have some
> approval about this kind of change. Also there are tons of warning by
> checkpatch about too long line... Are they accepted for headers? I can't
> really find another way to workaround the problem as reducing the define
> name would make them less descriptive.
> Aside from that I did the conversion as carefully as possible so in
> theory nothing should be broken and the conversion should be all
> correct. Some real improvement by using filed macro are in the
> fdb_read/fdb_write that now are much more readable.

My main concern is that it is going to be a tad harder to back port 
fixes made to this driver with such changes in place, so unfortunately 
it is usually a matter of either the initial version of the driver use 
BIT(), FIELD_{PREP,GET} and GENMASK, or the very few commits following 
the initial commit take care of that, and then it is all rosy for 
everyone, or else it may be complicated.

You are one of the active contributors to this driver, so ultimately you 
should decide.
-- 
Florian
