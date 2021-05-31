Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C58395618
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhEaHcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:32:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60482 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhEaHcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:32:01 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncNR-0002FK-Pg
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:30:21 +0000
Received: by mail-wr1-f71.google.com with SMTP id u5-20020adf9e050000b029010df603f280so3606600wre.18
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cAlI26tnTTG5mkLy5nypjSlUByQ/kCeC+Y7Gnr7Dwj8=;
        b=umpRVGLWCN9Pz0bQSTPcrIqPDoWCbcnRqdhfqh6HV+43kn9KQBzI6i+X0yWlu2fKCj
         Fi2t7h6yz27VBIET63rmOOZn5jbTCTdbqKWgZyh5lk9Fwm6yV0biMBkTi94OIrkOYYTz
         T1dUhZTMupNJ1kKxP0xg7tnz9LfcTu8C2Vim91yUvWWNjNt09MRnbYSD7FEXnBQcxirX
         kmBgsTRUcSrRCV7nLZo+V4OQibg63QNpV6QbEwL1DC9jan+fV1FxkgrS4IAcmCHDw+JF
         PZzptpNQarUOcLjPgXYRZBnLHFUr90RnUlR0xfxCsInrjCBMGL8gbXhDPrr+kSPlGMgS
         2G6Q==
X-Gm-Message-State: AOAM53008FTI6LpX1KPfmUN8NW4/pxFbheeXuVOIMHwOQ4fwd/CdyRs/
        /piJa09f2bt2KafOO1K57NHhHi3WKLn5PAhB6W6Br0Wdw0BBjofgFCWvUtfK1H/eqWZHMyjisXu
        UDlL9a5D4DvWY4eDdm7H85HTcORVPF5wI9g==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr19400392wmh.102.1622446221038;
        Mon, 31 May 2021 00:30:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGn2RwHbI3WaJdd8bqimsKztQEfvYoe5ivVyqd/sUnbSsNPwopPg2sBXTTyFD3lrJGA4eoOw==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr19400386wmh.102.1622446220937;
        Mon, 31 May 2021 00:30:20 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id v15sm22303365wmj.39.2021.05.31.00.30.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 00:30:20 -0700 (PDT)
Subject: Re: [PATCH 01/11] nfc: fdp: drop ftrace-like debugging messages
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
 <20210528151340.7ea69c15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <4f44c25c-c296-ba3e-7c6d-bc1016574231@canonical.com>
Date:   Mon, 31 May 2021 09:30:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210528151340.7ea69c15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/05/2021 00:13, Jakub Kicinski wrote:
> On Fri, 28 May 2021 10:53:20 -0400 Krzysztof Kozlowski wrote:
>> Now that the kernel has ftrace, any debugging calls that just do "made
>> it to this function!" and "leaving this function!" can be removed.
>> Better to use standard debugging tools.
>>
>> This allows also to remove several local variables and entire
>> fdp_nci_recv_frame() function (whose purpose was only to log).
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> Hi! Would you mind reposting these 11 fixes? build bots don't
> understand series dependencies and the last patch here depends 
> on the previous clean up set.

Sure, no problem.


Best regards,
Krzysztof
