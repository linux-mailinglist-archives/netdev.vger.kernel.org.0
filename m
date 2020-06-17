Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473E81FD354
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgFQRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:21:02 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D0CC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:21:00 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k18so1632816ybm.13
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhUzYFQFKmTbVPO3HVJIRrvkG7sdu3t8BgARxHAaJWQ=;
        b=v2c1akP8yFgLvkI+i4cRTuzRa15Pjx7sMD22yui3Rqu1lIO6+mSTNTxF8XHz3XmhER
         cpRbnXznrbiiVdaUxqZFoPbiPIsa0tiwuP4zNB3RwCsD1HGfQPAQBNy3KcDqFikE0LrZ
         qRIYTKZB8UFA8uMOOb8lxMZFFRoqfiK10DkX1+1z9ltGU4jzLQ6KMpwcJmndscQsBX4i
         HvdY1iyYY/EjG2xedF2REMiUBVC2bXuDp2I0Fe7qGnRK2yx5b7Q3xqKgDP0QOjEVFaIQ
         E8ghb1ulof5gaL8c82SzPMxeC+IL7ZtS8YXo8O1doI1M+0Sah/CHogbyJ+jcDQXGRdA3
         loIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhUzYFQFKmTbVPO3HVJIRrvkG7sdu3t8BgARxHAaJWQ=;
        b=Lbo6Y3bx58T+eeq2bvIVeLw/hw976ZsVUTSkpDiXm19C98vxGHjMj0AuQlG8Efj13U
         sZGVBhjpoEgOZpNNh2H6Q6FxiXxf29PdU0/Q0cQBDFTEuYOE+TSeo6y4q9rRtPuHZSki
         HTP4KM3uoZpY0OBNXzCOdnsHE4uj7meobzSSPls8YPICSFaHBBq8iKqhJDSNuAin5p0A
         iIEJVEIS8PmCmW9GIG5Rc/aCzXcKgmcCVNcScgh/VPeXMd/6uGaQqFJldujUWx8MSnOh
         wR2Y2USbHAXLxvGvlb1vTfgGYbEuy3YZ4Pd05LOmgm/DrDLVRg4cB2xN74mJNB9SL3YH
         es4w==
X-Gm-Message-State: AOAM531BOoHLEP9ruUA4SQVdopG9VybLTu90Grcy/Px/mndfccRL9Gg7
        mYrLaMe53UCzYIODDyBa1HoS4BbhqmC1wgjjaR3If7oR
X-Google-Smtp-Source: ABdhPJxW6fPMhq0EICCdqjPEnYg2+/VXnbrklhyDezc/3wd5cxMT21uQwrxFVvPzyCOhhZ76K7t/LV+reaqePVvdDSA=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr13267587ybh.364.1592414459850;
 Wed, 17 Jun 2020 10:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200617171912.224416-1-edumazet@google.com>
In-Reply-To: <20200617171912.224416-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 17 Jun 2020 10:20:48 -0700
Message-ID: <CANn89iLkSFM+EEehJn7Eg36Sou-nAsS3+sKbfg3Dj56a7-4A3Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tso: double TSO_HEADER_SIZE value
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:19 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Transport header size could be 60 bytes, and network header
> size can also be 60 bytes. Add the Ethernet header and we
> are above 128 bytes.
>
> Since drivers using net/core/tso.c usually allocates
> one DMA coherent piece of memory per RX queue, this patch
                                                  typo here : TX queue

>
> might cause issues if a driver was using too many slots.
>
> For 1024 slots, we would need 256 KB of physically
> contiguous memory instead of 128 KB.
>
> Alternative fix would be to add checks in the fast path,
> but this involves more work in all drivers using net/core/tso.c.
>
> Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
> Note: probably needs to stay in net-next for one release cycle.
>
>  include/net/tso.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/tso.h b/include/net/tso.h
> index 7e166a5703497fadf4662acc474f827b2754da78..c33dd00c161f7a6aa65f586b0ceede46af2e8730 100644
> --- a/include/net/tso.h
> +++ b/include/net/tso.h
> @@ -4,7 +4,7 @@
>
>  #include <net/ip.h>
>
> -#define TSO_HEADER_SIZE                128
> +#define TSO_HEADER_SIZE                256
>
>  struct tso_t {
>         int next_frag_idx;
> --
> 2.27.0.290.gba653c62da-goog
>
