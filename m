Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E1166312
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbfGLAue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:50:34 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35623 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLAue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:50:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so5225618qke.2;
        Thu, 11 Jul 2019 17:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tURlN5ZKmeKKHilH+hdBJmpFEbLfg/7gatKX2lCmdHw=;
        b=hZzi1FuDdGuYZJGTEaQOBxp+xqZ4x/tH1lBmc6RrpRj1oPnhqJ7m5+mNnjuHoM8vaM
         nLUd71Xv65Afy4ym7NLLH0ccSRfE8hKUN9QIuYfxc1C7tqZcnjW++D09dmGmlA1d7Zls
         KhxsaxWtlJGJTyegmtxZ1fO+lNOV6dJQimewSAZkW3DnW66ojvtFL1Ri2YbSHIWrYAuE
         b43RJK1S0wPhgRefnAHai7OBs4qbxHIOymlwMsBlIyeM9FTsPS2uMiNMYDkvWWJp15fU
         AVgWR15rNcWtACrjf31FoVq3Q3k7Kx5ndUi6SHY3t5LFwkOGEfDB+WXXUXCIU36OEy4b
         vDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tURlN5ZKmeKKHilH+hdBJmpFEbLfg/7gatKX2lCmdHw=;
        b=PEOe4DU4w/IMP6UwQN3vtWfjYSJXLoN/ZLMYUYIZrh9M9/iTcrEo6hjrh0E5SzkhLU
         53oe2F39AbNwfwg1KTPw/EbQHrGDpP9jY9GQwNcNhGqIImALeBzkWVy3t7EV3Y48wGqG
         pef+4v6e2+0z7cNfh/JGcPJWdIETQTZTL8X+qU9m2ONJvSmrNeIyFXxzfLiPoTsLJ9Vt
         8PY8qrpw/6vMhlPnSxjvA+IAap4dAP2Kj6Sypyt4GjlKl9UhdPTYT/GmdfbMZn+ZWYx1
         bQptEtSSXiAKTz9bTW3BdLi/K99ZwLEGP2A+4HcN/EB5n7+gYhN0jNozPdMubNX7LAKo
         bGDg==
X-Gm-Message-State: APjAAAXBFNQyFve+ljIQb+akiAChL49IiW3ZKU3FWhFJ/zk3S0ZI7uSY
        qi4LnQFQl59nBXSiabwrkghGEL/0jMQ8iM1j2nUFXmAOfkK/PQ==
X-Google-Smtp-Source: APXvYqyRHs8YP1IyeOa2+am7u3tGa6mq2Np6BBp2omZVlxwYYBzmPK1HV7iO8x83mSkgRZdehLtL7vl6uZ3A4zWcdL4=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr4330761qke.449.1562892633146;
 Thu, 11 Jul 2019 17:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190711142930.68809-1-iii@linux.ibm.com> <20190711142930.68809-3-iii@linux.ibm.com>
In-Reply-To: <20190711142930.68809-3-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:50:22 -0700
Message-ID: <CAEf4BzY4HG3TTTS=qNHLcr5oCT7uy4T_nb+h8RrcG-AMwD-RjA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] selftests/bpf: fix s930 -> s390 typo
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 7:31 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Also check for __s390__ instead of __s390x__, just in case bpf_helpers.h
> is ever used by 32-bit userspace.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/bpf_helpers.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 5a3d92c8bec8..73071a94769a 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -315,8 +315,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #if defined(__TARGET_ARCH_x86)
>         #define bpf_target_x86
>         #define bpf_target_defined
> -#elif defined(__TARGET_ARCH_s930x)
> -       #define bpf_target_s930x
> +#elif defined(__TARGET_ARCH_s390)
> +       #define bpf_target_s390
>         #define bpf_target_defined
>  #elif defined(__TARGET_ARCH_arm)
>         #define bpf_target_arm
> @@ -341,8 +341,8 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #ifndef bpf_target_defined
>  #if defined(__x86_64__)
>         #define bpf_target_x86
> -#elif defined(__s390x__)
> -       #define bpf_target_s930x
> +#elif defined(__s390__)
> +       #define bpf_target_s390
>  #elif defined(__arm__)
>         #define bpf_target_arm
>  #elif defined(__aarch64__)
> @@ -369,7 +369,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #define PT_REGS_SP(x) ((x)->sp)
>  #define PT_REGS_IP(x) ((x)->ip)
>
> -#elif defined(bpf_target_s390x)
> +#elif defined(bpf_target_s390)
>
>  #define PT_REGS_PARM1(x) ((x)->gprs[2])
>  #define PT_REGS_PARM2(x) ((x)->gprs[3])
> --
> 2.21.0
>
