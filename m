Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578AA3F9BC9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245152AbhH0Pgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244608AbhH0Pgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 11:36:31 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF72C061757;
        Fri, 27 Aug 2021 08:35:42 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e129so13270012yba.5;
        Fri, 27 Aug 2021 08:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elurosbJYKf8PNk7F8ORCf7uCyleyo4sWJRx+2DCXTA=;
        b=jHxv2iqkEBjOUNyq3zgyb3HRUO6LBwSeIjXl5VENEALmj3ipi3z9SxgpXXz5ziSfoE
         RYkYReDmKZGDNisVDj6zn5Wy/o/eu4+SuGM16UGw8On0ykD+6maCzQ+0z14mpXCCPlYl
         eMgGiBCwIEh3R7qrWKDC6gh29uno61759VtABLto1aFukRT9CCWLPvlMU4hxjNa0nb2i
         zJibeIaW26/KnWvU3RjUXsg+G0NF05kJmvP6PH6tUNKrtUTWg5o56BxCwAkGJOekX7pZ
         +QaHojHmYJfrNuw0xfDtq6/8nucLViPScaMxUWwWVApS8W+3ptHlqG+HNdfvvV9K2tgN
         rhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elurosbJYKf8PNk7F8ORCf7uCyleyo4sWJRx+2DCXTA=;
        b=BDYTLMJEM9HmYxPoepKOn/+HLR21dLgcSkvlUr7DlmOOgV/g+zK2EHog2lJorUikCx
         DxltMptkW1t+/O4/r24VIkpfnL2iN79Zzr94iDzeg6cHE8bjbKKacAO5V+Qbdvp+e0Xq
         1g1g9heuepoJKVjuJ+yPP2nbtl7+zOx4ob8xHH/yS9vHMh6D/ZbeW/oaYVAWliurTzUd
         aI2bNW9i6b4JxecxDeX88ObmmFyhHlWhUydAyEc8NHtuLioMCzOd+noLucwTZJ/x9KsS
         mjz9zfWH4Q3vDsmm+y3+0iYxzNUdWL0uIascBShEB+VXjGSqyceB0GuGb+daZ6bwHn2m
         QOmw==
X-Gm-Message-State: AOAM532m3KLtuVC7X1h7XWLHP5b5sEJoUFF1uv3kbJ46kkA4cVA9M+9/
        Ug3rK/0wUjOOgd0WNezb5Ml+Hhdn8MOUunOsLPI=
X-Google-Smtp-Source: ABdhPJyhpBHyNr/gDmxLWVfhEtXpRDHMwnDoCOtYOlKrhtC+HzJZ8UZPWf8BVplz6v2mMAitFGLcRhWvkGN1nD8+0DQ=
X-Received: by 2002:a25:810c:: with SMTP id o12mr6482926ybk.250.1630078541973;
 Fri, 27 Aug 2021 08:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210827132428.GA8934@kili>
In-Reply-To: <20210827132428.GA8934@kili>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Fri, 27 Aug 2021 23:35:31 +0800
Message-ID: <CAFcO6XMo2rFJqb1zZyPgEDtChLHNq26WfhAd5WC+9NMnRNM8uw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: qrtr: make checks in qrtr_endpoint_post() stricter
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 9:24 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> These checks are still not strict enough.  The main problem is that if
> "cb->type == QRTR_TYPE_NEW_SERVER" is true then "len - hdrlen" is
> guaranteed to be 4 but we need to be at least 16 bytes.  In fact, we
> can reject everything smaller than sizeof(*pkt) which is 20 bytes.
>
> Also I don't like the ALIGN(size, 4).  It's better to just insist that
> data is needs to be aligned at the start.
>
> Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This was from review.  Not tested.
>
>  net/qrtr/qrtr.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index b8508e35d20e..dbb647f5481b 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>                 goto err;
>         }
>

> -       if (!size || len != ALIGN(size, 4) + hdrlen)
> +       if (!size || size % 3 || len != size + hdrlen)

Hi, (size % 3)  is wrong, is it (size & 3), right ?

>                 goto err;
>
>         if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
> @@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>
>         if (cb->type == QRTR_TYPE_NEW_SERVER) {
>                 /* Remote node endpoint can bridge other distant nodes */
> -               const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> +               const struct qrtr_ctrl_pkt *pkt;
>
> +               if (size < sizeof(*pkt))

Yes, the size should not be smaller than sizeof(*pkt).

> +                       goto err;
> +
> +               pkt = data + hdrlen;
>                 qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
>         }
>
> --
> 2.20.1
>


Regards,
  butt3rflyh4ck

-- 
Active Defense Lab of Venustech
