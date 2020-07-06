Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85D216265
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgGFXjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFXjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:39:44 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1055C061755;
        Mon,  6 Jul 2020 16:39:43 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x62so30428949qtd.3;
        Mon, 06 Jul 2020 16:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LMmLrH5EL3kj+M+sxK2wwVhf0YVlmuSCc2pqZtTL8c4=;
        b=O5ewSce8r5f+CgUlP/WG1NQt6puOUuTRSdbzyl5yVtZuMH1WEBm7GeKf3Ao5Q49aer
         0NM6xHmD8JPjcTgHQTBf4lu72eQh4defxAYCnvQqWkCjL8zCNFQNJ8dCZq5VjfrDeVOx
         HsME/3ypJ5vUejioozH+gl/wFbFx24CHftV9n7uOEiD+iRh2BlV4JwTUWDAYdEddcsL4
         RN9IfUccSMdskI0kEP0rRKsQeQUPYr9SJhEhr+4O+Jo5vaXYejNHsWQZGvdZaSi8prBo
         DNl1bThNxxFTWNnNXudgKSnohRoptY8B8P2jY4Z8ign2e2FykFdgusIm52f9iJOgXSPC
         rXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LMmLrH5EL3kj+M+sxK2wwVhf0YVlmuSCc2pqZtTL8c4=;
        b=LLexY6idIDJzm33VyROieYJ6qZbaybqA5ZhoMxDXStNQGvYeUE3VLa5XwWnC5OoHYO
         dJVmvfT336Y+neqQl/NWcqU2dLf3/dO84+ZAMfwTsTNncGU094rSKyf7kUi65/rQ6NYi
         BenMpM4TbDTV+7kJuRMt7ClmEkZz1zK0z3PPs1sapl7hpKVt0RBWcARNFOjlSGm4+Bwn
         Or0m4hVUJp7Gku137acC5WM+0fwejHR4bnploT9CRa7CKi3yMQnRAa7GzEbOFLbcEW3a
         ZIMf/Cyxv1m4fPwwXghO4IWf8AT9i8wnB6nu69ORZn+d6i+48zOCAOw3mGK7Y2D7p00O
         CI5Q==
X-Gm-Message-State: AOAM533uvqrw2WH5LoYGihAcn9tMlkRF8vQ1AwaOnB8uN0+et3PUiHXZ
        TGXfNbe45eegJlD+hc1p3saA8WfK2JlIKRtcEuY=
X-Google-Smtp-Source: ABdhPJy50lhRt5KedIFP7Arl1oEUg2IJrVEePB36QyPH4YlbDNmOpnyFtJ79uGlpBxYcwKDgdqzRZw48bZ8pMnWx3KU=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr51450100qtp.141.1594078783011;
 Mon, 06 Jul 2020 16:39:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com> <20200706230128.4073544-5-sdf@google.com>
In-Reply-To: <20200706230128.4073544-5-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 16:39:32 -0700
Message-ID: <CAEf4BzY-QS_MniP2dXFxS_PLPwCL=yLoFFr8+HwKvCTnNg7T_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/4] selftests/bpf: test BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 4:04 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Simple test that enforces a single SOCK_DGRAM socker per cgroup.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/udp_limit.c      | 75 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
>  2 files changed, 117 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
>  create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
>

[...]
