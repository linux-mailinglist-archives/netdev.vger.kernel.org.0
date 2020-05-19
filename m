Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6F01D8EFD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgESFFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgESFFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:05:38 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543BDC061A0C;
        Mon, 18 May 2020 22:05:38 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id dh1so2036061qvb.13;
        Mon, 18 May 2020 22:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yDIXis3wbkJOg1KRwZF9BfQWPxxvnCIt3YICN+Tloc=;
        b=T2bgposN6yp77EV+tj0tSkhQHMJ0uajHcFzSh3DlYG7YwiHidrBf9HuxdywXLCHwMu
         wj24KCW20oQd1hbG/FGfYTqwBlyTl9n2la6VU6dD9epueYCnN7SKqRrRbbWKA82JRNXP
         Bw0fU98mHEdXrzSRWsmxo4ck6plAtATjQzJ++jpVsu1Tk1yFF/1vIYWtDaZilZbn2sNg
         nG5JR08QqDVdyl0ljIIEUDpT8VjYgkJMbEIor7AE6k9PlEvaG1x14K4QCAh5T7ju+sYE
         HuIajD0ds513L93V2SyGxTwDd+MlXT8KrbX+c0DKqqBMEc4EZwDRTUKOc3TVqtbvALmS
         fNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yDIXis3wbkJOg1KRwZF9BfQWPxxvnCIt3YICN+Tloc=;
        b=BLpX6XkSs8AFSE4/r5x5wlsbLO0UMBQs+mrnVdYMfqrj34M97eochtm86lCDciLUU5
         nEaN0M8dvR71jIzw9C+ulw9he5HDXe8ylgVj8C3FcQbQdUXjchTRucjt0ugaBnD3pKaf
         dgTTvW0MN04yDIdiRPc7UkKsSs1b3rr01LoODwMYSyECVjzmGgx3YLefVRu9Lk/FFS6M
         D3ld5gmxskD5NlJxl7I8GTMutHnswIyDf4Z666BsBZNFpQ7/VKJaW9x2RZm106/crzwO
         II5EHhoADj0wM+j1bVFFup2rpdorYv/rFvH5ls1AqW7aIQUHLHOUN/Tv0qLNBkRDdOd/
         TA0g==
X-Gm-Message-State: AOAM531JoyJsBSY8H12wayLjl5mHKc2pjIyuKkVMP+xSCh9ddfRqTpM/
        5T2uH+SoW+Ih3Hmz+JO5lciEVPwpgi+E3py5S0c=
X-Google-Smtp-Source: ABdhPJxzpl67HAjZ7skxeee2ZBZRGfGse/tHBzq3yiLHsNdcWLK1Azcumzbm79SjcOIbr3d9JUH0cOKhIT3wqXdmHCU=
X-Received: by 2002:ad4:55ea:: with SMTP id bu10mr20245785qvb.163.1589864737596;
 Mon, 18 May 2020 22:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
 <158983217236.6512.3045049444791726995.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983217236.6512.3045049444791726995.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 22:05:26 -0700
Message-ID: <CAEf4BzZKC5B-Nas-o_TPgJWvbwbcXUZ_aeH1-CPgPf0QAZN_KA@mail.gmail.com>
Subject: Re: [bpf-next PATCH 2/4] bpf: selftests, verifier case for non null
 pointer check branch taken
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 1:06 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> When we have pointer type that is known to be non-null we only follow
> the non-null branch. This adds tests to cover this case for reference
> tracking.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  .../testing/selftests/bpf/verifier/ref_tracking.c  |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
> index 604b461..d8f7c04 100644
> --- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
> +++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
> @@ -821,3 +821,19 @@
>         .result = REJECT,
>         .errstr = "invalid mem access",
>  },
> +{
> +       "reference tracking: branch tracking valid pointer null comparison",
> +       .insns = {
> +       BPF_SK_LOOKUP(sk_lookup_tcp),
> +       BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> +       BPF_MOV64_IMM(BPF_REG_3, 1),
> +       BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 0, 1),
> +       BPF_MOV64_IMM(BPF_REG_3, 0),
> +       BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 2),
> +       BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
> +       BPF_EMIT_CALL(BPF_FUNC_sk_release),
> +       BPF_EXIT_INSN(),
> +       },
> +       .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> +       .result = ACCEPT,
> +},

Can you please add another test where you test against non-zero value
to verify that both branches are considered to be taken and verifier
actually complaints that sk_release happens only in one of branches.

>
