Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893AF2D8898
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407620AbgLLR0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404061AbgLLR0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 12:26:03 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A22C0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:25:22 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id g20so16815951ejb.1
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SAldZ74f52N8LRAOY/OkuOIkIq54RAnc0rfu0esyOak=;
        b=KtLAYTAumTAAiIVaIXhMvc8ulaUr5px3LY/u/JfMH8L7rsXy2sNKQz1Eura21RPM6w
         hcvJ+94f6w/sI+jqIjF67pGEZEazW4aBUJpjt2hSpnGrIOd6LqpJZ6G6xUJWT1ZOejcn
         Ju7wmr4eQhq8+ozOrGMSkAOb1U3v6rXiAzN98WWcRxk1EdfY2og9eTleyFqaAy3RKIb6
         1z3kgb3dH//Q700fVVP0qyTTuxtveppMZrPJGTV/53szwg+o67ThhSglCdjwV/ULNiJA
         5fZyqCZ0zMVRzDg+CC0AiIf31pNtiaNMQRjLPv2tI/CNEDCBjGzq0ecoi4drfcjA67Ur
         /PAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SAldZ74f52N8LRAOY/OkuOIkIq54RAnc0rfu0esyOak=;
        b=gdXzDoFqJmuwY5G4bZtTapCbhojgYju5K3DDpCpnOLkR/XMNwI6sdNQURX/ndQPcrw
         v3+CpfGUU8pwHvtXKWiyGhouOP6VsQIMc4/zw65GDcDrWFck6I5rR1GuUifAKenwG8Vf
         p2b8paAuU5u6TXl2HpJFHSW1qBpvDBEKpBiSbJ4CfO06c6mkv6b9JYsMix7Hk8hgabAX
         iMTKYZ+3NyGrn0PWKOuXFtryikbsd3o5I7CklSRuREC1R83stregJRhikQ/3SS8Gz9dq
         gOzTBQEm+6e9U9OO6qdu5NTEoKkX4nV0RH9ed0GNlYKLW2caES0cuz7f6/JQMO3o12Yz
         +VBQ==
X-Gm-Message-State: AOAM532Hr2QUk0IUDQUhOtm6cxIDtcDBQeQ5lTOSEzYhkCGhYVho7/Fz
        yRcd5xsQ61DWE93vw4NE9LXgtYCmoukL44m7iRoiQA==
X-Google-Smtp-Source: ABdhPJyOcbrN+3OO1JVaS0DnmPSza1uvHn4A4HpY6XtcyuBaJei0tsFDd2JKEjmNWKDqPrwzp0CNZPu9eB/0na/pbDY=
X-Received: by 2002:a17:906:5912:: with SMTP id h18mr15661572ejq.261.1607793921384;
 Sat, 12 Dec 2020 09:25:21 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
 <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk>
In-Reply-To: <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 17:25:10 +0000
Message-ID: <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
Subject: Re: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/12/20 8:31 AM, Victor Stewart wrote:
> > RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
> > cmsgs" thread...
> >
> > https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
> >
> > here are the patches we discussed.
> >
> > Victor Stewart (3):
> >    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
> >    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
> >    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
> >
> >    net/ipv4/af_inet.c
> >      |   1 +
> >    net/ipv6/af_inet6.c
> >     |   1 +
> >    net/socket.c
> >        |   8 +-
> >    3 files changed, 7 insertions(+), 3 deletions(-)
>
> Changes look fine to me, but a few comments:
>
> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
>   could actually be used.

right that makes sense.

>
> - For adding it to af_inet/af_inet6, you should write a better commit message
>   on the reasoning for the change. Right now it just describes what the
>   patch does (which is obvious from the change), not WHY it's done. Really
>   goes for current 1/3 as well, commit messages need to be better in
>   general.
>

okay thanks Jens. i would have reiterated the intention but assumed it
were implicit given I linked the initial conversation about enabling
UDP_SEGMENT (GSO) and UDP_GRO through io_uring.

> I'd also CC Jann Horn on the series, he's the one that found an issue there
> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.

I CCed him on this reply. Soheil at the end of the first exchange
thread said he audited the UDP paths and believed this to be safe.

how/should I resubmit the patch with a proper intention explanation in
the meta and reorder the patches? my first patch and all lol.

>
> --
> Jens Axboe
>
