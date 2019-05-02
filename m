Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8391912318
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfEBUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:20:04 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35129 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBUUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:20:04 -0400
Received: by mail-it1-f196.google.com with SMTP id l140so5715742itb.0;
        Thu, 02 May 2019 13:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8rF3Gnx4uVH4vT8m+J/MHBp1IFdWlP4V/lANQLuXU0M=;
        b=RQFE7+4k4M8+wYI1I36VEomE+70DTGRCY2e78zXFq+B81n8sxAx18GFz4GgO3NFQ+f
         i5iUxn5WZnAVv3I8mWshGlNK4Splcr+bnc3szwrTNDtJPBH/b516CnUzhWQHvx/Mf8cv
         O5vwO52jV1tooZc1iA3sstlBaC0ewt4gencAIKc6YQCCDuKGq2WCj8/BRCWk6+2uK8LN
         ANSRHfV6GkaVz9KgknChBTqdcClODdr0xlboTb577IwkYThRF66gwS7joZ1F2LQv/AQP
         nmk5OQroaFZPYylRTUjRZmqf/p4XXbEp0phxn47UeGk9Da1TMNLRMxReL1JbqyNLJSXf
         FF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8rF3Gnx4uVH4vT8m+J/MHBp1IFdWlP4V/lANQLuXU0M=;
        b=lVRphhDY9Y/3HaHE/CHavsLWtRtEgl+zfhqPX5VPXL7OssD5wgdTFDZi1ZiSL8LRwZ
         yn/BOkCG1Hb4DUe9sAQO1Ky42jqLTrA8lH134YLJh4ynu56AAc94zTq3VSsRaGb8vRkH
         Sxys9W4kZNwPcdAvio5Z/Ng3RpAykjZjIpV8eNpzOIREYYldR0U2FqTDdQiFA1uYXMAr
         m32s3c0lJp+XEntjK64APRcI0FvKNRl1aVPnOT2pru827Y6m4fOtPfK0RxwlT+YI7CTy
         LT/xRyIaBTiiBSfPHuyOwHtziqoOfORQfEYqvn7JIaW/vvSr+Uwx7hoqVFHRTNeNGii0
         2x1A==
X-Gm-Message-State: APjAAAX0WfxUU4dxay1a4gqsHaFR2n+n+3DHJ199x2mrr+rsMXRpjs8V
        Bj/9uO4mPqxzTc9VlnDjoBjUA5p7FkHlQaPpryo=
X-Google-Smtp-Source: APXvYqz7roQk4gRK1HEoWI9GAtvZPk3QvMFuzChbPtXXdtzeJkmNSXo3h52CK/tTfBBECFjLP9QPI5qO8G04gXgWM0A=
X-Received: by 2002:a05:6638:214:: with SMTP id e20mr4243086jaq.59.1556828403141;
 Thu, 02 May 2019 13:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAH3MdRVkUFfwKkgT-pi-RLBpcEf6n0bAwWZOu-=7+qctPTCpkw@mail.gmail.com>
 <1556812610-27957-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1556812610-27957-1-git-send-email-vgupta@synopsys.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 2 May 2019 13:19:27 -0700
Message-ID: <CAH3MdRWkiFSRA+PRo53_Syx9OBmyj2U_ebap-9iBR8L7xW9UVw@mail.gmail.com>
Subject: Re: [PATCH v2] tools/bpf: fix perf build error with uClibc (seen on ARC)
To:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, Wang Nan <wangnan0@huawei.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-snps-arc@lists.infradead.org,
        linux-perf-users@vger.kernel.org, arnaldo.melo@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 8:57 AM Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>
> When build perf for ARC recently, there was a build failure due to lack
> of __NR_bpf.
>
> | Auto-detecting system features:
> |
> | ...                     get_cpuid: [ OFF ]
> | ...                           bpf: [ on  ]
> |
> | #  error __NR_bpf not defined. libbpf does not support your arch.
>     ^~~~~
> | bpf.c: In function 'sys_bpf':
> | bpf.c:66:17: error: '__NR_bpf' undeclared (first use in this function)
> |  return syscall(__NR_bpf, cmd, attr, size);
> |                 ^~~~~~~~
> |                 sys_bpf
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
> v1 -> v2
>   - Only add syscall nr for ARC, as asm-generic won't work with arm/sh [Y Song]
> ---
>  tools/lib/bpf/bpf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 9cd015574e83..d82edadf7589 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -46,6 +46,8 @@
>  #  define __NR_bpf 349
>  # elif defined(__s390__)
>  #  define __NR_bpf 351
> +# elif defined(__arc__)
> +#  define __NR_bpf 280
>  # else
>  #  error __NR_bpf not defined. libbpf does not support your arch.
>  # endif
> --
> 2.7.4
>
