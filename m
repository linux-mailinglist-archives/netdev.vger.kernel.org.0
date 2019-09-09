Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D65ADFB9
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405928AbfIITzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:55:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42411 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbfIITzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 15:55:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id q14so15559012wrm.9;
        Mon, 09 Sep 2019 12:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H3sorivf6lk7YjlLM7J3YYB/Mg3GHZvlq9G4ZRPM0+w=;
        b=jsAXB23rnjdjeM5UfD+d8i3rxb9hXtPit18YOfRd3EbiP6dm7RN3zDd+O8YqpeIyTC
         WXGqemzkfe4qH2LDBv3v3qS3XmXQvD0JJIO7Xmvgakc+B42WSIPs4ul70IV8VcrBDzYQ
         YYezL2a2qPyVlPFRZujHMBTyzIyd6+Wq30Fp3+/XdfqahSRfjQ2tUIa525SU1EiraU5r
         LxhAns3CMVtR6OKtNQj0ep4s+GpeGPrdMHHKeKPa+sNpHxrzzixRPDQEDQOLNOxPmms8
         U69iXvjpAG08xVGL0kwfcmxvlnBsg5ZCaP/oVYjd903GBRRRNE9nUNlH3d2HvsDOSPok
         AHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H3sorivf6lk7YjlLM7J3YYB/Mg3GHZvlq9G4ZRPM0+w=;
        b=neoP74P9rkSSCZkH3Mu5zdr5VAE9aNHFxKE8ob6XNG4e68P4Y7U6NBEeseCtavvsBd
         Z587hqqFBEiZUAkKuis5fld0gtGHH9O8pL9wvLVKr4Cew3d5vaPaYMccYHKkA7W99Mz5
         KO8Jw+uOXmTT2IiVpy8zNGbx4lqMg4FsTh2vU87p2NCJbQryDCBTDP6nKRuYkVImSZ0m
         S9ZDr45uVnk8gwBqErKPUEW9J1kF8dfoSJxmlcTQm403NW6EknK8yq0+Drp3hjyTraVa
         3hQe8al3Cry5eBEgPi2aGl1xmCwZNGW3t3yNQ4w+Qsq3A5zXcSs5ntjBICdZzMle1FlL
         hAuw==
X-Gm-Message-State: APjAAAUu55R8SUtu91Qekm4wwSw4ecWElzmvsoA1SnpPnlVyinNnSFh4
        RTVyYqLYugiyJNXLi82zbe8=
X-Google-Smtp-Source: APXvYqyKwGblOiuKTrKU5ErG3NY1HMFMZ+2uZS+EfQHfQXVmBKcquLtRW+JLWaDJ3K0/u3qg6rsZjw==
X-Received: by 2002:a05:6000:108e:: with SMTP id y14mr20497197wrw.344.1568058915780;
        Mon, 09 Sep 2019 12:55:15 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id q14sm33391410wrc.77.2019.09.09.12.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 12:55:15 -0700 (PDT)
Date:   Mon, 9 Sep 2019 12:55:13 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next 1/2] mlx5: steering: use correct enum type
Message-ID: <20190909195513.GA94662@archlinux-threadripper>
References: <20190909195024.3268499-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909195024.3268499-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 09:50:08PM +0200, Arnd Bergmann wrote:
> The newly added code triggers a harmless warning with
> clang:
> 
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1080:9: error: implicit conversion from enumeration type 'enum mlx5_reformat_ctx_type' to different enumeration type 'enum mlx5dr_action_type' [-Werror,-Wenum-conversion]
>                         rt = MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
>                            ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1084:51: error: implicit conversion from enumeration type 'enum mlx5dr_action_type' to different enumeration type 'enum mlx5_reformat_ctx_type' [-Werror,-Wenum-conversion]
>                 ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz, data,
>                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            ^~
> 
> Change it to use mlx5_reformat_ctx_type instead of mlx5dr_action_type.
> 
> Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I sent the same fix a couple of days ago:

https://lore.kernel.org/netdev/20190905014733.17564-1-natechancellor@gmail.com/

I don't care which patch goes in since they are the same thing so:

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
