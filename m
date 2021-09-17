Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1628040F2E3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 09:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbhIQHHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 03:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhIQHHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 03:07:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3088C061574;
        Fri, 17 Sep 2021 00:05:46 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g8so26331435edt.7;
        Fri, 17 Sep 2021 00:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LOf9q8mzRbrki3yO6fFFe1tHU9nCuZIdyCWgTW4OGdA=;
        b=iB7h4R1HUWPZhGhJMLhcz8TKDFFCPpH7xrZgXkJftoFiQjrc/3fINEo91sdBWOGb+R
         KRxCncPeflGcZti4/AufknoT8RYb5I2MgI0tLXL6aXBBo9cpZWzuyx32nLAFYT1J8uSa
         eDBDznX6iGgzsR+iewW8o0eYpgApwZ6fxUzpF0uihtUnVtEp20ahmXUq3Wt6IaA9qF9a
         waWcz/U+zJGdmUVMpUkMxNspdtsNdBUMtlRCkM5nJttMrWTQnYDAZfkkplo0EvmVX53o
         u8xlvHe3I+Kt1O+O8zIm8ypdYiKMrPa0GB4XPeUWCzz1ydPTzBTv3/4LW85TfTjux65+
         oUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LOf9q8mzRbrki3yO6fFFe1tHU9nCuZIdyCWgTW4OGdA=;
        b=1e9q0cp82TjnC5lATx91DZ9oD5lfgb0vX3ouHewB3o8HcLB5kajba2lUQZNT3rjwre
         bYbdXU6DuHs29QE/UdcfyfUp5fIbuN4VEdPrSrpTIiYFq0sXV5y/8Bqr6APD4KzfcnMT
         hx/I2HIdvSxnb9Y4SU7G2Kb78q9Q0TIqum0bj7hwPJs9w+gQQhzSrwLZqfMPg4y/2Z7S
         kJoN5y+IDVFrx7lT6VyqFcCZQjTMYN9dUhmObAItmHwdt6WlxyKPsGJTe0D7Gn1eC9c7
         DfzCeeLTPtBb1HI3A1GcSXGubqtxgz3rVDlKw1ZbgSnomDaylXw8QknZb97fFrc+LZhj
         psNw==
X-Gm-Message-State: AOAM533P3XfP6gS2pdY/DVRNQ2BgspWB+se70uw9qNJnKQ1nLNyoxjh7
        w2Uc3AZzxg0lX+c4bKNKdxpXnFdoMbKNWRJbKqbaiUg8Qmg=
X-Google-Smtp-Source: ABdhPJzegCOcNu1KG+Ti0ofsT10EcuDXbFKXPHUoS/WYx/05/2ahSwi+duoRXnk9RI6DEXKouOpzVEA49uDqY0esGfQ=
X-Received: by 2002:a17:906:a04f:: with SMTP id bg15mr11126041ejb.417.1631862345264;
 Fri, 17 Sep 2021 00:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <7e1d0cae-ebd0-d7b0-cfe3-80b38ea8fbfb@gmail.com>
In-Reply-To: <7e1d0cae-ebd0-d7b0-cfe3-80b38ea8fbfb@gmail.com>
From:   Eugene Syromyatnikov <evgsyr@gmail.com>
Date:   Fri, 17 Sep 2021 09:05:41 +0200
Message-ID: <CACGkJdvEP17+B0-Y42V5Szf_4WF8C2cu11QQU+imy9+0j_Aopg@mail.gmail.com>
Subject: Re: [BUG?] ipv6.7: SOCK_DGRAM can accept different protocols?
To:     Alejandro Colomar <colomar.6.4.3@gmail.com>
Cc:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org, linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 8:13 AM Alejandro Colomar
<colomar.6.4.3@gmail.com> wrote:
>
> Hi,
>
> Reading a stackoverflow question
> <https://stackoverflow.com/questions/51996808/do-we-need-to-specify-protocol-when-type-is-sock-dgram-or-sock-stream-in-soc>
> it noted that, while ip(7) notes that protocol can be left as 0 for both
> SOCK_STREAM and SOCK_DGRAM, ipv6(7) is misleading and seems to suggest
> that protocol may be significant for SOCK_DGRAM (at least in the SYNOPSIS).

It can be left as 0, but, I think, IPPROTO_UDPLITE (at least) can be
specified in both cases, if the caller wishes so (as well as
IPPROTO_MPTCP/IPPROTO_SCTP for SOCK_STREAM, and some other, more
obscure protocols, like DCCP or L2TP).

> I guess that's not true, and it can be left as 0, but since I don't
> know, I'll ask.
>
> Thanks,
>
> Alex
>
>
> --
>
> IP(7)                Linux Programmer's Manual               IP(7)
>
> NAME
>         ip - Linux IPv4 protocol implementation
>
> SYNOPSIS
>         #include <sys/socket.h>
>         #include <netinet/in.h>
>         #include <netinet/ip.h> /* superset of previous */
>
>         tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
>         udp_socket = socket(AF_INET, SOCK_DGRAM, 0);
>         raw_socket = socket(AF_INET, SOCK_RAW, protocol);
>
>
> --
>
> IPV6(7)              Linux Programmer's Manual             IPV6(7)
>
> NAME
>         ipv6 - Linux IPv6 protocol implementation
>
> SYNOPSIS
>         #include <sys/socket.h>
>         #include <netinet/in.h>
>
>         tcp6_socket = socket(AF_INET6, SOCK_STREAM, 0);
>         raw6_socket = socket(AF_INET6, SOCK_RAW, protocol);
>         udp6_socket = socket(AF_INET6, SOCK_DGRAM, protocol);
>
>
> --
> Alejandro Colomar
> Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
> http://www.alejandro-colomar.es/



-- 
Eugene Syromyatnikov
mailto:evgsyr@gmail.com
xmpp:esyr@jabber.{ru|org}
