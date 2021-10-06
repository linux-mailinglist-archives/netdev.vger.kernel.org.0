Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33441424AB4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbhJFXws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhJFXwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 19:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E7D61152;
        Wed,  6 Oct 2021 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633564253;
        bh=K+W20q2FWy3PZV6etyIJ9ZB03lez/QC8rG/hOh87ntY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p97l+sNqjJeT6XPBJpY+jKfLBeaIRLFzihFD0DFjJcY40iQvZRn/ZoJdSv0TJXJHP
         4sagqmKBR90doik3UBQ1dpK24DEMojbFi5I4GMoj8tldSFIGV8enQQF7Ak9GDBAPxr
         cwn/ynCei6R1kQKAseuXbZYD5eBayFj+wTqqRxjigzNmAYtVtGj0k4i9r5bXEe39tp
         Ygcw1qwXsWHkNq2o1YB6yD0QmJLUlL8DUhApIoL1QIjhMUzXZVQGGH79Zu6ccS2SpH
         AFVulwvC3c84qfF6E12RSUdbSCwsuICjAW8vFhvXt8lmk/iOMsgpoYfyW/aIBJoxbq
         4uJySw1yGBCSg==
Received: by mail-lf1-f44.google.com with SMTP id m3so17334879lfu.2;
        Wed, 06 Oct 2021 16:50:53 -0700 (PDT)
X-Gm-Message-State: AOAM5301hlVmQ6gLyES0MjqccyhxpwmXWeH586vSmEKt0tNJux15mYTC
        PI/oi+50aL/XfgaM1NI0D3jPO3yBbZNVDSQ1oVA=
X-Google-Smtp-Source: ABdhPJz1SUv65lRuJngQ1VpLq4ZNUfR+fNBQ/yD3MHn5+hTeVSDxdMD5UI+Ns4kYqJpYRuhwKHoIrGgxOtXSrrduluk=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr1033715lfv.114.1633564251532;
 Wed, 06 Oct 2021 16:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211006230543.3928580-1-joannekoong@fb.com> <20211006230543.3928580-2-joannekoong@fb.com>
In-Reply-To: <20211006230543.3928580-2-joannekoong@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 16:50:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Uxu=BaZzwd9oiuC1dea00ePkdFbHCCnPf51tNjby0iw@mail.gmail.com>
Message-ID: <CAPhsuW6Uxu=BaZzwd9oiuC1dea00ePkdFbHCCnPf51tNjby0iw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] bpf/xdp: Add bpf_load_hdr_opt support for xdp
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 4:09 PM Joanne Koong <joannekoong@fb.com> wrote:
>
> This patch enables XDP programs to use the bpf_load_hdr_opt helper
> function to load header options.
>
> The upper 16 bits of "flags" is used to denote the offset to the tcp
> header. No other flags are, at this time, used by XDP programs.
> In the future, more flags can be included to support other types of
> header options.
>
> Much of the logic for loading header options can be shared between
> sockops and xdp programs. In net/core/filter.c, this common shared
> logic is refactored into a separate function both sockops and xdp
> use.
>
> Signed-off-by: Joanne Koong <joannekoong@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
