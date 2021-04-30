Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5729F36F57D
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 07:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhD3Fsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 01:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3Fsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 01:48:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6B75613F7;
        Fri, 30 Apr 2021 05:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619761662;
        bh=uN3W5AsIapviMEagZO43iHfN9y2Xy6Ij7KqfAJPPtz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CbEaoj2E6jBJmYQcnUXfa3aPLm0l7wwk1dgTz0uFUCwhHQwokIRT5q2Gcg1hZk7oM
         vTFXxNAySKTzmBc22szg0+AcfrACnHSlGdYvoA6kXn/713Gjxue91RkVIZBWSvvJfx
         lYMGF3UflgKEwN52TBYLAsMcjB+9rOMsBSphbZDQ=
Date:   Fri, 30 Apr 2021 07:47:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Rob Herring <robh+dt@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        devicetree@vger.kernel.org, keyrings@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] .gitignore: prefix local generated files with a slash
Message-ID: <YIuZ+rDdYzvTcSSB@kroah.com>
References: <20210430020308.66792-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430020308.66792-1-masahiroy@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 11:03:08AM +0900, Masahiro Yamada wrote:
> The pattern prefixed with '/' matches files in the same directory,
> but not ones in sub-directories.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Miguel Ojeda <ojeda@kernel.org>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> 
> Changes in v2:
>   - rebase


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
