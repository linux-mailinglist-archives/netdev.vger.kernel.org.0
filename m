Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E0E620577
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 01:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiKHA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 19:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiKHA4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 19:56:30 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B505A1CD;
        Mon,  7 Nov 2022 16:56:29 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id n12so34582641eja.11;
        Mon, 07 Nov 2022 16:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nSxjoZjbFIxHTV0nYZIpQjL4qQfrdYPk0LMSt+I8mzY=;
        b=lA2xZQ3Aep2uItQIqVfFVWTOVFk5Shf3bU7uftlzwXrTolyHL9onhgJLPshMJtnk0L
         GXUfjUlvG0dWA8tCUkdt6tBE47jz10HEb31R94hPvQna4V/B5euHg61rkMPBfwKUBnT5
         7+OoipBKQXZ3upBoeKm/UDfNb1CoOBN70pZnmWAOj+m/1C4C2b9c8Xh3dPAqSnNN0WVz
         hPBuM3coBIAx9khnkFsd5hMEi8asojRUWPiuS1/UbaX32oSpR+JjE0QEDIHHcpgKQV5T
         Ouy4rcfKjyXdpGScAgFS1EBkDzXkQyLlphQmj74iEEvxiIJ9D8Y0BnJaBG4bFyhecIQz
         j8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nSxjoZjbFIxHTV0nYZIpQjL4qQfrdYPk0LMSt+I8mzY=;
        b=p3VUT/XkUwkeonKdko1gEr1YjLQRPB8tafnt4T8Z+vgOOmlVP8n1PNR0TWTGwOBr4B
         YWE5q1nfwSusilUyRwtsMa378LYkKj/K7sYZwARsG+qZDiqrqdtrNfjJCoPCYUs4/NDX
         fghh+f3topw58kH4jTyMInrHmXowkJFy9yNtlCbB2r/NDwsUhwAFSpvHcWmQnH976jaK
         5HyXO1zcd9988ncqeysDIhRX7tpdKbWfHlLL20ZhNujo24ALIkfaa3J7dlhvl2kK9uIh
         3FbYldwXB2soeolg32D7q+knmx63yf8zHbuKhtBsEGrLOfv58KcMjvTWyfvNtBuFl0h6
         raGQ==
X-Gm-Message-State: ACrzQf024/Od0ko9PaxLnZ1FQHnvvvtXw7O67CnxpCk/b/hx7vBCWcgk
        jkAby+vW0kQPxDiuOMcYwmwHSATllnmNoote01VTKgTU
X-Google-Smtp-Source: AMsMyM7IF/RUzLu30OpRZZGgzOt3CiKzJbK02VKF0nAjOvowxq2i5Suqy/9/kqdxNQA2+tEqdqq8h9Pn095nTu0Wj64=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr50056755ejn.302.1667868988319; Mon, 07
 Nov 2022 16:56:28 -0800 (PST)
MIME-Version: 1.0
References: <20221102182517.2675301-1-andrii@kernel.org> <166747981590.20434.6205202822354530507.git-patchwork-notify@kernel.org>
 <1db13bff-a384-d3c8-33a8-ad0133a1c70e@meta.com>
In-Reply-To: <1db13bff-a384-d3c8-33a8-ad0133a1c70e@meta.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Nov 2022 16:56:16 -0800
Message-ID: <CAEf4BzbuaTk1KdYJ5w_8wQLo01i_+js-jvYbTZ_zeWwGm9Zu=A@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] net/ipv4: fix linux/in.h header dependencies
To:     Yonghong Song <yhs@meta.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kuba@kernel.org, kernel-team@fb.com, gustavoars@kernel.org
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

On Thu, Nov 3, 2022 at 9:18 AM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 11/3/22 5:50 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This series was applied to bpf/bpf.git (master)
> > by Daniel Borkmann <daniel@iogearbox.net>:
> >
> > On Wed, 2 Nov 2022 11:25:16 -0700 you wrote:
> >> __DECLARE_FLEX_ARRAY is defined in include/uapi/linux/stddef.h but
> >> doesn't seem to be explicitly included from include/uapi/linux/in.h,
> >> which breaks BPF selftests builds (once we sync linux/stddef.h into
> >> tools/include directory in the next patch). Fix this by explicitly
> >> including linux/stddef.h.
> >>
> >> Given this affects BPF CI and bpf tree, targeting this for bpf tree.
> >>
> >> [...]
> >
> > Here is the summary with links:
> >    - [bpf,1/2] net/ipv4: fix linux/in.h header dependencies
> >      https://git.kernel.org/bpf/bpf/c/aec1dc972d27
> >    - [bpf,2/2] tools headers uapi: pull in stddef.h to fix BPF selftests build in CI
> >      https://git.kernel.org/bpf/bpf/c/a778f5d46b62
>
> Can we put this patch set into bpf-next as well? Apparently we have the
> same issue in bpf-next.
>

Unfortunately we can't because they are already in bpf, and if we have
them in bpf-next, they will cause merge conflicts. So I currently
cherry-pick those two patches locally when compiling selftests. This
should hopefully will be fixed soon and bpf and bpf-next will
converge.

> >
> > You are awesome, thank you!
