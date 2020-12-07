Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0B92D093D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 03:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgLGCt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 21:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgLGCt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 21:49:27 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0866DC0613D0;
        Sun,  6 Dec 2020 18:48:47 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id i6so5134091otr.2;
        Sun, 06 Dec 2020 18:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HHEKxHRp3ZgcW42jBbUIw2jXdfRrwJoBXqbGrhb6jdU=;
        b=uuRCsTg798AIg9LU8LXMWREd5BUlvPCc2LXiHZMgdMfP0L8Kgbw2n9OgZ6gxJ9dcGf
         Wp2vyEoHpoPn6CbDUEK4UKnF4JsHKnvHIwGcIXOT8rKhOBwxE4/dxE76zXyDriNROl/X
         yIaayZLqNj49XREnvsCvE7C8nouawz8ru/hCCgLxSDLRANlEEGXZ83XEyVFp42DS7GWZ
         3hbkw4M2641sDASw0NrXhMK4yowSzsQw/3Gkbxnfzv7XeQQUnfdUOhyD8P48XEMNSV43
         aiQPE8dRYHFVR+J0+rSqAAubhxzkd/JTrpQtkXWEiivMLzpDedMKHHwQuJyjpJ69R0wo
         oz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHEKxHRp3ZgcW42jBbUIw2jXdfRrwJoBXqbGrhb6jdU=;
        b=HKf83aQRNrO2fVuZ/zgJJbzQCsShRTAlyY6jn6iQelzUIfI6Jc/5gflIliFH7layln
         iMCXXlCXZrTztxzYdDbKLNqdEjYGkgA+NhvR00ezw40tLyrPaLu5t4AwvZaFJHfJCyYy
         bkRO3mN7eGtfxL85tsjAlBKGOh8dabHwehl63cD3Kj/l3hGuxTEE4A7RC3JkXtiDpjUp
         PpGphduRx4BheHC64oxZ2GE4nfrwNsRQH7ULVdBQTvR3b/Nx45cqkRIpz+ngA+PmJ6xi
         qfkBPN8U/T3Vm8s3k+VaTSHgf+UgcR4XDlBE9LgAlg9F49bx7KQRriti3NGYuVPSKtcT
         fQjA==
X-Gm-Message-State: AOAM5337GgZ/MVORY0DZFKn4NSE3wptI69bQWwMzWXGTuD+Y+aM/hfZ7
        k2lUputp8eC2l5gc8Th8Aq8=
X-Google-Smtp-Source: ABdhPJw5rhD7Ga9bqQbgrXDBRXdOLceoPsG6dZiNO7zgI+ZL/DoStccvv5kQ0nJPuylW0RMxXTX5OQ==
X-Received: by 2002:a05:6830:1551:: with SMTP id l17mr11418102otp.279.1607309326416;
        Sun, 06 Dec 2020 18:48:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id l132sm2574845oia.23.2020.12.06.18.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 18:48:45 -0800 (PST)
Subject: Re: [PATCH net-next 07/13] net/mlx5: SF, Add auxiliary device support
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     jiri@nvidia.com, jgg@nvidia.com, dledford@redhat.com,
        leonro@nvidia.com, saeedm@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-8-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b9e84fd1-1af4-d979-184d-cbbeedec1aa0@gmail.com>
Date:   Sun, 6 Dec 2020 19:48:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201112192424.2742-8-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 12:24 PM, Parav Pandit wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index 485478979b1a..10dfaf671c90 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -202,3 +202,12 @@ config MLX5_SW_STEERING
>  	default y
>  	help
>  	Build support for software-managed steering in the NIC.
> +
> +config MLX5_SF
> +	bool "Mellanox Technologies subfunction device support using auxiliary device"
> +	depends on MLX5_CORE && MLX5_CORE_EN
> +	default n
> +	help
> +	Build support for subfuction device in the NIC. A Mellanox subfunction
> +	device can support RDMA, netdevice and vdpa device.
> +	It is similar to a SRIOV VF but it doesn't require SRIOV support.

per Dan's comment about AUXILIARY_BUS being select only, should this
config select AUXILIARY_BUS?
