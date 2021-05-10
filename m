Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E4A3791C4
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241997AbhEJPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240504AbhEJPAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:00:17 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C02FC028000
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 07:19:45 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso14502056otb.13
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 07:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AJD3MVDHOs2UKSo2SdAcWYa/oGWquD6lSzGzBdwET0U=;
        b=oWxiqfhmXXycbY/pcCJGTF5Jl7SyhEqXYRp4FvUAY64Q9C2yV0KQup5izdOvCe8Rsa
         o5ldlcbx6cVxJnP2iroWqMehUIXyc65DHMFcYvqySETBjxpBxHL5CkhdpK9K6yQHPf45
         0N0g2Eveu1Z6/YXn8YwZCQ2isrTCqN5NkGtbx27dczgfuh0WyQoEQK9OSWV+3uMGlU0X
         3yLooe7nskOK4uskpB84M+zv5jjmiboa8Cd+6ftSP/aI3dJWdo1sS1mujsntezk0pgmA
         8kqCGFobsBhrMQluAU3x2IRxbQQ6RGDshZLaZHJKVcbruVQ75JtVmFn0sGJt2lIgUGRu
         cpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AJD3MVDHOs2UKSo2SdAcWYa/oGWquD6lSzGzBdwET0U=;
        b=huCWfrtl8mc7Ec2D/i9wMgrqDyHjDPdUUnaaoClKwP7z0WEnnH9vCiJrRRCJ513+98
         iCBfIfe3FiZSNo5cy6k/MiPWV0Bcr/DhGIrBIVvqkfCCBXCkeRzprUiAtXCi0deL423e
         4ENgORZLL2EKHNl7D6mxBca7roUtwIXCfMV3HLjxeJl9pBBzHL1+UAPGDjEXBXVzfW2M
         MblspmNpYIeNJ88QqBC+AKfgcp9IPxZtHnNXYum+bJfyYZXaHvBfUdmlGASzMF5CP3YF
         Cxm9raSnYxAcuBajK5ZmgJWopTmO9Cl5TJJAAX974jWHJZt2qbulcFLTd1v1WLcEX0Q9
         f6aw==
X-Gm-Message-State: AOAM530HLp2Zj80dOIYSQUSNFR3RKVlnYL0TqPvlkZ3OPhmzxf0g64gy
        djmleHROShW1T9Dfri1uLpM+SsB5R9Z/uvFR0I8=
X-Google-Smtp-Source: ABdhPJwlF7apCqwI5f6NdxsX2nsDQuS6EkxVUxFqkeSi/LW/NOQ9iwbaxX/nanL5FUnY2gi6S6lgFsIM+PAzCJl1O5E=
X-Received: by 2002:a9d:28d:: with SMTP id 13mr21565421otl.278.1620656385086;
 Mon, 10 May 2021 07:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210510135656.3960-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210510135656.3960-1-thunder.leizhen@huawei.com>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Mon, 10 May 2021 22:19:34 +0800
Message-ID: <CAD=hENe9A-dbq8FGoCS=0_RV6qMmE8irb4crKjnLrSyc1orFCA@mail.gmail.com>
Subject: Re: [PATCH 1/1] forcedeth: Delete a redundant condition branch
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 9:57 PM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> The statement of the last "if (adv_lpa & LPA_10HALF)" branch is the same
> as the "else" branch. Delete it to simplify code.
>
> No functional change.

Thanks.
Missing Fixes?

Zhu Yanjun

>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 8724d6a9ed020a7..5c2c9c5d330b65f 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -3471,9 +3471,6 @@ static int nv_update_linkspeed(struct net_device *dev)
>         } else if (adv_lpa & LPA_10FULL) {
>                 newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>                 newdup = 1;
> -       } else if (adv_lpa & LPA_10HALF) {
> -               newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
> -               newdup = 0;
>         } else {
>                 newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>                 newdup = 0;
> --
> 2.26.0.106.g9fadedd
>
>
