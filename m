Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F4A5FCE86
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 00:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJLWg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 18:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJLWg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 18:36:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94F6D57EC
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 15:36:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12so374024pjk.0
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 15:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJuspXcv7ruXPp6rcpUd7oAP5CVcNrA65qXmxw9FXU8=;
        b=J14RGaMfL7oAgxaTXkAwbO29Nh4J9K7FoEmebZMSwevTgDfEwEww19UCzlGaz4UjPp
         JMh7XSqTsJVvifPxuhh4FegZgqcxaWuZ3/1S0sndyQJY7qNh8Fq/JjCj3hG78lgIXnyb
         NylxstvrtC7m5KGddEyfJ8dhS0j0apC4edGCwHCosyyH5dDMtnWcOHovzsD6E8/cnHjw
         vdZhpgUDaXX+95k9w4wjFxhKRBLH5joR7hNlwIuXXl6h/6pmBZ/eccXHYPaBLoA+jRxj
         prWp/lzhrohfQPWxT6fDqF/Fa+cka546BoRcKWu6IHnBLw7ag9Defjie+h0pC5bKFMRo
         Z0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJuspXcv7ruXPp6rcpUd7oAP5CVcNrA65qXmxw9FXU8=;
        b=FZp6Ka/cr7pX2n43xECPzkNFpjlf76r74no8NZsyMUc9S/F3tfHqxGmnahqxGint49
         778CFqn+AMbEzlXcWa8KtfzNmBMuKrnwYB6eht5guq67Djrv+AlQO+a6J7dGQ8rCmMi2
         a2ru1psY1oO8bAty2GUWGfANuOsvLfsB8miS7ObfEnGQ6CyDqAw3MWM06PrBIangtHnp
         yjliy8MphD70PwIgTEGbIMlx6u1myAWgHP6zoFWKzFpgqdX+0EDvEyl3eaaf7u/76CDf
         ClHSVtWur9gRHv5cDtaYh0IKsYm7r9QL76Y0p3UmmlQrD2SxAS9df8FynoM2jOuts+Ct
         eZFg==
X-Gm-Message-State: ACrzQf3HNUlt1noCj2shGYuPjWGCDHca9GRmvqgsEXKmKyKGX6IB35NH
        2PFJpClyYGMb3nwQCNg9GB8=
X-Google-Smtp-Source: AMsMyM6E2WRDheYapuoWF6z10g9Cl1brOzvNB7h7Tds+jo9MPSa8g3nWo9cR9fXLLvsDr19qYEaRRA==
X-Received: by 2002:a17:902:8a88:b0:17f:8642:7c9a with SMTP id p8-20020a1709028a8800b0017f86427c9amr32052276plo.13.1665614184001;
        Wed, 12 Oct 2022 15:36:24 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:9517:7fc4:6b3f:85b4? ([2620:15c:2c1:200:9517:7fc4:6b3f:85b4])
        by smtp.gmail.com with ESMTPSA id l76-20020a633e4f000000b00460a5c6304dsm7521273pga.67.2022.10.12.15.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 15:36:23 -0700 (PDT)
Message-ID: <44a7e82b-0fe9-d6ba-ee12-02dfa4980966@gmail.com>
Date:   Wed, 12 Oct 2022 15:36:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: qdisc_watchdog_schedule_range_ns granularity
Content-Language: en-US
To:     Thorsten Glaser <t.glaser@tarent.de>, netdev@vger.kernel.org
References: <c4a1d4ff-82eb-82c9-619e-37c18b41a017@tarent.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <c4a1d4ff-82eb-82c9-619e-37c18b41a017@tarent.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/22 14:26, Thorsten Glaser wrote:
> Hi again,
>
> next thing ☺
>
> For my “faked extra latency” I sometimes need to reschedule to
> future, when all queued-up packets have receive timestamps in
> the future. For this, I have been using:
>
> 	qdisc_watchdog_schedule_range_ns(&q->watchdog, rs, 0);
>
> Where rs is the smallest in-the-future enqueue timestamp.
>
> However it was observed that this can add quite a lot more extra
> delay than planned, I saw single-digit millisecond figures, which
> IMHO is already a lot, but a coworker saw around 17 ms, which is
> definitely too much.

Make sure your .config has

CONFIG_HIGH_RES_TIMERS=y

I don't know how you measure this latency, but net/sched/sch_fq.c has 
instrumentation,

and following command on a random host in my lab shows an average (EWMA) 
latency

smaller than 29 usec, (32 TX queues on the NIC)

tc -s -d qd sh dev eth1 | grep latency
   gc 194315 highprio 0 throttled 902 latency 10.7us
   gc 196277 highprio 0 throttled 156 latency 11.8us
   gc 84107 highprio 0 throttled 286 latency 13.7us
   gc 19408 highprio 0 throttled 324 latency 10.9us
   gc 309405 highprio 0 throttled 370 latency 11.1us
   gc 147821 highprio 0 throttled 154 latency 12.2us
   gc 84768 highprio 0 throttled 2859 latency 10.7us
   gc 181833 highprio 0 throttled 4311 latency 12.9us
   gc 117038 highprio 0 throttled 1127 latency 11.1us
   gc 168430 highprio 0 throttled 1784 latency 22.1us
   gc 71086 highprio 0 throttled 2339 latency 14.3us
   gc 127584 highprio 0 throttled 1396 latency 11.5us
   gc 96239 highprio 0 throttled 297 latency 16.9us
   gc 96490 highprio 0 throttled 6374 latency 11.3us
   gc 117284 highprio 0 throttled 2011 latency 11.5us
   gc 122355 highprio 0 throttled 303 latency 12.8us
   gc 221196 highprio 0 throttled 330 latency 11.3us
   gc 204193 highprio 0 throttled 121 latency 12us
   gc 177423 highprio 0 throttled 1012 latency 11.9us
   gc 70236 highprio 0 throttled 1015 latency 15us
   gc 166721 highprio 0 throttled 488 latency 11.9us
   gc 92794 highprio 0 throttled 963 latency 17.1us
   gc 229031 highprio 0 throttled 274 latency 12.2us
   gc 109511 highprio 0 throttled 234 latency 10.5us
   gc 89160 highprio 0 throttled 729 latency 10.7us
   gc 182940 highprio 0 throttled 234 latency 11.7us
   gc 172111 highprio 0 throttled 2439 latency 11.4us
   gc 101261 highprio 0 throttled 2614 latency 11.6us
   gc 95759 highprio 0 throttled 336 latency 11.3us
   gc 103392 highprio 0 throttled 2990 latency 11.2us
   gc 173068 highprio 0 throttled 955 latency 16.5us
   gc 97893 highprio 0 throttled 748 latency 11.7us

Note that after the timer fires, a TX softirq is scheduled (to send more 
packets from qdisc -> NIC)

Under high cpu pressure, it is possible the softirq is delayed,

because ksoftirqd might compete with user threads.


>
> What is the granularity of qdisc watchdogs, and how can I aim at
> being called again for dequeueing in more precise fashion? I would
> prefer to being called within 1 ms, 2 if it must absolutely be, of
> the timestamp passed.
>
> Thanks in advance,
> //mirabilos
