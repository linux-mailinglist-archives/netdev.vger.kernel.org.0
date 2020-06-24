Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A375C207F47
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389122AbgFXWYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbgFXWYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 18:24:07 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C04C061573;
        Wed, 24 Jun 2020 15:24:06 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x18so3609808ilp.1;
        Wed, 24 Jun 2020 15:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XizXk/rIjA4/OAmJT1uOxFYKdrsnWWaaSfnW9C/glhw=;
        b=FEI12gvcdheEM1J7794lpIXYN1eDVBS7JCQm5F8ZMb1ylGZIr8KpklKNRXWGSl33BB
         mKLIAKLsYGGDJNdP5XR0/pmY2iMky+8F2ed9S2Gdpy+tlh2RsmepzloAGQarPQARWgLq
         kDrzbeTkc23bNZoqf9Czzc/prpjfWCB43td3urRBonfg5JmHm1mstV7nJb5iLbMfgeI7
         sNFTqAWMWoSO+KhTPqqD/79dfWM1SOhPUqmyCXxoY9v+bhoSaWtj/g2b3SvtBTZV9G04
         Qz/83cvzHOK9SOMvUlfActGprvxX/L661UQK2hp5SsEu8kagJi5lLlRKp2sHw0QKyK07
         I5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XizXk/rIjA4/OAmJT1uOxFYKdrsnWWaaSfnW9C/glhw=;
        b=rcuMp9G3Eiw9CgMaEEXbXe6vN9hHBrOHId3PiIeQlgDbYOp23i3YcOrCO8zYQ95Gru
         VK02pFYBZ3O5kkaj3kRJC7rwppAYS0MEKt9xanpirHrEyqyHENDy4EbEPn7q8GurdXAu
         7++O6HuAwssXUOoQAIblD8seedVgDdiigC4wEuoFNh0JiRlJaA5F1GSC6++poVPlhZGm
         zUOnccDsWOpmJmjq9/9bxwy2h4hDsc+SA65qCHymLyLyqSx/IsTSOd5fmI7YFdBGeJ7h
         lihxAhgFhb8YhXaGx0+b6XuLdeE+pVSY//EOobUVEn30yvIaGNmSKeykxLZwG6htLvBj
         owQA==
X-Gm-Message-State: AOAM532iqYemXbImpQI4yjyb8sz//fG/UgsqTd9XBM8k1eMXpcBO1tgW
        3d5T0CzcGCU1a55ZQqRjc8yELOIuUf8=
X-Google-Smtp-Source: ABdhPJwEQ3JMLwH7aM2EbAgU5iyvE4fJm1OeuBO1yUuMxygU4w9uYJWtneu0103wC5plGzpibRKcNw==
X-Received: by 2002:a05:6e02:cd:: with SMTP id r13mr24675613ilq.119.1593037445874;
        Wed, 24 Jun 2020 15:24:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t1sm12309700iob.16.2020.06.24.15.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 15:24:05 -0700 (PDT)
Date:   Wed, 24 Jun 2020 15:23:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5ef3d27e224bd_7c272b1cd50b45c474@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzYZBoffuYUfssw+wBgz2SQx9E=AAP0VvOQDMc3Y3y1zLA@mail.gmail.com>
References: <159293239241.32225.12338844121877017327.stgit@john-Precision-5820-Tower>
 <CAEf4BzYZBoffuYUfssw+wBgz2SQx9E=AAP0VvOQDMc3Y3y1zLA@mail.gmail.com>
Subject: Re: [bpf PATCH] bpf: do not allow btf_ctx_access with __int128 types
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 10:14 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > To ensure btf_ctx_access() is safe the verifier checks that the BTF
> > arg type is an int, enum, or pointer. When the function does the
> > BTF arg lookup it uses the calculation 'arg = off / 8'  using the
> > fact that registers are 8B. This requires that the first arg is
> > in the first reg, the second in the second, and so on. However,
> > for __int128 the arg will consume two registers by default LLVM
> > implementation. So this will cause the arg layout assumed by the
> > 'arg = off / 8' calculation to be incorrect.
> >
> > Because __int128 is uncommon this patch applies the easiest fix and
> > will force int types to be sizeof(u64) or smaller so that they will
> > fit in a single register.
> >
> > Fixes: 9e15db66136a1 ("bpf: Implement accurate raw_tp context access via BTF")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> 
> "small int" for u64 looks funny, but naming is hard :)
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 

Fixed up the parens and sent a v2 keeping the ACK. I don't have any
better ideas for the name, let me know if you have a preference for
something else.
