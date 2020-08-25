Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB3925105B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 06:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgHYESY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 00:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgHYESV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 00:18:21 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C405C061574;
        Mon, 24 Aug 2020 21:18:20 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 185so12189541ljj.7;
        Mon, 24 Aug 2020 21:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5mPaHH2PuKFaG+DsDPxNn1hi/jMyz7zQ1ATDz5LlUY=;
        b=obYSzHARSUmMwzXUFljXoAavEgNQJTmWEd/8Z4hDSivBzo1bCCXq5YaEPgQPIV4oUK
         TtFPn1GR8+0wjOuOjnLDhQ6QUL4DFfDE6/AJJlyBPoaQE/p0l2h4CzdBOGRnBVSsLi7A
         1NZ8zaAFpEk/OSg7Z73HEIZL2rqTl+jvjkYtAeZ8NoduynpjlHZuc889c/a0Bi/J8v0s
         m5M72UYRNz56fte7tyrYbySxFRt9oAUfqmlQKqKRK9xUqa6Z90W8U6sMDJuaBpUrEhdK
         VbK8ph7DcwuhFXYZzcq41QsIIdRkR8DLYb4EALTi/maerBqV4LQC0oEr9koZteziLJ8I
         zTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5mPaHH2PuKFaG+DsDPxNn1hi/jMyz7zQ1ATDz5LlUY=;
        b=Zlz1FxDp+/XK1jXOIko+6sAgCmsLnXGx6SpqcGtsxSh9ZlwZSkXFN7n/0XCqbEbaOH
         f6/9kAleByhksqlXYENjwIcEu8PuPs34uaYvuyN2qJ8zHP3vsEWVo4J5jdjRGq6p8T4P
         uAZZcPm/+/ZKUgM/4cWe2DzJ19iEygMa4nNrtH1SiQWahn5j373WYvxVy7MhhqA/XQsq
         ti/f3MBXfT+1dyBcWIfVX83LEkrBErXAewqUKaslcVolkPMxOB+cfKsV4nrrBI6kHgJN
         STTm06o4/re5SS9yIGYRpCVSqke3WQ1eu2mk/azggHbPYwYfZA9CzloC0Zdbk9U34dt3
         8QTw==
X-Gm-Message-State: AOAM532Ma+WL5ixkUVOMmsYYI0G6t5FZF6oXM6vdLVF1qKRWC11tC3Sr
        kjC5KyM3yni/1hwwwpKY+ZrQYP2Xswth4sfVC0k=
X-Google-Smtp-Source: ABdhPJxwO6s0xlnIEf7ZvvAYvo1qowjVya0Jm0o+FeH5PmJyePnaE0qBF+oNNLyeuNJOHsrVIeLBY5ZxM3wMHbcvG/k=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr3694367ljk.290.1598329098641;
 Mon, 24 Aug 2020 21:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200824222807.100200-1-yhs@fb.com>
In-Reply-To: <20200824222807.100200-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 21:18:07 -0700
Message-ID: <CAADnVQ+jES5ho+wGWr3eLrGvnLC5AvNKYjmR-QvvyFmQj1ZJaw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: enable tc verbose mode for test_sk_assign
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 3:28 PM Yonghong Song <yhs@fb.com> wrote:
>
> Currently test_sk_assign failed verifier with llvm11/llvm12.
> During debugging, I found the default verifier output is
> truncated like below
>   Verifier analysis:
>
>   Skipped 2200 bytes, use 'verb' option for the full verbose log.
>   [...]
>   off=23,r=34,imm=0) R5=inv0 R6=ctx(id=0,off=0,imm=0) R7=pkt(id=0,off=0,r=34,imm=0) R10=fp0
>   80: (0f) r7 += r2
>   last_idx 80 first_idx 21
>   regs=4 stack=0 before 78: (16) if w3 == 0x11 goto pc+1
> when I am using "./test_progs -vv -t assign".
>
> The reason is tc verbose mode is not enabled.
>
> This patched enabled tc verbose mode and the output looks like below
>   Verifier analysis:
>
>   0: (bf) r6 = r1
>   1: (b4) w0 = 2
>   2: (61) r1 = *(u32 *)(r6 +80)
>   3: (61) r7 = *(u32 *)(r6 +76)
>   4: (bf) r2 = r7
>   5: (07) r2 += 14
>   6: (2d) if r2 > r1 goto pc+61
>    R0_w=inv2 R1_w=pkt_end(id=0,off=0,imm=0) R2_w=pkt(id=0,off=14,r=14,imm=0)
>   ...
>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
