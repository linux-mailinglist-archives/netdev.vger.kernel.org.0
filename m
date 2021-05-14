Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFF838121F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 22:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhENUyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 16:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhENUyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 16:54:15 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368F8C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:53:03 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id v22so708230oic.2
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 13:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YlQKt8y0EZtuZH7/4tDzDRPxNpRChNxKVQZsAVkn9XE=;
        b=fst7rL662oJOZebki9o9DxkZYx2J7YMRs2i4EP0CPMDRJssKQ0MmZ9PgYYRmTZp2kF
         J+EV1YASJvE/rV9NJvqjFlHcfeA7osimfs6EeS4PR6bZFwNWU92v46K3fjbPKTgDCqKL
         X5AMZlxCpZyGsN9aubtZcOAEz90/XdDqW42QORKIs7vTEqc3WUsDcd70t3LcLoJz3E76
         zv0nQAlgatYBSvO/9xSgwqozOixzehUv8OhAtRgS/VfWKOptMKrSY9aKUwTBqeXedQVA
         BCn9u9CUAX3pBJffbrjNXoG61vL9C4vT98//dewLj2vE7LoBYU/VYYIuIAIAkTaVoKpD
         4OMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YlQKt8y0EZtuZH7/4tDzDRPxNpRChNxKVQZsAVkn9XE=;
        b=r7pew80XPrnYnyQaW6e+BlkRiq0kcTbMBpWkNq4W0giS4aEm3tUtJ+RCE9QJ7SOr+a
         sXD7aZm/rADGhVb7BfmlpUli27fnETE0yftUt7ryzWz4AeONjozqvNlf1arrq47XVfKv
         6/eTn0snzOJ0J48UsmcPBLkBuMqiubsakjVRow0Sv+A9tRoM+xqlqHMEqUFoi0bRphLx
         1Q2z+nmVepjke6cgHDg94KW7BkIslhB2QWfk2tbLrbD0tThLkYxJEqwQfksz5pahSmIB
         I+8/U6YeJoEz1+lS2uJidHGmyP2Y4VSwCsMwQVUryOJ/GzrpL35QURi5m2k3P7GM3EI6
         W58g==
X-Gm-Message-State: AOAM530DAwkF/6/vEluaN6hNmu1L21jEDpQIiMZHDwjTA524V2Rzz0+8
        AQlc136EIUQzXTC/8FOQz47JqRnT7VZz7XJnjFagUzM+PVI=
X-Google-Smtp-Source: ABdhPJyKFpid0DBNvfKWF4YUtkZRG6g3Kj6WH5n5bZ8KJMBauQIesjgb+oWzptp4vm3noe7Zs6xzcyTIM1AFFXi3zVI=
X-Received: by 2002:aca:4e55:: with SMTP id c82mr7881296oib.17.1621025582683;
 Fri, 14 May 2021 13:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210512212956.4727-1-ryazanov.s.a@gmail.com> <20210514121433.2d5082b3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210514121433.2d5082b3@kicinski-fedora-PC1C0HJN>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 14 May 2021 23:52:51 +0300
Message-ID: <CAHNKnsSM6dcMDnOOEo5zs6wdzdA1S43pMpB+rkKpuuBrBxj3pg@mail.gmail.com>
Subject: Re: [PATCH net] netns: export get_net_ns_by_id()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 13 May 2021 00:29:56 +0300 Sergey Ryazanov wrote:
> > No one loadable module is able to obtain netns by id since the
> > corresponding function has not been exported. Export it to be able to
> > use netns id API in loadable modules too as already done for
> > peernet2id_alloc().
>
> peernet2id_alloc() is used by OvS, what's the user for get_net_ns_by_id()?

There are currently no active users of get_net_ns_by_id(), that is why
I did not add a "Fix" tag. Missed function export does not break
existing code in any way.

On the other hand netns id API is incomplete without this export. You
have no way to write and test a code that uses netns id API without
manual kernel patching and rebuilding. This is annoying, but could be
trivially fixed.

Accounting for the fact that this change is trivial, closer to a fix
than to a new functionality, I prefered net tree over the net-next
tree. This way I expect the new API to reach mainstream distros faster
than over 5 years :)

-- 
Sergey
