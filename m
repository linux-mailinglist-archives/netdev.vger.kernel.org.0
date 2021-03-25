Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1C7349D0A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCYXvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhCYXvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 19:51:10 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3416C06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 16:51:09 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 15so5429223ljj.0
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 16:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RwgWCG0EilsxWEf/l9wl28dzUzphjxy8qzggPKyOVms=;
        b=QwUbOly5CBlTXhyMfV6B0kwfR0uM96bywmpYQUSNQpBCP5ZGFvzx2uV7wMIQiine5G
         YvYIOGNl3IVmj2Ep0WrgKQ5W4WXkzxX/3ZNTtLUh5ZVa0vu6qdpEJN0cEW++hoGA2kTm
         q2m7YVJUODcm9tXh6dvV2+VJ+2qxuGLNsuXS6v6+g8DwvUoUVYRR/KubLhStLRKBtM06
         EwVY3LO+fHP1HkNeiFQWq+OMGhp8qCjtPrxKHV0pRDwHzw6jccpDiKVmZhbUubrdYiJW
         n4K8GYuCilX3suqWhZ8XX3BjiYGtTEoEiIiSk7X6YREtkZdwNIJPMz+4aTpxxGlfU4VU
         P8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RwgWCG0EilsxWEf/l9wl28dzUzphjxy8qzggPKyOVms=;
        b=AZEt6FKZ9fTidM4vyv+OvklXtOR+qZDsInIUUDoqu9SP0dW2OcnOP+5XX7ltVYQfHC
         zwmsGDHTkeZDPcU/kWZNbex1A69DqAgOIx/hpfj+zqH4kiLx4cI/PrSJs2Mpk9cx0kRE
         N091VsTj8UKIy4XtilcMuTDHR21nShi7z6QvlPwTKMXxSz25KqoOKKcLXNq2ew/OR6t0
         u7fAZ8yQ+BgLK+f6ubKgLqu0sCN0K7iAq9SKjA/5a5orCFKcATCQixP0f5tGpOVdh7Pe
         ZSFOJi6JrCcHloEgucVmAOVhIDaF1PaAAkCxKP34IHfkcECWyaVTBDmZu37AYTn8bG5E
         IeEg==
X-Gm-Message-State: AOAM530+WllHaG5/fnO4UkximePRKj/8FlDUhq3ySlRsJjoNS+WIKLRa
        cl0FHCE/Htmqj8az8guOdNCct6p9aRb0EAOmAkXNEw==
X-Google-Smtp-Source: ABdhPJzL4e8Ue6pPom45rweGtEsx9ljLB94UQjAA6ERXa5+xPorz2hrRIe2EgkKoX9CeL+o/REm+UsXFpROhfPpPw48=
X-Received: by 2002:a05:651c:387:: with SMTP id e7mr7254054ljp.425.1616716268168;
 Thu, 25 Mar 2021 16:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <1616658992-135804-1-git-send-email-huangdaode@huawei.com> <1616658992-135804-3-git-send-email-huangdaode@huawei.com>
In-Reply-To: <1616658992-135804-3-git-send-email-huangdaode@huawei.com>
From:   Catherine Sullivan <csully@google.com>
Date:   Thu, 25 Mar 2021 16:50:28 -0700
Message-ID: <CAH_-1qxV6cjfLkP-XeJEy1mWLGR6p8o-ZMdS39HeP186ozbaHg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: gve: remove duplicated allowed
To:     Daode Huang <huangdaode@huawei.com>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Kuo Zhao <kuozhao@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 1:00 AM Daode Huang <huangdaode@huawei.com> wrote:
>
> fix the WARNING of Possible repeated word: 'allowed'
>
> Signed-off-by: Daode Huang <huangdaode@huawei.com>

Reviewed-by: Catherine Sullivan <csully@google.com>

> ---
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
> index e40e052..5fb05cf 100644
> --- a/drivers/net/ethernet/google/gve/gve_ethtool.c
> +++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
> @@ -388,7 +388,7 @@ static int gve_set_channels(struct net_device *netdev,
>
>         gve_get_channels(netdev, &old_settings);
>
> -       /* Changing combined is not allowed allowed */
> +       /* Changing combined is not allowed */
>         if (cmd->combined_count != old_settings.combined_count)
>                 return -EINVAL;
>
> --
> 2.8.1
>
