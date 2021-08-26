Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5B3F8ADE
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242932AbhHZPUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbhHZPUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:20:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF56C0613C1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:19:25 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a25so7071880ejv.6
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=COuDqpujOoWFpeeNNVgXjqNNoXXP7AkxPAE3chYS1Po=;
        b=JCyUqbkSSAxsyKHlPcDgr7bgu4xmtVHL3mMeRVZeb6qfMKAng357OP/E5hkg9aoStF
         2YJLuXDqu3P8xCXy6icac2IuDQFk7lYkkKSmPtacGNNVUJzsX7GoF7oskqD7a9IZMhUt
         bBjwW7mNnpLivO2nfPB1XMTWgU57F0xkiTWmn7kivQcxk42YyKKAcOVKwgGWgledhc4Y
         BLikzeGRCKF5ZLQDxcTM+THStdh4TYnu6CeTypxB8+0Lf5md2SprTcmKwWta3ec/oXuo
         Od6QcmkFPPgAHpo3rMTggu0bull0Ye8Uz6qc8AX4dSOoLAZsi4cilOcNWTQAqtdqV8rT
         ev5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=COuDqpujOoWFpeeNNVgXjqNNoXXP7AkxPAE3chYS1Po=;
        b=CmNsxwyYsWFVfRujxKtQKmiHbVDZo97uaebh767n1rbIw4LTJJ9fF2V4WsDtLQo3VE
         CaKoKUVWfR1Org8HfRs66nm0oICsOBT3tSbIQrLQDCA90wTSTFD15yyuxDyPNt8iZO+w
         b5xpDF9F2VyaFpCwgigV5kVCTjVjKnUGrMNeAxVcUcGYTYFKvKrzBvDXY4mcpKFMMDgi
         8nfde8vgh7gTTxeuZ8gLfikmV+QFOTP4VDz9uyWQdFbwLblpvFPWEV0muiSmU8Y1WVPV
         wPmX60qiv6XlGkMZBha3GiU5dtKfq1F8akpSNEdwz7aO9NC5j8WlJbJPgWsOEtPyFXdP
         If2Q==
X-Gm-Message-State: AOAM533isVur3W+dSLcrvVcU80LLwQuk5FcOr36HN5EBwsME7CdcB5Zq
        dv8mXKKhtF9hzUwszaCcucKX7tDf46HvzO92P+4Imw==
X-Google-Smtp-Source: ABdhPJyO9KnFCBi21tKMJtf8QVpUf6kS1Qy8yS+zGqz9k+SUvHsTRbFtGWD/dcXGWHJXHIAvJfygTp1FMgk+XX8Vjkw=
X-Received: by 2002:a17:907:785a:: with SMTP id lb26mr4815912ejc.77.1629991163835;
 Thu, 26 Aug 2021 08:19:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:77d4:0:0:0:0:0 with HTTP; Thu, 26 Aug 2021 08:19:22
 -0700 (PDT)
X-Originating-IP: [5.35.24.211]
In-Reply-To: <6d8179f45f7139ecc8172c2d2c4988b943393c1e.camel@perches.com>
References: <20210826120108.12185-1-colin.king@canonical.com> <6d8179f45f7139ecc8172c2d2c4988b943393c1e.camel@perches.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 26 Aug 2021 18:19:22 +0300
Message-ID: <CAOJe8K1zCRZH-0-+ekDQ5T3mX2cGv1X-gBt1eg4co5HNPP+2vQ@mail.gmail.com>
Subject: Re: [PATCH] cxgb4: clip_tbl: Fix spelling mistake "wont" -> "won't"
To:     Joe Perches <joe@perches.com>
Cc:     Colin King <colin.king@canonical.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/21, Joe Perches <joe@perches.com> wrote:
> On Thu, 2021-08-26 at 13:01 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> There are spelling mistakes in dev_err and dev_info messages. Fix them.
> []
>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
>> b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
> []
>> @@ -120,7 +120,7 @@ int cxgb4_clip_get(const struct net_device *dev, const
>> u32 *lip, u8 v6)
>>  				write_unlock_bh(&ctbl->lock);
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>  				dev_err(adap->pdev_dev,
>>  					"CLIP FW cmd failed with error %d, "
>> -					"Connections using %pI6c wont be "
>> +					"Connections using %pI6c won't be "
>>  					"offloaded",
>>  					ret, ce->addr6.sin6_addr.s6_addr);
>>  				return ret;
>> @@ -133,7 +133,7 @@ int cxgb4_clip_get(const struct net_device *dev, const
>> u32 *lip, u8 v6)
>>  	} else {
>>  		write_unlock_bh(&ctbl->lock);
>>  		dev_info(adap->pdev_dev, "CLIP table overflow, "
>> -			 "Connections using %pI6c wont be offloaded",
>> +			 "Connections using %pI6c won't be offloaded",
>>  			 (void *)lip);
>
> This is an unnecessary cast.
> And these could coalesce the format fragments and add newlines too.

and fix the leftover in the comment:
./t4_hw.c:7185:	 * set wont be sent when we are flashing FW.


>
>
>
