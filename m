Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F94CC2A13
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfI3WzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:55:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43181 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3WzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:55:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id c3so19174784qtv.10;
        Mon, 30 Sep 2019 15:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zmi3R4LtZmokgmaswrhYl+DvlDbr3EfDsUv5GQDTZNk=;
        b=qpVVbEHzWaQQRBi3xvW7PP0lbQAl+J7qrEWC5TCSG9qAiw2x7o/evNOL8XhxBldlCM
         1sDpzwPqTMmvTZXTgO3wtTqfaUZPU6T9QIEb/P532giUVdOxRkTOnOL7bAYSSQqJCDKI
         gXC9LOq7H6e25WJrwE7yVYOiSJuPttOtSR+2MkzOPkp6dpWpcmWSAIet4SIXzkdmWBNR
         fQ6bwqP337LmjceKnY/jxV45ubflCNROIOGTzZkaKagFG+rLfGnM1ZGX579deLDwjhSZ
         APEYADCegO3Rcf2tCf8qnNGYERucSwKM+XmlNVUk1N4RBaMqOQUbLZvLFeBCD78xqLiE
         MqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zmi3R4LtZmokgmaswrhYl+DvlDbr3EfDsUv5GQDTZNk=;
        b=kvzLEDOejrxk5geKrQMaHTmsi8gTVWzcpCgkvjHVf43+ZV2kYRXJ/+kMbZvNh9KpII
         h/RXjARR0kLDCHYEVQOYhYic4zJILyw+zh94etrP4c9rdzPqaoeIz47Fsaz07RsBYW58
         JowRx03MQ8l9Q18ZLoZtv+bw3kU91HXxiheiC9rDQc/LY9JEvOiMchd3Xl0pjST02RtX
         2Emctg5XGJOcewUpZ2BD8Hf4gqlPbS8lI2YZbd+Qx98anY0emHaL94ynSpLWawlzotdl
         Bp8iabghX4Lih9s0D4yKXY9T9cK9u3vJkMTEFwY+9CtmJpbFi486XZFdU/V7VWnS/EFE
         5Y9A==
X-Gm-Message-State: APjAAAULJaH7J9qKTCxjLgLmq6NdANVxNwIxj/6nenAtg/gJa6RWsi3M
        ix4A9wVKflEKUpPB4k2cZOtmzOCjlRXjDk1dze4=
X-Google-Smtp-Source: APXvYqyfrITsybpMlqrdqCzYR0P5kgOXrzK7kL4P7X8gksJgIzA54R2i41INMe6XceIoiJ7yZaaB9vfP5R82g1SfOf8=
X-Received: by 2002:ac8:4704:: with SMTP id f4mr27311973qtp.183.1569884122170;
 Mon, 30 Sep 2019 15:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
In-Reply-To: <20190930185855.4115372-3-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 30 Sep 2019 15:55:11 -0700
Message-ID: <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> are installed along the other libbpf headers.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
many +++ and ---?

Thanks,
Song
