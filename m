Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AA2307F0F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhA1T7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 14:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhA1T7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 14:59:03 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A696C061793;
        Thu, 28 Jan 2021 11:58:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z22so8050670edb.9;
        Thu, 28 Jan 2021 11:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGjxqmV0DkXFcXzzSJ8LFqABMT7fBMXHiBKy/LXov0A=;
        b=E57LN2ZuPFivoFrwH6HgbngyfCdLVYSMSo9142Nh8etq33WDLlO2fTK2WgEJvP7tkW
         tkEZ/9LbEAucc/i6XIT7cr1rALIZQyOgkJuEbj/n3mQyHZI6ZqggQSvhGcnynRaJkhOs
         wM9GxHtTe8Ec3zB87Oo1RJwSH5Opc6jmZm19DZxgDfX0FcAhZUVWaYPlf4EkKfTtmf67
         op5pYlY6xL2yi7f7cCpyiaVCzhcjPvxeHhvPP4nS/TW9Os1UulY1i0o8f8HLuGYQHex3
         K1roBDPpZBPPvWahwoQ40c3cfYhl348NM4BwLm2KZUoh6gk+5jsvFFGU08gBmmjJTBLV
         qeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGjxqmV0DkXFcXzzSJ8LFqABMT7fBMXHiBKy/LXov0A=;
        b=rPOle4ikViM/G/3perXzDjrKa7XvLfFv5pqwM2b0UxQsVB14/ewQwpqJFFuS0WqE8N
         pAncMZemd4ji9AXv06FfAXLYvFd2IgO7I75mAzUlU/3Sl9wGmWL5to9wO3l0Kr09a3hd
         bRmgVogxO7V7MUYISv9BL9cbbq42eeNv5z7YS18SUNM9dlgD1Bt0JOf9xG4Lf7MwimOy
         UpiDY4LwZmgKn8oDdh5+n4tTbHA9Bvp7g4OyXG2IT3xu/IWyRJO4qsplvIqRQkNGNksk
         YLiwG3+TtRGdqG5ISbQU8PFftPyS/shKCOX5pGfJDWmGQby95iYY+VGlePWDf/WqlbMB
         uENA==
X-Gm-Message-State: AOAM531BCpoKoJNmRZ5p8qauaWfoAYHrbUJw21WrAzxi63jFBuDZH8QZ
        QUCE5pyyu3VQM7sLJUUpQS3eMippn970gkeIq/AgFKTE
X-Google-Smtp-Source: ABdhPJzD4DQwgIVEMh9cxkmrbLGriTVrlag0uORp4Pb8xhEzjO9LOfUf+KqY1yTSu/1FAGwRsOjWjGllf4meUYZZBXo=
X-Received: by 2002:a05:6402:ce:: with SMTP id i14mr1474445edu.42.1611863901788;
 Thu, 28 Jan 2021 11:58:21 -0800 (PST)
MIME-Version: 1.0
References: <20210128112551.18780-1-jwi@linux.ibm.com>
In-Reply-To: <20210128112551.18780-1-jwi@linux.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 14:57:46 -0500
Message-ID: <CAF=yD-JNMTaUgfAAp5+qfOBnL171j9FFj2jvb4Na955jBqj4AA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] s390/qeth: updates 2021-01-28
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 6:34 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>
> Hi Dave & Jakub,
>
> please apply the following patch series for qeth to netdev's net-next tree.
>
> Nothing special, mostly fine-tuning and follow-on cleanups for earlier fixes.
>
> Thanks,
> Julian
>
> Julian Wiedmann (5):
>   s390/qeth: clean up load/remove code for disciplines
>   s390/qeth: remove qeth_get_ip_version()
>   s390/qeth: pass proto to qeth_l3_get_cast_type()
>   s390/qeth: make cast type selection for af_iucv skbs robust
>   s390/qeth: don't fake a TX completion interrupt after TX error
>
>  drivers/s390/net/qeth_core.h      | 44 +++++---------
>  drivers/s390/net/qeth_core_main.c | 97 +++++++++++++++++--------------
>  drivers/s390/net/qeth_core_sys.c  | 10 +---
>  drivers/s390/net/qeth_l2_main.c   |  6 +-
>  drivers/s390/net/qeth_l3_main.c   | 90 ++++++++++++++++------------
>  5 files changed, 125 insertions(+), 122 deletions(-)

for netdrv

Acked-by: Willem de Bruijn <willemb@google.com>
