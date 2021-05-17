Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B608386DDE
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhEQXpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhEQXpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 19:45:20 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DC4C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 16:44:02 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id j75so8048621oih.10
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 16:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d0YZFRlCmOw1ZT9+QDMVE2KdtNQFQJXD4ryxKlWjm5c=;
        b=Km5M5rSPYr8wWgrOkq8uA0WQ8w/yekBVgx7R1ZSLmvgGrIgimn268O3BdL6ghgcPn8
         NnhswO6akAJZ+8TSNwYoQjME4nLalTNYULukcBZSqbId+cDjWCf/uD75bRT+wMKpWLdR
         WFnCwGUwT40Jp2vH933fb+MIYv7aN2a/yBkp+MZJ8j9Kpk+0WuuReG6NCcRZDcngCn1s
         DgTyuxCbBc/jirZNJ3hU2OjbfkbCqKPgPHGpxGpV9EJmx8D7eAwopktCEbnIvz3DJeik
         2l//x01qvvU9hszEjkSP2L6VB5BMFEwYBt9OXxaTOn4MWqnBTzgI6uzP44YWv88yJwHU
         ixdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d0YZFRlCmOw1ZT9+QDMVE2KdtNQFQJXD4ryxKlWjm5c=;
        b=YBmkfIgXjD3YUijajueTzjPCmJZca2/lWWRYc9yKT4fxDlXrAAUSJodLxMd2/GnP0a
         rdlWkUWtbAFWbvmyABrtnL99IxrS678wDgR9Y3z4CZ6KHv2lYHNbPyDFx8H/X6bWg/t/
         KCVUTuehwEQv77hQt3coAWygxVmBb1YxewZoUEMgJWvM4mJj+sE0hPqR3a4a8AndipNe
         Y4mx72vurmp79CdgvQ32TDOf57uGGhI7ODo94a3EwK73VvPwJHG70TJyVhR6oKGYfbb2
         3jshEbY82hj2V3L7NRUBmdTaG1eTM9O1SLMR0v5EKNrFW5E9Uzrce4+8LnzYH0guEBf9
         zMsA==
X-Gm-Message-State: AOAM530m45K7/Qb9CC8SnouAn5FK+/6yNUfayTIJf2kSFAjJqd1Mc2QL
        Av8Y1iYVq4OVu6/aBsN4KHTK4fdbb5XX1SmG6XnAMmML3Cg=
X-Google-Smtp-Source: ABdhPJy1smTpWjTWn0eM8qLSz1bApKqibl6aX3mRvuADt/I8aX3H1ZA9y5kvMv8y4+v1ZOr5g4HmVoi2bKfeEfvBoQ4=
X-Received: by 2002:aca:4e55:: with SMTP id c82mr1216130oib.17.1621295042397;
 Mon, 17 May 2021 16:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <1621245214-19343-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1621245214-19343-1-git-send-email-loic.poulain@linaro.org>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 18 May 2021 02:43:51 +0300
Message-ID: <CAHNKnsTnbLKXQF2CHEKA-BN9PBAhuY5GYVaTNK5ztjBV4q2zKg@mail.gmail.com>
Subject: Re: [PATCH net] net: wwan: Add WWAN port type attribute
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        dcbw@gapps.redhat.com, aleksander@aleksander.es
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Loic,

On Mon, May 17, 2021 at 12:48 PM Loic Poulain <loic.poulain@linaro.org> wrote:
> The port type is by default part of the WWAN port device name.
> However device name can not be considered as a 'stable' API and
> may be subject to change in the future. This change adds a proper
> device attribute that can be used to determine the WWAN protocol/
> type.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wwan/wwan_core.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> index cff04e5..92a8a6f 100644
> --- a/drivers/net/wwan/wwan_core.c
> +++ b/drivers/net/wwan/wwan_core.c
> @@ -169,6 +169,30 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
>
>  /* ------- WWAN port management ------- */
>
> +/* Keep aligned with wwan_port_type enum */
> +static const char * const wwan_port_type_str[] = {
> +       "AT",
> +       "MBIM",
> +       "QMI",
> +       "QCDM",
> +       "FIREHOSE"
> +};

A small nitpick, maybe this array should be defined in a such way:

static const char * const wwan_port_type_str[WWAN_PORT_MAX] = {
    [WWAN_PORT_AT] = "AT",
    [WWAN_PORT_MBIM] = "MBIM",
    [WWAN_PORT_QMI] = "QMI",
    [WWAN_PORT_QCDM] = "QCDM",
    [WWAN_PORT_FIREHOSE] = "FIREHOSE",
};

So the array index will be clear without additional notes.

-- 
Sergey
