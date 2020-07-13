Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB10421E327
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGMWnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGMWnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:43:18 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33109C061755;
        Mon, 13 Jul 2020 15:43:18 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id o4so10147642lfi.7;
        Mon, 13 Jul 2020 15:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mXBHeeYbnyYnZoImg9lxJETKMT9BDtD3SLBQDkwKpUg=;
        b=NS1sJFWMit7btLIextnomhwfsgvvCcoEI3bba4FYWzuqeQgAFhHeZ47giKEbA6zGD+
         hV7v1wS/PljTvy9d48Zv0jeLe80MREPAbd6wQ30FGmKYHuee+M1lakFsKRfOqEh70THc
         jM+WA9cok/IHAw5EHn2/k9CNJO7lWFCjwFkK8/6cRiK8YmPCUCseqnZsWZVdWEZT+cX1
         Zq8Hip49UCvPJOWbMEAG4DHlZ8o0RzaLawe+jtX0SkPeS/IQys7OsKxvTbazJGjUY1Hu
         3s2btJOcXZ+dU4qEXhy+IhfiNPHy5A9Qaa2+LtJaPD6b+yDwXxsAAUPej0H/iU5TcYHV
         uRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mXBHeeYbnyYnZoImg9lxJETKMT9BDtD3SLBQDkwKpUg=;
        b=OySjHJaapc0Kw9VMfeR5rQTv3bkaAtdxz8Hf5WofjX2W6eSY5SodQSVgqYt5XdHpOx
         HKyX336xBdof2DZ41qtSvMq715LCbMLWTLt+pBvjCWWD030CRLAMBuzEnwHcrIRCc93J
         7tVcfzMRRHVc3a963UpZfD2GTBgIxELsMiH82+QMxNxXVeBrmgeGBYKhq91SqOFKyv9F
         R0ag9rUbiddtw9H9R/0KeKSQlqrdurE2pRtfuNgckbQR3gQmqMCqnUXWMwmrfufHIwQ6
         ydhEyy0r/4/HzWEfyBOd6QLWWKcu7w3fDUhU04Om1BIMHegnuv3TXogqTxmNNtkp9Gax
         Cdwg==
X-Gm-Message-State: AOAM530Mr4WyAK8jKzwRidT3a2ddy6M3CLm1DF13nPbZF7aRLq+cVGX2
        ybuBY0hsKcth2qjTEiGR4nIdT3Q8tOYVFOZfr/9vrA==
X-Google-Smtp-Source: ABdhPJxGwBpHHxf7US3jV7gyU20uWm4nZjl+J49kuJJSFwBwY3r30p+7aQ9GRrrL7T7IP1flfFxs32Xz2Ope2dstqMM=
X-Received: by 2002:a19:815:: with SMTP id 21mr612446lfi.119.1594680196712;
 Mon, 13 Jul 2020 15:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200710232605.20918-1-andriin@fb.com> <49d46a96-ad92-90dd-9723-893bd1e5a7bc@fb.com>
In-Reply-To: <49d46a96-ad92-90dd-9723-893bd1e5a7bc@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jul 2020 15:43:05 -0700
Message-ID: <CAADnVQ+rHWYq9nQT9S=6h3w7RMdF=tnGg0WBy55UFrHRvJsOzQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/bpftool: remove warning about PID iterator support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:10 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/10/20 4:26 PM, Andrii Nakryiko wrote:
> > Don't emit warning that bpftool was built without PID iterator support. This
> > error garbles JSON output of otherwise perfectly valid show commands.
> >
> > Reported-by: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Thanks for the fix.
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
