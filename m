Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0B8DE17
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 21:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfHNTxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 15:53:04 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42511 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNTxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 15:53:03 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so7686qkm.9;
        Wed, 14 Aug 2019 12:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwVzsiDfePC0SBZqim8AH59LR3WNBLqRTjVAYe72Yc0=;
        b=cSTwPyvrn7ZoSXdeWlgGCVOXlMRHJGkHdce8Z2LQ2sME+q8hG6gEEMmnL3QpX07BhQ
         qpqVpza68MWAgS4YCFZlbQw3VDm8NXAFw+67JYBk5qtsE4oq4YFl3jWRE7jrljoltBEr
         85xeJ94YvNcm3ADDUCdedCMxLfqy1spS7hbZRh1sg7ULZoU7CnV4FilntJbTvZS/AXRw
         UBymwByKMn78ylZZQl31NlhR6p9/zIr6tuXjDQhwwZ6X8sn+HvvRbQlDA9bg2x2Gb2pA
         APKG/wujVCDBuMvlAIt3MPwxtvnUIgiBBfgZGykmdfnzOx8MFYSYXiRGKu59TEDS0o6t
         Gbjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwVzsiDfePC0SBZqim8AH59LR3WNBLqRTjVAYe72Yc0=;
        b=fujdFvDJwbxsYTi6tMV5r1/trc7/2fWrO55TE4s48kRT1/szrSvrQ80D7VwoC+7QP+
         6Q2u/+XCT+yiUGpVqVqYllXJ1Ixb5TLHMTyiuYFM7BKyHydtfpZjXWn8UAfF7UNzsYgc
         5kRZ5UirQBNr8fD4aNHMpJdJcqygSVqX0F3t5+rOFDqWh1e/xxjYNf0TZoq6GJsK0cy+
         Qi3dn0K9i+Z9QPdqlVmhJdqNmBqnAwM8q/jSZ41rdsEd1qVJ11hclQxhBRPbT0cRIV3T
         QskbskhuhJB30NWTxh85pslpzEq16oxNVcGzd1r5uos09HQ8J1PhlLfZXtiVMTXBjwme
         QWyA==
X-Gm-Message-State: APjAAAVhdUa25lwWevVQvTGvMF31jSMveusM3Dfc2Oh8sIt5QpQ79VNa
        rYXC1kIkse/IcDOGjjp9gvRuQjmxVjT9rGO3qqc=
X-Google-Smtp-Source: APXvYqxda1rNThSRCWYHRCdMrc0vndDo4KD2PkGIAC5Y1nVAXr6YEtcu6bmevdZLlFGyg53fNs9cPqbRb0MIMAozISs=
X-Received: by 2002:a37:6c82:: with SMTP id h124mr1061699qkc.92.1565812382691;
 Wed, 14 Aug 2019 12:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-5-sdf@google.com>
In-Reply-To: <20190814164742.208909-5-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Aug 2019 12:52:51 -0700
Message-ID: <CAEf4BzbUGiUZBWkTWe2=LfhkXYhQGndN9gR6VTZwfV3eytstUw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: test_progs: remove asserts
 from subtests
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 9:48 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Otherwise they can bring the whole process down.
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

This is probably why you added all that extra logging in __test__fail(), right?

So had a low-priority TODO item to add another CHECK()-like macro that
would only report failure (but won't bump/log success). Seems like
this is something that would be useful for these asserts?

What do you think about either QCHECK() (for "quiet" check) or surely
we can also do ASSERT (but it's less obvious that it won't log success
and it's also not obvious that it won't actually terminate test
immediately).

Then inside that QCHECK() you can log file:line number, similar to
CHECK(), but only for failure case.

Thoughts?
