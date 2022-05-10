Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDDC520BD5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiEJDTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiEJDT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:19:27 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C22A7C36;
        Mon,  9 May 2022 20:15:28 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j6so13826534pfe.13;
        Mon, 09 May 2022 20:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OzBRtyA4Byv4LHvvdlavJZPXa2xwqQ3WqNSL+ipftlE=;
        b=GRyifsnxSAzQclB46AIqh//+4UVGhBderEtEsgh88zGcsLB6KJfD4JqQotuLmYQk8C
         qlWplL77Gza4lP3BSveSdF+ZsPItB7vHxW3p1K06qWPGHVB0HKJm9rQYB/F3VYHbi6Po
         bYhc+MYISHqIWN8palL2/40KWuIy5SK+VMCp2078167w96Q7/bQccaovelMHkFE1N41v
         zJ6kHyBj+H0YTYOLH0Wk2d0vJx7PcFM3RHlx/IxKenDEjGnx/lGzd8vIipji3mkpornL
         6nCxSOiGZPNmWOkDYhXbD89Cx9QTcpl/N7g4pgZdfSRAQ1os9u74kz+sOrYQUs52DGiX
         RMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OzBRtyA4Byv4LHvvdlavJZPXa2xwqQ3WqNSL+ipftlE=;
        b=Ujl+paofVJPJ8B+ecRBAasmWgoX7nNpuaVMu/LDUN3fhRMNEmA6FkYx4b4kXT6e0bb
         z+R6BzahBKMgTnvj715wwVdmNwhcVPm8td3HMKZVJD1ap61+9zdvYfac7VI1gZicO+S5
         ixDBrfDeKPe2a7nVmPFNQT6y5r9HeJEjJoroeRAWldLpWeSG2skBspnIf01NacsYepHN
         TWW9MVd2SH1CdvRCEQOqSr7YviTtbtLHk/88aZtnlyuAEv9lxmhwxv9pyB0VNAs8nLKo
         AgwhfO/UM5KZpBe9xN9ido6NG0mnJVyf4yvVUsYLNT6fTm5dMCiBz1HfLo68tTnCKkDl
         i0Sw==
X-Gm-Message-State: AOAM532bGGyAHcr6JZRlaDMgjz6ww3qxDX8N6ftJFnvylyiDV6R0OMeI
        Huwr6YlkxITG3bLY+qyLjbKwWe8AOcyH1GhcnYg=
X-Google-Smtp-Source: ABdhPJx5NoYTMAQANTkydC4IpcP+swG4dX1n9zoWhruqsIgQDTRC5XKQkT1vr5YaiY0DmWqZsC4y49eBzgbkatMRFIE=
X-Received: by 2002:a05:6a00:8ce:b0:510:9298:ea26 with SMTP id
 s14-20020a056a0008ce00b005109298ea26mr12990895pfu.55.1652152527696; Mon, 09
 May 2022 20:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220507024840.42662-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzZD5q2j229_gL_nDFse2v=k2Ea0nfguH+sOA2O1Nm5sQw@mail.gmail.com>
 <CAJD7tkbd8qA-4goUCVW6Tf0xGpj2OSBXncpWhrWFn5y010oBMw@mail.gmail.com> <d20aef2a-273a-3183-0923-bde9657d4418@bytedance.com>
In-Reply-To: <d20aef2a-273a-3183-0923-bde9657d4418@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 9 May 2022 20:15:16 -0700
Message-ID: <CAADnVQL+Vq5y47J++VCppti1728w3U0maxg9d4SqAtArY+h1yg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH bpf-next] bpf: add bpf_map_lookup_percpu_elem
 for percpu map
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 7:41 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>
> =E5=9C=A8 2022/5/10 =E4=B8=8A=E5=8D=889:04, Yosry Ahmed =E5=86=99=E9=81=
=93:
> > On Mon, May 9, 2022 at 5:34 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >> On Fri, May 6, 2022 at 7:49 PM Feng zhou <zhoufeng.zf@bytedance.com> w=
rote:
> >>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> >>>
> >>> Trace some functions, such as enqueue_task_fair, need to access the
> >>> corresponding cpu, not the current cpu, and bpf_map_lookup_elem percp=
u map
> >>> cannot do it. So add bpf_map_lookup_percpu_elem to accomplish it for
> >>> percpu_array_map, percpu_hash_map, lru_percpu_hash_map.
> >>>
> >>> The implementation method is relatively simple, refer to the implemen=
tation
> >>> method of map_lookup_elem of percpu map, increase the parameters of c=
pu, and
> >>> obtain it according to the specified cpu.
> >>>
> >> I don't think it's safe in general to access per-cpu data from another
> >> CPU. I'd suggest just having either a ARRAY_OF_MAPS or adding CPU ID
> >> as part of the key, if you need such a custom access pattern.
> > I actually just sent an RFC patch series containing a similar patch
> > for the exact same purpose. There are instances in the kernel where
> > per-cpu data is accessed from other cpus (e.g.
> > mem_cgroup_css_rstat_flush()). I believe, like any other variable,
> > percpu data can be safe or not safe to access, based on the access
> > pattern. It is up to the user to coordinate accesses to the variable.
> >
> > For example, in my use case, one of the accessors only reads percpu
> > values of different cpus, so it should be safe. If a user accesses
> > percpu data of another cpu without guaranteeing safety, they corrupt
> > their own data. I understand that the main purpose of percpu data is
> > lockless (and therefore fast) access, but in some use cases the user
> > may be able to safely (and locklessly) access the data concurrently.
> >
>
> Regarding data security, I think users need to consider before using it,
> such
> as hook enqueue_task_fair, the function itself takes the rq lock of the
> corresponding cpu, there is no problem, and the kernel only provides a
> method,
> like bpf_per_cpu_ptr and bpf_this_cpu_ptr, data security needs to be
> guaranteed
> by users in different scenarios, such as using bpf_spin_lock.

Right. The new helper looks useful and is safe.
Please add a selftest and respin.
