Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493CC53B182
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiFBB77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiFBB7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:59:51 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796492A7881;
        Wed,  1 Jun 2022 18:59:50 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id q1so7175664ejz.9;
        Wed, 01 Jun 2022 18:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z4IPnbPTNMwJf1LxyY6++GFYBsXGCojv5YeZ4Ub3aDE=;
        b=pRKKvgirCMFTSCZMzlVGZq7IphZBAx9dEqz7q54Bqg1Se69fbzXdkqcgoBih6MBjNR
         0GTNToJKaPNfnngcEI3C7EZzngxFAITioQP0oTrWou+TtbmwcfxN8E9dhfSRBFWw4Li7
         THJ9wEiQxvlY4fjdhulJbeRL//syvqFdB37y96yE2+HBSW6PYRWxaJAZ1MzT2RifC3OV
         5a1k4YltSoK+e/farcWi6oIudYrvUc9F/lAl+oVKTVybBqDsEHhJcYYQThfQXTDpFqBK
         DzknpVBge9fD/YQnbCw2q8KseGBSLutmSNOUu7zIgQyYo/BPzFhOPgQp3ldeeMb0Apmk
         XPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z4IPnbPTNMwJf1LxyY6++GFYBsXGCojv5YeZ4Ub3aDE=;
        b=2MrghoQS/1U9A+b+H/l5piV1G2gyRAFC4m1wV7U4lZqeS6lB1FLUODadt8Cvn6xh/6
         XGpO12ZMY6GFDq0C4VRvoJFVSZVsLUyyMv7ckGM+iZfIXEvLOQFOtuhq/osNSDyJTH1v
         TdD/Hz0DB8LlMTACJ5EITbJr2LHBrVcGIOjDJZ3O7+LNmpVsLg8B1uyhRS5HFSBDJxGq
         wYm32hpdzRhaZ8LHeWf7Ex1geQ5UN9910rKqoveXVrjkZc69Ov7ONlINoEND5aerHD32
         2OXToYERDYn6RLKiVhzbVu4zz7YPVJ0iKw8Ac/u3PYcM6AqHZupgEQt77YIiFvSmr6kh
         znQg==
X-Gm-Message-State: AOAM533h00YeAIAFmKSFhqo/qn5dghaE7mzJy1NXcVxv+dRPtHTpuuDh
        3ivOmtUer1ipLf/LXoE711VagHUawPhFs3XW4HWQWAzC
X-Google-Smtp-Source: ABdhPJwh5UBi1e7gXxPGe2haOG6Yf7w8BayPKw/4kniD+evcZGE8oi8w61fNRjPcj55/AWj43mhac+27PwP4JlxFZhw=
X-Received: by 2002:a17:907:1b0c:b0:6fe:25bf:b3e5 with SMTP id
 mp12-20020a1709071b0c00b006fe25bfb3e5mr2185140ejc.689.1654135189019; Wed, 01
 Jun 2022 18:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220601065238.1357624-1-imagedong@tencent.com>
 <20220601065238.1357624-4-imagedong@tencent.com> <20220601174209.1afdb123@kernel.org>
In-Reply-To: <20220601174209.1afdb123@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 2 Jun 2022 09:59:37 +0800
Message-ID: <CADxym3ZfbPpJDxfGbyMQBH9OeQhrKrs+EvFBr9OopwcayP3Fng@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: dropreason: reformat the comment fo
 skb drop reasons
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 8:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> The patches LGTM now! net-next is closed until -rc1 is released
> so please repost on/after Monday.
>
> > + * en...maybe they should be splited by group?
>
> nit: since we need a repost - I think we can drop this line.

Okay!
