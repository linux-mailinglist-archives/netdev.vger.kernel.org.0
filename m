Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1863BC40CB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfJATOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:14:30 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:46051 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJATOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:14:30 -0400
Received: by mail-io1-f42.google.com with SMTP id c25so50841552iot.12;
        Tue, 01 Oct 2019 12:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6kajwKaLuNN6C+oFax54BC30STGZ7zIHG/rv5q+QAok=;
        b=bUffJ8Jd8LGs5tXhNz5TMlz3CqfCU3wKi7KP1KtZ3ZAP29KBzjhKlxCpuMXSVxy9Vs
         LeNMOOSWO2zkYMnee2edytuWdocUuBdCFrGynd0zJA3IONdnWKOQ9Jy7Kr0L+bwKQ4l/
         grxDBYUkM+RP00K7SwbetGdLP7uDd8+LEvtdYkBGvuPiqazqQh2TKUyhBvbMlYOV1Av3
         p/m6hlVWcvqPLcTTxzzNxs2ngOaOWnX0NA0dJIRHP/lGBF1A5d+gFuHkrfxb8qezCjPj
         Chaa4RY8j5Ye7G4viU1WxLJf4sbNUciKEupWTNKyVg+d4CuqII87s1Ouc53kBWM4tn2l
         p5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6kajwKaLuNN6C+oFax54BC30STGZ7zIHG/rv5q+QAok=;
        b=NNGEi3nbaqLyceWlVPpcV/C85hLO8J66lS25gEjPfYImPsxDbjZ9KYhQkCj1PkwodU
         gW0Us2M/RyXKbHWeIV4HsNbJRKGvZn1o20OAujqCgtid1bX/k/HIUkV7xuZA2uXe+47S
         8vXqTkm+y5BkjSl1w8cDej9MZQpTRf/OQS2PkqkwNPBRYZuRlX0QB2aHJkWMCYae+71I
         WUo9OtkEYPei+lfvvzwsgff2I6XyumqnMsTJY4E+SABvzK9nepG4cl3eKL52rBqFprnQ
         ovGfXNvsREJa/oxYBq+MUy7Er5DCNN7wfn8kHHipgzKTGcy+l0D21bDANWI/vL8jU7y6
         378g==
X-Gm-Message-State: APjAAAV6lyAMCHcphrhmKubgrnpSZ9GVlFUkSkmY1sBYZ0IPR9EF97pZ
        A3IcIPS1BL3jvP+EtOT8C1M=
X-Google-Smtp-Source: APXvYqyz+46OBfgsE1Nt+qfsls91PcUPe9hRfS0BqOkpg4ikydRf5gKduBQZI6pDHSwOXpQjvrhp5w==
X-Received: by 2002:a6b:6f02:: with SMTP id k2mr3191345ioc.30.1569957269168;
        Tue, 01 Oct 2019 12:14:29 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y26sm7141813ion.1.2019.10.01.12.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 12:14:28 -0700 (PDT)
Date:   Tue, 01 Oct 2019 12:14:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d93a58be3b5f_85b2b0fc76de5b4e@john-XPS-13-9370.notmuch>
In-Reply-To: <20190930185855.4115372-6-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-6-andriin@fb.com>
Subject: RE: [PATCH bpf-next 5/6] selftests/bpf: adjust CO-RE reloc tests for
 new BPF_CORE_READ macro
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Given introduction of variadic BPF_CORE_READ with slightly different
> syntax and semantics, define CORE_READ, which is a thin wrapper around
> low-level bpf_core_read() macro, which in turn is just a wrapper around
> bpf_probe_read(). BPF_CORE_READ is higher-level variadic macro
> supporting multi-pointer reads and are tested separately.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
>  .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
>  .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
>  .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
>  .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
>  .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
>  .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
>  .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
>  .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
>  9 files changed, 54 insertions(+), 36 deletions(-)
> 

Starting to get many layers of macros here but makes sense here.

Acked-by: John Fastabend <john.fastabend@gmail.com>
