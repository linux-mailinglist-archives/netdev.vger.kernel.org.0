Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871EA21674F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgGGHYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgGGHYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:24:00 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1BDC061755;
        Tue,  7 Jul 2020 00:24:00 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z63so37231202qkb.8;
        Tue, 07 Jul 2020 00:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUUobSdNBrJuF1EW+dIJdI5D+Jjq/ev7F+J15Oa8C9Q=;
        b=YZObO+C6WuoXFjMmxg/9UDWawj60dvqkpoNj4mqu9yFcyqHn4G8vR/bfVzQrtqUCk9
         /38EPWQQx9oy2h4U2FkCeRn0QXB8RmKe6LOowfQfg/h+5UMUFbjRj87puqupYKKeU2oz
         8/7Dv7PTAAHGxIzPRZD/Y9mp0TuZJGi284VnX/16uU2EmOhnay0KibNZB8p2UoeIHtqq
         vJHkapVoo7CBkf33NzoZva098D4yJuetQcEclWlIb/kew10lFcLnA/PZBfW1Nkxu6YeK
         Ma58lL6pTXP8py5hUi96wSsnQC6gOieWz8GauUihu7Qi2guzXap1/iZkUmEf6ZUmlRIA
         oOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUUobSdNBrJuF1EW+dIJdI5D+Jjq/ev7F+J15Oa8C9Q=;
        b=steYoq5Ab2/pmyteAJJHe2vIOF1VeY5mQ4mthYUxnoZmA0LiI3d1lv3KzWyQehQ6bl
         9KDpBIxxH6EjUhgPBrb97IUlOdwnpmSkQNbEE10Oxw2re9gXM4k3ASx3BAG1wM/9DatK
         nOTGb+inopTh9XcdFn/EJ5rZR/chCvcg/67EsG02QorL+IG/4qlQ47NUalAoEFQP5j0A
         nvMRcepNbdS9yK+cHNawRuNG0oXdjSfipciiPy7+G2bJlEt4Wia2WzjZCBOkYMlpZWkJ
         ba3AOmKdXqs54GrUsTHvhUein1CilOeo6a9VmL0aS26AbO/QwtVsxVN9L2Ry2ZcDKRCE
         Xh1g==
X-Gm-Message-State: AOAM530+sz5AX1DC1oA7jJUKfF8WQZzPOMJA0jz9R/Ntjw213xepVwRB
        opJrQTuFdRl6J9prBcq3Ky4LRPIs9SyqgHwEpNY=
X-Google-Smtp-Source: ABdhPJxBQfF7heAYoEgSKht4+fIfPmJ4ngreCUqxM96ndAYK2PAmq94ztrEuft/Y5So7ikOwEA06muPnntfXkmMjnu8=
X-Received: by 2002:a37:7683:: with SMTP id r125mr48103373qkc.39.1594106639361;
 Tue, 07 Jul 2020 00:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <159410590190.1093222.8436994742373578091.stgit@firesoul>
In-Reply-To: <159410590190.1093222.8436994742373578091.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 00:23:48 -0700
Message-ID: <CAEf4Bzb07mdCQ5DS_gao4b9GSyeg406wpteC9uDaGdfOAHXFVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 0/2] BPF selftests test runner 'test_progs'
 use proper shell exit codes
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Martin Lau <kafai@fb.com>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 12:12 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> This patchset makes it easier to use test_progs from shell scripts, by using
> proper shell exit codes. The process's exit status should be a number
> between 0 and 255 as defined in man exit(3) else it will be masked to comply.
>
> Shell exit codes used by programs should be below 127. As 127 and above are
> used for indicating signals. E.g. 139 means 11=SIGSEGV $((139 & 127))=11.
> POSIX defines in man wait(3p) signal check if WIFSIGNALED(STATUS) and
> WTERMSIG(139)=11. (Hint: cmd 'kill -l' list signals and their numbers).
>
> Using Segmentation fault as an example, as these have happened before with
> different tests (that are part of test_progs). CI people writing these
> shell-scripts could pickup these hints and report them, if that makes sense.
>
> ---
>
> Jesper Dangaard Brouer (2):
>       selftests/bpf: test_progs use another shell exit on non-actions
>       selftests/bpf: test_progs avoid minus shell exit codes
>
>
>  tools/testing/selftests/bpf/test_progs.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> --
>

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>

My preference was shorter EXIT_ERR_SETUP, but it doesn't matter.
