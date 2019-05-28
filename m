Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2752C566
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfE1L33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:29:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41788 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfE1L33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:29:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so4613566wrm.8
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ju+JmBh6Rz9RnYdNl3ZgSQ2n4Cm6Io+S86LKE2Ndfc0=;
        b=ydi2A1o22nE9aHkE6n1pV5bhghNjQRxCeAMRZkik1JEWVUWvDYv6txHMzR5ez3w458
         dgNs7EC3ebc7Gv3TGLGwd5ixzPFOUHpZUeg6z6M6Mp4UoKQDa9oSsoH/Sf714Eieo4br
         uAoMZHU9w2b2yaUEWqLV7+m5XOLE7+N5jvhSZRN4vIpf0SxeZVXAXuVyoKHz15hLuEB/
         /Q0K5DiRhIyJ17uWb2/5L3GQ/HA2KqCImbzbqrmNlBzPeXpFWWkDeKd7DV5edWJTnaom
         ROMTq4hixFU4yaGW0quIauW7FKzJwA/QOYQjDa+vcKru7wtHC8gBUeXmQRtLadAlLkto
         mlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ju+JmBh6Rz9RnYdNl3ZgSQ2n4Cm6Io+S86LKE2Ndfc0=;
        b=JSF+4cUsWPQkVY9WDp9815JisK11nGarOQRXIkKOgci6Thrc1+VorOYO15tlxANgFy
         Zl6p7uRgBxJWWg6QOVp3TiKt03riP28A9GkCGu8FqHKl6X3OJYQduOJvzQPQz2mlmFK5
         8fd+Po5t3vwi1AUU3fmFjHLpSgBzZLWGPcRn61JSWHuKzYATtNrLqTXUsbwevhq5zBWA
         UNUhzYtlN3MvqzOLDG0WD0f+62UN/o0w9Ccv9Lq0B8jNkeiHE5AETXvqLUJHKZ+EzMGB
         4rPyOCDyhtqNsmz0vFpmAM2ZrX/69Z2UDnQorBH7NULBY7qDkuL5O9qNTyMun9yV7qgd
         mrCg==
X-Gm-Message-State: APjAAAX6j91A6rjbRha9WvKeXnAbebKbAB358GHmCT+/vDOmRj5IOUiA
        hLL1vgkQqfE7WSNfrehm+e0I6A==
X-Google-Smtp-Source: APXvYqxwx6oYW3kWjoN2hWRpABhVLQRT2Tfou9PDzTKmG6fffflDYenPllH/f6IFbBHa/atyPnbFng==
X-Received: by 2002:a5d:53c8:: with SMTP id a8mr42324700wrw.152.1559042967244;
        Tue, 28 May 2019 04:29:27 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id u2sm40744679wra.82.2019.05.28.04.29.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 04:29:26 -0700 (PDT)
Date:   Tue, 28 May 2019 13:29:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [patch net-next 0/7] expose flash update status to user
Message-ID: <20190528112926.GB2252@nanopsycho>
References: <20190523094510.2317-1-jiri@resnulli.us>
 <c4bd07725a1e5a4d09066eb73094623d8b37082b.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4bd07725a1e5a4d09066eb73094623d8b37082b.camel@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 23, 2019 at 08:37:28PM CEST, saeedm@mellanox.com wrote:
>On Thu, 2019-05-23 at 11:45 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> When user is flashing device using devlink, he currenly does not see
>> any
>> information about what is going on, percentages, etc.
>> Drivers, for example mlxsw and mlx5, have notion about the progress
>> and what is happening. This patchset exposes this progress
>> information to userspace.
>> 
>
>Very cool stuff, \let's update devlink docs with the new potential
>output of the fw flash commands, and show us some output example here
>or on one of the commit messages, it would really help getting an idea
>of what this cool patchset provides. 
>
>> See this console recording which shows flashing FW on a Mellanox
>> Spectrum device:
>> https://asciinema.org/a/247926

This should give you the idea :) It's not easy to add it in static
text...


>> 
>> Jiri Pirko (7):
>>   mlxsw: Move firmware flash implementation to devlink
>>   mlx5: Move firmware flash implementation to devlink
>>   mlxfw: Propagate error messages through extack
>>   devlink: allow driver to update progress of flash update
>>   mlxfw: Introduce status_notify op and call it to notify about the
>>     status
>>   mlxsw: Implement flash update status notifications
>>   netdevsim: implement fake flash updating with notifications
>> 
>>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 -
>>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  35 ------
>>  drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +-
>>  .../mellanox/mlx5/core/ipoib/ethtool.c        |   9 --
>>  .../net/ethernet/mellanox/mlx5/core/main.c    |  20 ++++
>>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   3 +-
>>  drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  11 +-
>>  .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   |  57 ++++++++--
>>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  15 +++
>>  drivers/net/ethernet/mellanox/mlxsw/core.h    |   3 +
>>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  75 +++++++------
>>  drivers/net/netdevsim/dev.c                   |  35 ++++++
>>  include/net/devlink.h                         |   8 ++
>>  include/uapi/linux/devlink.h                  |   5 +
>>  net/core/devlink.c                            | 102
>> ++++++++++++++++++
>>  15 files changed, 295 insertions(+), 91 deletions(-)
>> 
>
>Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
