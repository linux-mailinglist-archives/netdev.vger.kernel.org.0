Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF840FE83
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhIQRTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhIQRTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:19:20 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FADFC061574;
        Fri, 17 Sep 2021 10:17:58 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id c7so14146442qka.2;
        Fri, 17 Sep 2021 10:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=40fDEg3fABnjTm2Jeh1ku9dFDScBQkyGxaPi+SrGI08=;
        b=GbjCn6xIGP18QKsyjQ75a+2uuzkA7jodKc8CftKHKkWgQWG2S6k7S7GRF5cwQC43Tw
         x4EiDuMqtlpoXk87DL2KldWpMbR1KJpcfTPBRj/2ztLH2Ejhd7+CekUaOPOp6zmK9D+V
         HO0PTMr3/bRqoBSFdO7kAujOnhHi0GiKmidc63hbCW+Q9yrEwiR9Z13Kzd3RaOGVSRjL
         87WHiPeEtbQkV4FPHug+fkK1ZnjnHeBfKzG9JJACkJHvQHY/7p+n7ucDfuvKoVYrTQd2
         7Zx20w0zYEbnNZ7moeuE1VQBwQcWmTTaYkkR6BmeNIuyEqdvE1riMUxABU8xUxlMKxky
         Fzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=40fDEg3fABnjTm2Jeh1ku9dFDScBQkyGxaPi+SrGI08=;
        b=Z1mVBN8BgDtgw6G45Abazg4OjGh7rJ1/hWPNq8G+Fk04AAJRDibDRuFVbA9SW+S7j0
         vYYUHwPPGF+s6GKQNUKIAqY65Ur714hX+5t+zkownBORQ1hNhdtfvUZlwisof8izeM9m
         jz6nxVSazgh4vStHJQj/WWVRpSiLKICcVhNLXgLN5UgZXpBBzqs3pccDgZJlUOWyduMw
         ASdgHBx8UXIIaLkMrFNvqtX9WkaoLrtkmsH0KZKKwHf2dL2mehnrQJbdNkVoPiSBRohZ
         Cj94kScSj/zb2RMN7taqQQr5ApDcIWB89zlqbJmZDisv/GOPm/YZu/yVU9vO35SSi8Ha
         5T3g==
X-Gm-Message-State: AOAM532aY4EX5OJumpTAvjTyXqqFCuvbjWIZK5agdX1VY+aEPxtsmic1
        mT2rPdwtc20y7yoggjZsg7ZwWR7HxlNlBPjVm9L1S8Dm
X-Google-Smtp-Source: ABdhPJyGl6QvysJfh5QnTncuKTK9qBA1RXZO68+G0cToZkCIWY3mJF0VImgBstLSGjhj9D27kdeyXXB+1Azs2dHhsgw=
X-Received: by 2002:a25:fc5:: with SMTP id 188mr14498879ybp.51.1631899077169;
 Fri, 17 Sep 2021 10:17:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631785820.git.mchehab+huawei@kernel.org> <803e3a74d7f9b5fe23e4f8222af0e6629d1cd76a.1631785820.git.mchehab+huawei@kernel.org>
In-Reply-To: <803e3a74d7f9b5fe23e4f8222af0e6629d1cd76a.1631785820.git.mchehab+huawei@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Sep 2021 10:17:46 -0700
Message-ID: <CAEf4BzaULanV_QFbZxA=f-vYZ5LrFZji1Nwq3xn68qO08AHQpw@mail.gmail.com>
Subject: Re: [PATCH v2 09/23] tools: bpftool: update bpftool-map.rst reference
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Beckett <david.beckett@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 2:55 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> The file name: Documentation/bpftool-map.rst
> should be, instead: tools/bpf/bpftool/Documentation/bpftool-map.rst.
>
> Update its cross-reference accordingly.
>
> Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> Fixes: ff69c21a85a4 ("tools: bpftool: add documentation")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> index 27a2c369a798..2d7eb683bd5a 100755
> --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> @@ -383,7 +383,7 @@ class ManMapExtractor(ManPageExtractor):
>      """
>      An extractor for bpftool-map.rst.
>      """
> -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-map.rst')
> +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-map.rst')

this is wrong, BPFTOOL_DIR already includes "tools/bpf/bpftool" part.
Did you test this? There are many places where BPFTOOL_DIR is joined
with bpftool-local file paths, you haven't updated them. So I assume
this was done blindly with some sort of script? Please be careful with
such changes.

>
>      def get_map_types(self):
>          return self.get_rst_list('TYPE')
> --
> 2.31.1
>
