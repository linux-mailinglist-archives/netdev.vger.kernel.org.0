Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A12A22BE
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 02:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgKBBXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 20:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbgKBBXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 20:23:51 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77CAC0617A6;
        Sun,  1 Nov 2020 17:23:50 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id p9so16691991eji.4;
        Sun, 01 Nov 2020 17:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Fj/XAiut5KD+Vt6/GK3xY+tW/qB3reA1Co7p6yw9pE=;
        b=n6Ybo9l6m8j9KDGTWPWS0WbLGwzYNpa7tBlMxhF+MzSkefA/dxQ13nEXTwA+fIPkty
         Bclkq3BDmOOnIrjbp+biUAF/nBYUA8LcRyQ0EnWmtYirvjeCyj9IsOJLMeT6J2m+8bih
         yzp2dL5/vbopXyt49iNwWCS9tNJ3at+QBauEfTeyciVCR2XfbnNoPQV4T2O5LHwDcXNG
         /vhSC8Iit2DO4YyyEY4t+aPlRGc4L8Zcz1dLigaphEBSEcMwlRqqeYKXwnQuNBs6EVgF
         Uu/2TpcmKjN7ZANeOr4JI8YhLkByxaGPWMho+asn2BEmorZNND0KV91NzNvPQPKdUdPR
         zKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Fj/XAiut5KD+Vt6/GK3xY+tW/qB3reA1Co7p6yw9pE=;
        b=UYN4xtvzuA6gsiMS5ZH8lnAOUXe1Ckk+xBPEKYorXLYbVu2LFuYIZEotmFUScB9yC9
         K4T6cRASK186wdWx888BQbvEH6m8/pderZwUsL0MZJN0qNwH0SmvP3hCcyfAUW0wnQib
         kSKZUreyl7nfG8BWYRWin02B7Rrvb2SCQcldTLYcXPfi8i7QFp8U35phXd3/hCGpN137
         Dmt3SiaxxlZW1uoDiQuOs+AkxZ3nIP3YtAJWJ/AXRqrtWVSMzrHnQob8kZcx8CrYUHlu
         T3bIh3GVXUUoMWHu9lx8EpYA8BgN6CFYN/F+qIdpimrXU3v983xhyVIBqNcG6Ca7Gszh
         hSIQ==
X-Gm-Message-State: AOAM531gqXk5lAdEk/FahuDcouVmKOmLMDEFaE1zjqautnEsd673URWE
        ZKLauP4Jcgsc8P7FUpOtcnMfQ0WSJaRkMqtN94A=
X-Google-Smtp-Source: ABdhPJyinjAs7YmrGBkvPZv1qWupNBm6Ctn/cMghhYNtriifqZd/VuOCDMHhlMC87tmugVUK2mFkFX2bEqvAMVilueg=
X-Received: by 2002:a17:907:42a1:: with SMTP id nf1mr13634050ejb.135.1604280229391;
 Sun, 01 Nov 2020 17:23:49 -0800 (PST)
MIME-Version: 1.0
References: <20201031060153.39912-1-yuehaibing@huawei.com>
In-Reply-To: <20201031060153.39912-1-yuehaibing@huawei.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 2 Nov 2020 09:21:05 +0800
Message-ID: <CAMDZJNVUnnxHegcQi7mwWFbDBbqPvqyB0h=EHSKe=uFyiHWV-w@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: Use IS_ERR instead of IS_ERR_OR_NULL
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Pravin Shelar <pshelar@ovn.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 2:02 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix smatch warning:
>
> net/openvswitch/meter.c:427 ovs_meter_cmd_set() warn: passing zero to 'PTR_ERR'
>
> dp_meter_create() never returns NULL, use IS_ERR
> instead of IS_ERR_OR_NULL to fix this.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/meter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 8fbefd52af7f..15424d26e85d 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -423,7 +423,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>                 return -EINVAL;
>
>         meter = dp_meter_create(a);
> -       if (IS_ERR_OR_NULL(meter))
> +       if (IS_ERR(meter))
>                 return PTR_ERR(meter);
>
>         reply = ovs_meter_cmd_reply_start(info, OVS_METER_CMD_SET,
> --
> 2.17.1
>


-- 
Best regards, Tonghao
