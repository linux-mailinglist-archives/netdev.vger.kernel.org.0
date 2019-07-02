Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD2B5D23E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfGBPAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:00:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37416 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfGBPAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:00:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so18776041qtk.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+YGwmXcv7uu2nfynM4BuMCgcoI2zuMXaKYw9SxwVbWE=;
        b=LQ3IlvBhtvvp2q4Xk1DvAT+P+LuorF/YSLI5aMavyr/I9CLeIUdKgcPiD3oqcWnHce
         NBlpl7GprU4ycMSH3T7wn1ba5IOwz0/OQR8wkm9SY1F1hYoab1oGWuvAj4dSWTZiPfrT
         2DrhmZbH0+bYz7RAPmzQxIAOgv83BMK64TG1DMuJ2UEtS79Z1SUpBN1mrvbdhTdGfpOA
         aAPj34ieGlmoosp+Z2HnW0k1X0arqLn4FudwQCvDFUyV7iVwRMPuew71jQ0odgw8cWOQ
         BmFTnQ1r36WvN0P/j/9Iqw7XiYyj7fVh7AtmLmu4eoqy1MiMZhSeiqCRYDRZP9SD7Din
         uiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YGwmXcv7uu2nfynM4BuMCgcoI2zuMXaKYw9SxwVbWE=;
        b=SkLfyD2SI/QE5MO82LL2OQeZlFLlfemo5jTzSJFsBR/eu/3E+ObCN6lUpUp3zHGQTr
         P0dBMwIYbf+DZ1kIkFXsHh4sbaDLzMdL7x39+pDAJfGwwjEF9/5KFKX55f634P3RxXdf
         4Yi8XyJuAXEd9HI/DtOIJ4/+hqcjKrEP1dzN7VY4BViIoSwweYc/0dQZlcWYpOEEW0Uo
         mBgKixc2K58QDLavkZ6c1vt2vJOXu8cYlhr5FHos1bWCmIA3fFoASuU38Zy6bzXgWG7z
         0IW2QnzYfnBFc6zZhm9BcN4NKDciA1u7iOIqc2wncQ5AXkHznv/fEzYMGZ0a102IA6BA
         g+Hg==
X-Gm-Message-State: APjAAAUOY9hkZ7dOacEnI+RaDZlX0TYCaULPQeJqnOIxs1naRtetaeex
        gaAgM9TgBKqfIIR+4Mk6Ct2g53GJd/E=
X-Google-Smtp-Source: APXvYqwZxpXZ8drk0t2Y6Zf5C7uK3zRe4uTzBBNOk+AhqnjhsIiSyl5eA7VBKoDm+sUTft76A/Urfg==
X-Received: by 2002:aed:33e6:: with SMTP id v93mr25870674qtd.157.1562079604623;
        Tue, 02 Jul 2019 08:00:04 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c1::1019? ([2620:10d:c091:480::c41e])
        by smtp.gmail.com with ESMTPSA id t197sm6366261qke.2.2019.07.02.08.00.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:00:03 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is disabled
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
 <20190625152708.23729-2-Jes.Sorensen@gmail.com>
 <ff76fcde486792ad01be1476a66a726d6e1ab933.camel@mellanox.com>
Message-ID: <21f6c5a0-49c1-fa47-f55a-048b07f9be1d@gmail.com>
Date:   Tue, 2 Jul 2019 11:00:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ff76fcde486792ad01be1476a66a726d6e1ab933.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 2:00 PM, Saeed Mahameed wrote:
> On Tue, 2019-06-25 at 11:27 -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> The previous patch broke the build with a static declaration for
>> a public function.
>>
>> Fixes: 8f0916c6dc5c (net/mlx5e: Fix ethtool rxfh commands when
>> CONFIG_MLX5_EN_RXNFC is disabled)
>> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> index dd764e0471f2..776040d91bd4 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
>> @@ -1905,7 +1905,8 @@ static int mlx5e_flash_device(struct net_device
>> *dev,
>>  /* When CONFIG_MLX5_EN_RXNFC=n we only support ETHTOOL_GRXRINGS
>>   * otherwise this function will be defined from en_fs_ethtool.c
>>   */
> 
> As the above comment states, when CONFIG_MLX5_EN_RXNFC is disabled,
> mlx5e_get_rxnfc is only defined, declared and used in this file, so it
> must be static. Otherwise it will be defined in another file which
> provides much much more functionality for ethtool flow steering.
> 
> can you please provide more information of what went wrong on your
> build machine ?

Sorry was swamped here!

Looks like you're right, it only triggers in our build due to some
patches we don't have from upstream. I did the patch against upstream
and applied it to our tree, so should have checked further there.

Cheers,
Jes

