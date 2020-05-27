Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093251E348A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgE0BPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgE0BPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 21:15:39 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD60DC061A0F;
        Tue, 26 May 2020 18:15:39 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id fb16so10475080qvb.5;
        Tue, 26 May 2020 18:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FTgIoFmJ7jfvCnsMHaD2LwHD2SvL+8p8rVd1cLx0pZk=;
        b=a6HfxCcAy2VRykaLYxvM4uw3+o0TAWsiCmJGmNev0x20n4iEYgRdW24Tcy/4Hftcjf
         RcQp1mENUMF4C0fzYbmbqtknxC1cF5tXbG3S5/WBasPozxrC6FYWjQ23yylLTaVLehb9
         NV167rh7foAVhdaT6eE2qiIi/SaQnDoAr5WSxdL7niqBlaEe3ATynnW8ctd+M5ByDPox
         aj4i/ng8QhHv6MQ5faR0F57vqYi4rS1YZrZuPft5KbwdKHEAmA9EImIhX+MVyrg5ZtYs
         +F0nyNeHhYkGiY99qD4XQ7B7bdXCGxFAzcvFG5H/vjyNUBT15ujgVTmRgTRjzKVGA1TS
         tKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FTgIoFmJ7jfvCnsMHaD2LwHD2SvL+8p8rVd1cLx0pZk=;
        b=Q+7BOawyBDeI6sfb9a5Vd/jIY8KxvH/wd0lxSe2zq/X78p3PDUwpQhcxKhWOx//AXj
         oVESGDRKBmkrvg6fFSr+Aw2zO3YNsvs8VYtvhJ6QBZioLPBoXdJ9AKY+FF1w9Z/sIhWz
         Ft1VgB2ur7tgaKqiZ0NQDYlcCn9ReOdppWi82MaaXZJPazSchINtncrncvSa0ckLjjNR
         S9LsSUVRcTuqA4bD44rpPBJ2wB7Rz+eVJMLD0pUvnqvzc0wKDP1sYVPhW803Rl7hWh5x
         Xrb6Ai5UJGdMuuzj1DqUMXyijOYkKpj4VokjuKdKm8iTevPTXW9a15QPZAmk7baXxZzT
         /oMg==
X-Gm-Message-State: AOAM530DF86cJ+fZTtNYDpw4qrWFywLcmZqhB/ZfUAw+6NvqpGuXY4Pp
        WoY6YOzAu0HFurThPO5ww+Y8WaPE
X-Google-Smtp-Source: ABdhPJzhHYEnsFjAcxTahAY8N/o0kUYmHWW2UkM8khFdgcPuVK8kItL3mDaXBSrBe69uoVRE4aPqbA==
X-Received: by 2002:a05:6214:311:: with SMTP id i17mr22067329qvu.59.1590542138847;
        Tue, 26 May 2020 18:15:38 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id m7sm1149167qti.6.2020.05.26.18.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 18:15:38 -0700 (PDT)
Subject: Re: [PATCH] mlxsw: spectrum_router: remove redundant initialization
 of pointer br_dev
To:     Colin King <colin.king@canonical.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200526225649.64257-1-colin.king@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <77496adf-bddf-7911-dacb-f383b5ca6d17@gmail.com>
Date:   Tue, 26 May 2020 19:15:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526225649.64257-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 4:56 PM, Colin King wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 71aee4914619..8f485f9a07a7 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -7572,11 +7572,12 @@ static struct mlxsw_sp_fid *
>  mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
>  			  struct netlink_ext_ack *extack)
>  {
> -	struct net_device *br_dev = rif->dev;
> +	struct net_device *br_dev;
>  	u16 vid;
>  	int err;
>  
>  	if (is_vlan_dev(rif->dev)) {
> +

stray newline added


>  		vid = vlan_dev_vlan_id(rif->dev);
>  		br_dev = vlan_dev_real_dev(rif->dev);
>  		if (WARN_ON(!netif_is_bridge_master(br_dev)))
> 

