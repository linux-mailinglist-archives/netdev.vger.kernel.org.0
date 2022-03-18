Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE824DD3C7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 04:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiCRDyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 23:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiCRDyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 23:54:45 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8310B1760D8;
        Thu, 17 Mar 2022 20:53:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n18so6084512plg.5;
        Thu, 17 Mar 2022 20:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rI0FrmQ3+ceiLgNiqpfsxdYGbjB79Df3AZRI5bRwQ0o=;
        b=Hn4JBwIy1jFjd69nBo+JFJCVJTNTD+3bEmjId2ADMgJLcte32nRtt93TpmWQRS4c7x
         rR3dQlzClV0KAYsGDhtSw8cDWKQ2t/uiy5tlnOJIYD3VY9RESUiS6CnLqkdazkns/6pv
         UAHAKywoeebHtivA1rdf1btn57gw/UFuxxO4ILGRDP6jhPc3W8CRA2pVUs0Y4QvLIuQ9
         x/i37jh/SlO7Rj/lk0Raz/Wv5GvcU34ithzP8JXKVzYdvCz/gMAuQT76Qps4bLfKGpS9
         iF44e0+FX8XLrJ9zp8D1QK50IQKSEpT/T09RfNixVI/NIZzXht9u9PY/z2YmhBY4TxEL
         sTbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rI0FrmQ3+ceiLgNiqpfsxdYGbjB79Df3AZRI5bRwQ0o=;
        b=myUwgMgfEjOURmVrguPuQL9F8B5CNc1nQiHx/I80q0un7b06zcJaODO6zf8R1fhcl5
         cfU96kCzCnOQGnXIGOg+GVM5r/HKFTeeTh+6/7FIwaEPxME3ZgD8RQWafCAVPNZ4zsjc
         XJN1vNvvBT9/ijLM/kMkUgdohg2aGgtf1ixdXlhDYhZtESjoxZVn77NSxVS/zYDC9S9T
         hmqmQ/L5Lb1wnp9Y866Kitm0NIHrWONju26Kb8WWt+taIKxilD2dC97Jg4TILumxF+EG
         G/uEKaDPpPhwKzGgZZkfaC4PK5PjKvRqNsgmVs16ccYAO85sG+yL3x+bvPhjiIH8jyUG
         KJIQ==
X-Gm-Message-State: AOAM531jsO0adzyj4QqFwvrZIXWHA97+o89aGO3B1ZXeYX/d7CyWG+xH
        iYnpEKWKB4sKUZ5iEdAGjubpn1kg1ihRN9whnu8=
X-Google-Smtp-Source: ABdhPJy2ZGzSwNJVYvTAvFyGkHdWwb9m7G9msiWNB29nrOy+gUScs5WGun2fBr8MEIsKK9zmWNETbCkreSoUzE6cdEU=
X-Received: by 2002:a17:902:ab10:b0:153:b520:dbbe with SMTP id
 ik16-20020a170902ab1000b00153b520dbbemr7875333plb.55.1647575606916; Thu, 17
 Mar 2022 20:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220316122419.933957-1-jolsa@kernel.org> <20220316122419.933957-10-jolsa@kernel.org>
In-Reply-To: <20220316122419.933957-10-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Mar 2022 20:53:15 -0700
Message-ID: <CAADnVQ+tNLEtbPY+=sZSoBicdSTx1YLgZJwnNuhnBkUcr5xozQ@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 09/13] libbpf: Add bpf_program__attach_kprobe_multi_opts
 function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
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

On Wed, Mar 16, 2022 at 5:26 AM Jiri Olsa <jolsa@kernel.org> wrote:
> +
> +struct bpf_link *
> +bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
> +                                     const char *pattern,
> +                                     const struct bpf_kprobe_multi_opts *opts)
> +{
> +       LIBBPF_OPTS(bpf_link_create_opts, lopts);
> +       struct kprobe_multi_resolve res = {
> +               .pattern = pattern,
> +       };
> +       struct bpf_link *link = NULL;
> +       char errmsg[STRERR_BUFSIZE];
> +       const unsigned long *addrs;
> +       int err, link_fd, prog_fd;
> +       const __u64 *cookies;
> +       const char **syms;
> +       bool retprobe;
> +       size_t cnt;
> +
> +       if (!OPTS_VALID(opts, bpf_kprobe_multi_opts))
> +               return libbpf_err_ptr(-EINVAL);
> +
> +       syms    = OPTS_GET(opts, syms, false);
> +       addrs   = OPTS_GET(opts, addrs, false);
> +       cnt     = OPTS_GET(opts, cnt, false);
> +       cookies = OPTS_GET(opts, cookies, false);
> +
> +       if (!pattern && !addrs && !syms)
> +               return libbpf_err_ptr(-EINVAL);
> +       if (pattern && (addrs || syms || cookies || cnt))
> +               return libbpf_err_ptr(-EINVAL);
> +       if (!pattern && !cnt)
> +               return libbpf_err_ptr(-EINVAL);
> +       if (addrs && syms)
> +               return libbpf_err_ptr(-EINVAL);
> +
> +       if (pattern) {
> +               err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
> +               if (err)
> +                       goto error;
> +               if (!res.cnt) {
> +                       err = -ENOENT;
> +                       goto error;
> +               }
> +               addrs = res.addrs;
> +               cnt = res.cnt;
> +       }

Thanks Jiri.
Great stuff and a major milestone!
I've applied Masami's and your patches to bpf-next.

But the above needs more work.
Currently test_progs -t kprobe_multi
takes 4 seconds on lockdep+debug kernel.
Mainly because of the above loop.

    18.05%  test_progs       [kernel.kallsyms]   [k]
kallsyms_expand_symbol.constprop.4
    12.53%  test_progs       libc-2.28.so        [.] _IO_vfscanf
     6.31%  test_progs       [kernel.kallsyms]   [k] number
     4.66%  test_progs       [kernel.kallsyms]   [k] format_decode
     4.65%  test_progs       [kernel.kallsyms]   [k] string_nocheck

Single test_skel_api() subtest takes almost a second.

A cache inside libbpf probably won't help.
Maybe introduce a bpf iterator for kallsyms?

On the kernel side kprobe_multi_resolve_syms() looks similarly inefficient.
I'm not sure whether it would be a bottle neck though.

Orthogonal to this issue please add a new stress test
to selftest/bpf that attaches to a lot of functions.
