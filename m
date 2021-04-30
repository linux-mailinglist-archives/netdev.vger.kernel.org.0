Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A353702E5
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhD3VXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhD3VXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 17:23:08 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0C0C06174A;
        Fri, 30 Apr 2021 14:22:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d11so14195282wrw.8;
        Fri, 30 Apr 2021 14:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMdVb96Ebtl3ru83rtVmVeThVmQQhiSJu9hUSuKAPiE=;
        b=Nkqo011c4MJ28xRL/bEr50uVHNQLHa0xUhTdHCypCOOWAJKhDxE9F8d8CGwr/NURzj
         41xpYdM6PuV/1cDzkkQfydJfGgJrGhjl1vMfJd54LN1s+c6YIisyn+ELVah9cEwOjSj6
         WTZX5asf16wAplvRn4KRnV3u9V/lIFJ8fvfmioDl3igKE0mL9jSmMWj6jPuY2uym+3dM
         71xNB4ckNR45vntNYkXJ86j0sQ9G5cI5GrgFiXcWUe+A/k1ePjB11bITvpTV9Oo2bKxk
         fY+oARIvg63PAV7R0bT3qAi1VKSgHWS+/8gV3NRTyvULhAadM9hKherItXujiPkX7MGw
         YSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMdVb96Ebtl3ru83rtVmVeThVmQQhiSJu9hUSuKAPiE=;
        b=RbzPfZeSHHmXMz3XqalVlms+GRx0kEaWOCrJehIUq2mCVOc5gTlbU22dKEwH3XzlWt
         dqq93LRuMa2kUzAefyGXNP31CrJPmO+KIPDmY+4j3DNlI4v7tO9NRJBWLHRd7dJlY5Lf
         l4IdvDR0yt9YTZXXQ1ZA8lh8+B/i/NGVArocp8ROiVhiJrFXxeDr5TeJN5wgjWIBHP6o
         Ne0N8Urj1Zo5iillvrnad4F78nQep2xU7UAdKBN7GEPSRUzMNHdNB3wFTOa+A4BI3YHw
         MkN9NHZZRaPZ2goprw+/XrHteYc+fDgetzDeayfwigQ/FvSkAeqpdoeRPhZOaQr3ZzWS
         fxhQ==
X-Gm-Message-State: AOAM531vKu3QkWYEMMP3GaB4bFwHXQWz8+J0YUgBJCavrSamo5EXMx5Q
        rEOQOjbiEDNnXm14EVwWOqrTS7BwG4EscbgkqdY=
X-Google-Smtp-Source: ABdhPJxaaXYC35dcTvz4io//xzoawObZxmOesdrLcNPGTVuE7cBAYh2mJ1Z0K2NHVCwTWxRUUqBAREqJrByUj3vQDOE=
X-Received: by 2002:a5d:4c8a:: with SMTP id z10mr9799959wrs.395.1619817737810;
 Fri, 30 Apr 2021 14:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <1619691589-4776-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1619691589-4776-1-git-send-email-wangyunjian@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 30 Apr 2021 17:22:06 -0400
Message-ID: <CADvbK_d85SOS51oU6-a2HKm8Ammd2y+L0qiy+k3-wb9hEUNbkQ@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: Remove redundant skb_list null check
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>, dingxiaoxiong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 6:20 AM wangyunjian <wangyunjian@huawei.com> wrote:
>
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> The skb_list cannot be NULL here since its already being accessed
> before. Remove the redundant null check.
>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  net/sctp/ulpqueue.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> index 407fed46931b..6f3685f0e700 100644
> --- a/net/sctp/ulpqueue.c
> +++ b/net/sctp/ulpqueue.c
> @@ -259,10 +259,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sk_buff_head *skb_list)
>         return 1;
>
>  out_free:
> -       if (skb_list)
> -               sctp_queue_purge_ulpevents(skb_list);
> -       else
> -               sctp_ulpevent_free(event);
> +       sctp_queue_purge_ulpevents(skb_list);
>
>         return 0;
>  }
> --
> 2.23.0
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
