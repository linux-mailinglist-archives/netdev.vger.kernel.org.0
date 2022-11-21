Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A830632CDA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiKUTRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiKUTQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:16:17 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48450D39E1
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:16:11 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id jr19so7907595qtb.7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ApT+IeWeTGVzposAzQjCXEOyrLOedhy0BEwkfxB68K0=;
        b=NaQc6G9JOQ/LDucdXVmFCbGd6NycFUBJYxGg1k6xGnN+S/poyroc9XiqY01KsfEJz2
         Jiie2zizoS5CkHbJIHh1keG/SPTprMX+1ZMV1xjjnA+eRSZ3gF+s3qNuO+ePwJkUdPfW
         rFeYysPyTlmaEiqYcaAYkKA2+0rMJ4zYurny0RDjsQQG/hfZqA7MjI4Fl66jtFUmZMph
         nxm4QKAgOxmG5Ud/D+RsnznEOklxH+4oX/06MJ1EtCWoBvsVTYmcLgGDm+wmZHRsWzLQ
         ANThlWjwStYqdybbPdlS8Vkgo2E1xj+MvWo7SGit2/TshIi+8zncgNy/vcePg9Qjhlkt
         1G+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ApT+IeWeTGVzposAzQjCXEOyrLOedhy0BEwkfxB68K0=;
        b=g5BZsF3sgZR/Qc0S3ezhY37oxLHbO5x6XAQsp9sKbRzFkwS7ZwF2Bg5nolrjEqLjQk
         xWFjNse7L+mfh5aESnbG6dvmvTsNnpGP40gIPhgguP5rYyJWvD06VnV5IfCwH/WGVLna
         zeQZzzRisDEs8rGrq7/NX4GWW5HVvHhmJ/HzzNM6CavvVYdT4hcPd3tMRwGOqLfPTFLe
         5oLj1Mggs3lTJItt9wHNYp/baVmRM099Sm8ZJvNRdWHkZU8HsLRK4wMqef4TASs1l6Wk
         OytXU3fUp+v3XpIKTnCO+EjK6fTadiqMCR9FHWBew6QypwNTYYGlt4KLBh9bAeHAsW1V
         gdwA==
X-Gm-Message-State: ANoB5pl69ofSrukUt7TWgixa9UDJhY6aFnpPA+WKAnCsX31uG2Cm5SBb
        4fOApPBn0Y8QF6hr9Kf6IOo=
X-Google-Smtp-Source: AA0mqf6MNB1WnWqeYlHIeu4RuuyQinCfeIdVhqQqyEeskS7OoVuzNTE7Nz4cWDa6a7Og9SghenatGw==
X-Received: by 2002:ac8:7550:0:b0:3a6:21e5:d41b with SMTP id b16-20020ac87550000000b003a621e5d41bmr16801962qtr.108.1669058170266;
        Mon, 21 Nov 2022 11:16:10 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fy11-20020a05622a5a0b00b003a4f435e381sm7157783qtb.18.2022.11.21.11.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:16:09 -0800 (PST)
Message-ID: <260e9aa4-cc62-7cb9-f899-a30c1e802868@gmail.com>
Date:   Mon, 21 Nov 2022 11:16:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 00/17] Remove dsa_priv.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 05:55, Vladimir Oltean wrote:
> After working on the "Autoload DSA tagging driver when dynamically
> changing protocol" series:
> https://patchwork.kernel.org/project/netdevbpf/cover/20221115011847.2843127-1-vladimir.oltean@nxp.com/
> 
> it became clear to me that the situation with DSA headers is a bit
> messy, and I put the tagging protocol driver macros in a pretty random
> temporary spot in dsa_priv.h.
> 
> Now is the time to make the net/dsa/ folder a bit more organized, and to
> make tagging protocol driver modules include just headers they're going
> to use.
> 
> Another thing is the merging and cleanup of dsa.c and dsa2.c. Before,
> dsa.c had 589 lines and dsa2.c had 1817 lines. Now, the combined dsa.c
> has 1749 lines, the rest went to some other places.
> 
> Sorry for the set size, I know the rules, but since this is basically
> code movement for the most part, I thought more patches are better.

This all looks fine on paper, only concern is that it will make our 
lives so much more miserable for back porting fixes into older kernels, 
if you are fine with that as a co-maintainer, then so am I.

That argument could always be used to make zero re-structuring and it 
would be sad for DSA to ossify, so obviously should not be the major 
reason for not making changes.

Thanks for doing this work!
-- 
Florian

