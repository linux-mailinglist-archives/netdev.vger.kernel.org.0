Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C2B2BBCE
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfE0Vri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:47:38 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36380 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0Vri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 17:47:38 -0400
Received: by mail-ed1-f65.google.com with SMTP id a8so28535868edx.3;
        Mon, 27 May 2019 14:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r2hVb9lV+h5Cjv2A7/9CvRXwChjiLaizfhnf5GPDNy8=;
        b=KMq58PXOHqmRh9etknlqzjTt9ApCaZvYzMoD8s7UWI4+yq3Faao52SGnblYXeA7iK7
         oMt2IIPiNNg3Hy7Xk0VS6M6ehEWYo55y/EjdrO2ofzkxkfvHtaykuhLFPSGO4BJYn4P9
         DNIeO31lS8wNl9IcpK9qSoHVc4PkuJRDnzRyYjsNAtEnu0EmFRRGjkZlELDnPc2uwgd9
         k5AOlodaikudCJ7fL2lSvEeJnJqGw20iSzKlyq65Vy6/DzvFIK3HqNuTJLQuNJ+PZeja
         2WB+kK1QLuN+6JAHjU08PkZFkXBxLD54WJJoyLcFKku29DpUWgXcZkdsxSLlrM+PfsWt
         +W5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r2hVb9lV+h5Cjv2A7/9CvRXwChjiLaizfhnf5GPDNy8=;
        b=GLkcCYv07GNZ6nQm5OCAQAHXdDX+kWCllZYWNa47uCsHMI8S8+ViZN0wwtEGIi9Gua
         8hNHft1zHBma+p+HoEcx9N1KbnlieFaxfdR8Bq0IfTXesIRdgVtXmses4WvXgCH628VJ
         xQBuOLrUNLWzxI57kSy7zT92UTNhKhlakC5H4U1Bnbrg7AanI+xkfvZCrwkh9EYYPHBI
         kS+/kBT7ggbNso7CCUnAKdTy8ZvTnht9WGyE/l4PlM/wMGg3Vwk+rhvi9X5xVgsd8IcZ
         CI3EI3dGK8a5I+vS64EtbJqu4TIS2ny1Pu0RSM1A3mRSd7TjeOgp3gJSzPdYpnHsCmxc
         Y1Zw==
X-Gm-Message-State: APjAAAXLYEnGvzfc+JSnUTcmvNCS3OxoKzPrg3S6wZJ1jLmqFomRNo20
        RRbyDgEVkv5ughl90BgebE5noaC7qwSy6YRymhg=
X-Google-Smtp-Source: APXvYqxbJd3UOx7Lh3mqPiydq1UqdS9T0mbceyBw3lxWV07n8LvpDz/w/LceS0SVckjaiKZAjcd2BCXARcGKMfmNgt0=
X-Received: by 2002:a05:6402:745:: with SMTP id p5mr29004098edy.62.1558993655959;
 Mon, 27 May 2019 14:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-5-fklassen@appneta.com>
 <CAF=yD-KBNLr5KY-YQ1KMmZGCpYNefSJKaJkZNOwd8nRiedpQtA@mail.gmail.com> <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com>
In-Reply-To: <879E5DA6-3A4F-4CE1-9DA5-480EE30109DE@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 27 May 2019 17:46:59 -0400
Message-ID: <CAF=yD-LQT7=4vvMwMa96_SFuUd5GywMoae7hGi9n6rQeuhhxuQ@mail.gmail.com>
Subject: Re: [PATCH net 4/4] net/udpgso_bench_tx: audit error queue
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 5:30 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Willem,
>
> Thanks for spending so much time with me on this patch. I=E2=80=99m prett=
y
> new to this, so I know I am making lots of mistakes. I have been
> working on a v2 of the selftests in net-next, but want to review the
> layout of the report before I submit (see below).
>
> Also, I my v2 fix in net is still up for debate. In its current state, it
> meets my application=E2=80=99s requirements, but may not meet all of your=
s.

I gave more specific feedback on issues with it (referencing zerocopy
and IP_TOS, say).

Also, it is safer to update only the relevant timestamp bits in
tx_flags, rather that blanket overwrite, given that some bits are
already set in skb_segment. I have not checked whether this is
absolutely necessary.

> I am still open to suggestions, but so far I don=E2=80=99t have an altern=
ate
> solution that doesn=E2=80=99t break what I need working.

Did you see my response yesterday? I can live with the first segment.
Even if I don't think that it buys much in practice given xmit_more
(and it does cost something, e.g., during requeueing).

> I also have a question about submitting a fix in net and a related
> enhancement in net-next. I feel I should be referencing the fix
> in net in my net-next commit, but I don=E2=80=99t know how it should be
> done. Any suggestions?

It is not strictly necessary, but indeed often a nice to have. We
generally reference by SHA1, so wait with submitting the test until
the fix is merged. See also the ipv6 flowlabel test that I just sent
for one example.

> >
> > This would probably also be more useful as regression test if it is in
> > the form of a pass/fail test: if timestamps are requested and total
> > count is zero, then the feature is broken and the process should exit
> > with an error.
>
> I have it set up as a pass/fail test.

Great, thanks.

> Below is a sample output of the
> test, including a failure on IPv6 TCP Zerocopy audit (a failure that may
> lead to a memory leak).

Can you elaborate on this suspected memory leak?

> I wanted to review the report with you before
> I push up the v2 patch into net-next.
>
> Are these extra tests what you were expecting? Is it OK that it doesn=E2=
=80=99t
> flow well?

Do you mean how the output looks? That seems fine.

> Also, there is a failure about every 3rd time I run it,
> indicating that some TX or Zerocopy messages are lost. Is that OK?

No that is not. These tests are run in a continuous test
infrastructure. We should try hard to avoid flakiness.

If this intermittent failure is due to a real kernel bug, please move
that part to a flag (or just comment out) to temporarily exclude it
from continuous testing.

More commonly it is an issue with the test itself. My SO_TXTIME test
from last week depends on timing, which has me somewhat worried when
run across a wide variety of (likely virtualized) platforms. I
purposely chose large timescales to minimize the risk.

On a related note, tests run as part of continuous testing should run
as briefly as possible. Perhaps we need to reduce the time per run to
accommodate for the new variants you are adding.

>
> ipv4
> tcp
> tcp rx:  11665 MB/s   189014 calls/s
> tcp tx:  11665 MB/s   197859 calls/s 197859 msg/s
> tcp rx:  11706 MB/s   190749 calls/s
> tcp tx:  11706 MB/s   198545 calls/s 198545 msg/s
> tcp tx:  11653 MB/s   197645 calls/s 197645 msg/s
> tcp rx:  11653 MB/s   189292 calls/s
> tcp zerocopy
> tcp rx:   6658 MB/s   111849 calls/s
> tcp tx:   6658 MB/s   112940 calls/s 112940 msg/s
> tcp tx:   6824 MB/s   115742 calls/s 115742 msg/s
> tcp rx:   6824 MB/s   115711 calls/s
> tcp rx:   6865 MB/s   116402 calls/s
> tcp tx:   6865 MB/s   116440 calls/s 116440 msg/s
> tcp zerocopy audit
> tcp tx:   6646 MB/s   112729 calls/s 112729 msg/s
> tcp rx:   6646 MB/s   111445 calls/s
> tcp rx:   6672 MB/s   112833 calls/s
> tcp tx:   6672 MB/s   113164 calls/s 113164 msg/s
> tcp tx:   6624 MB/s   112355 calls/s 112355 msg/s
> tcp rx:   6624 MB/s   110877 calls/s
> Summary over 4.000 seconds...
> sum tcp tx:   6813 MB/s     451402 calls (112850/s)     451402 msgs (1128=
50/s)
> Zerocopy acks:              451402 received                 0 errors
> udp
> udp rx:    914 MB/s   651407 calls/s
> udp tx:    925 MB/s   659274 calls/s  15697 msg/s
> udp rx:    919 MB/s   654859 calls/s
> udp tx:    919 MB/s   654864 calls/s  15592 msg/s
> udp rx:    914 MB/s   651668 calls/s
> udp tx:    914 MB/s   651630 calls/s  15515 msg/s
> udp rx:    918 MB/s   654642 calls/s
> udp gso
> udp rx:   2271 MB/s  1618319 calls/s
> udp tx:   2515 MB/s    42658 calls/s  42658 msg/s
> udp rx:   2337 MB/s  1665280 calls/s
> udp tx:   2551 MB/s    43276 calls/s  43276 msg/s
> udp rx:   2338 MB/s  1665792 calls/s
> udp tx:   2557 MB/s    43384 calls/s  43384 msg/s
> udp rx:   2339 MB/s  1666560 calls/s
> udp gso zerocopy
> udp rx:   1725 MB/s  1229087 calls/s
> udp tx:   1840 MB/s    31219 calls/s  31219 msg/s
> udp rx:   1850 MB/s  1318460 calls/s
> udp tx:   1850 MB/s    31388 calls/s  31388 msg/s
> udp rx:   1845 MB/s  1314428 calls/s
> udp tx:   1845 MB/s    31299 calls/s  31299 msg/s
> udp gso timestamp
> udp rx:   2286 MB/s  1628928 calls/s
> udp tx:   2446 MB/s    41499 calls/s  41499 msg/s
> udp rx:   2354 MB/s  1677312 calls/s
> udp tx:   2473 MB/s    41952 calls/s  41952 msg/s
> udp rx:   2342 MB/s  1668864 calls/s
> udp tx:   2471 MB/s    41925 calls/s  41925 msg/s
> udp rx:   2333 MB/s  1662464 calls/s
> udp gso zerocopy audit
> udp rx:   1787 MB/s  1273481 calls/s
> udp tx:   1832 MB/s    31082 calls/s  31082 msg/s
> udp rx:   1881 MB/s  1340476 calls/s
> udp tx:   1881 MB/s    31916 calls/s  31916 msg/s
> udp rx:   1880 MB/s  1339880 calls/s
> udp tx:   1881 MB/s    31904 calls/s  31904 msg/s
> udp rx:   1881 MB/s  1340010 calls/s
> Summary over 4.000 seconds...
> sum udp tx:   1912 MB/s     126694 calls (31673/s)     126694 msgs (31673=
/s)
> Zerocopy acks:              126694 received                 0 errors
> udp gso timestamp audit
> udp rx:   2259 MB/s  1609327 calls/s
> udp tx:   2410 MB/s    40879 calls/s  40879 msg/s
> udp rx:   2346 MB/s  1671168 calls/s
> udp tx:   2446 MB/s    41491 calls/s  41491 msg/s
> udp rx:   2358 MB/s  1680128 calls/s
> udp tx:   2448 MB/s    41522 calls/s  41522 msg/s
> udp rx:   2356 MB/s  1678848 calls/s
> Summary over 4.000 seconds...
> sum udp tx:   2494 MB/s     165276 calls (41319/s)     165276 msgs (41319=
/s)
> Tx Timestamps:              165276 received                 0 errors
> udp gso zerocopy timestamp audit
> udp rx:   1658 MB/s  1181647 calls/s
> udp tx:   1678 MB/s    28466 calls/s  28466 msg/s
> udp rx:   1718 MB/s  1224010 calls/s
> udp tx:   1718 MB/s    29146 calls/s  29146 msg/s
> udp rx:   1718 MB/s  1224086 calls/s
> udp tx:   1718 MB/s    29144 calls/s  29144 msg/s
> udp rx:   1717 MB/s  1223464 calls/s
> Summary over 4.000 seconds...
> sum udp tx:   1747 MB/s     115771 calls (28942/s)     115771 msgs (28942=
/s)
> Tx Timestamps:              115771 received                 0 errors
> Zerocopy acks:              115771 received                 0 errors
> ipv6
> tcp
> tcp tx:  11470 MB/s   194547 calls/s 194547 msg/s
> tcp rx:  11470 MB/s   188442 calls/s
> tcp tx:  11803 MB/s   200193 calls/s 200193 msg/s
> tcp rx:  11803 MB/s   194526 calls/s
> tcp tx:  11832 MB/s   200681 calls/s 200681 msg/s
> tcp rx:  11832 MB/s   194459 calls/s
> tcp zerocopy
> tcp rx:   7482 MB/s    80176 calls/s
> tcp tx:   7482 MB/s   126908 calls/s 126908 msg/s
> tcp rx:   6641 MB/s   112609 calls/s
> tcp tx:   6641 MB/s   112649 calls/s 112649 msg/s
> tcp tx:   6584 MB/s   111683 calls/s 111683 msg/s
> tcp rx:   6584 MB/s   111617 calls/s
> tcp zerocopy audit
> tcp tx:   6719 MB/s   113968 calls/s 113968 msg/s
> tcp rx:   6719 MB/s   113893 calls/s
> tcp rx:   6772 MB/s   114831 calls/s
> tcp tx:   6772 MB/s   114872 calls/s 114872 msg/s
> tcp tx:   6793 MB/s   115226 calls/s 115226 msg/s
> tcp rx:   7075 MB/s   116595 calls/s
> Summary over 4.000 seconds...
> sum tcp tx:   6921 MB/s     458580 calls (114645/s)     458580 msgs (1146=
45/s)
> ./udpgso_bench_tx: Unexpected number of Zerocopy completions:    458580 e=
xpected    458578 received

Is this the issue you're referring to? Good catch. Clearly this is a
good test to have :) That is likely due to some timing issue in the
test, e.g., no waiting long enough to harvest all completions. That is
something I can look into after the code is merged.
