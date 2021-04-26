Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411B636B5DC
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhDZPe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZPe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 11:34:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CD3613AA;
        Mon, 26 Apr 2021 15:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619451225;
        bh=osgS3AXWXNp6bu1C3444Rsv8qP3XldCS7p+4U7Jf+QQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QnzaRhQqB0igf+Z3asuX4irg9G+Z71kWG43WoW+NoERsheTVoAHqIICNUJNgpMf2U
         /lGvHd6yDTgOpXLHBEA7EH63mH9sMPjAVTO3TJwRM1I/0JNAywZGDIPUhU3HnoBM7y
         bFVpYnOUw5MywEuyM17mo1HzKn4fF9uQQmhGaqWWyKAtS3s1lF8mZKrFGBU5UhxQqa
         tcYJVk6QPDK8VSRkQVk+BXWx6UTDTNNoSGFKdJKw28rMnujinKh0vPJLtWOsGA77+V
         DNjkaq7Zjd0B8N1f9hnUs5GLIdPgUWNXQS/s8my3IP6XiMpLnFuwMgqArurbMfnNps
         grQdeaWRNY9Ag==
Received: by mail-ed1-f47.google.com with SMTP id c22so2593747edn.7;
        Mon, 26 Apr 2021 08:33:45 -0700 (PDT)
X-Gm-Message-State: AOAM5331z1ldKIitX2pQUjIj0iENByj8rlSBx3C6Zj/OfbwBc/KPAJ9N
        1NTlEAnY+ErvpU5DjgffSrLixlJDv3sBNCLkEQ==
X-Google-Smtp-Source: ABdhPJwNZx4cfsajqvqtdLrLKygdGbSxP3pzTySFadKKNqqDSrOBLVNGECi/ddGsCdNYPDUa3AHPPOcKOGvNnPqAGpI=
X-Received: by 2002:a05:6402:234b:: with SMTP id r11mr3697822eda.137.1619451223941;
 Mon, 26 Apr 2021 08:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210425062407.1183801-1-masahiroy@kernel.org> <20210425062407.1183801-4-masahiroy@kernel.org>
In-Reply-To: <20210425062407.1183801-4-masahiroy@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 26 Apr 2021 10:33:31 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJK50tmc+gqi2sSse+v032otJTp8NF3v8inA9MtP4ZeTw@mail.gmail.com>
Message-ID: <CAL_JsqJK50tmc+gqi2sSse+v032otJTp8NF3v8inA9MtP4ZeTw@mail.gmail.com>
Subject: Re: [PATCH 4/5] .gitignore: prefix local generated files with a slash
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        devicetree@vger.kernel.org, keyrings@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 1:35 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> The pattern prefixed with '/' matches a file in the same directory,
> but not a one in sub-directories.
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
>
>  Documentation/devicetree/bindings/.gitignore |  4 ++--
>  arch/.gitignore                              |  4 ++--
>  certs/.gitignore                             |  2 +-
>  drivers/memory/.gitignore                    |  2 +-
>  drivers/tty/vt/.gitignore                    |  6 +++---
>  kernel/.gitignore                            |  2 +-
>  lib/.gitignore                               | 10 +++++-----
>  samples/auxdisplay/.gitignore                |  2 +-
>  samples/binderfs/.gitignore                  |  3 ++-
>  samples/connector/.gitignore                 |  2 +-
>  samples/hidraw/.gitignore                    |  2 +-
>  samples/mei/.gitignore                       |  2 +-
>  samples/nitro_enclaves/.gitignore            |  2 +-
>  samples/pidfd/.gitignore                     |  2 +-
>  samples/seccomp/.gitignore                   |  8 ++++----
>  samples/timers/.gitignore                    |  2 +-
>  samples/vfs/.gitignore                       |  4 ++--
>  samples/watch_queue/.gitignore               |  3 ++-
>  samples/watchdog/.gitignore                  |  2 +-
>  scripts/.gitignore                           | 18 +++++++++---------
>  scripts/basic/.gitignore                     |  2 +-
>  scripts/dtc/.gitignore                       |  4 ++--
>  scripts/gcc-plugins/.gitignore               |  2 +-
>  scripts/genksyms/.gitignore                  |  2 +-
>  scripts/mod/.gitignore                       |  8 ++++----
>  usr/.gitignore                               |  4 ++--
>  26 files changed, 53 insertions(+), 51 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
