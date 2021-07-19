Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DAB3CE251
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbhGSPaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348588AbhGSPYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 11:24:55 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A501C021985
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:16:26 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id c16so21716025ybl.9
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxsFx/ud5bCkcwO5HB+617yeOVe2OtySxQQLQ/kd00c=;
        b=SZ7V6QfTXzZC4NeKDxbXlI5mMgJMxbREy18Rd/NI3UwpSRc92lfJL76RaHYwZX6MJz
         C/I1RP6h7HnirQqf2zki2ZRoLaPPffJhtdolKAblLUcf60syYxAx9ArzCcQcEgvAl+m2
         wf7+udjOND7FBJNbP3fLzl45oNkVW6LRN94KMCOzu8bVT1OY7ys6SbVzS08TTYuqb+Xc
         RSXIOY3d6/S1oVVravKnq652urGIOXj+NTnQMBdKzzrFWFseExCANF1X63bWJKR8/7ST
         ad2731DR1I/8eWbsbBi73jDbwRhISZtruJ7myR9BtZCc2wlD7vd0gYgZR9fupF7X9sqR
         F7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxsFx/ud5bCkcwO5HB+617yeOVe2OtySxQQLQ/kd00c=;
        b=ELqGU3QabQzjHrK8fqSsHm1NnkHay3GJK5rtK0e6cLFkBsJwT55qfrwk7EATMVb4+j
         aQp7Cu4gacSate6lw3rdshXw9qgZb7HaM439VYbku9HajXl9bkyKmwZQTN2rMWcVz4hw
         kcoYkklXG6MmwtcL7rPXyZtnKAWFPg6PDSPtmKnFCTb7l3nPLQNufg8N2JglzX1rUKPB
         vIM/O2kzduKksV04EAd+cC1cMQ4LUPkU5JH0t/ERomxlOYpGEq/IyEIdsFVpLv/JpS/w
         hNs8pHuVGryLVG/H7LW1pLZQQ1SVc123krd3krJm5eWThxw5e4dBbLJnEKZ/zzrDyPs4
         7/tg==
X-Gm-Message-State: AOAM531MeZfQHSGn0KGtITEm6ECUs7CmpnmypHdq/qYaX3Cyh+Yoa51X
        LnsZgDfNrvRDkaY4lXFbbYPSM73YLQz3vMX5ojgFdg==
X-Google-Smtp-Source: ABdhPJzMZXAc4RqPTXHU6XBJrb+duW+lb+Rvxv6ctjrG0OO2TtcXbYDI0TjM/dNlljDupLfuzg9YbHeDP9Q+kfprtZ0=
X-Received: by 2002:a25:acde:: with SMTP id x30mr32924263ybd.123.1626709430620;
 Mon, 19 Jul 2021 08:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210719092028.3016745-1-eric.dumazet@gmail.com>
In-Reply-To: <20210719092028.3016745-1-eric.dumazet@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 19 Jul 2021 08:43:36 -0700
Message-ID: <CAEA6p_Dr9Vgber447H5aHhVxvfYmPRYrQAOhzZcnQ_+6T8nuJQ@mail.gmail.com>
Subject: Re: [PATCH net] net/tcp_fastopen: remove obsolete extern
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 2:20 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> After cited commit, sysctl_tcp_fastopen_blackhole_timeout is no longer
> a global variable.
>
> Fixes: 3733be14a32b ("ipv4: Namespaceify tcp_fastopen_blackhole_timeout knob")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Acked-by: Wei Wang <weiwan@google.com>

>  include/net/tcp.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 17df9b047ee46dabed8797246f99e1a2fd39c243..784d5c3ef1c5be0b54194711ff7f306d271d95c3 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1709,7 +1709,6 @@ struct tcp_fastopen_context {
>         struct rcu_head rcu;
>  };
>
> -extern unsigned int sysctl_tcp_fastopen_blackhole_timeout;
>  void tcp_fastopen_active_disable(struct sock *sk);
>  bool tcp_fastopen_active_should_disable(struct sock *sk);
>  void tcp_fastopen_active_disable_ofo_check(struct sock *sk);
> --
> 2.32.0.402.g57bb445576-goog
>
