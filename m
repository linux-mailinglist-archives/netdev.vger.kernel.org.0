Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050EF1CB88E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEHTrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHTrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:47:03 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DD6C061A0C;
        Fri,  8 May 2020 12:47:03 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x12so2385334qts.9;
        Fri, 08 May 2020 12:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/x2HggFoKdZg9YZ7OB5ms1q8A9SDnkS0sJf+ym4GB8=;
        b=ocGzf0/8zOghZ0VBRhNuybdWCi+5uzbac638szVZBkk+kWeiAC0LhYmLvYFpfAxlXW
         N+V346ClME45ZlWDtFPoeB5nwSjnlXutiiNXwEKs0SmWUkLCaJ3SHKUtHs8gYllrllS5
         VtvfrPlpqIOaePi4uTCDG0uzAJzoOXDN2JHzyQAlObykJ2YKlNQWR9rusZBUbtueTVfE
         +aVF4yxBrmYSa0YNx33JGOn2Oya6ofX6xVSL9k9MFBSGgeclWLpRUM+0mso5PRaCMLyo
         Re/42t3LVA1PY/9cpFPNyxlzBI9OEyomvnvW47FMHibAOyDWntMLrh22xIjdhCC7T3vI
         FfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/x2HggFoKdZg9YZ7OB5ms1q8A9SDnkS0sJf+ym4GB8=;
        b=FJKr8N/R67VM13TrbTBHwgxhbLrx1HR2AnbjSuqFtr9rTNxUtVw1vVcdraBsUT81q+
         rYiMjWjDy3mNsFke0avfE3MCF30s2jRb/P7F1uXmctRhYLLsVNVEee4tJFBRB/s0LmQy
         NkUJnSSVs/lDjHCSugM400Cz9xQAOffM/uby4Nu3YIzXsa6+oyozfnnJvtctSyJEaRNX
         Q3oqzIvfEVriipNnnZpmUvsN59/IrbmAI8QsbLrmnFwJxetQ7vIUK61dSfj8OPMHl0WP
         N7ZpLER2fWk1U+g3lD+5GGsG9hy5uN/3O/lhWecpGua3+5pUk83CbKCNI0uKUqUqyKTw
         sbZw==
X-Gm-Message-State: AGi0PuYiYyNLweaBV5rvY376wL/XWEHNJH1DcRSxiFHcm0jplSMj554Y
        CGMb9UPiMusays+bF0/DPjcbRWHD8wivqxFAkTg=
X-Google-Smtp-Source: APiQypIaxZdU8mGjC6Ckwpmczeq2jXPiaynPhIYvUe5hV6ASf0pcMnHpa8nO5okZREtyzZJC1/nrj1D4RjfmNkBKmv4=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr4609548qto.59.1588967222413;
 Fri, 08 May 2020 12:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053934.1545091-1-yhs@fb.com>
In-Reply-To: <20200507053934.1545091-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:46:51 -0700
Message-ID: <CAEf4BzZ0c78FHKHosqArHkP6i_wvKxVb5UsEpgA6hxwJpKt1-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 16/21] tools/libbpf: add bpf_iter support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:42 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two new libbpf APIs are added to support bpf_iter:
>   - bpf_program__attach_iter
>     Given a bpf program and additional parameters, which is
>     none now, returns a bpf_link.
>   - bpf_iter_create
>     syscall level API to create a bpf iterator.
>
> The macro BPF_SEQ_PRINTF are also introduced. The format
> looks like:
>   BPF_SEQ_PRINTF(seq, "task id %d\n", pid);
>
> This macro can help bpf program writers with
> nicer bpf_seq_printf syntax similar to the kernel one.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks great!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf.c         | 10 +++++++
>  tools/lib/bpf/bpf.h         |  2 ++
>  tools/lib/bpf/bpf_tracing.h | 16 ++++++++++++
>  tools/lib/bpf/libbpf.c      | 52 +++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h      |  9 +++++++
>  tools/lib/bpf/libbpf.map    |  2 ++
>  6 files changed, 91 insertions(+)
>

[...]
