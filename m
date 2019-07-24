Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949D774159
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfGXWYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:24:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45041 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfGXWYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:24:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id d79so34954769qke.11;
        Wed, 24 Jul 2019 15:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nf/kjdFILDY0kToHS5bgIM3jS2G2TIGN9csne5L2gaQ=;
        b=el6wjY3V7LixmSHares3AO9oPKxhbOm2sy0eml5k/zDn/K42pnVrPO3IJ/OKmHX54E
         QwnzOVHj2Ewpx4w4hXNeoTCK3lidX5/jUyZ36Z4M7dK3bM/RhPOFUOUFlJafisQ7AXSn
         iUw3D+MIkZ5haT90vsozDgWUUWqNRNSXHsKjTE07uPjva8jtfQzLJdr1fmIAt6lL4fGJ
         OHkREj4voPsSxCs4gkZV0OAkImYNZRTy73tZvTAlO3q4qd+M7woqT25025mywKvVj22Y
         y49I5WMETW/76Y+IuNHJ6e41zW7D3RtvKwn9KaU6qNEiVNRyyJo4Cd3SOqsqMS4IF5Y+
         eEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nf/kjdFILDY0kToHS5bgIM3jS2G2TIGN9csne5L2gaQ=;
        b=mYwEhg4nkFPYbQhJ/fkyk4XUyFUk/Mnng9SPeFv7wCReJaie7pIz9ATUXFciteyQLM
         b0dG280mJhRhwnILIsQ4ejfYzqFBH8j7jUlLHDIghn++UJnRfiIVrcbEZjpC6VJfT8eO
         yEspB813toJCF+qRy8vKw1+2zQWeRpBXDPnHRp2/pRe7baOZitPMVJ18Kwi53FqFaodr
         u+yxfzkfoOYzwFc3rOe+oy/Kd/fDWy2Asm345GS7zSaNAPSQjEJuBVlEWy9AuoC9wiv4
         W+qUVpFnEIBcxRyqo+TOVuYqVhMHY5+XNEQGX1HqA8iMDTbjUYhujeuVCz/2/e9DqpoP
         RPIA==
X-Gm-Message-State: APjAAAXyOeKVGUSuxE0/rLt/Wu9z/ViDAwsGWIutqCg5FhYUQaKTIMsp
        ON4SmSFXW3l58yqSiGCzo7vIZS+LvhEnTXFocHs=
X-Google-Smtp-Source: APXvYqztOUiRpkunWC0PGA5uk7sxOP7pp2rIFkcZE6qoJmgk8Nqdp8QJgXnmeB2ZKVt6O//cJk56qa4Ss3l7rd7ReM4=
X-Received: by 2002:a37:4d82:: with SMTP id a124mr54396991qkb.72.1564007081079;
 Wed, 24 Jul 2019 15:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-3-sdf@google.com>
In-Reply-To: <20190724170018.96659-3-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 15:24:29 -0700
Message-ID: <CAPhsuW4rB3ZBrkCwo5yMHdSNNoE8qwho-5iTqR2cnN6HF76iEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/7] bpf/flow_dissector: document flags
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Describe what each input flag does and who uses it.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  Documentation/bpf/prog_flow_dissector.rst | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> index ed343abe541e..0f3f380b2ce4 100644
> --- a/Documentation/bpf/prog_flow_dissector.rst
> +++ b/Documentation/bpf/prog_flow_dissector.rst
> @@ -26,6 +26,7 @@ and output arguments.
>    * ``nhoff`` - initial offset of the networking header
>    * ``thoff`` - initial offset of the transport header, initialized to nhoff
>    * ``n_proto`` - L3 protocol type, parsed out of L2 header
> +  * ``flags`` - optional flags
>
>  Flow dissector BPF program should fill out the rest of the ``struct
>  bpf_flow_keys`` fields. Input arguments ``nhoff/thoff/n_proto`` should be
> @@ -101,6 +102,23 @@ can be called for both cases and would have to be written carefully to
>  handle both cases.
>
>
> +Flags
> +=====
> +
> +``flow_keys->flags`` might contain optional input flags that work as follows:
> +
> +* ``FLOW_DISSECTOR_F_PARSE_1ST_FRAG`` - tells BPF flow dissector to continue
> +  parsing first fragment; the default expected behavior is that flow dissector
> +  returns as soon as it finds out that the packet is fragmented;
> +  used by ``eth_get_headlen`` to estimate length of all headers for GRO.
> +* ``FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL`` - tells BPF flow dissector to stop
> +  parsing as soon as it reaches IPv6 flow label; used by ``___skb_get_hash``
> +  and ``__skb_get_hash_symmetric`` to get flow hash.
> +* ``FLOW_DISSECTOR_F_STOP_AT_ENCAP`` - tells BPF flow dissector to stop
> +  parsing as soon as it reaches encapsulated headers; used by routing
> +  infrastructure.
> +
> +
>  Reference Implementation
>  ========================
>
> --
> 2.22.0.657.g960e92d24f-goog
>
