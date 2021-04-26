Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5B36B1E7
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhDZKve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDZKvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:51:33 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37108C061574;
        Mon, 26 Apr 2021 03:50:52 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 82so64274461yby.7;
        Mon, 26 Apr 2021 03:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UfH1Zmn9d8AenTubEewZ4u4D1igD8DxPFj71s3RAr6c=;
        b=mLMzD40qG+9eX3ZnUCjGA+yGPb37K+3PdedTTL7WBrHpcer8kn8eSytkwPbGv8yLrX
         QJqqwBtUWD+ENBPwdqPvRlqguSSpPUndyA2cRz+epvbREuCrJw9ghtxnceDpeIANKC5f
         O0dUSjtj7CX9Au5/8ROzypfBbnnjDCGYi0Q9ewqp9y9GTeVAsg6tDeJ9Uw9v1uTQ4Rjj
         9/48Cw7UTnp+37rB1SgbXdBNpcDUbwV0FwBiRD1x8Z+ttQ1yltxHhkfpYS1DJxoqsC6p
         LjNpoaCy6xYVKOm2wq3aoc01V57QScVXcCwotWjnyWsNJzEzUAvzzDQmSmqmMWvyLcc2
         6m3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UfH1Zmn9d8AenTubEewZ4u4D1igD8DxPFj71s3RAr6c=;
        b=M/luv70g0Z3K3XQVEjA2VYm3mrXeChKXxG4IFRgSsAQ+9QS/xJPIfrxfS7Y/3q0VZL
         kOwUw6WQlaD7XX/wO7nya0cQW2nEAtqieHpz3sBl7g+YoQJG7fgEOF+t90jr8umz9KPR
         q1cs1AKxuqebILa7utEfcP5ABLT/w2EyE6SNKkB3MDYCYIEgPvg3WW5VmYSqmfMdgS40
         RsZmk48JEx6NZwvYYKykk3EHK0NRpcrR5v4of4Zt8dCAX7bWRb6S/c7jDqzXXV/NKkTd
         HdmtZYtIKVQw4y9F9YIo7qG6/vr+bohFQBatBnpUQ9wUJFlOfrmUJ+shDmTu8Vx5kqe1
         fQPQ==
X-Gm-Message-State: AOAM5337LiONpcoZwf/+7cyMVPDwQYc+StlcGq5MOjlRbjgJUbn7rbC5
        71S6UdQ/cEQdF+3Fvb+vz9KcotxcpXtQRt81n6g=
X-Google-Smtp-Source: ABdhPJylpudlDbmdOGRLzjwnDBVt78BpV+y3O7BGDcgF8HzpDY3sdjpc9mL6w+3Q+hDt74v9Pa2YPtH6wiJ9tuhSD48=
X-Received: by 2002:a25:7909:: with SMTP id u9mr22993292ybc.22.1619434251524;
 Mon, 26 Apr 2021 03:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210425062407.1183801-1-masahiroy@kernel.org> <20210425062407.1183801-4-masahiroy@kernel.org>
In-Reply-To: <20210425062407.1183801-4-masahiroy@kernel.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 26 Apr 2021 12:50:40 +0200
Message-ID: <CANiq72nfXMfZzuSV_LG8xB7K90QZLRw773xkOpwgqA1nM5Eoew@mail.gmail.com>
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
        Rob Herring <robh+dt@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        devicetree@vger.kernel.org, keyrings@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 8:28 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> The pattern prefixed with '/' matches a file in the same directory,
> but not a one in sub-directories.
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Good idea, it helps to be more explicit.

    Acked-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
