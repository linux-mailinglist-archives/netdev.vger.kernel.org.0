Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A277240085C
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhICXik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhICXij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:38:39 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90EC061575;
        Fri,  3 Sep 2021 16:37:39 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id l9so649656vsb.8;
        Fri, 03 Sep 2021 16:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c5HXH0UEqvRFg7fiHvVooz4ZvcE8dS4x+eksgLrM1Hw=;
        b=HPToHelTDdD9RGA7PhQY5Kk4vQtSrX2eLhAA5TD2hefxJ/fLZuNWzdZZtPrrDYt7TF
         /nDmPenuq5cBQH9X1LrE4jrcQxw7sWuLs4CeNvQPWMd3QFZDhIQVCOM03ed4ECC9mamZ
         hi+oMBFgWmhH5UyAylNWdAbGOhBwMG2gsUBzGE58RhfW5VtdAcxJLMO2P75jta4ZYYy2
         jZ6UbxR/F01hI5sHQCuDYR9Cau7LYzWvbifPXfUWWfnLSwNMwclUPUXYH/8FPzB17/56
         dmllTrs5NsoqJkVk5KkWnpV/17pjJVyPO6V11KknV1i6UO74hTVuhDpg+DHcwR+0uIbh
         xyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c5HXH0UEqvRFg7fiHvVooz4ZvcE8dS4x+eksgLrM1Hw=;
        b=oz6oWMaQVtSNre2Pq2NQS+BVuSgCUgv31JCDcI9UEqebBbjTfdtA7s4HwZ57zpaw/n
         NeU98pXs5k5GPK6Yt8PfZedupyLpfmAp4PbgPm9/gR95/qLCu1Y9Xs6aa7nEOKAiBD9+
         CxD/7IWTUxPjNj++9Cxoum89sf2Po/tB5DHtWKjdFtklbKktP5sz9v92pleY7vx060aS
         kWRYMMZdrRCO5xB+Uu//BWRNW5bGQqjZfqHbEZRXWYB3WSI0z4tfRPom+/ycEc9iSnEc
         JvOQjtau9keynyGq2iIZyR2NPjDtgQtcD2EDsafqC9AJwqy3LVV6DJa0NcjIdR+pzMxI
         E3wA==
X-Gm-Message-State: AOAM530tK4WiW5kHG4CLBUfODeNTblzbrxGeJubW80wFPvo5DB8B61Sg
        pkUXplpJyDcr2IpF0oMVipC2/tS+y1tEOGeWmCiKP7rT
X-Google-Smtp-Source: ABdhPJwOY5zUBLI5T3CaX+ma5kogdwn2AWrK3PuyGyqNvv8Imxb+7s/BU65Gm1S7sCVGVIL3bvZD+a4T/Smy9ErDRsI=
X-Received: by 2002:a67:2d08:: with SMTP id t8mr827077vst.10.1630712258221;
 Fri, 03 Sep 2021 16:37:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210903031306.78292-1-desmondcheongzx@gmail.com>
In-Reply-To: <20210903031306.78292-1-desmondcheongzx@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 3 Sep 2021 16:37:27 -0700
Message-ID: <CABBYNZJnbDDqX=bEtRhn7URaOfoMVHR8JTavr+T8k0UYMLOhQg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Bluetooth: various SCO fixes
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

On Thu, Sep 2, 2021 at 8:23 PM Desmond Cheong Zhi Xi
<desmondcheongzx@gmail.com> wrote:
>
>
> Hi,
>
> This patch set contains some of the fixes for SCO following our
> discussion on commit ba316be1b6a0 ("Bluetooth: schedule SCO timeouts
> with delayed_work") [1].
>
> I believe these patches should go in together with [2] to address the
> UAF errors that have been reported by Syzbot following
> commit ba316be1b6a0.
>
> Link: https://lore.kernel.org/lkml/20210810041410.142035-2-desmondcheongzx@gmail.com/ [1]
> Link: https://lore.kernel.org/lkml/20210831065601.101185-1-desmondcheongzx@gmail.com/ [2]
>
> Best wishes,
> Desmond
>
> Desmond Cheong Zhi Xi (2):
>   Bluetooth: call sock_hold earlier in sco_conn_del
>   Bluetooth: fix init and cleanup of sco_conn.timeout_work
>
>  net/bluetooth/sco.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> --
> 2.25.1

Applied, thanks.

-- 
Luiz Augusto von Dentz
