Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185DE178602
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgCCW4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:56:25 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34973 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgCCW4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 17:56:25 -0500
Received: by mail-ot1-f66.google.com with SMTP id v10so132648otp.2;
        Tue, 03 Mar 2020 14:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VcHCJYAxdRbM/KzIXhD4pmR6h8QT2ko7xv65doL2hDg=;
        b=OCRnPt6vgWTUFeLm7sG6zoo48/woBzbP0wCbTtmC+ptNUzHuhm3drTgTONA3MbfgM9
         hC4ZMqeOeruG5d99vjzxdqdyM6ZJpyvRA5FWOp25MOudCIKmKYtfP9rTEmp09gslFwog
         oAxDARw8mAYcl225JUP8noGDPGtINFF0YG6cSuLPuz5p7zIQtqxqyC9vdhLrH5TgWlZ+
         SqPogCX9aTeLHHarZEiWoyWdIzr3lwQHG7gHZWfkAhCOBCTWmJuJETUpk2JEXZphc0Fa
         m8xir0ku73QDjpFuCyf0adxQqzbrM2QCS68/ob2IjoBFH3DjZkWI+vaX2X9PT1WAFmHB
         s8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VcHCJYAxdRbM/KzIXhD4pmR6h8QT2ko7xv65doL2hDg=;
        b=OiLo+UVHAH9MxtX/Vkv9oQQF9FQCwGmzL6sifxzTkKMUGH2L6tQXgRcLjR0eICJy1h
         XyMKBrNMO3aOkuOYLzoVQ0xFumGeJR/LgM0CL/il4E5mH0cfnT1C0KDdpuVF0xYpuTU9
         kReuOPdo9dyJPFXBHJOHPKxxkAFZOGK7yauT+PDbKP4TtHLKKhbVuZuiktdKKyJU+sb9
         r1noL6A8Qk0OkH4wvct1R62BflVT7s1L/gCF84pHY/VsIGaRwPnrQHX2ATOeDU0ye225
         2E8RN5aemeM+rfrpdM/OWyusyDlpxttE6UKC//dtmMTUV2QEGdoFvUFak/2j684W2YVU
         8aTg==
X-Gm-Message-State: ANhLgQ3uPnW/cBEJi0odb50eUUeRbn+vdueMLTG4x8H2+sZthqQZDdA6
        ycvmWO2i8r7XWYLhIzWad9GC7j5v0mzDvkImDXs=
X-Google-Smtp-Source: ADFU+vuAj0zcOjq0lv5DatSOt7psVjk732AxPPwptMlNw9YoK01BGCfj/DLza5AEJIAEaVqmGhVtiyrx+zscGvuN3bM=
X-Received: by 2002:a9d:7ccd:: with SMTP id r13mr156550otn.80.1583276184666;
 Tue, 03 Mar 2020 14:56:24 -0800 (PST)
MIME-Version: 1.0
References: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Tue, 3 Mar 2020 14:56:13 -0800
Message-ID: <CAGdtWsSd8sDoxTfW_Jcwc9u4sfHECKMzxt_GNjMTkWCbvKBr0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] add gso_size to __sk_buff
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the series: Acked-by: Petar Penkov <ppenkov@google.com>

On Tue, Mar 3, 2020 at 1:46 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> See first patch for details.
>
> Patch split across three parts { kernel feature, uapi header, tools }
> following the custom for such __sk_buff changes.
>
> Willem de Bruijn (3):
>   bpf: add gso_size to __sk_buff
>   bpf: Sync uapi bpf.h to tools/
>   selftests/bpf: test new __sk_buff field gso_size
>
>  include/uapi/linux/bpf.h                      |  1 +
>  net/bpf/test_run.c                            |  7 +++
>  net/core/filter.c                             | 44 +++++++++++------
>  tools/include/uapi/linux/bpf.h                |  1 +
>  .../selftests/bpf/prog_tests/skb_ctx.c        |  1 +
>  .../selftests/bpf/progs/test_skb_ctx.c        |  2 +
>  .../testing/selftests/bpf/verifier/ctx_skb.c  | 47 +++++++++++++++++++
>  7 files changed, 89 insertions(+), 14 deletions(-)
>
> --
> 2.25.0.265.gbab2e86ba0-goog
>
