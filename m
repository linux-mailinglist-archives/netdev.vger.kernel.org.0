Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A602C02FE
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgKWKI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgKWKI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:08:27 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B53C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:08:26 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id a16so22478778ejj.5
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 02:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WoWKjemo0iT1DbHN9ts85XqT0YGU8IxLpaJUob8pzgE=;
        b=jNDlM2fmUkFpbF4NdTLHccsNny9g++VKsQoqBWSKF8V1j5Kxg41Xv+584AKjUSM2LR
         lwOLy/v1XV47wzT39aKhOz9at7a4rpcJ2nzSRH21xgRHkaQ85jsLwfd4ycyL5JilJTAa
         BRAc5Ju9jzGHvaDds3X2yd1puMSesgrJ6oXD4bSEsda84gUII8uepEDu7anHGJR9poVJ
         fhdzZTlXMoMWhDAR8NyElXptLJq+iS/gwpfj2Md8zwSUJ8ZoC8jer8amx8dJorDLDFK+
         EWgnx53EibtrAoyBVHAqwibkFyYXsmiVBVQNHSjlfLYyuTTa+MVddsEQUuyUHN5G/jBp
         xFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoWKjemo0iT1DbHN9ts85XqT0YGU8IxLpaJUob8pzgE=;
        b=DRDvOfV4Ukk6LiFyOTPPucYQx3EASglEqges0cvTkLXZ29dyOvA5/g9Cqn5nkCXDRR
         sUtDjpyQVMfAEqphiFTDSgJpJLdZtqKsbKKzWVfapeXa+xVh3iap5cXXRBT493ZvRfP9
         3lqI0K4JfGYPeGTSjBdfERCy10O2lrB0G3+qXf5d8n/mx972CIm+d1pyvs0EdO4oivC/
         8vJN69OXr3mIAQJbsKDFtSW5XH7oFr3TwQBjDEVzMjgizsDOmi9MMf6F9ZiciI8lf5Ty
         sIQeE4h0Rx8/Lk4aiKCDAC+u37FK+FR1NQKn8QFUI/vNHtJgV+q6vmmkEroskCWy+AmF
         VVgg==
X-Gm-Message-State: AOAM532XNmxpakGqH4u/3KxSuQ2sy29BdTD2Ucl4FDv7lZgZvLGhg3fc
        e3yGi2jXZTAOXPU3+/stFvk=
X-Google-Smtp-Source: ABdhPJyJtue+2LUYGpkPOG0iH/Rf/Upa6Mja3j52BFOt9UkuXLsy21YKzGz1n39zFbCiiDG+b/qxfQ==
X-Received: by 2002:a17:906:a106:: with SMTP id t6mr41640365ejy.63.1606126105668;
        Mon, 23 Nov 2020 02:08:25 -0800 (PST)
Received: from [192.168.1.110] ([77.124.63.70])
        by smtp.gmail.com with ESMTPSA id c8sm4719508edr.29.2020.11.23.02.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 02:08:24 -0800 (PST)
Subject: Re: [PATCH] net: mlx5e: fix fs_tcp.c build when IPV6 is not enabled
To:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201122211231.5682-1-rdunlap@infradead.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <bcb539df-901f-c5a5-697a-a022c1c3bfe5@gmail.com>
Date:   Mon, 23 Nov 2020 12:08:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201122211231.5682-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/22/2020 11:12 PM, Randy Dunlap wrote:
> Fix build when CONFIG_IPV6 is not enabled by making a function
> be built conditionally.
> 
> Fixes these build errors and warnings:
> 
> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c: In function 'accel_fs_tcp_set_ipv6_flow':
> ../include/net/sock.h:380:34: error: 'struct sock_common' has no member named 'skc_v6_daddr'; did you mean 'skc_daddr'?
>    380 | #define sk_v6_daddr  __sk_common.skc_v6_daddr
>        |                                  ^~~~~~~~~~~~
> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:55:14: note: in expansion of macro 'sk_v6_daddr'
>     55 |         &sk->sk_v6_daddr, 16);
>        |              ^~~~~~~~~~~
> At top level:
> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c:47:13: warning: 'accel_fs_tcp_set_ipv6_flow' defined but not used [-Wunused-function]
>     47 | static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)
> 
> Fixes: 5229a96e59ec ("net/mlx5e: Accel, Expose flow steering API for rules add/del")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Boris Pismenny <borisp@nvidia.com>
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
