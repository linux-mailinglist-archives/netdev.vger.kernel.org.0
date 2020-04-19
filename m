Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6E81AFDA0
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgDSToj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgDSToi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 15:44:38 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89950C061A0C;
        Sun, 19 Apr 2020 12:44:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n143so1651983qkn.8;
        Sun, 19 Apr 2020 12:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/a00SXdtPLR1UXli00oeOMOKBStwD3QxEoGYBvjNXKA=;
        b=NVDCPA8l7oqxgZUR2EN4/un6Ni8ocqk++OuNEvIbTjfzEAfBnXRBQzHD4YgoVSd4xz
         qCZCbCeE9OIYjGhQ1U1UiCSSkdMJGisqkw/oVPAUbDaYU3d75ez5Hc+pggzYrbSVfC9Z
         5w+N3GoY/58c+82ZI5m6wfeMR5Qx8RNX1Jva9hJfSABVEYRCydsav4OgzRp7WIZQDhIv
         TvlqoVL85v2UhDxz+sneQhJKtazPExPqxdA1BS4r/fq/tl9Fl28eZBVyfBsy07ulH0Nq
         6lu2x2CRa6yLLOWT4+by8EYUAfpm89yZlqm4qFEBwn5kXjr8SAm3DhqrGg2A/X7aijAT
         iEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/a00SXdtPLR1UXli00oeOMOKBStwD3QxEoGYBvjNXKA=;
        b=awXJGFrlrQyz5VQsvbJA6Ts3wKng1ICvdIEOQzHO5EjDGSOgHXa7aOjG/RRw2EuIYQ
         zO5caY4WidtXbUyJi93vnwAwMt5M8JrUMH6NgprRhRP1VKBRzomn4Q3ipcWpt2DmITR0
         huA75V4idloDMARIj2pBq2zsxUYMB6ffY9mo0RQN2mwilsCUwv9/J2J3tSkIdItRpHgt
         4v+wIXXyewhcqCieT56lxmK8OZcorvltVyOTPRZ7MNhmPVQxKjNCBOZGYlZUe5ubhsQA
         gH5BoauI6Dg1YatVYRHuOM4dBBgn0yuabACgCMUUm1vijr8dueZJNykOLPSQPy7qwdOj
         kS2g==
X-Gm-Message-State: AGi0PuYDh/vQBYoxdIEa/a0Ipvbir4hsSAwDjk8rF0MqwsHrhTTg8M+0
        CcGV4eHA6l3Ht3GZTmb8jK6Bgrpl
X-Google-Smtp-Source: APiQypLQyJLMB8U7Ux4CMOC/JrBsRNv9p50j/KhDzT+BgNL0o8BcydpRFHifdyGKjn+y1AGBPsGZqA==
X-Received: by 2002:a37:4885:: with SMTP id v127mr12647564qka.253.1587325477837;
        Sun, 19 Apr 2020 12:44:37 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id b201sm1531138qkg.32.2020.04.19.12.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 12:44:37 -0700 (PDT)
Subject: Re: [PATCH mlx5-next 00/10] Add support to get xmit slave
To:     Maor Gottlieb <maorg@mellanox.com>, davem@davemloft.net,
        jgg@mellanox.com, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200419133933.28258-1-maorg@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ac373456-b838-29cf-645f-b1ea1a93e3b0@gmail.com>
Date:   Sun, 19 Apr 2020 13:44:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419133933.28258-1-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/20 7:39 AM, Maor Gottlieb wrote:
> Hi Dave,
> 
> This series is a combination of netdev and RDMA, so in order to avoid
> conflicts, we would like to ask you to route this series through
> mlx5-next shared branch. It is based on v5.7-rc1 tag.
> 
> ---------------------------------------------------------------------
> 
> The following series adds support to get the LAG master xmit slave by
> introducing new .ndo - ndo_xmit_slave_get. Every LAG module can

I do not see ndo_xmit_slave_get  introduced ...


> 
>  drivers/infiniband/core/Makefile              |   2 +-
>  drivers/infiniband/core/lag.c                 | 139 +++++++++
>  drivers/infiniband/core/verbs.c               |  44 ++-
>  drivers/infiniband/hw/mlx5/ah.c               |   4 +
>  drivers/infiniband/hw/mlx5/gsi.c              |  34 ++-
>  drivers/infiniband/hw/mlx5/main.c             |   2 +
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |   1 +
>  drivers/infiniband/hw/mlx5/qp.c               | 123 +++++---
>  drivers/net/bonding/bond_alb.c                |  39 ++-
>  drivers/net/bonding/bond_main.c               | 272 +++++++++++++-----
>  drivers/net/ethernet/mellanox/mlx5/core/lag.c |  66 +++--
>  include/linux/mlx5/driver.h                   |   2 +
>  include/linux/mlx5/mlx5_ifc.h                 |   4 +-
>  include/linux/mlx5/qp.h                       |   2 +
>  include/linux/netdevice.h                     |   3 +

nor any changes to netdevice.h. Bad spin of the patches?

