Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189163C57C3
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354550AbhGLIhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 04:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377495AbhGLIgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 04:36:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64C7C0612FB;
        Mon, 12 Jul 2021 01:31:07 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x16so15686657pfa.13;
        Mon, 12 Jul 2021 01:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=USZiAAsnNcmx97R7p1M6PzM3se8C57lt9HYxN0V6Qcc=;
        b=nvP+/a5+jVKWMsXjzHgZAxWI7uuGev/9/hYI2pyS812qZBb67A6fFrDSIJV4U39e1t
         oo3ncUvbPQo/vZkBRCE6n2p5+sRpwBaRlWERd17F4ef1jXACYADGrLqlXqD9T56jqS03
         4R9R8ud3J7125ui7qBBBTlNAMeVzYFQyPETpnnqDLisqSA3o6VAqdZKJX/QImk8M8h0D
         7SY4U0HFwTfELBctlQohvEty+YKB8q4nPgln7C3YGIQiGmTvEj4yHidktz7ybydgeHjc
         TCOnM9TKlYpzDEl+21af8DiiXImbagGDJhzzQdIfBPHHylQw/mxUL0gTR+Ng8Bq/ppah
         Py6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=USZiAAsnNcmx97R7p1M6PzM3se8C57lt9HYxN0V6Qcc=;
        b=tIrJGrjajg/MyglbnksmI76j+LFGFbeeqz4IQBAvRmrHAWdSugahg140O64E0AC34L
         /qqWdTFzCRRQ7exNOZODmGpMD0hUaOHE3/sWIQtx+8g1s/hiBRP3+Kt1m7Vhs/hVeZNx
         sZYjlUFULyrzN/70F7B8c/vzGFRxXdSzZm96Wrld5yq/q2grw3D9p8mG/exwCXC9spOI
         U8TR4MqQjdTDomhCi/cxfWrymagOGObJLoyCoFBXlGluDLwPWWfgThWxiGwcPonpnF01
         KcsmTs5rU8h5SO190tsMs4dN8QeN3tJ5jrU9jj/pX6WGhd4Z+u0H3+Ic7d2XhFzNuGe6
         TfvQ==
X-Gm-Message-State: AOAM531B0rR0bCWy2ZMakUOpyBWBvzK8IGhIwLT7lt3drTKUfsciByun
        G60nN3DqUbWpHAMikr3r8sEF7BMezVn6D4yc2G0=
X-Google-Smtp-Source: ABdhPJycqFu8SXQ7kbd6Rwqxf4o8DNaLb2XVL4awwvXXUR3sR4jqJjtpCVD5oivruxCHNMyRZ7tBfTqNQMR53EcvLeY=
X-Received: by 2002:a63:383:: with SMTP id 125mr47405385pgd.208.1626078667214;
 Mon, 12 Jul 2021 01:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <1656fdf94704e9e735df0f8b97667d8f26dd098b.1625550240.git.baruch@tkos.co.il>
In-Reply-To: <1656fdf94704e9e735df0f8b97667d8f26dd098b.1625550240.git.baruch@tkos.co.il>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 12 Jul 2021 10:30:56 +0200
Message-ID: <CAJ8uoz1+-DX=sKDjKnqDuHAW1x7bmszpYyZQZB6cT7nJ951Nxw@mail.gmail.com>
Subject: Re: [PATCH] doc/af_xdp: fix bind flags option typo
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 7:50 AM Baruch Siach <baruch@tkos.co.il> wrote:
>
> Use 'XDP_ZEROCOPY' as this options is named in if_xdp.h.
>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  Documentation/networking/af_xdp.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks Baruch! Sorry for the delay. Been on vacation for a week.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
> index 42576880aa4a..60b217b436be 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -243,8 +243,8 @@ Configuration Flags and Socket Options
>  These are the various configuration flags that can be used to control
>  and monitor the behavior of AF_XDP sockets.
>
> -XDP_COPY and XDP_ZERO_COPY bind flags
> --------------------------------------
> +XDP_COPY and XDP_ZEROCOPY bind flags
> +------------------------------------
>
>  When you bind to a socket, the kernel will first try to use zero-copy
>  copy. If zero-copy is not supported, it will fall back on using copy
> @@ -252,7 +252,7 @@ mode, i.e. copying all packets out to user space. But if you would
>  like to force a certain mode, you can use the following flags. If you
>  pass the XDP_COPY flag to the bind call, the kernel will force the
>  socket into copy mode. If it cannot use copy mode, the bind call will
> -fail with an error. Conversely, the XDP_ZERO_COPY flag will force the
> +fail with an error. Conversely, the XDP_ZEROCOPY flag will force the
>  socket into zero-copy mode or fail.
>
>  XDP_SHARED_UMEM bind flag
> --
> 2.30.2
>
