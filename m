Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20ED04EAFB1
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 16:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbiC2O6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 10:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbiC2O5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 10:57:54 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5D6A7760
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 07:56:11 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x20so31860905ybi.5
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 07:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nshrKIEYRvhhGChQcKo4/WOLaQnHQ7MVr4HJAx+7fCM=;
        b=nggyKR34xWau0YYyvwRQmqNf9ML1VUesMAdYb4bOC5T6MuMC0oScBD2d7pXU2POk77
         OA4BbnVNrJ/t+4seBYsW1QUFLpdNB6RrJiFde4LaBHQ/r12FJt2gzxRTW8LymOj/pVhy
         leltTJ19+pv50/jnTippeLzYBRxglgDocamhIt19GHngMQJ6QVjKQtHSXZWOolE1xVHG
         Fzu3WhBC+A3LTZiFHKZYoP23n5hJbeqyqfPWSMXWhzL+9McgSFJ0KHDUr927WbXMvg6x
         M5dNJvjj8M3k3WqJL0ixqb0h3Fhqht5a64AF7kh03Hogj+r8r0L9SNWYQUgVT1NlCqU/
         qt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nshrKIEYRvhhGChQcKo4/WOLaQnHQ7MVr4HJAx+7fCM=;
        b=hvAK5Rxxo7D/ofmsyNIrnD7GQ9E215NtFOPc6fsDn/angVvdgJgMnUKrmqdeWdcxjX
         9XOETGM4AIWkJKYVPRQFY63Fh/iW9NsjQJ4ay9SGwIdUAfUUwX4vymrPpi0TALl0y77g
         VL1+l2suFHYHc8ofE0UhnE9FaG2p9IcmsbbZV+PMqp9TqXZqlNsrWmiD2c8Ay3CySKD+
         NNdB+SpYp37iowBygH9YKSUiLJ96R5xEEzMSY4jlciMhVCBN+Tk+R8cAgbyIM5TY/c06
         uDXdUCN/jWlxFJYIFFKaxuLV2dyB+KVUKfdWfRLdJ+KPh/VN3IbGiuYRPvAf+VkYbWtx
         DxIg==
X-Gm-Message-State: AOAM532g7Twxj1IWdZ9rdmDgMneIoghFaBwuM90kNki8BWFURGAHo9Eu
        NnYiu1gppHtghoOAs6VPAeBaQH4C9r9fEicNdVsu4g==
X-Google-Smtp-Source: ABdhPJzoobXvGwgVjEd4j6mZ3qHA6/OVAWfOgVyjNLjrxiHrXHlyz8bg5YJXfrvmRHUumsoONLU2HBM7F1EdIIEXfJc=
X-Received: by 2002:a5b:892:0:b0:633:ba98:d566 with SMTP id
 e18-20020a5b0892000000b00633ba98d566mr28126807ybq.128.1648565770277; Tue, 29
 Mar 2022 07:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220328134650.72265-1-naresh.kamboju@linaro.org> <20220328135430.2ad39326@kernel.org>
In-Reply-To: <20220328135430.2ad39326@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 29 Mar 2022 20:25:59 +0530
Message-ID: <CA+G9fYvxTtZTWHcobG_WTg7zH6nygyeugib-tJ1Ka2NX2+4ZqQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: net: Add tls config dependency for tls selftests
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub

On Tue, 29 Mar 2022 at 02:24, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 28 Mar 2022 19:16:50 +0530 Naresh Kamboju wrote:
> > selftest net tls test cases need TLS=m without this the test hangs.
>
> The test is supposed to fall back / skip cleanly when TLS is not built.
> That's useful to test compatibility with TCP.
>
> It'd be great if you could reply to questions I asked you on your
> report instead of sending out incorrect patches.

I have replied to your question on other email thread [1]

- Naresh

[1] https://lore.kernel.org/linux-next/CA+G9fYsjP2+20YLbKTFU-4_v+VLq6MfaagjERL9PWETs+sX8Zg@mail.gmail.com/
