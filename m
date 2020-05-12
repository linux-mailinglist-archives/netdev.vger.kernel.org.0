Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677701D0256
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgELWax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELWaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:30:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED2DC061A0C;
        Tue, 12 May 2020 15:30:52 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 190so9867116qki.1;
        Tue, 12 May 2020 15:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0mPbMbjn69KjqF8hxMpsVRf+SDB9FYYBLONhsk7r3E=;
        b=O1ypy+QrKVzXaq4V344CsylrDHFi55RnpYlFsG87a6+tL5F29SGDf9t6ifWbmPLdw8
         cLjWJOe7K7trffuNSFwkCRGTpDKtgMstlw+nkvUpnV+yylWFY2b4tMMtTFWo8N4KV3tR
         tUiC83y/5TrC7U47dAcr+94eulEpn8eAh5wz18VEXmCDiek2cmg1CMDb9LSz+stlxj+j
         5ooL4sGXs2AfjPzFt9YOV9TDS6zTbiRESieo4DiWkhRD1UxvwFVo77c1xopbSfS+RvjH
         pD66OIvuYRSUubJPELuC9r8MvZq4Q3g+/dBI3RXIdngdGqx4tKGGhvPNCNY17mv07EhR
         vJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0mPbMbjn69KjqF8hxMpsVRf+SDB9FYYBLONhsk7r3E=;
        b=EIyxpJBeQ2m5XUSPAR/2pc0o9II0KsPJGN/tQDxB8GQgno7L4YMWu6FhoiaEL28I68
         3AHlT2wMwyFLIFH3ssYu+R7t9PUlBP+CXko2/ofNPwA4fj5K1onDIEeMwID8j23ZhCHC
         mr2ZkJsV95NUipeG2JH+OUaDfs/oxQttZo50uCBXoQnvxFQkjTRATwRyxTRPfnrNTgt9
         sUATCRrql0DWAQ8qh1U98epLJwatHQqhIf7DZlSC4Z5XSrF9KOwWFG9+EpmqLwZjiiJn
         zjGhcBzn9BR1nCdKIMc+F2SMA8WEyIrhnyFx6/OT9KR6zP0FxHpUHugIQR7mMD4HtZkG
         LB0w==
X-Gm-Message-State: AGi0PuZycY22VDAPje8khxBkaRl+LlMYGhWLKGP/AxctOTVaXhQjV8iJ
        APZXZvbVEf1j+IqfcVuSOX0LDpMmAFcIvt+q97k=
X-Google-Smtp-Source: APiQypJ5d3dkUHqV17NZKAV1fdn4/hv92O++epOHaA6wdeg9/bLkhfzBLmeOoPmIaLRQbf4mOErnP59exZBxNDeNeK8=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr24834334qkg.437.1589322651683;
 Tue, 12 May 2020 15:30:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200512155232.1080167-1-yhs@fb.com> <20200512155240.1080830-1-yhs@fb.com>
In-Reply-To: <20200512155240.1080830-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 May 2020 15:30:40 -0700
Message-ID: <CAEf4BzapE89OjQ4z7kzQiOz78JqpMBdjkbQfePDGGG0sy7DJag@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/8] samples/bpf: remove compiler warnings
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

On Tue, May 12, 2020 at 8:54 AM Yonghong Song <yhs@fb.com> wrote:
>
> Commit 5fbc220862fc ("tools/libpf: Add offsetof/container_of macro
> in bpf_helpers.h") added macros offsetof/container_of to
> bpf_helpers.h. Unfortunately, it caused compilation warnings
> below for a few samples/bpf programs:
>   In file included from /data/users/yhs/work/net-next/samples/bpf/sockex2_kern.c:4:
>   In file included from /data/users/yhs/work/net-next/include/uapi/linux/in.h:24:
>   In file included from /data/users/yhs/work/net-next/include/linux/socket.h:8:
>   In file included from /data/users/yhs/work/net-next/include/linux/uio.h:8:
>   /data/users/yhs/work/net-next/include/linux/kernel.h:992:9: warning: 'container_of' macro redefined [-Wmacro-redefined]
>           ^
>   /data/users/yhs/work/net-next/tools/lib/bpf/bpf_helpers.h:46:9: note: previous definition is here
>           ^
>   1 warning generated.
>     CLANG-bpf  samples/bpf/sockex3_kern.o
>
> In all these cases, bpf_helpers.h is included first, followed by other
> standard headers. The macro container_of is defined unconditionally
> in kernel.h, causing the compiler warning.
>
> The fix is to move bpf_helpers.h after standard headers.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/offwaketime_kern.c | 4 ++--
>  samples/bpf/sockex2_kern.c     | 4 ++--
>  samples/bpf/sockex3_kern.c     | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
>

[...]
