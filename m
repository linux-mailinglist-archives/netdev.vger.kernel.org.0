Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F4089125918
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfLSBLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:11:51 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33023 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSBLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 20:11:51 -0500
Received: by mail-lj1-f196.google.com with SMTP id p8so4302139ljg.0;
        Wed, 18 Dec 2019 17:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F0fthrE48knNAOyxF+Yceu62pdIXb13034ptSwh3wAw=;
        b=BWFhIJPrJw6VyqCTtdf00IEaReySTrGUAHU+Ii8im5jphay4dEsgGmbPhl1c6wNh0K
         E1ZTOQ7NNRH/eeOehQx+929CAUJaBKNu0EbotxGYDE04y0SJqi/5YtCJI9+0eaTSEvjJ
         NowRwoUFf8+1lx1G+oPDi1tNAwivkCAPaDRadYWxu1REN9HnNzlDq+IoRAhYvOhMszXC
         Pk4rIaz4zBg8E3wjM23WlrNGyg90u4W1KYKuR9IwfmZJG43YToocTgdwBevC8+1Z6c+j
         Dp9a3/qtCxQv1ATjf9ZEBtAnqjQahEQZIHuxLg7rBimJa99GnlIOMbwZqr+dR+z6V5ba
         QMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F0fthrE48knNAOyxF+Yceu62pdIXb13034ptSwh3wAw=;
        b=FbBMB0okcIsYQvHgOYRlTT/8VJ6cjzW1lvHi59dNsn+jqWdHcZmTdUDrWXKY6b5H/G
         /x9nMQuoTwNNezL7iNaErjf6qfm0s14LayqXM81VnqwAMWMuc8ZnFGraiFLlwY5xxSVH
         Zvua0Ki+Gc80xDJf2Kpg8bHtcz5vd/ns+voSRl7Y2BelTKQw7VM4c1lPVaQKqfB78/GH
         4/IL/FnHroC+jrPRd6JS8lHK44W4mZH9/fOPGbspP5knvjbDln0+jmKZ4XYFulkH+21H
         WbN/tM86AqcCl03T9fr//3ODjn14lk3e7bbXnumwmeKZjMkT5InlswqZKhemhudefaLp
         yLdg==
X-Gm-Message-State: APjAAAVmkUFGwXR3qPmjggDv2N9pCbE8dcL792wb9cd8HBbNcCEsdQBe
        CsYfSuHSvH03Cscu6UZ2LsXHjGHu8IL8AVDQ3lY=
X-Google-Smtp-Source: APXvYqzPVkyfToCH6R8URpiEuhigRu1NaNge+Mxji2ZG9MET4K/cyuT1hD+lvcDHUEx+BN5bL9iM397fm8xhl1EuApg=
X-Received: by 2002:a2e:9cd8:: with SMTP id g24mr3859839ljj.243.1576717512802;
 Wed, 18 Dec 2019 17:05:12 -0800 (PST)
MIME-Version: 1.0
References: <20191218221707.2552199-1-andriin@fb.com> <bc49104a-01a7-8731-e811-53a6c9861a48@fb.com>
 <1689268b-3f09-0a8a-b1dc-8c739901d92f@fb.com>
In-Reply-To: <1689268b-3f09-0a8a-b1dc-8c739901d92f@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Dec 2019 17:04:59 -0800
Message-ID: <CAADnVQ+PTVQvoRQym8UZYCUQS9tTrB4B3SOWsBtNS943rn7rMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 4:42 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/18/19 3:35 PM, Yonghong Song wrote:
> >
> >
> > On 12/18/19 2:17 PM, Andrii Nakryiko wrote:
> >> Work-around what appears to be a bug in rst2man convertion tool, used to
> >> create man pages out of reStructureText-formatted documents. If text line
> >> starts with dot, rst2man will put it in resulting man file verbatim. This
> >> seems to cause man tool to interpret it as a directive/command (e.g., `.bs`), and
> >> subsequently not render entire line because it's unrecognized one.
> >>
> >> Enclose '.xxx' words in extra formatting to work around.
> >>
> >> Fixes: cb21ac588546 ("bpftool: Add gen subcommand manpage")
> >> Reported-by: Alexei Starovoitov <ast@kernel.org>
> >> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com

Applied. Thanks
