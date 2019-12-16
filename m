Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1E412053F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfLPMQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:16:32 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45475 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfLPMQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:16:32 -0500
Received: by mail-qt1-f196.google.com with SMTP id l12so5553707qtq.12;
        Mon, 16 Dec 2019 04:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MJ/TMdYgQ2WgX5tItOvR+lRv2YzdL6QzVAQ99cZHZw4=;
        b=PDEv7V0IQ8DIqC23zukl3YPC1aEukQLo6YZ9nMI6Oe/2YQAUzzyZsCO6328TgBC1mf
         70ZYeqBK1D1Q7J0Dud07KxhhRfcwWKSDx6FvKB/nxPXp86ows9nbDp9Cq2xtrdkTtHwp
         znvEZ+G7bHaWB8O1WAO8UVjliMHs8dJ5Td6c7UyV8OosN2+bk1R/2lAnO4ruG8KWgukn
         jUCrpSIOkg/Gh19Nl5MpsAu2NDwge4GEd5xjwmmr5NcfDcYt3J+9Ndy133MMugz0e6un
         O27QtKc5ZFHLDrSsfCH/nJBte+hRLYzxPWh5I2n3y5kFWCMW39U7QlfDh15URnsgQlZB
         i6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MJ/TMdYgQ2WgX5tItOvR+lRv2YzdL6QzVAQ99cZHZw4=;
        b=hnqyRbpcjR9Mp8V1AoNuM5FIk2LXiYvmGa9waQA4vGzkQWrAx4jlVPKmUSLNY8WQ05
         DdtczPvcVjY990PVdjYaLFwHZYtkcILemxD5YtKeAukLfazQ5Q2vD+1C1izjYExvOYmD
         uQsfgpmoCRxN2NhhI3djO3Yz7p2VEMT1mLxgo2giUDS+QOOugXkhIneEHW7nWiM59F9l
         D+ifXOkSXguoiP4aE8adq0q4ojHW7VYNcSPhSxt82DgLNd1a9VHWgDrUivodAqCJCVVU
         lzNNoKBWEPQB+QZS7l5BFybRS5b4o7EMtoPJ/GV0A9h6DkM3weq5BGSX8+VjULRkBGzK
         quyQ==
X-Gm-Message-State: APjAAAW/7KeSbd6k2/glkDsl26lWWjI5wIt/2zLJAcuhe55xBmyprl4y
        eSZjLMXeEUR01wSLySba3CjIUUpJLSpuFNa44sY=
X-Google-Smtp-Source: APXvYqzrwzU73WB2VCx8BuJhMO+VC39IpRT/3J8xxKdmYrWm76bEd/2yTc2efbXlRRv3nYJ+skKq74xYxJqUiDQqcho=
X-Received: by 2002:ac8:104:: with SMTP id e4mr23589790qtg.37.1576498591261;
 Mon, 16 Dec 2019 04:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20191216102405.353834-1-toke@redhat.com>
In-Reply-To: <20191216102405.353834-1-toke@redhat.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 16 Dec 2019 13:16:20 +0100
Message-ID: <CAJ+HfNjyx6ZLrcqW+voHsNH-PUuLKGCyvtdVXSz+kODhyxQYAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: Add missing -lz to TPROGS_LDLIBS
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 at 11:24, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Since libbpf now links against zlib, this needs to be included in the
> linker invocation for the userspace programs in samples/bpf that link
> statically against libbpf.
>
> Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Thanks Toke!

Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  samples/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 1fc42ad8ff49..b00651608765 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -196,7 +196,7 @@ endif
>
>  TPROGCFLAGS_bpf_load.o +=3D -Wno-unused-variable
>
> -TPROGS_LDLIBS                  +=3D $(LIBBPF) -lelf
> +TPROGS_LDLIBS                  +=3D $(LIBBPF) -lelf -lz
>  TPROGLDLIBS_tracex4            +=3D -lrt
>  TPROGLDLIBS_trace_output       +=3D -lrt
>  TPROGLDLIBS_map_perf_test      +=3D -lrt
> --
> 2.24.0
>
