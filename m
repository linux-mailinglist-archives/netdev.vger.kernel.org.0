Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5C1CB449
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 18:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgEHQCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 12:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgEHQCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 12:02:10 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E95EC061A0C;
        Fri,  8 May 2020 09:02:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id d7so2293323ioq.5;
        Fri, 08 May 2020 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=r21SYHW30TnwMP4cS8xVM26uU+3dot9UoyA+zIoGdLk=;
        b=AI06f/l4KaxxCG97rEgrlvSPvY4Vlsf4SNQW591Rqpw9f6hGwzRc+dD4dyh3Invy8D
         KIEMiABXU3A9fze/E9tD4taaCmCmydEMk8RGeOs0MRd92Q2U2Pt1AxRIeem9Bne5jDd+
         zsgmDFc1mZ2dxQd40+s7Q06tWMWWTHHskQsm3h9DSjR0N5eUkL01zvwLgbJqwPCcpi/Z
         HuGdNxAytK55hFBuhhF8sIb7PcwlaCgWRf7c/kauNgCZgsXECNLFiSxyUsrQYMNNoDnQ
         +eVp83kNaz633vaebRme3eNoAvi5wTJC8O/MROaCZhJSNBBcLXGwXFvDZKV5DFPv7tfj
         Ts5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=r21SYHW30TnwMP4cS8xVM26uU+3dot9UoyA+zIoGdLk=;
        b=J1++QQoxjrGxi3AxnoHS042nUvMUlRuaOLcJXIWhBaMUHv1ejThoCRCD1JOV3kT/+a
         QxcfXxZlHe6KokFJkPh4BW/glrSadTqHIUHgvJ+KNEFF8R7qxSmcGWcBGjReLwZKGYdy
         yko+16E1PB7TMIUlkD4scXSMEstISR8i2Xmf1Tf0mOxoo0koyzlSnHCs5FO+JtiB6efU
         76CCLy2DphcQPZGRI+Mtzr/bVOUPXG4fNnzDpYncgBtAwfY6/t2vbM3QwKq9n8suxu+8
         bQmIhCi3t+8vLR7M4h0RvjbgsFWwknrtxxNlyOB0Ia7w9i3lvBsWBq7P+nw+kcSyjuAs
         hGJw==
X-Gm-Message-State: AGi0PuYbTeaLmF3Ic2LzY3u/R4ct5R0glSaZc4tsWutKUs+9biR/yg1a
        4XrnaOjBf8LkJtRpa2I9+NA=
X-Google-Smtp-Source: APiQypLg0OzJG5j/jVO96AV/seHdNdOpkhM6bPgeNK8CIs63lVV39xNzpy5fArjRVRuq8JxF1+4KWw==
X-Received: by 2002:a02:cc5c:: with SMTP id i28mr3355813jaq.20.1588953729550;
        Fri, 08 May 2020 09:02:09 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b11sm980564ile.3.2020.05.08.09.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 09:02:08 -0700 (PDT)
Date:   Fri, 08 May 2020 09:02:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5eb58278bae41_2a992ad50b5cc5b430@john-XPS-13-9370.notmuch>
In-Reply-To: <20200508070548.2358701-4-andriin@fb.com>
References: <20200508070548.2358701-1-andriin@fb.com>
 <20200508070548.2358701-4-andriin@fb.com>
Subject: RE: [PATCH bpf-next 3/3] selftest/bpf: add BPF triggring benchmark
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> It is sometimes desirable to be able to trigger BPF program from user-s=
pace
> with minimal overhead. sys_enter would seem to be a good candidate, yet=
 in
> a lot of cases there will be a lot of noise from syscalls triggered by =
other
> processes on the system. So while searching for low-overhead alternativ=
e, I've
> stumbled upon getpgid() syscall, which seems to be specific enough to n=
ot
> suffer from accidental syscall by other apps.
> =

> This set of benchmarks compares tp, raw_tp w/ filtering by syscall ID, =
kprobe,
> fentry and fmod_ret with returning error (so that syscall would not be
> executed), to determine the lowest-overhead way. Here are results on my=

> machine:
> =

> $ for i in base tp rawtp kprobe fentry fmodret; \
> do \
>     summary=3D$(sudo ./bench -w2 -d5 -a trig-$i | \
>               tail -n1 | cut -d'(' -f1 | cut -d' ' -f3- ) && \
>     printf "%-10s: %s\n" $i "$summary"; \
> done
> =

> base      :    9.200 =C2=B1 0.319M/s
> tp        :    6.690 =C2=B1 0.125M/s
> rawtp     :    8.571 =C2=B1 0.214M/s
> kprobe    :    6.431 =C2=B1 0.048M/s
> fentry    :    8.955 =C2=B1 0.241M/s
> fmodret   :    8.903 =C2=B1 0.135M/s
> =

> So it seems like fmodret doesn't give much benefit for such lightweight=

> syscall. Raw tracepoint is pretty decent despite additional filtering l=
ogic,
> but it will be called for any other syscall in the system, which rules =
it out.
> Fentry, though, seems to be adding the least amoung of overhead and ach=
ieves
> 97.3% of performance of baseline no-BPF-attached syscall.
> =

> Using getpgid() seems to be preferable to set_task_comm() approach from=

> test_overhead, as it's about 2.35x faster in a baseline performance.
> =

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Nice.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
