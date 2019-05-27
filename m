Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694042B9F1
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfE0SOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:14:35 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35657 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfE0SOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:14:34 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so7318159plo.2
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 11:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NdiYd8sSPlfrsEZldEib90Y3u4Iolll3AVPF6q1jj6M=;
        b=GaXppYPWy2JbkrXvZ0zE17sz8MVOfiOrZpU7wCsGeyFAo08IHLeQRCnOtUbxX++CBg
         TccmzzdooFLNrZhj7pYPQhcv1rpIPmbwl37jcN1D5Ytcp4iYQTQHzq6KZljcKuDhoF6o
         XxxVqye+dH914LvF8Ah4jBbdgw9Jlkk7E6z2VVhsVJgcRhVXJmqm9OaXZWnEDxkNnLar
         f4bJrih/k8sOF5zWG9cFWOYVjfW/+Md6xpRbSR8YG0rmPe4teCria8WQ4gW0EjJ43sBZ
         FGFqGY3UVB9cFO/jQIUtehtHj2XfD4HPVx//wbnpHS8zGbI2gYKN0jGnAB3FyjvtXujc
         HIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NdiYd8sSPlfrsEZldEib90Y3u4Iolll3AVPF6q1jj6M=;
        b=Lg0TW5bQRL6i16SKhTyyjz45ovKjCWY+1Gb/0Z0/iArTE7qR8BztIJf91ehFNgohbk
         +zmAW8WFlJ7klkQjLq/RTALEbZJFq0QkAyWhT8n89H2stejr9TcYBLjKqfjZpm2h5GRx
         ouQ+2jfPMgKFSIGcec5L5YehWn2JlBEW5mPDmBnCYV/BddFKtxftkq8XqnfXXvJvaqjQ
         5/iqxKBeeEeJBMuiWfhXXRvwFE8LkGpB+AuhIhN1rthitp51QaUPFA3wcJ5rmdHwBk1R
         oNVRDttvv6tApo/iAP0n3aSvPm339yCpwWWG1wxi2WzJU0UEDpP/AVfoQXtaUVtT7ZHy
         w2OQ==
X-Gm-Message-State: APjAAAXgQ3D4+mF7EPGx5vE+KMudBbgywIYwHyYpMtybuudXUZ7uNDdB
        yLqGz+n7sxuLmMyIA7+1XCw=
X-Google-Smtp-Source: APXvYqz3+jfEqdZ/4mpBs/It+6KxSY9iczyRN3uAdEbWnLPJxft74SVGvEjFIrOKKDTNpsR45i0qXA==
X-Received: by 2002:a17:902:a708:: with SMTP id w8mr11382565plq.162.1558980874006;
        Mon, 27 May 2019 11:14:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id u11sm11306728pfh.130.2019.05.27.11.14.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 11:14:33 -0700 (PDT)
Subject: Re: [patch net-next 0/7] expose flash update status to user
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
References: <20190523094510.2317-1-jiri@resnulli.us>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a4a0c438-95e7-9f23-072e-33d55fc9f9a5@gmail.com>
Date:   Mon, 27 May 2019 11:14:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/2019 2:45 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> When user is flashing device using devlink, he currenly does not see any
> information about what is going on, percentages, etc.
> Drivers, for example mlxsw and mlx5, have notion about the progress
> and what is happening. This patchset exposes this progress
> information to userspace.
> 
> See this console recording which shows flashing FW on a Mellanox
> Spectrum device:
> https://asciinema.org/a/247926

It would be great to explain why you went that route instead of
implementing a MTD device (like what sfc) which would have presumably
allowed you to more or less the same thing using a standard device
driver model that is establish with flash devices.

> 
> Jiri Pirko (7):
>   mlxsw: Move firmware flash implementation to devlink
>   mlx5: Move firmware flash implementation to devlink
>   mlxfw: Propagate error messages through extack
>   devlink: allow driver to update progress of flash update
>   mlxfw: Introduce status_notify op and call it to notify about the
>     status
>   mlxsw: Implement flash update status notifications
>   netdevsim: implement fake flash updating with notifications
> 
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 -
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  35 ------
>  drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +-
>  .../mellanox/mlx5/core/ipoib/ethtool.c        |   9 --
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  20 ++++
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 +-
>  drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  11 +-
>  .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  57 ++++++++--
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  15 +++
>  drivers/net/ethernet/mellanox/mlxsw/core.h    |   3 +
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  75 +++++++------
>  drivers/net/netdevsim/dev.c                   |  35 ++++++
>  include/net/devlink.h                         |   8 ++
>  include/uapi/linux/devlink.h                  |   5 +
>  net/core/devlink.c                            | 102 ++++++++++++++++++
>  15 files changed, 295 insertions(+), 91 deletions(-)
> 

-- 
Florian
