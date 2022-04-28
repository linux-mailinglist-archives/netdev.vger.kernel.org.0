Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC1B512802
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 02:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiD1AaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 20:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiD1AaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 20:30:21 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE2C66AF7;
        Wed, 27 Apr 2022 17:27:07 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id f5so1018668ilj.13;
        Wed, 27 Apr 2022 17:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o3MSvfM9wEmUtz42Ymu/sM60AbHFV11BulgH7An8Lxs=;
        b=F2bazNd31CxueKBIy+2KJJOsbX2b7TcqB5m0TpBK2AAzjTcUx+L5PGxdtGDym1/zV2
         kg0eNig2mjnbp892fNc1PwHzciACzIPZA5+FdRUGUqsC5a6xXpmYbKW8M97bulUkznAQ
         8fSsvhUpT738EMl/46dR64ZXKzU7sIBNnziIbdpo1BdKRKiF+J5OjLWT+7Fj/7V7dwQN
         SL0z/Mv9w5LPxaNQMwVmRGVEH9kEgdpp02+qzdJI97j6YGWk7Vri+80707MvbGGUwQqA
         AqNT6itVm35Uz/sFFrAOwvvm1oi//Lpeiqzm6H/ntNqDBOde0yAV9HxQxEaFOwVfhSYH
         /01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o3MSvfM9wEmUtz42Ymu/sM60AbHFV11BulgH7An8Lxs=;
        b=EM4su0NiGL61MkjlCV4x4Zg6vdxmo6OU5tWpdEw/YSwISBaQlppvf/Prn0iLBGxz29
         s9oGINcvFTWvXcJPDbeHRVbItfUHTxcGeQWGNc2IoBjNnMiOzMYIRuUDT52HmXW/7/hs
         xPGFZeQVOPkL4oqe3Qb1dITTQ8ilqo/ZQVIoOaFip1g4dDQMdw+NK5fxPgVDZgZq3wB1
         JR2ALFL3zXrI3lkvjGeOhYYgiGaFoAomuitUhf8nNYBuQq1NxLzT9prx0BVhEkJnoyX0
         00yyeSBuVoLwcfdvebF/eiBLQemAMWb+aghgD/aBeR5gTJ/KK+0Qj+CAvODVrxY7t2e5
         EkRw==
X-Gm-Message-State: AOAM532OaRLFg7msi7V34hVqqL7k4xqYKGtmhV7UiiUa9Q5uu0g31ZAk
        Mi0vAMVi5A2F478kXdsJmVFxLUwZsccN2bJcHWU=
X-Google-Smtp-Source: ABdhPJwEbwLH4aNnVbnyKorcEZqq75u28DwvusxOaUT/yfdirNllsv/iNb7KtbYAD61vi+qkgLHL9KrJ8K4f2uLd3/Q=
X-Received: by 2002:a05:6e02:1ba3:b0:2cc:4158:d3ff with SMTP id
 n3-20020a056e021ba300b002cc4158d3ffmr12130304ili.98.1651105626572; Wed, 27
 Apr 2022 17:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220427224758.20976-1-daniel@iogearbox.net> <165110050658.2033.16722871450848438620.git-patchwork-notify@kernel.org>
 <20220427170526.57d907d2@kernel.org>
In-Reply-To: <20220427170526.57d907d2@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 17:26:55 -0700
Message-ID: <CAEf4BzaO5X2ubv1NX=qgCFQiXJXHriV=Ue=LkJt3ioiZYJJp1Q@mail.gmail.com>
Subject: Re: pull-request: bpf-next 2022-04-27
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 5:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 27 Apr 2022 23:01:46 +0000 patchwork-bot+netdevbpf@kernel.org
> wrote:
> > Hello:
> >
> > This pull request was applied to bpf/bpf.git (master)
> > by Jakub Kicinski <kuba@kernel.org>:
>
> Boty McBotface still confusing bpf and bpf-next PRs :(
>
> Pulling now.
>
> No chance we can silence the "should be static" warnings?
>
> The new unpriv_ebpf_notify() in particular seems like it could
> use a header declaration - if someone is supposed to override it
> they better match the prototype?

Seems like it will go through tip? ([0])

  [0] https://lore.kernel.org/bpf/CAADnVQKjfQMG_zFf9F9P7m0UzqESs7XoRy=udqrDSodxa8yBpg@mail.gmail.com/
