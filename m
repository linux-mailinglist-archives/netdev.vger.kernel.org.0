Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B1A1D8F02
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgESFGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgESFGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:06:44 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0715EC061A0C;
        Mon, 18 May 2020 22:06:44 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id m44so10151717qtm.8;
        Mon, 18 May 2020 22:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jZrOxYWb3zpRqUWJJ997GvLPJkWOufs/Ei5ZU9Rcnaw=;
        b=CXLn66yc555yalWCtF7Paw3DaYVuFUf+5X2ygSBOU1I89GpDPrP52Fhtx1ADuSpwja
         Ozhqek9y+YfH6eZRE2Yz0ts1NQRNagyOxmd8fS9pZMDtzS+qnlwB5UecQvjpJ3du9BfG
         Nr0SW+GrMuuUi5uyS+pGk82OnqkncZ4yc7jOnArg4SSZprUAZ+jLMdZlEa4jlVq5XxSE
         Uwr0lu0Zq7zIqM4fLAfsCh6JdUrCUA8SNzdzng9ijCLHDTSSa95oevWiXA6lrHD/4qxB
         LZj31sRj0v0KkgjKFd+2WT5BpwXuXuy44TEqg7rdqahdUyCdSqZOtL03IkhQs1An1aeN
         X3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jZrOxYWb3zpRqUWJJ997GvLPJkWOufs/Ei5ZU9Rcnaw=;
        b=HVW+jkMDjG2nCQiu9ELHcvBAOvEo/d/NhO4pwsGDOy4S9yFv7jkNYgy5PWPJpfsUYB
         /BEpeHevhxb/1PUnt9NfgBaZKRGRBDqfrpTtt0hYhCuzBS4J7e9x/Fx76yQsuOem2xZe
         KEjR7PonpbDcCLlxbBlFRynPp35otcfck9BvjxPABrQ1+l1gSYB6K0051p8DEcVw1+7H
         edRfKsikqY6KbRedH0eMLa+VdnjOpNipj+LIbXC7SQvoK3vTGTviyM5v+MeK25cTSKu4
         5Q/6DvJXTdLga78CakEaJftsFAWzyeHnHfLWCmUc+ArIzWaMQLi6zZ3LfmZMZxzANevK
         C9zA==
X-Gm-Message-State: AOAM530mJcYxTS9ZEo6mEHvjvC/VEoEwzo0Olc78kg4eUkHZTvsiuKC1
        8UGmVBNIH5eLl/qYTHtIZkTtVvYo5FQ4PCG8qZaXwxP/
X-Google-Smtp-Source: ABdhPJykH3wkbgsXA8DYy1+4Yd8qP+fJ4w7YbKYi+ze7GpJ0OwbuvdXxEOXezhtK2wvovtF/7eHuw8YfhPIgGk6+q+8=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr19927038qtk.59.1589864803195;
 Mon, 18 May 2020 22:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
 <158983221039.6512.6745842570405722925.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983221039.6512.6745842570405722925.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 22:06:32 -0700
Message-ID: <CAEf4BzZC4qAJHkQq_ZVTk2REv+6u1xLhv3de15Ec2u+AT7SiMg@mail.gmail.com>
Subject: Re: [bpf-next PATCH 4/4] bpf: selftests, add printk to
 test_sk_lookup_kern to encode null ptr check
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 1:05 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Adding a printk to test_sk_lookup_kern created the reported failure
> where a pointer type is checked twice for NULL. Lets add it to the
> progs test test_sk_lookup_kern.c so we test the case from C all the
> way into the verifier.
>
> We already have printk's in selftests so seems OK to add another one.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Yeah, I think it's fine.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
> index d2b38fa..e83d0b4 100644
> --- a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
> @@ -73,6 +73,7 @@ int bpf_sk_lookup_test0(struct __sk_buff *skb)
>
>         tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
>         sk = bpf_sk_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
> +       bpf_printk("sk=%d\n", sk ? 1 : 0);
>         if (sk)
>                 bpf_sk_release(sk);
>         return sk ? TC_ACT_OK : TC_ACT_UNSPEC;
>
