Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB06ADAC
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbfGPRb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:31:29 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40083 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGPRb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:31:29 -0400
Received: by mail-ot1-f68.google.com with SMTP id y20so6013893otk.7;
        Tue, 16 Jul 2019 10:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R8MXJuGF3VOe2xZoC5VvvRqzCcRzeJc9EL52ma0h3wk=;
        b=pkeMXSDqN2AuOf+CI3wtG6jXLNbk/7yZiXpE6G3pQn/bxpxmE2OckES17ovbbe6FTE
         qhOMtQBieXjMFM5inG8vQmwmWIqP4CyAk1wSUoCwX7bEROQZi9YiGR1id6HKy3k+augq
         RXpboXrWFQf7mRAAEPL22n4mbLdf6nuvdSlp29kGo1eyO29juxa329MM3WBSHuG3yXG5
         9EQ+LwZ6DOpiD4Q+WNJzB0zI2zu69N/OuFC2MHFNHfPBqa2p+4L0SijhhExaJgPmZr5K
         YGCyTJ0r1kzqedh5xSK9/KiwvzMvZ658FhCNDgbdIzfhQwyMxxFZaOQj4VkJWA7kNu6/
         FGKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R8MXJuGF3VOe2xZoC5VvvRqzCcRzeJc9EL52ma0h3wk=;
        b=ljB46PFgiiUiEk1KDcPtns4MxJ4MI6vEweHdUS/vy4uqFGZweSi4uQ1tmmNwBns0uw
         tUSM62rATo7roju+qQ4FlWYCQn0wQ4uAQ+r/8jZI3kwDv6d1UgjDIstzW5ftw6LpHnwE
         jKubvyKIIkTJsDexJpmsNS+vFUfEFXhElsmmxEYSx838TnS8+1FeQeqGgWpPs/eN79o5
         g77zuxCmRf+cI1SC5henWacAdXNhcg5X1ACXcXfKttXKyWTkmzT9ydJfMLQUaPHNbMJS
         FjqTjkR0MIe6lCbOClROcthSn+R0A6R6aT7RK8mbGDAy+LfAqkP++BqOeGQ2vtsElVm7
         7HhQ==
X-Gm-Message-State: APjAAAVBzjtaVGjbNLQ5fRvw1GKWtxnxjHZ4ksivSs7s67IA8ha6I5CA
        DLYXD/9F4MV8Pe35sp67Lyavbf5NYRXU5dtm3V0=
X-Google-Smtp-Source: APXvYqw4H6ZI+T2+e3De+4DO8KgkxjwHTwxXoh/MhCemQNhZu+srPj2SGa6XVYN/IWVGfNmJGjFtdtVlnBHZKSXB7qc=
X-Received: by 2002:a9d:6256:: with SMTP id i22mr3583179otk.139.1563298288252;
 Tue, 16 Jul 2019 10:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190716035704.948081-1-andriin@fb.com>
In-Reply-To: <20190716035704.948081-1-andriin@fb.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 16 Jul 2019 19:31:17 +0200
Message-ID: <CAJ8uoz03xFA4TW7GNmLAw_A0wMjHUjYU2rG3pRWsEX-sAX8BFw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix another GCC8 warning for strncpy
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        kernel-team@fb.com, Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 5:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Similar issue was fixed in cdfc7f888c2a ("libbpf: fix GCC8 warning for
> strncpy") already. This one was missed. Fixing now.

Thanks Andrii.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/xsk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index b33740221b7e..5007b5d4fd2c 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -517,7 +517,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>                 err = -errno;
>                 goto out_socket;
>         }
> -       strncpy(xsk->ifname, ifname, IFNAMSIZ);
> +       strncpy(xsk->ifname, ifname, IFNAMSIZ - 1);
> +       xsk->ifname[IFNAMSIZ - 1] = '\0';
>
>         err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
>         if (err)
> --
> 2.17.1
>
