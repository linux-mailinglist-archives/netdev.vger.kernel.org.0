Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CE85C372
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGATHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 15:07:40 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37708 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGATHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 15:07:40 -0400
Received: by mail-yb1-f193.google.com with SMTP id l22so406167ybf.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BuegrSj8leiIsC8a4bCP4BLocnDErLhxHlYrIzInHc4=;
        b=loCyiPisupsnCfJM922qv1z3wo33Lr7PAyByKT4D9WovrlUUnsd4YzSKoPQRreeBZX
         3m8avefEqNA+css3UtcZ3ezYgxYe0o1fWJrIUJ3wgP2zJgHCiUPDb1PgiOmih8Xcrjdy
         g/qC3b7aeYuUlUO/+JNE8jTQbf1nFgiGrzIpAM1mk3jAu+jpcWs1Q4bhKBroi2dZjzcG
         mOHF5zDkBN2Xlv/Z1/R85eegCBDGgxvth+wk/+gluQzUN5xGENbFDaqQPXl3UjJ3F+iL
         cJvvFsIsniS1dudrwY8xV3PVWq9RyV2lLXkx/o4mB0ZexFrj/Cwr2t2YdHiV+tM24G2W
         a6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BuegrSj8leiIsC8a4bCP4BLocnDErLhxHlYrIzInHc4=;
        b=K/13KU5p8fjxTfnSHuOCbJpkQm51ViDQt31KVtidPTjSMFRAaINr4MqCw2mjvP+o0M
         tVDGuxdlaW6wrX9HI+66SrX0YU3xqwWBg/rx0kh13fyncQl1UG9gKhEv9yB1LcmuyplH
         QAbkHrpsOveVbcevzKRf8CE8PzhJf7ghPr05Xb2zdtELbVIfY9j7fk9WgzMGsFR5niMh
         8u76P3v5GeQQOfIDi4s7k6QLyUx4ENCW+LtwLqSnZDvJB2SrKVKAZVKPKL0TOgCRaEy3
         Zrenqj4Q3Q5HGUtoBhN5fYIMaZEoMi3r/jtGB/4mYgIwBmr5PSdpg2igSGim/DcQ78LS
         fiNw==
X-Gm-Message-State: APjAAAXHpz9ZozHGQjoXwxKQ5t8vz00Dufg+J62EwGuhC+OwFs0Yaaxo
        mWJdJGzWj+PZjtUOYvChwEQo15GD
X-Google-Smtp-Source: APXvYqymfZpLg6/fk9K0475MVEq/6oXhuX3MIWeaPyjimEx8OeMyYUYr1L3rPkrzIUYFX4HyOh/T7w==
X-Received: by 2002:a25:e08c:: with SMTP id x134mr8874142ybg.174.1562008058949;
        Mon, 01 Jul 2019 12:07:38 -0700 (PDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id y3sm2713595ywa.47.2019.07.01.12.07.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 12:07:38 -0700 (PDT)
Received: by mail-yw1-f47.google.com with SMTP id t2so378459ywe.10
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 12:07:37 -0700 (PDT)
X-Received: by 2002:a81:6a05:: with SMTP id f5mr16365861ywc.368.1562008057472;
 Mon, 01 Jul 2019 12:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561999976.git.pabeni@redhat.com> <8c32b92eee12bf0725ead331e7607d8c4012d51f.1561999976.git.pabeni@redhat.com>
In-Reply-To: <8c32b92eee12bf0725ead331e7607d8c4012d51f.1561999976.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 1 Jul 2019 15:07:00 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfHF_LRuZeW3ZiX5a662=fdAu9zmmpa67WpOkZqkt8Srw@mail.gmail.com>
Message-ID: <CA+FuTSfHF_LRuZeW3ZiX5a662=fdAu9zmmpa67WpOkZqkt8Srw@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 1:10 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> This avoids an indirect call per syscall for common ipv4 transports
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/af_inet.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 8421e2f5bbb3..9a2f17d0c5f5 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -797,6 +797,8 @@ int inet_send_prepare(struct sock *sk)
>  }
>  EXPORT_SYMBOL_GPL(inet_send_prepare);
>
> +INDIRECT_CALLABLE_DECLARE(int udp_sendmsg(struct sock *, struct msghdr *,
> +                                         size_t));

Small nit: this is already defined in include/net/udp.h, which is
included. So like tcp_sendmsg, probably no need to declare.

If defining inet6_sendmsg and inet6_recvmsg in include/net/ipv6.h,
perhaps do the same for the other missing functions, instead of these
indirect declarations at the callsite?

Aside from that small point, patch set looks great to me. Thanks Paolo.

Acked-by: Willem de Bruijn <willemb@google.com>
