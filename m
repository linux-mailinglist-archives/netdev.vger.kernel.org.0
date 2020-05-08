Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F3D1CB892
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEHTse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHTse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:48:34 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AF8C061A0C;
        Fri,  8 May 2020 12:48:34 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 23so1955487qkf.0;
        Fri, 08 May 2020 12:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10jjvD/YlASvN2EqjhkJYkWw+sETt58oxwg6/IS0Zco=;
        b=Eu/wOr1qR8/kgb3ALSOUzuz7Wgqu4/y52pX3A+weiuQFQ0KN3KPTpVLfiQkJ6dAoCc
         aRl2nMEpUtf1g0viK+tYipT9xZ4kPehuejyT1ReBHzW/hvaI5LMG/kbQvL60vi7+5OQm
         rXp236eCp2bbcSg74XfaA7TRtpPf7rvoYplEQcbyEvl7UPaL+H20ey/d3bS+PScA46Ow
         GUsC1BcPUo4T+upKMmpRzPCpWciJOR5QAoDbZB2h13c0TRneJz+UF0iysqVByuavXkO3
         ciRwWReTrmFp7x1dO83SqWz3fnR6p+Uwl51WBVRaGb/ZtY8DTwEFREaRUrZDzp9/Jqrw
         eYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=10jjvD/YlASvN2EqjhkJYkWw+sETt58oxwg6/IS0Zco=;
        b=e2yLgBlsvp3ov4pQ57gR1h0uK04R4MDV5GnabTQF7rmqt6/HDOJDyep6W4UzIEtnlH
         YwPHnpMP2HwRBvXIs/kC0uoUVmQYXPo0NiOyOm184MkmFoQRaqBLMrNSdg43ykX8vWfl
         T4s8YEzyWGCN2x5hz5I96pf7gpWLuRId7XNbvO5YL/7iSHQ57DP2W6JbKR7pDRxG4X1D
         r+1TtRS67pl+9hV4Rpo2hZ6dSTtRyFm+fkrn18qIhW5TDC603bzxXyxOk9WFDMJLQRRV
         7OTqclcGLhyV6/BRaLjugimiBDKsBSt0Hj+BGTM6wLAdLFfPf67VfkedDQ+nICXaYFfB
         hCvA==
X-Gm-Message-State: AGi0PuZpk41Z1qRnV0uPwEUt8LQ5eLdltXschVZNDwCyBYG1rdCSP3oL
        1AFbdt559GScbQxU/Jc2CijBU/PEhMVX3jFDHm8=
X-Google-Smtp-Source: APiQypIDrCpyg2ZkNZABDYF/GHFovsJXdKlsIaw/Z6t5+p3SbrQIPpldtP1p9PZ2CVyeAOnk3BH4TAO1nROBj00jjB4=
X-Received: by 2002:a37:68f:: with SMTP id 137mr4521257qkg.36.1588967313502;
 Fri, 08 May 2020 12:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053935.1545181-1-yhs@fb.com>
In-Reply-To: <20200507053935.1545181-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:48:22 -0700
Message-ID: <CAEf4BzYP4BDMLRkGDRKukq7-P4SKdJpx6gGfw4mPUQcQ77Ts+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 17/21] tools/libpf: add offsetof/container_of
 macro in bpf_helpers.h
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
> These two helpers will be used later in bpf_iter bpf program
> bpf_iter_netlink.c. Put them in bpf_helpers.h since they could
> be useful in other cases.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Not sure #ifndef/#endif guards are needed, but won't hurt either.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>

[...]
