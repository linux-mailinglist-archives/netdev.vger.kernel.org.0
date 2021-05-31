Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50AA3967F7
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhEaSbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 14:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhEaSbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 14:31:34 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BC7C06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 11:29:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k7so8344883ejv.12
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 11:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ordpulkGxN476D5EL8Cq5yew28eKluY7I6AJyK4vPGE=;
        b=YLDaKnax/wZY9UOuR7bSOFDml5OOUTyCTt0VEVVQX+V6PGiXf7oPGrfKKQBEIq3H1B
         yJpwxl2a3Xv5rnx2HbxOpKPvcSb2Rswqhf5ruAamvKwsP4GLLP+B9sQzPKHEKkAmoeV+
         6mvZ/Ea0oXSPvXdl/Xifdvc0o1EUN+dc1End1t9q8tXlWeXhkTnv7+x/zRI44HPWyzUI
         UYXhDoBNC+pN0vfj6zDNHfR6+GgzaW4D+Fgv08FebRzYl0ca/vTa3FiqwGEvVf9Sv9Cb
         8kmCxS7PXdnNjPoDsjWZ+KLWmY++TMP8swnN1xddYsV8FQ/rSXNfEUIQohnVSRaACo2E
         N1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=ordpulkGxN476D5EL8Cq5yew28eKluY7I6AJyK4vPGE=;
        b=pP77pREvNqeutxrQpfyBsgVuF4EWkRw3pYR3Rpj8i6OEUakFy6Q/9cR9yJk1nLYFc/
         zztZi9EeolFrRb64C0haip70hHgDmABSeqsBxcDz1Ae0DyOn54gfuXBBqbABlZTGZQCR
         lt2UIklDMSRxjjmTloQMAYvtMWyv/WisLJbP3ydSkA/elWmstJBZwCmPzS0hsohA9Hg9
         MYL11PsHvNRxtwnJE9yQn/uEt66Doue+JakGDKM85F6Gs7k5y6R/ypUY49SUhPBBeIBb
         U5MmIU4ADH0yXSi5w/glA8Gy41Ay4JWknJHQW160dHuqlBM6K0m1rb+H68YgttpBBGzk
         f8Cg==
X-Gm-Message-State: AOAM530Yq58QA1neTwUxu1If09JmCfi8xR8iIY3n42ynvWVzose9L5M8
        FNZKMW3DlOSsauX3x2uOwupvDztp/k/HovFYjwx8Vw==
X-Google-Smtp-Source: ABdhPJxuUFrSbVbOC0qpq+dPkby+bm8BjMsZ4/MgZxMZvGAFp89+rcUbTdnFugN/3w3WrnsWc2onDtAnZFpIAWwZ0qc=
X-Received: by 2002:a17:906:3057:: with SMTP id d23mr15979838ejd.131.1622485792710;
 Mon, 31 May 2021 11:29:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:394a:0:0:0:0:0 with HTTP; Mon, 31 May 2021 11:29:52
 -0700 (PDT)
X-Originating-IP: [5.35.34.2]
In-Reply-To: <60B24AC2.9050505@gmail.com>
References: <60B24AC2.9050505@gmail.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 31 May 2021 21:29:52 +0300
Message-ID: <CAOJe8K1StX_VDF_pZ3si82a5S9i0-D1YychsikRerUTt+SwtRw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/21, Nikolai Zhubr <zhubr.2@gmail.com> wrote:
> Hello all,
>
> I'm observing a problem with Realtek 8139 cards on a couple of 486
> boxes. The respective driver is 8139too. It starts operation
> successfully, obtains an ip address via dhcp, replies to pings steadily,
> but some subsequent communication fails apparently. At least, nfsroot is
> unusable (it gets stuck in "... not responding, still trying" forever),

What's your qdisc? Recently there was a bug related to the lockless
pfifo_fast qdisc

> and also iperf3 -c xxx when run against a neighbour box on a lan prints
> 2-3 lines with some reasonable 7Mbit/s rate, then just prints 0s and
> subsequently throws a panic about output queue full or some such.
>
> My kernel is 4.14.221 at the moment, but I can compile another if
> necessary.
> I've already tried the "#define RTL8139_DEBUG 3" and "8139TOO_PIO=y" and
> "#define RX_DMA_BURST 4" and "#define TX_DMA_BURST 4" (in case there is
> a PCI burst issue, as mentioned somewhere) and nothing changed whatsoever.
>
> Some additional notes:
> - the problem is 100% reproducable;
> - replacing this 8139 card with some entirely different 8139-based card
> changes nothing;
> - if I replace this 8139 with a (just random) intel Pro/1000 card,
> everything seem to work fine;
> - if I insert this 8139 into some other 486 motherboard (with a
> different chipset), everything seem to work fine again;
> - etherboot and pxelinux work fine.
>
> I'm willing to do some debugging but unfortunately I'm not anywhere
> familiar with this driver and network controllers in general, therefore
> I'm asking for some hints/advice first.
>
>
> Thank you,
>
> Regards,
> Nikolai
>
