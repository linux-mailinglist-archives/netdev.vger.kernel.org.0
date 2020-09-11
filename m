Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377C92669F4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgIKVQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgIKVQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:16:47 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50855C061573;
        Fri, 11 Sep 2020 14:16:47 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x8so7255508ybm.3;
        Fri, 11 Sep 2020 14:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RSL8ORKPwL6wACHMmENceAsvrQpZBZMEC3C78MwzAbE=;
        b=dS4QnPkqfpttFprha9o+GfNralJBIzuOO2zxUy5pAOk646s4FQTAHIPCjNLusle0c4
         LO603q9wWMfaWSiJbZ94ye3hOMQXHhK1W9JPmPUKToIEXjZb/QKgMHhEHd4RYdox4rs1
         cQfi4Aegv6lp3VeDmmtFCDITOvfJWGRDS4Saf5Jac5RA44yjZGs02qOGgEGV5ApAlZVh
         nKUTA5eJdFAEPBAcEvNglCg5+s5j4b5KOybTawEcvQ72wUMabra9+aiM7IUhd9T1jIwW
         0o/JRRzCXUi4DKzyjrsJ+odrsqmVmGb9zGJgE2QcCpvF6hKG1xvumvYyGKzJK3h7LlV+
         F/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RSL8ORKPwL6wACHMmENceAsvrQpZBZMEC3C78MwzAbE=;
        b=QpL8lJ7fo2+OUZpLPs1vamGMXaw0AzJZzdg/jaociBt9VZS1GcF07blGl9QxH9rnvo
         +CwMIqFJb7sOSNhr7kHMR6SXsiFpfp4tcgqmQ/eK+T5K2Ge4iNjaTPi6gonqZpCb62r6
         n63TthYxj4Ji0ARD7yHA8OId7gQZFHimfAbNQxgfSeRkeml+41ntnArhx3wfvZS/PsrZ
         k/tKPta/lR/PO7U87ErqTlzGCwl+/egPnmIpIr4yJduD/V/Fs02Womaj69x9Z+T16pyW
         ZTei170ftV7HZfaWR8x6DKVC2K9jxSI0LZJ2yAknRPMl8bN6za/jnJp6oIUt6uk8E2f2
         /XWA==
X-Gm-Message-State: AOAM531S+O4QGZ9pjBh33GtLNpvzvYf/l+Cy0X9xsa14P3pDorwyA/f5
        I+K7BVTRgINMnvievx3tp5UcRVBuor723UWFe2M=
X-Google-Smtp-Source: ABdhPJzeBzO/0F6OfQSRYl16sFYNQbdpocXYNzJabuCsjul5JYtMyNYCxgv/vI/6tcaTCOGrZ55kLX1GQsQvqBXHWp4=
X-Received: by 2002:a25:e655:: with SMTP id d82mr5644863ybh.347.1599859005951;
 Fri, 11 Sep 2020 14:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <159981835466.134722.8652987144251743467.stgit@toke.dk> <159981836129.134722.13602310042777114855.stgit@toke.dk>
In-Reply-To: <159981836129.134722.13602310042777114855.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Sep 2020 14:16:35 -0700
Message-ID: <CAEf4BzYqL0mowSPkp=0yCEG3D7biMLtNo=5FNEtvxnKe3+9P=Q@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next v3 6/9] tools: add new members to
 bpf_attr.raw_tracepoint in bpf.h
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 3:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Sync addition of new members from main kernel tree.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

There is no more need to split these updates into separate patches,
feel free to fold it into the patch that changes original header.

>  tools/include/uapi/linux/bpf.h |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index 90359cab501d..0885ab6ac8d9 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -595,8 +595,10 @@ union bpf_attr {
>         } query;
>
>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN comm=
and */
> -               __u64 name;
> -               __u32 prog_fd;
> +               __u64           name;
> +               __u32           prog_fd;
> +               __u32           tgt_prog_fd;
> +               __u32           tgt_btf_id;
>         } raw_tracepoint;
>
>         struct { /* anonymous struct for BPF_BTF_LOAD */
>
