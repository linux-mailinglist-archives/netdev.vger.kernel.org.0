Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4CC512785
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiD0XbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiD0XbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:31:23 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41C5186E6;
        Wed, 27 Apr 2022 16:28:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id 125so4838002iov.10;
        Wed, 27 Apr 2022 16:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J+PADB9F5WqUqK6GNU+Fxyjymg7zexYWmAXBuu5DB9g=;
        b=U7azQ2bUah5mgLR/JEX/N2A3mspp3zwA+qStLEeStwS/w5mOfeanqxTJ1Z7BpA7t77
         sZ0ei5lKcGnDWrRQDT3q33zjz86xpbg5Rmq1Qq8gw4iA/FaZE9vx6qGrhS4mtTlrk6T9
         B+XVrTVRwAryBUF+e1GO9yoNSwkP2HEhwXth1LBTj0wvToNjx9VyRqtyQm0Md/nR//vN
         rkmpHlaE2fKHvCMdXR9OMwX6CcD+KVKBdR1mIq77GAGa3hYM2xzCqMmznRpl5j4X68wY
         rMuThzJzcNs75oXtKDvpHctRzmFNKb14YbU5Gr3w+N7O+N8ZuUTgZqgmTqUdfN5d1pDG
         sUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J+PADB9F5WqUqK6GNU+Fxyjymg7zexYWmAXBuu5DB9g=;
        b=zm1lG4HUgLS+WHpKIJsR9rxFLhjv23BYl8d5+v76BeHsGU+8lkl0MwvLm7uPLf5XrX
         W4JG3MwbihToR7P+L3GcO+fpyD0be6RfEql0j1ipEI/HkY1MMHtl6Njle6I91+ALSeKU
         IXBgMPyrjnF+d5CtM8YaNHGY4/QTrlwneOwg4orMWYhAkfqe4NkzxvY55ytGXRt7T+2w
         HEc/nLFnFW/IaJzUCsRB7InEXE6UgI0t+VPQSEFoxIl0XEMv1vGRu/y1u7rcWyzcTfVF
         2FJSmeI6DGFktT3jE0xl1Em4JJ6SxabAAc3DZlEmxxpadRGf61X4GED0WfVKqEXWhc3M
         qEng==
X-Gm-Message-State: AOAM533reNHTqa8rYaSo/ewOTBL4XV4ffQ81FYxkVq2PfIuwIAD9/Uq1
        ZUQaF1oUy8Gpulfqxbu+cn2UvwztJsrVulx0CmI=
X-Google-Smtp-Source: ABdhPJwalUssHr/J/IX56j230ASTn2a0DzhQdRKHS90estxGTH5SmnfwW1oCy4oBOZPZNCVeFyK+3AZUfPLC5S3vyxw=
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id
 j19-20020a056638053300b0032ad418b77bmr9771567jar.237.1651102090204; Wed, 27
 Apr 2022 16:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220427210345.455611-1-jolsa@kernel.org> <20220427210345.455611-6-jolsa@kernel.org>
In-Reply-To: <20220427210345.455611-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 16:27:59 -0700
Message-ID: <CAEf4BzaT45OszajSQJbxES1RveBh0ingzAzkK0BOchBGZuavTw@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 5/5] selftests/bpf: Add attach bench test
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Wed, Apr 27, 2022 at 2:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test that reads all functions from ftrace available_filter_functions
> file and attach them all through kprobe_multi API.
>
> It also prints stats info with -v option, like on my setup:
>
>   test_bench_attach: found 48712 functions
>   test_bench_attach: attached in   1.069s
>   test_bench_attach: detached in   0.373s
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../bpf/prog_tests/kprobe_multi_test.c        | 133 ++++++++++++++++++
>  .../selftests/bpf/progs/kprobe_multi_empty.c  |  12 ++
>  2 files changed, 145 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_empty.c
>

[...]
