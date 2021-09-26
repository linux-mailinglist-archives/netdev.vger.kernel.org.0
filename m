Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14D441859B
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 04:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhIZCYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 22:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhIZCYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 22:24:14 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9659C061570;
        Sat, 25 Sep 2021 19:22:38 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id s36-20020a05683043a400b0054d4c88353dso8130980otv.0;
        Sat, 25 Sep 2021 19:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nj+G8GkuNT5hGMd8K9aymkYSN+enFAuUPMyNPjlyK48=;
        b=kTBdGOpfjzQt9bXyFWTkT1NODUtydsYiq+h61BC9MuikRdLIS4XcSDV7ZbMBUgzHtq
         lllJgpPKmNayz5W6Aq2DyT2DgjhYRmtm1EuxRaZw0II1F5kYzRRXDSXMQXLBp3IQsXP/
         t5htX+l4Jg2pZbE3hZqRvnvE8FA1qmaeb0OqBV5Xl5czV4d0m2R9n8MIGkU/XR4yQezG
         iORd6PglvfhONgXzXHZ7omviB4JBlhVOA3Dq4dmkiXgAYNgibMLPQpNYJ3spJYxoRg81
         n5qC3xjBSpn80pIVwudqiuABtg8o4Gq9CYKNEqcqsEi4mM1Mjv/+arObdvlZOnSPDUyv
         01Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nj+G8GkuNT5hGMd8K9aymkYSN+enFAuUPMyNPjlyK48=;
        b=70fVNhHhmS0r+9r6S0DjFF/W4jpWjFRZkfKHvA27BVOsswEkbDmgzttwvRhiB40fFF
         dhLFsDr5EVmoyxTZm77e2MKb/3S/IvFwPFFrevhDkUZhJZ31QH7+O0JIfYuz/kQRFLgf
         igM5KDNhwgS9JnomHSyWqTp6LjSyoFbzYkvPMFzYPr9MO9HXDwXxRtU/Z8RtAoz9q4cs
         ZXcKZQI4pbH8CpG5uj0ngvqSW3gMsBxfVQYtLAqEuWuqnBo1u+hqpIE/uzv907Z/oSfy
         hVSqyid5YiNPhj5Tl22IU2OPvnXT7DPiF2UReC92FvynnJccFVWo9TAShfJ0E4NXkaSz
         SZwg==
X-Gm-Message-State: AOAM532wsOMejAO00T3OUBAkddjDflHfP13A30dPG2gsw/6L4kQu56n0
        vNrrtDVEetY6Hf+OYXiJlDxtgOa8OIg=
X-Google-Smtp-Source: ABdhPJzcgkOiRZFHSghvqK//AMjMoDWJYEqNMKVMMnLqpdVnNwS/QUI+IP7Uh29kWFPfCn1sLajIcQ==
X-Received: by 2002:a9d:7d0d:: with SMTP id v13mr12022342otn.289.1632622956517;
        Sat, 25 Sep 2021 19:22:36 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e? ([2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e])
        by smtp.gmail.com with ESMTPSA id u15sm3475737oon.35.2021.09.25.19.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 19:22:36 -0700 (PDT)
Message-ID: <2cb4144b-7250-1e6d-88d1-cc4efa3f59dd@gmail.com>
Date:   Sat, 25 Sep 2021 19:22:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net-next 0/5] brcm ASP 2.0 Ethernet controller
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
 <YU8xX0fUWAoEnmRR@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YU8xX0fUWAoEnmRR@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 9/25/2021 7:25 AM, Andrew Lunn wrote:
> On Fri, Sep 24, 2021 at 02:44:46PM -0700, Justin Chen wrote:
>> This patch set adds support for Broadcom's ASP 2.0 Ethernet controller.
> 
> 
> Hi Justin
> 
> Does the hardware support L2 switching between the two ports? I'm just
> wondering if later this is going to be modified into a switchdev
> driver?

It does not, these are just a bunch of Ethernet ports sharing a few 
resources (clocks, network filters etc.).
-- 
Florian
