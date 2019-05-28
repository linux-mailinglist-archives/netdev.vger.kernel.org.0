Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FBF2D017
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfE1UJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:09:46 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:45360 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfE1UJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:09:46 -0400
Received: by mail-ed1-f44.google.com with SMTP id g57so18751971edc.12;
        Tue, 28 May 2019 13:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lfHCjXdAucK32QgcRHWRo0qGiwkfsWt0JaYloVUGZf8=;
        b=aMrOykYI9DVuCfBXVLxQVyW1/LvVXswL14cMijeWdx6z6rYgK4R+gUCF8m4QGXl3GC
         PH2AX2SanfnRTvIcsED/auiDa8GgMJWc1HPb/GzwSeHbf9XbWEJJjCdMCBbhd1tHU5l6
         oWFtcAnz/UppSHrWFQkMPoclKzVxPe+xPXfICEFPMTT0/zmhf+7vuCsYPO+p5HOp1DTg
         bVPKFGkYERvF62gaAVv03CueyoCR16ooiBIHG3Cv1ZNsyogwMRLWuXvvxiaXIKEwyn2A
         wbxe/Cf6WieOJeKpWugbNZ2uuahlrgBUrxYHBYBBqrr6S0K4TBIwbocYz2kpt6Q9pSgw
         5gUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lfHCjXdAucK32QgcRHWRo0qGiwkfsWt0JaYloVUGZf8=;
        b=NnPPU/f0afTgF1k7SvjtyAMUNqq0zdTCQznuf7KngD6Os0b845fvyVlSBiAx6rpeHd
         HtnEKNh9dKOefOqBvY7xy23OvWcHXYJhGXW3IEq3N7qGNWlP1VQVtOzrsoaD9c+JiZkf
         Nher+UkzaLBKKsg/FPsOz1M3FL5rYuVkg2z0dQ9kQ1q1ivJfEFejCR0OUV8QyTMbR9Va
         i7XyZf/5+ctFUA0x2FUbt5cErf/yqvIUtS4M21/fXyIW4hakRB0oZJEriAAaxgvaFzfo
         a/sHRUkWMKt20g51yf62RUwgVrV1rSacP+zNoIk+i3m5rEaVXenfGTzDHJVcDkfhTFi8
         HTGA==
X-Gm-Message-State: APjAAAVC/h2+NjjXwiLwCDMKg5ifh/XEtn8myDZ5JFoy6Bp1e76nCcxh
        jGgZiO6k4ArZB/1rH89JxRUPDi1rGIxI24j+Hkw=
X-Google-Smtp-Source: APXvYqzEOeZWC9L1vOMmqxVgoI1B8bDBS/QAi758qW8Lu/Q0XsVo+3caRyPLEpsaQ9+8ScyzX8Wa1c4SeLkbV4L9qVg=
X-Received: by 2002:a17:907:397:: with SMTP id ss23mr6839098ejb.226.1559074184038;
 Tue, 28 May 2019 13:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190528184708.16516-1-fklassen@appneta.com> <20190528184708.16516-3-fklassen@appneta.com>
In-Reply-To: <20190528184708.16516-3-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 16:09:07 -0400
Message-ID: <CAF=yD-KozDxhwf1Arkbz5X_dYfZ5M40xr9hcxKGDRmeg1BOE=Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net/udpgso_bench.sh add UDP GSO audit tests
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 3:24 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Audit tests count the total number of messages sent and compares
> with total number of CMSG received on error queue. Example:
>
>     udp gso zerocopy timestamp audit
>     udp rx:   1599 MB/s  1166414 calls/s
>     udp tx:   1615 MB/s    27395 calls/s  27395 msg/s
>     udp rx:   1634 MB/s  1192261 calls/s
>     udp tx:   1633 MB/s    27699 calls/s  27699 msg/s
>     udp rx:   1633 MB/s  1191358 calls/s
>     udp tx:   1631 MB/s    27678 calls/s  27678 msg/s
>     Summary over 4.000 seconds...
>     sum udp tx:   1665 MB/s      82772 calls (27590/s)      82772 msgs (27590/s)
>     Tx Timestamps:               82772 received                 0 errors
>     Zerocopy acks:               82772 received                 0 errors
>
> Errors are thrown if CMSG count does not equal send count,
> example:
>
>     Summary over 4.000 seconds...
>     sum tcp tx:   7451 MB/s     493706 calls (123426/s)     493706 msgs (123426/s)
>     ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    493706 expected    493704 received
>
> Also reduce individual test time from 4 to 3 seconds so that
> overall test time does not increase significantly.
>
> Signed-off-by: Fred Klassen <fklassen@appneta.com>

Acked-by: Willem de Bruijn <willemb@google.com>

If respinning the series, please add a comment about adding -P to the
tcp zerocopy test.
