Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0181E29BA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgEZSJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgEZSJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:09:26 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C858BC03E96D;
        Tue, 26 May 2020 11:09:25 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v4so16943220qte.3;
        Tue, 26 May 2020 11:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XC+9atK+SRwWUYdhr2HXBTWfeg0JsLTMpcoy04M33VA=;
        b=M7q3232SuXLOoTjZDMXqawFV4kv1V2wTYgPwwW0bXd1PMoNa5Ufj9GWqdBW/R7+lu/
         JK3P3ghSpWN4ZT28BrEqCgGeK+c7CA9zOkcafg1FjT5cQkGdQBbb7Yx6A20P/hUYfg+9
         eE9TgKbY8qwHY8IydZGM+S546LFePeAem5wRGwjrRVMhPjltXiDjjDu6y8QLaq9jrBdG
         YZ5IHi+NAA7rrsWjU3bfqShtmE2tdPtmQGEE1Yskn+hRP64LhTyPD3tERrUBX9MCLlXt
         MXG7GbkQISDixA1YhEANOFeGtacLjVGBMDIMjBcvaSC32HIM+P8+3tSCpHr0QWjs70lX
         Qy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XC+9atK+SRwWUYdhr2HXBTWfeg0JsLTMpcoy04M33VA=;
        b=ifOO9rwS8Mcs1r7JowtV78L3t0katTrDIXCpQso/Re5Ccmq8OZQmttWSV2WtmQejxk
         JEVsE0eXI395Zn7FnPpGwpdo9aYO8r3YBvPZRMXUCF/uYw5ffIAQ+i743g+hLnaavtlw
         Dc15YEYSqVdcLahNO9lfv8lmz4QCj+1LIFILLUxLhlUsFcrK7gN3KNynbloyeOlAqehM
         Zt8/BURe00Xcyvp1ZkVMIQ54LDxT+qoPln3H2wJ7CFnHKajJySB/Os2SpbKPN6wa0VfV
         q1nynJ9uB/WC8VKTkq1KLasjRCulXNMze/XAYfkyI++CC5/kakC2KHlKjCGaf4MHDI7G
         y1Rg==
X-Gm-Message-State: AOAM530G7hAkV+lM8BgW8E8UPXEnvsw0SDmYzXKxlU+Qz4j5pBy+wxKc
        Tzfy96eTDGJGISvY/KJxk/fvjdpHfoARrLtgosk=
X-Google-Smtp-Source: ABdhPJwTx6SplwftBIi9zznc2Aj48Kqv5vm1ebYm+egdmODEPChjXOmUddDxDXHb/IYwbkFsGbf2QKf7aDBsIYAErP0=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr19101qta.141.1590516565065;
 Tue, 26 May 2020 11:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
 <159033911685.12355.15951980509828906214.stgit@john-Precision-5820-Tower>
In-Reply-To: <159033911685.12355.15951980509828906214.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 11:09:14 -0700
Message-ID: <CAEf4BzbOgrAmvq=G=w54A1xZFoSH=dRHMMDMJgeFo46bA=nBNw@mail.gmail.com>
Subject: Re: [bpf-next PATCH v5 5/5] bpf, selftests: test probe_* helpers from SCHED_CLS
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 9:52 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Lets test using probe* in SCHED_CLS network programs as well just
> to be sure these keep working. Its cheap to add the extra test
> and provides a second context to test outside of sk_msg after
> we generalized probe* helpers to all networking types.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

One day we need to just replace all bpf_prog_load() calls with
bpf_object__open() or skeleton open/load. But not today :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 ++++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_skb_helpers.c |   28 +++++++++++++++++++
>  2 files changed, 58 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
>

[...]
