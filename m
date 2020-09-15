Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45811269A6F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgIOAbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgIOAbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 20:31:15 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E12C06174A;
        Mon, 14 Sep 2020 17:31:15 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x8so1242581ybm.3;
        Mon, 14 Sep 2020 17:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSuua+KQFUkRQnZw9f4qmHsHpgSqDmm375Cjk5dD/tg=;
        b=k7yQ3U9wo0YcKmPIKDR0DAx7ocNOQ1GeqbYmghwmK5tzpUxVbhfflxwyBz0nsIeV5N
         oPuwA89IGJ+u+zfSEdnRFo6+SmmK5DysQImD5Cz1uY8pZEgLY8f+7j9GVRkvs+0xAby7
         qY+p45ZRO3O9UXLe+kYFsyxaoMss5LX5lLB4atZvFeJCMU3OE57SM7OLhj64O+3b0P/2
         xU2sVJlwkNJeYEVIsPegcSY/pPcNznUk4krtB8q9NnMU8GvbVfiBYSTzM4Tzjcje8fsi
         QDG/vT0KPcK8ThUVZvgFHhDZF+BHxIwzXvvXCPEjJGeSoZWtsxbNYg6T3Cimfn5eXzJ2
         cykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSuua+KQFUkRQnZw9f4qmHsHpgSqDmm375Cjk5dD/tg=;
        b=bV0WVZR6hhxFhDKTR9/3eqH3aH2L6gNIe04CHQu5wj/1kC5jeqQZKeQE5B6elxejH1
         OkN3Eko9wvM4q0VEITL3QrXp3A26VjbMCJbyhsg26YVq8PC9onhb2aahJqDAXhEdZGg0
         5nXu0lGG/aV1yL0KaZFe0+u66Y6bexvkzUtlLI++HpzMH8ZslexVDvPi4hYq6861ybxV
         zfnNjLV/HS0OMhZLNi6PM8vzfwpT43m5O9MSTXjV7/5+imUO0B5RhaS/2vUkktlLzdLi
         /fd3NV5RqfDsOoN/7oKJgvFHRmtve1M7tYLdkNloIQeZNbw+K4DPdGtMOYd7a0Gq4OOZ
         mLAA==
X-Gm-Message-State: AOAM530kYSp227g15Mm7kBkdPTCINBuGh8Vga2I7z/wYYZjnZM3kkPVn
        Xb9kjnUp8C5ry94ZpB3RcC3Yh73Atk8PcGsfhN4=
X-Google-Smtp-Source: ABdhPJzbJN4nH3rol5IoQwJtIva1nHqf2KozRRo7uMW+7Wmk728PEtcMDEBOkffueJVJ1tvsSgnx4cPaRSmYbZcTHM0=
X-Received: by 2002:a25:da90:: with SMTP id n138mr4805165ybf.260.1600129874642;
 Mon, 14 Sep 2020 17:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200914183615.2038347-1-sdf@google.com> <20200914183615.2038347-6-sdf@google.com>
In-Reply-To: <20200914183615.2038347-6-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 17:31:03 -0700
Message-ID: <CAEf4BzaP6JvbsiTg6sAfGijk0sXkNAdjv0LUmSvQfXoCUKYTTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/5] selftests/bpf: Test load and dump
 metadata with btftool and skel
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:37 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> This is a simple test to check that loading and dumping metadata
> in btftool works, whether or not metadata contents are used by the
> program.
>
> A C test is also added to make sure the skeleton code can read the
> metadata values.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../selftests/bpf/prog_tests/metadata.c       | 141 ++++++++++++++++++
>  .../selftests/bpf/progs/metadata_unused.c     |  15 ++
>  .../selftests/bpf/progs/metadata_used.c       |  15 ++
>  .../selftests/bpf/test_bpftool_metadata.sh    |  82 ++++++++++
>  5 files changed, 255 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
>  create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
>  create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
>  create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh
>

[...]
