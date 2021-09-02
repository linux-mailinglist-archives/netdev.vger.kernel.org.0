Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AF23FF7AC
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347943AbhIBXLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhIBXLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:11:18 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A118C061575;
        Thu,  2 Sep 2021 16:10:19 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r4so6887964ybp.4;
        Thu, 02 Sep 2021 16:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKzS7IB2clPso0+rztEPnqTn2ycex38WYxjIzSXMJbM=;
        b=mAOuY1mqNuRNx3vCJKe7FW5Be+M0eSB7Z9a3/tZn+eBh4TiUI8s/1kERM6MmzRLjBo
         Yb18mOujomcizIreIkvMyhE0KFQMkHvj6MJoL9yFzz6yRenOYhlcqZZ+kwpLviRSj1Xa
         C1E/ou96Xy9t4DQ5sBus5761hMazoVRsRGzWk711h0ORaqlqzvBanpF1nyTe1XD3M0i2
         oXfVN4NrcoUnj1oj1f/yh0JEfDus9MaR6vsDsUK9rRwPZeDZHouDoiIsNcXDIKQEflIL
         kFrRx+UCCkpfMeEtOliKPZiSIqxfLby41wk3b0SLvJewXirIG4bSDa2M90hdC8t8WTRA
         6uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKzS7IB2clPso0+rztEPnqTn2ycex38WYxjIzSXMJbM=;
        b=hgB/ut2xiLX2EuvuW2xRDmddvVIp11EHFbCLnSUMOTucgjdNZ0GcCZdnzMqOdNkuat
         huCil0BcYR5+MDNpybrVzNZVD7NIweIZ9RW4CZUzz0ll5QeTd4w748qxwp9SExDkOQk4
         Ovh8dlWxFBo6SUzxKx2EndbCVWmCH+e1lIvxiNBjw35PrwUpduC5jnfiVXjSzS+O6Ahd
         QK7enqmBv1xGovnZtODNHgnaqipK+yq6NczNeVPNTgPkv/CO0vefjYv5pjhpt+cQluKf
         0kM1irEUT8Uxn1ZWqkl+Q+gZky+rNorgiYBM8LqJx4VQZAisI9/QSLPKHeD5FDTlgAog
         H9Cw==
X-Gm-Message-State: AOAM530LgwwsneBQevRxjCgRhv9F3B0lFIfGzVRp+PEgMe4Vgy+YUHpx
        Rwpk0BFZaPlWatiLKfL2M6Qc3UZAoAiP8v0wYQM=
X-Google-Smtp-Source: ABdhPJxf9KZw8DpUaopeaCaMpTqGC9wclAXUTnXCpiwwfII7SjWyxn9sSNHI8OppDXVLjbgNGeJQy68wZx+zHNXnA8o=
X-Received: by 2002:a05:6902:70b:: with SMTP id k11mr1044090ybt.510.1630624218723;
 Thu, 02 Sep 2021 16:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210902171929.3922667-1-davemarchevsky@fb.com> <20210902171929.3922667-7-davemarchevsky@fb.com>
In-Reply-To: <20210902171929.3922667-7-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Sep 2021 16:10:07 -0700
Message-ID: <CAEf4BzZ_Vm+EsjtvJu-KunD6rgMXDSJxiNoBq2FRPfe=wis2dw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 6/9] bpftool: only probe trace_vprintk feature
 in 'full' mode
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 10:20 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> Since commit 368cb0e7cdb5e ("bpftool: Make probes which emit dmesg
> warnings optional"), some helpers aren't probed by bpftool unless
> `full` arg is added to `bpftool feature probe`.
>
> bpf_trace_vprintk can emit dmesg warnings when probed, so include it.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/bpftool/feature.c                 |  1 +
>  tools/testing/selftests/bpf/test_bpftool.py | 22 +++++++++------------
>  2 files changed, 10 insertions(+), 13 deletions(-)
>

[...]
