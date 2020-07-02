Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72615211B2F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgGBEjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgGBEjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:39:15 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B313C08C5C1;
        Wed,  1 Jul 2020 21:39:15 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id e3so5765902qvo.10;
        Wed, 01 Jul 2020 21:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63lHvV5v06+ee/YlEcaJZO+H3OUy+LvHS3G6QAJErzM=;
        b=SSc7lGBBZ0ZPz1ePXH599iguI7uWVhIOyEt4jqWggs5zMEHOSsPc5bhe807c5mcPDb
         7KOuH1LzXiBwkjQ2y8XL7U7iGwTr4HDEhX22X3DyZ5EqD+dLJ/C8Aii2bh7VdiA5zA44
         c7UIYK5KZ00ZezSStaNosOjQtgn2oQlBp9g9qvk0NB/fahMw2Yuyt1rnnl7z3+d8+TCw
         ZKElx/sv4KFFfOVHV4Fl8bXT5m57KAr250jwfREmc6M03zl2YwSBL3y1bLw6Qn/CIppA
         v5xJAwvfCWwFgM/7kuWd3nCAOIjW118DIB4/EkXTXS+w8dwWYpZhcZg+TztRMqa05+Eb
         pHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63lHvV5v06+ee/YlEcaJZO+H3OUy+LvHS3G6QAJErzM=;
        b=mCIWnB6zgzHzhMo1xds4Kc0O2PWqszcymWFCVpkZaorpTD9qObd7NEgnkoQNwaU07a
         JpA2uOAF5fFPR3wPE40urob6Yjs+MuJeP/5Dcooay2dIKWvNN85fhKXBznrKyqD69x33
         jbmV4nDOwpnLb0wZ5O+fbfSzvUahxwNzDQaqoadMGFMkT4Uxq+DaAzw2Dg2f8EAsURI1
         /9CkTs9K8TTr93nC1ljUDgmzupYqKXLN8wPN5A69Ox5kY3P3Hs00FsCRueyuJEuod4Ft
         rnbsK1t8s0iqPSr56S2ZqHQh7MeBEjEpvmFJRr/4kMmoO2v6LbhbHqsSLwZ4+8rKw9Cn
         LmNQ==
X-Gm-Message-State: AOAM531fOW7sTXF2ti5XCEHRhfgfIMfI6IbuZ9O6s3fHvEPEZX5y3OyZ
        1BXo3ZzBb0K2wIWLJHqwbaE3C1IMSRXJeRdS8sI=
X-Google-Smtp-Source: ABdhPJxNOVrAHtIQP3qGUUABHu0aIgkGjldw9kp2xiyYC0rHjZ8ZeZVl+CqNR59wx/NC9exKT9S6dVzXwf9LWt3X7qY=
X-Received: by 2002:a05:6214:946:: with SMTP id dn6mr18055666qvb.224.1593664754402;
 Wed, 01 Jul 2020 21:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com> <20200702021646.90347-5-danieltimlee@gmail.com>
In-Reply-To: <20200702021646.90347-5-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Jul 2020 21:39:03 -0700
Message-ID: <CAEf4BzY5HD59+a1vELqBmGJu3vVVGiNC7Ren7To6BL8_roxQfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests: bpf: remove unused
 bpf_map_def_legacy struct
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 7:18 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> samples/bpf no longer use bpf_map_def_legacy and instead use the
> libbpf's bpf_map_def or new BTF-defined MAP format. This commit removes
> unused bpf_map_def_legacy struct from selftests/bpf/bpf_legacy.h.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Great, long time coming! Thank you! Some day entire bpf_load.{c,h}
will also be gone :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/bpf_legacy.h | 14 --------------
>  1 file changed, 14 deletions(-)
>

[...]
