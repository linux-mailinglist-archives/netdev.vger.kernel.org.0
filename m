Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A10441A00C
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbhI0UXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbhI0UXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:23:22 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F5CC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:21:43 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t10so82573281lfd.8
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mwj4wlx7pJTq+sjObs1F2mI1VFoqVK6/+hi+p1jBXEk=;
        b=gKkkCHqnSCZZTj2vq1G8M9uDMhNRm8MF4PretqKSg9tTcnMpqDfVNjfIRSpq2jtr8h
         qCnblJ9/XMOYZidcpNfeLuyT7G6Nn3mANqBTowq4ZwbHtSj0J25lrlW0peEdWUS4d+bU
         D7uEb80B8ZVEwNq0pn63gcD63GmeOGuEdG94q9ur6iRLx/E6M+sghZyOHn9tvfWvcd9E
         d8mFAMHvkxQ6hT3/Qjot8AT9M+g+j0ZjgGOBWxIwLVe4MSPrFP1zrGmr3WUUyIui1nBp
         7JxxwwZc50jbL+X+cEJX5CtVoWU1so+tEq3fNVQiHtjls2tddqzl8Xe+xdZZGcxlXJQw
         ZN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mwj4wlx7pJTq+sjObs1F2mI1VFoqVK6/+hi+p1jBXEk=;
        b=C7mFcLZ9Ik1a2XEIf9Py++cYHkaHw3ALF8jKCj8LjqHVqSYOS/T1qDVU4UOlNm6PjF
         slqUGgEPrx2NXz6vt14V5NVUi198Zw6ffyV7p5o0mk2pzJ/KHupMQZrtcqntFwY+5Cyc
         8i0+SKfN3sUEO8WmlKB3gRoDHXE92iMLLk86Y7CybEdVCa+wTPuA5l8fxHJALVGPUvVe
         AKH8fJ8byUVp1ULdjqCb7k0gs7pX6bTxVWPufMhO3YbPne8at+Gp3vBwashOxMLBnxDi
         hNwH44Ir/YsdTkfqKVVcNQSpoqZ5KcB7bsOTaxU9Ldi/wIliJxcSUytAo+cKALiEYd9T
         kWlQ==
X-Gm-Message-State: AOAM531vry0N0NQrzUrauZjESCKOAvp1JR2O7JSby59t3ZYdFL+E0GGa
        BeV82qvzMntJMa5/wbXMw6/ZOxF4ZKE8fVOrByqi2Q==
X-Google-Smtp-Source: ABdhPJwqh7Vuqs/4cTCIcQTnwLEMOPNAtSqsyICJmZ9PV2f9uEyYaeypxJqQsfGX/DJNIGcadAy9up+yk7jZ7rpuclI=
X-Received: by 2002:a05:6512:3190:: with SMTP id i16mr1672241lfe.104.1632774101646;
 Mon, 27 Sep 2021 13:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210723231957.1113800-1-bcf@google.com> <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
In-Reply-To: <CAK8P3a1aGA+xqpUPOfGVtt3ch8bvDd75OP=xphN_FrUiuyuX+w@mail.gmail.com>
From:   Bailey Forrest <bcf@google.com>
Date:   Mon, 27 Sep 2021 13:21:30 -0700
Message-ID: <CANH7hM7_brYnVu_x7=+vY34SGQNbc7GUGQmAqpYwXGgVP0RH6Q@mail.gmail.com>
Subject: Re: [PATCH net] gve: DQO: Suppress unused var warnings
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies, resending as text

On Mon, Sep 27, 2021 at 2:59 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Sat, Jul 24, 2021 at 1:19 AM Bailey Forrest <bcf@google.com> wrote:
> >
> > Some variables become unused when `CONFIG_NEED_DMA_MAP_STATE=n`.
> >
> > We only suppress when `CONFIG_NEED_DMA_MAP_STATE=n` in order to avoid
> > false negatives.
> >
> > Fixes: a57e5de476be ("gve: DQO: Add TX path")
> > Signed-off-by: Bailey Forrest <bcf@google.com>
>
> Hi Bailey,
>
> I see that the warning still exists in linux-5.15-rc3 and net-next,
> I'm building with my original patch[1] to get around the -Werror
> warnings.
>
> Can you resend your patch, or should I resend mine after all?
>
>       Arnd
>
> [1] https://lore.kernel.org/all/20210721151100.2042139-1-arnd@kernel.org/

Hi David/Jakub,

Any thoughts on my patch? I'm open to alternative suggestions for how
to resolve this.

This patch still works and merges cleanly on HEAD.

Thanks,
Bailey
