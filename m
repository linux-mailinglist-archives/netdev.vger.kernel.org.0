Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB09E3B2757
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFXGXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhFXGXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:23:16 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C881C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:20:57 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j11-20020a05600c1c0bb02901e23d4c0977so4815890wms.0
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34pAJ/DdBTPHmMvZH3jZXwLo4D62PXcipffHnlmImnA=;
        b=jwuA3wRIZZEcZyDs+VzOdiF1xZayEIxm3bKZ1ONezsPzi9MIb+NTmNCBs2ax/NR3pl
         SicvmaTdt4tpxhhVbg+YLigXRLjsTPvNoLP/YPeNWO0BOY3R20sy2/5erODIIPlF1LSz
         34Elt6SUy1O+ZgZI07aMM8Q3sEbl1RQLNUUQCPGFT7+O+Xi3thv94iN3S9ZeBk6lxnq1
         Hl8Dg+DI8uBsutQMvAA/JnbMQX6xSuzNoAgwe6Jd2NrkQm0qREQfjBjg+PCnKWoyIPT8
         bUYWOdZj1mxmYW5CnnR+Y3HvKQZrtqIzpuooxSJX3ktL6n9KdwxMUZTGDMAft0eRvJRU
         IKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34pAJ/DdBTPHmMvZH3jZXwLo4D62PXcipffHnlmImnA=;
        b=W6C30FBGYIdoHLIJPIqFEnJqN3NWSCETX6ydIY48kEQdf/Z9kaY1A+iw9AHe0wYKK1
         KtQI8IHgLtcGPoMRBY0SX/dmYcQdBwyRmzGTI38Yer87199eqtWUUTeUHiWBJiXf6ZY1
         8DecPBROIW1RY0nuZ/g8+3OEqQi+qLPBLyKiKxBCuRHRI1Zs5sM+TvsglIsRrU0MI4xk
         b1xiJUKqVarnlHVrZySw645Kg+IPa05QY1BgSCMbiGAQ0gwZCKrW3OqjpKuO1gYUwfhC
         rkXAOSaHWHeme8JYsv4O6sUMqDY0lU7U8xk/OMDhf3g9JWTAFjjZ3qql7V97WsORhjly
         tPtw==
X-Gm-Message-State: AOAM532WCAk+n/s1agRqGxXnFzO4TxE63tYOVkwVS3BaJXeOBsez1rFl
        g3q5mLDWDwPFZ9yc6yIBCd0DN5K3SNYDxYNCE1Q=
X-Google-Smtp-Source: ABdhPJyQxspDy8AHdk7Zbn1Sd0HuUBCg2XcyP25G+q/T6caa34JXYHiMeMhDsYt/DbCoZ5+3GUkPdhEBX4EWsA6+vm4=
X-Received: by 2002:a7b:cb8d:: with SMTP id m13mr2271887wmi.8.1624515656219;
 Wed, 23 Jun 2021 23:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210624041316.567622-1-sukadev@linux.ibm.com> <20210624041316.567622-3-sukadev@linux.ibm.com>
In-Reply-To: <20210624041316.567622-3-sukadev@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 24 Jun 2021 01:20:45 -0500
Message-ID: <CAOhMmr6USoB-yw1HduSWc1h2AGdS7U3+Ze9nBRh51pM=V2P8Kw@mail.gmail.com>
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:16 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> From: Dany Madden <drt@linux.ibm.com>
>
> This reverts commit 7c451f3ef676c805a4b77a743a01a5c21a250a73.
>
> When a vnic interface is taken down and then up, connectivity is not
> restored. We bisected it to this commit. Reverting this commit until
> we can fully investigate the issue/benefit of the change.
>

The reverted patch shouldn't be the real cause of the problem.
It is very likely VIOS does not forward the rx packets so that the rx interrupt
isn't raised.

> Fixes: 7c451f3ef676 ("ibmvnic: remove duplicate napi_schedule call in open function")
> Reported-by: Cristobal Forno <cforno12@linux.ibm.com>
> Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index f13ad6bc67cd..fe1627ea9762 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1234,6 +1234,11 @@ static int __ibmvnic_open(struct net_device *netdev)
>
>         netif_tx_start_all_queues(netdev);
>
> +       if (prev_state == VNIC_CLOSED) {
> +               for (i = 0; i < adapter->req_rx_queues; i++)
> +                       napi_schedule(&adapter->napi[i]);
> +       }
> +

interrupt_rx will schedule the napi, so not necessary here.
