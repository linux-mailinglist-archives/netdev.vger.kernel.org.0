Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E874597BF
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 23:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhKVWhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 17:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhKVWha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 17:37:30 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB879C061714
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 14:34:23 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id h16-20020a9d7990000000b0055c7ae44dd2so30931286otm.10
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 14:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I04oNPwT2LiIQ3uhsXlgCjlTAN3glQ39ci7yvZbbCc8=;
        b=RE8czrGCfJ5Ok1yftGNCD72TpenCGVexOBvvKK+7mx26OyVruGpWUWKnSPAVedDr/H
         M73Jb+15oHAm53LD9pChmqgwTj5RL6ZfS7RWuRF2F/QsMZmRUrYms/qsefi/THaw1klg
         vUITpnVmayybSV/dumBEr/AtGN3QKTXnofLQKQA+1Fe2kwQl9h75d9mkLJALbfn97QQo
         4BMC3bOGlFvFrO7c4cMVvVR0I9oPS+GHhdtJuAlbksUmN15xqYUEgeYDUiQ3OQYGNIwm
         KMcQs9iycXLAsNK51uVzn/cG/rOcaiATG06mw0ahzSl6s0BWfHc+9Vb4e4JcZUwTQK7q
         NGDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I04oNPwT2LiIQ3uhsXlgCjlTAN3glQ39ci7yvZbbCc8=;
        b=mblAklrOs9uJUBt+bgu7sj/IaVHPN6zuRQwVOF5TAUy78OM0nZPqi3FaFuYyqGKZID
         +QvlcLdYZBj15t6gRso8hg9w3AKN/r6dvvZ18OHze+gka7o7P2S9uv44Zlw1x9BnTDot
         sgtqVrIjgtbMTcg1bS7ARcemnxtIetRt34hWdlldOSzGt4VZH8AkhMZ5B9SV28hDAfiw
         NSIupN3aZ/C5PngGZ3iDagKWuuEy/g1Go5mY03KtwOdza/YS0Ho3zZs+mW9qmTYJ+Y6O
         vhIUnYKaf2P3Zf2Ms/dFZnj951NpueESUggGPATOFVo00Eiul5m/jtt3Rev4gUNuZjgj
         TSLQ==
X-Gm-Message-State: AOAM530JfzZnjMFdfD1sKtSKAJpaGPC4iygjgC2rBp3Z5NrlYQu1L0Mc
        gLmd7+tpCVxU7hP6Acw6jVUay1T4ylN/1s6Nwf5zY60jMk0=
X-Google-Smtp-Source: ABdhPJxB5TuOm794DPnunnfv4u71Kmfx0jbthcxCYfOvI4cr2nNBsq93NmFQjmRRFwM/fbwniWvOeN7jp4OlIU/bAiw=
X-Received: by 2002:a9d:74d0:: with SMTP id a16mr659095otl.237.1637620462604;
 Mon, 22 Nov 2021 14:34:22 -0800 (PST)
MIME-Version: 1.0
References: <20211122104607.3145732-1-linus.walleij@linaro.org>
In-Reply-To: <20211122104607.3145732-1-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 22 Nov 2021 23:34:10 +0100
Message-ID: <CACRpkdZTxH+5A9tCkoa5Y_3U8iM=b5NQAKQ3Ogpmv9emsaKXQg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] dt-bindings: net: Add bindings for IXP4xx
 V.35 WAN HSS
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 11:48 AM Linus Walleij <linus.walleij@linaro.org> wrote:

> This adds device tree bindings for the IXP4xx V.35 WAN high
> speed serial (HSS) link.
>
> An example is added to the NPE example where the HSS appears
> as a child.
>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Add intel vendor prefix on custom queue handle bindings.
> - Make the pkt-tx and pkt-rxfree into arrays of handles.

I found some problems with my own bindings when converting
the driver over, I will resend a v3 along with the driver changes
in a separate patch.

Yours,
Linus Walleij
