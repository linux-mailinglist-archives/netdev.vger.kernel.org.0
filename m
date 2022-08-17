Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A455969BC
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiHQGoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiHQGoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:44:32 -0400
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D85399F5;
        Tue, 16 Aug 2022 23:44:30 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a7so22910721ejp.2;
        Tue, 16 Aug 2022 23:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=B7g3ltFV/fmTYB11JKHMMtmJBzDyaJIQD4wDJpbDeHs=;
        b=GbBWYX4KYUO/ldp75yKdgLn/zaK/tq5lTh6NX4uWDcaiHSq9jeI9Tvkk7bglEOYy1q
         CiIRSNiKCWQf9t30RYHmsXluwcZHquG2QwDQVFuAxL1EZ+cAFPhcyaMtv30kebqSgdu6
         DqXv0FLoqCY+0o5iWHMHnMtPfySZz4ulQuTCjHZyABW8Qa1ArE/jZHK5cY+3aR/pw4aw
         PkZmKrXVUZTwxryYOtq1UJtHleIgvEm8A2FRXH+7PR9iHW5vb0lITwrMJY92p++rjw9I
         yB/+9EWd2n45tDTHRaI9auln3zTkN752/J2RhkRPkWxismXtiP13wEhJFYKiAG+wASDt
         ZLaw==
X-Gm-Message-State: ACgBeo3gA+w+L2VWFlzEg4O+lzqnMnsBR06MII/DJ4f80Tw9iOueFtv8
        A372ut+CruaUmjjFGjXBsvc=
X-Google-Smtp-Source: AA6agR7j0MrTqiTbOuoRvfDjqQwPS6KMeKM+b7cASB907aPyVek/OGse/AO+P4MIzbSvTQCfPIcD0g==
X-Received: by 2002:a17:906:9c82:b0:6df:baa2:9f75 with SMTP id fj2-20020a1709069c8200b006dfbaa29f75mr15990881ejc.762.1660718669291;
        Tue, 16 Aug 2022 23:44:29 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id f24-20020a170906391800b007324aa2ca77sm6321564eje.85.2022.08.16.23.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 23:44:28 -0700 (PDT)
Message-ID: <eca0e388-bdd1-7d83-76a8-971de8e3a0ce@kernel.org>
Date:   Wed, 17 Aug 2022 08:44:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: python-eventlet test broken in 5.19 [was: Revert "tcp: change
 pingpong threshold to 3"]
Content-Language: en-US
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>, stable <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        temotor@gmail.com, jakub@stasiak.at
References: <20220721204404.388396-1-weiwan@google.com>
 <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org>
 <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
 <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com>
 <21869cb9-d1af-066a-ba73-b01af60d9d3a@kernel.org>
 <CADVnQy=AnJY9NZ3w_xNghEG80-DhsXL0r_vEtkr=dmz0ugcoVw@mail.gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <CADVnQy=AnJY9NZ3w_xNghEG80-DhsXL0r_vEtkr=dmz0ugcoVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17. 08. 22, 0:19, Neal Cardwell wrote:
> IMHO the best solution here is to tweak the test code so that it does
> not race and depend on the exact timing of TCP ACKs. One possible way
> to achieve this would be to have the client TCP connection use
> setsockopt(TCP_NODELAY) so that the body for the PUT /2 request is
> transmitted immediately, whether or not the server delays the ACK of
> the PUT /2 headers.

Thanks a lot, Neal! So for the time being, until this is resolved in 
eventlet, I pushed a change to disable the test in openSUSE.

thanks,
-- 
js

