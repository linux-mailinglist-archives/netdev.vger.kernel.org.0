Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816B7422359
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhJEK3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbhJEK27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:28:59 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278A1C06161C;
        Tue,  5 Oct 2021 03:27:09 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p11so23652089edy.10;
        Tue, 05 Oct 2021 03:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rL/GLS5OZJ7phPRaTudkfusEYdNhL2DzyNbbUENADsA=;
        b=Wq9T3G0WPnxR/rZvZhT8FySILjdpQeObdqc7jVW2yOBAi+Fk+uIMs9Aqeqs7MIc7jO
         HPBWHUgktcwIXpK2szyEP53YrLMfSZ05clf5PjpwtckGcwhR25J+DTjb3btqfNbKyKp1
         Ogr38RvI/rKBEeCuf+UcaRar2z+CO9A6i/j7GNIowmZFE3qeTnRmi3pTVxG9xb0M+/Y6
         ghGHQjDQCsRMMpS3P/jeO1fkvezfwK725MM2ZcWSqaY2ZZPrOBi3YJ/8V0MjxWv36ses
         fTVRMGQ0BSEUjSqTlX7Oilyz3Lneva18rAQAa/b+0NNlXtZ+Fsbs2Xp42yPc7CBzF9bx
         RQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rL/GLS5OZJ7phPRaTudkfusEYdNhL2DzyNbbUENADsA=;
        b=4eAQFpSQXr7uLh5MniVqp3Zu1p+G5OR9I8ajfA/zBoHHiaVY6ax0NLUd0YPPPTQ0wi
         PE0fErrsPgZRxG/L2uIEnFxAy77ylZZz7CPAchv+kywyGtNcanVIjSJ5QAftzKGSQ6EY
         iOVe4sGfOiG8mNReCi3aagaZdGjB21aZh+5YXLbtsD7WwNsN9gdQADGRhBz8efb5spBK
         w8FZ2SBPl9x/fyf24iB3JMOPblXXB82RGrkvTkm97xLpzBrFFZ/noNvFc48fRxFVzYsy
         4A3SjrZIBHmPB533Hu4+4i8wxMwabYAfxB4IOkotInrTcstY2MGNM/ZzFWAh4dptYgJs
         AQQA==
X-Gm-Message-State: AOAM531Omz5eqvG7PVfbqPVLTSKLdi0US/EvOWX5HnJxmRNT0e7lu9zv
        5rEvGGeYpFGtFPzQYllPeJ+jlbwITSo=
X-Google-Smtp-Source: ABdhPJxTSyP2ndd3eqbqcdaPDwiXEAife6VMlP5B1kWxmF3e/IFUNba7iapdYXph410yC0VHKM7gZA==
X-Received: by 2002:a17:906:d1d1:: with SMTP id bs17mr23253228ejb.198.1633429627362;
        Tue, 05 Oct 2021 03:27:07 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id b5sm8509877edu.13.2021.10.05.03.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 03:27:07 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] mlx4: constify args for const dev_addr
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org
References: <20211004191446.2127522-1-kuba@kernel.org>
 <20211004191446.2127522-5-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <02850c46-85b1-49c7-a347-e057be13ed1f@gmail.com>
Date:   Tue, 5 Oct 2021 13:27:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004191446.2127522-5-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2021 10:14 PM, Jakub Kicinski wrote:
> netdev->dev_addr will become const soon. Make sure all
> functions which pass it around mark appropriate args
> as const.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 8 +++++---
>   drivers/net/ethernet/mellanox/mlx4/mcg.c       | 2 +-
>   include/linux/mlx4/device.h                    | 2 +-
>   3 files changed, 7 insertions(+), 5 deletions(-)
> 


Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
