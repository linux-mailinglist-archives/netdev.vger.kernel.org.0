Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E42834DC4A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhC2XKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhC2XKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3189E6192F;
        Mon, 29 Mar 2021 23:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617059432;
        bh=0noQ+Rgq8yK9Gx9eARD7uquXfpIzRiWu3yr9VQanp7c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bWYAyKGx95UqZ4iE+1TgTvBY401Wu78wWgEAdYcucbm1ZMPJ96+8bKOsZ62AGd0pG
         Xe1cGUTCwRwsMlb6qxWZfjzKSDTpHwJCWuWngGhWRLdtqTb55f22Se4xxl8lnbhWnv
         xTnzdlXPD7G27EuchBFKHqwl+STs8BjWfn6t6AWOeAA4W963i6MMWlM2/M1LTmiH3O
         ePe0w7T1bHS5EIA3fBDdDDtOcHTOtOLG98zXr4GS+7hgTS2WDogwRK3CU1a+FkVdLB
         f2XpNNUB7LUbKC3EW6Pl8ryZPi+FmZBrXTTYx1RUFagRwSqIJLDHW5WSLr7C+cOEsg
         JDYNCZ/Lbt5BQ==
Received: by mail-lf1-f52.google.com with SMTP id 12so10509904lfq.13;
        Mon, 29 Mar 2021 16:10:32 -0700 (PDT)
X-Gm-Message-State: AOAM5328fafgdT505nRu2bnaPrQK3eausAOZ40DYlBUHEM4HdE5EIrDP
        oOsNecHnxjYItiZlys3V0ynkzZkyKPMsf211iMQ=
X-Google-Smtp-Source: ABdhPJztOqCFpWHiMjH/EQnajrCGC9IepYSu9+amrOcyv/tRtL9FrtooB7C/9pb72cCJPEi/t0YVcQzabGsVr6XEe2I=
X-Received: by 2002:ac2:5221:: with SMTP id i1mr18054668lfl.160.1617059430543;
 Mon, 29 Mar 2021 16:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210329223143.3659983-1-sdf@google.com>
In-Reply-To: <20210329223143.3659983-1-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 29 Mar 2021 16:10:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6aNC2XbvH+_NB0oheqRQHXzXzZzVD8=WCLZx=hdX2zYQ@mail.gmail.com>
Message-ID: <CAPhsuW6aNC2XbvH+_NB0oheqRQHXzXzZzVD8=WCLZx=hdX2zYQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] tools/resolve_btfids: Fix warnings
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 3:35 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> * make eprintf static, used only in main.c
> * initialize ret in eprintf
> * remove unused *tmp
>
> v3:
> * remove another err (Song Liu)
>
> v2:
> * remove unused 'int err = -1'
>
> Cc: Song Liu <song@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>
[...]
