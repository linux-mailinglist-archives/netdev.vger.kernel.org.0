Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4AD5115
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfJLQiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 12:38:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38912 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfJLQiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 12:38:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so11834012qki.6;
        Sat, 12 Oct 2019 09:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Asvf+7RAspz/dNRNRh3zzivlzI76nj7xUdvXm0KQbhk=;
        b=XBNFCriiZVsRqpp1Rz9jpimqWq2KJ8MPRKnu/0kp2MgT3pjUOoS6wqyhHq/azfu9tw
         mkdvUtG6oNGjVDwDK6Shi8tdBEzU8u95kOjtDWA1T20pbcycPm7xdxd5erP/u3udI1/D
         wDvQXLBE1udoElPfF+hc3pJoPvM4brcadJuX8dMtYiQBFfMwQXoAVKWyGYLzFpAZRuFv
         d2sn5QWLQvi/VB/WnWth7HYFH+6LIJxrqqNAzzFshamgeFdZMlQp6sAtlywJRpZ8AKTH
         ITdKz+N6XMyzSq76j9Qs3rG1kh/KXwHlKsqUUwHFVJvUwf0OdcPg0QgGqtgDfkI8A4jg
         szDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Asvf+7RAspz/dNRNRh3zzivlzI76nj7xUdvXm0KQbhk=;
        b=qjeWN1frlYjXEYJ17OmBvpo2vkXrEesAQDWU7P8ZsUJyIJQb4eqxb1iqScMIH48ULe
         RSMWCsotaNiqnSu2gdFtiqUHg4JA8T4+qjF00EONvXpUbbgrOhMKbUTyGrQpkF48jfE+
         +mp14joQMTx33KH8YPE4HcAeqpVwx+XoKm2WYH1MMYBesKhORZtxOxRc9inWmwE5nVSn
         BzhKACNrK+VQvlCIJUYHwDZL8+4d8EvHz50E2lH8BTdR3F9N3pLCxl5U32s1Aj1JHv7z
         1/5BCB8o/rgiGs4GR/K/kyErdFDRkO8xVqM/X9oCsdThc6PfSfzO7qVFwio2RUVj1prA
         Rj8A==
X-Gm-Message-State: APjAAAU1DbJhvw5ZkfwXSISFNLysSoHHsFSxe9s3sWQOXQKYg2vWNzYM
        5gl8SQhAkhcIzMX0Eir8Mrlpsnc6EtwwF4bS9nI=
X-Google-Smtp-Source: APXvYqz4UgPL57sKOTRBp1i4XHjeD9kz9YalrIgSn3zKwCGtiBrNst2Y70SVRh0PrbrRZNB9seFJ9+Xa1v7eTJl6B+g=
X-Received: by 2002:a37:6d04:: with SMTP id i4mr22438253qkc.36.1570898301394;
 Sat, 12 Oct 2019 09:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org> <20191011002808.28206-13-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20191011002808.28206-13-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 12 Oct 2019 09:38:10 -0700
Message-ID: <CAEf4BzZCLoYxvkUsPgZMuKHUSJhmTxGHGsyybBJNoGeoUVCUww@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 12/15] libbpf: add C/LDFLAGS to libbpf.so and
 test_libpf targets
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 5:29 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> In case of C/LDFLAGS there is no way to pass them correctly to build
> command, for instance when --sysroot is used or external libraries
> are used, like -lelf, wich can be absent in toolchain. This can be
> used for samples/bpf cross-compiling allowing to get elf lib from
> sysroot.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
