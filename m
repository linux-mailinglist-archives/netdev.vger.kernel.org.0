Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45E48A01E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243222AbiAJTas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241847AbiAJTar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:30:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32BCC06173F;
        Mon, 10 Jan 2022 11:30:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97BEB61416;
        Mon, 10 Jan 2022 19:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009DEC36AF5;
        Mon, 10 Jan 2022 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641843046;
        bh=YmviK5RZSlP89MSfpfdgfDv26eVqjbSGZFEAexfUax0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WQJdGeIw03IxhjkyOh/oHy0/xhGEqu6Yzf6vNo9uP74UezpnSgGWRZgeGnJHCNAJ1
         a+gZU004fsbLe0PVty+dm+DCWa21lrdv1U6mZ7gvXR57Aolr+JFgWbTHPpyp3W9TSD
         0a5lp9fYYLOhOr7Juj5uPePAYMHtQpcIqi59+v6WrrevdQOzJRhVXKzl9Z69k4o0R1
         IPWG2yCUeTeMu4lKPkburPZWQtbEzLu8WCd+zbDG0yr06Jy+XkyFyAY9gC64hsxdfz
         HYPVxqgvHJveZOwObNUU8xmh9sey1RsCfGXtW2kEXvXSmgCnSwvOr3WYU65STQjun3
         D2/kGMcUEl7Mw==
Received: by mail-yb1-f180.google.com with SMTP id j83so40987037ybg.2;
        Mon, 10 Jan 2022 11:30:45 -0800 (PST)
X-Gm-Message-State: AOAM530pdSqU1maeEwEXflyzhswb+rIFtZ3H7BmFI/PXlMYsbM1l+lGf
        vg/YANdgSSUktLG5rmdJeuDavagzUicDdmvID34=
X-Google-Smtp-Source: ABdhPJxi1+kIoliozeFn6h+zQk5GRTM/v/LZ+hjQz3ZA5kzu+flR3VAEV7Vvspv6IoLYEidim73AuXuTQCbYgYwvXts=
X-Received: by 2002:a25:287:: with SMTP id 129mr1482739ybc.670.1641843044963;
 Mon, 10 Jan 2022 11:30:44 -0800 (PST)
MIME-Version: 1.0
References: <20220107180314.1816515-1-marcel@ziswiler.com> <20220107180314.1816515-5-marcel@ziswiler.com>
In-Reply-To: <20220107180314.1816515-5-marcel@ziswiler.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 Jan 2022 11:30:34 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6sewYKBbCh+EcY-6PcwQV_+4-Pm1bmgXcZepzoAH=Z6g@mail.gmail.com>
Message-ID: <CAPhsuW6sewYKBbCh+EcY-6PcwQV_+4-Pm1bmgXcZepzoAH=Z6g@mail.gmail.com>
Subject: Re: [PATCH v1 04/14] arm64: defconfig: enable bpf/cgroup firewalling
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Marek Vasut <marek.vasut@gmail.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?Q?Guido_G=C3=BCnther?= <agx@sigxcpu.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Will Deacon <will@kernel.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 10:06 AM Marcel Ziswiler <marcel@ziswiler.com> wrote:
>
> From: Marcel Ziswiler <marcel.ziswiler@toradex.com>
>
> This avoids the following systemd warning:
>
> [    2.618538] systemd[1]: system-getty.slice: unit configures an IP
>  firewall, but the local system does not support BPF/cgroup firewalling.
> [    2.630916] systemd[1]: (This warning is only shown for the first
>  unit using IP firewalling.)
>
> Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>

Acked-by: Song Liu <songliubraving@fb.com>
