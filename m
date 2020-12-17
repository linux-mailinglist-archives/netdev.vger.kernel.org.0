Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0BD2DD867
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgLQSbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730257AbgLQSbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:31:22 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A851C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:30:42 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx16so39314285ejb.10
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lfC4hlaL3cRkORnIhJHCSr0BxESS7DkrkwZH7VfEONE=;
        b=KW4eoHJUzv8FZwvTPkjCkmNEZNyTPitaUCkJwgZBEN567MZsJ/cPY9UHuiZK+XgGU8
         wPRsweKH/13xKfLijHBn77WFwj0hWDYvQMLLXb2f9Ula/ewn/5nyVNXo5HaN1UvJFGK7
         197cyQAp5Q+/uVdUr4Yb/jljMJwXf9Vl98H1XVzD2POU6ciZcITF+udLjSUM3OH7tzev
         KZAr86f+fQk/hRmnBf1yqE3JbZKIC2xwFrSnDi6lUXJQH8mUf+EtwaGgMyoFAKRC09KC
         sCyPlG9XP0sBVoPEtGnkYmtkydP8GLgvY+87cKq4pxhVZqj5Rfs7WfYRRzT+ezAySK7h
         MyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lfC4hlaL3cRkORnIhJHCSr0BxESS7DkrkwZH7VfEONE=;
        b=X/hLnVw1S2JZ6KHgSCXArBxBN3EBufD3/FhycMn3HLkMSzm/5utm4LT4aZ16s6vX/J
         XeDzCWnIaHSEbLishVKXa18oewrDwpp71VvJFQSHIty2F2ptfV9Io0h7GEtTOTKkjF8P
         oqVq++N1ndS4uiPrYtIPr7Ob0zsrqLhitQ7Q2FTvnVIEptblrmakQfjUNlW1CLRv2wJ+
         Yaon9onTntAv/k5UZqpfLaDqC/WJuEfiV0UrQZoyiR73TMby3d9dfyKWNZ+mx7v805dr
         kJjzCalSi0hCLs+gcR6XIsjHw0u0TvrbjpeluitcEJnudUpaQFIiXCSLvyTLjvPkmSmW
         jzqQ==
X-Gm-Message-State: AOAM5324as9HbvU2sQLrGfll441E273d8H95yBnGqDz2ktQSegvxrLO8
        Zf/EoFF6M2pzxOhgdeTEVxf26e/EIhw/W2UerVeyhg==
X-Google-Smtp-Source: ABdhPJwqUl1NfD35pInUwcGmi5kCnCZ5IhiKuXoyxIPSLM/IG5PsUuq5l7VkYFF5OTIKPbSKiBVauiaH0BaSzIIVULo=
X-Received: by 2002:a17:906:7cc6:: with SMTP id h6mr289282ejp.161.1608229841149;
 Thu, 17 Dec 2020 10:30:41 -0800 (PST)
MIME-Version: 1.0
References: <20201216225648.48037-1-v@nametag.social> <5869aae1-400c-94a4-523e-e015f386f986@kernel.dk>
In-Reply-To: <5869aae1-400c-94a4-523e-e015f386f986@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Thu, 17 Dec 2020 18:30:30 +0000
Message-ID: <CAM1kxwiwCsMig+1AJQv0nTDOKjjfBS5eW5rK9xUGmVCWdbQu3A@mail.gmail.com>
Subject: Re: [PATCH net-next v5] udp:allow UDP cmsghdrs through io_uring
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

might this still make it into 5.11?

On Thu, Dec 17, 2020 at 3:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/16/20 3:56 PM, Victor Stewart wrote:
> > This patch adds PROTO_CMSG_DATA_ONLY to inet_dgram_ops and inet6_dgram_ops so that UDP_SEGMENT (GSO) and UDP_GRO can be used through io_uring.
> >
> > GSO and GRO are vital to bring QUIC servers on par with TCP throughputs, and together offer a higher
> > throughput gain than io_uring alone (rate of data transit
> > considering), thus io_uring is presently the lesser performance choice.
> >
> > RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
> > GSO is about +~63% and GRO +~82%.
> >
> > this patch closes that loophole.
>
> LGTM
>
> Acked-by: Jens Axboe <axboe@kernel.dk>
>
> --
> Jens Axboe
>
