Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C23C3BE76A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGGLwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231359AbhGGLwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625658594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V9IeRsZw5PJvZd39/8U4Y4h8zF+fv0utrTPDsntgLyw=;
        b=GgFLIpRVoC4yvvgcpAWBF5KMYfxv9Fy186a+oxW6WYyulaUMBoWIsDSNVkL9sieID8cuXU
        ZXYajQUfvP7doxI25r9k70FgjYifBn8Bs5bji0QvXEtEdfmIIEkrFpT3p5phC7No9mMXEn
        XpE9RTycYHR0wNqd82Ozi6XsYSPeYzM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-BOHkuAnlPDO9XDM20hk7_g-1; Wed, 07 Jul 2021 07:49:51 -0400
X-MC-Unique: BOHkuAnlPDO9XDM20hk7_g-1
Received: by mail-il1-f200.google.com with SMTP id j6-20020a926e060000b02901f2f7ba704aso1304735ilc.20
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 04:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V9IeRsZw5PJvZd39/8U4Y4h8zF+fv0utrTPDsntgLyw=;
        b=dwC45uLA0vNDFfiBsXnu4MJwPu7rOk1iWA4Wjy8Li59sOR1xQKETkNR0RVLJChe+KT
         09H51f2tD7QMhD5VtkYDeLHHVPVqvKSq3aPo8rIPSelN2Gaq07FecYDKj6svrkvqFERR
         0FnkSH1fXdpoo4UiHOwdKj+sbA2b1rwAB5v/UmPO0yOSLDvCXUrAw7PTU0tkzKShHNpr
         w/0vc0sBN5X7jnxQAnACppWyEfw4keuHws5G7gBad3NrTxhGpRWR7KX55+3Bm6YIpEEQ
         VpUcMrpNeEncxGwXap+Jhn4Y5BDsbWw1QRHsxzEHZ0q0HquENRb/j/hfRCIEuS63LWtH
         NEuw==
X-Gm-Message-State: AOAM532V5XSpYXzGW7vTsJ6jD4QaQ/2DttaDTPbM9bRhOVTcbdwV44tO
        RKfpXQEb81rznMGpsgYWJC4F+E1szhmc1VWGA4FnqbYXB/YcYCkR3F/XBBKDs3pENPI+prc+YAU
        /mEBR8V+YCuJGgdmA0TBRwKGuG+n8yGTO
X-Received: by 2002:a05:6638:372c:: with SMTP id k44mr21292756jav.94.1625658590882;
        Wed, 07 Jul 2021 04:49:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1PpXk8l3QPiePPFgU87c/Z7Y4/M0/ObejD1R0o+v/1m5fzGQGBRgt5e6UnX4NnAmxao/v/1ZmNlV0+xYGNpw=
X-Received: by 2002:a05:6638:372c:: with SMTP id k44mr21292740jav.94.1625658590743;
 Wed, 07 Jul 2021 04:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210707081642.95365-1-ihuguet@redhat.com> <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
In-Reply-To: <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 7 Jul 2021 13:49:40 +0200
Message-ID: <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev queues"
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     habetsm.xilinx@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 1:23 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
> Should we then be using min(tx_per_ev, EFX_MAX_TXQ_PER_CHANNEL) in the
>  DIV_ROUND_UP?

Could be another possibility, but currently that will always result in
EFX_MAX_TXQ_PER_CHANNEL, because tx_per_ev will be 4 or 8 depending on
the model. Anyway, I will add this change to v2, just in case any
constant is changed in the future.

> And on line 184 probably we need to set efx->xdp_tx_per_channel to the
>  same thing, rather than blindly to EFX_MAX_TXQ_PER_CHANNEL as at
>  present =E2=80=94 I suspect the issue you mention in patch #2 stemmed fr=
om
>  that.
> Note that if we are in fact hitting this limitation (i.e. if
>  tx_per_ev > EFX_MAX_TXQ_PER_CHANNEL), we could readily increase
>  EFX_MAX_TXQ_PER_CHANNEL at the cost of a little host memory, enabling
>  us to make more efficient use of our EVQs and thus retain XDP TX
>  support up to a higher number of CPUs.

Yes, that was a possibility I was thinking of as long term solution,
or even allocate the queues dynamically. Would this be a problem?
What's the reason for them being statically allocated? Also, what's
the reason for the channels being limited to 32? The hardware can be
configured to provide more than that, but the driver has this constant
limit.

Another question I have, thinking about the long term solution: would
it be a problem to use the standard TX queues for XDP_TX/REDIRECT? At
least in the case that we're hitting the resources limits, I think
that they could be enqueued to these queues. I think that just taking
netif_tx_lock would avoid race conditions, or a per-queue lock.

In any case, these are 2 different things: one is fixing this bug as
soon as possible, and another thinking and implementing the long term
solution to the short-of-resources problem.

Regards
--=20
=C3=8D=C3=B1igo Huguet

