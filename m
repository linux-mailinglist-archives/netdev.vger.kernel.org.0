Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE00292BF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbfEXIPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:15:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54739 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389234AbfEXIPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:15:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id i3so8353435wml.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 01:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T5whtg5IHaYt7FU4vL1j5x4035f8sz3LCYaMVvlXCys=;
        b=iGCg9cVu/bL1fRVkDfn9gfMCDe9GnIXVBFiIowNTMzaUBlp6nhaaBlbZRGXcE4pKbZ
         V/z5eZ/vvtlXTDTwjBfK6ZW2+ygiiaWJkhN2crOOc3BYjB17dRrDpvf3sV+zY8S3lQDy
         woITWU32aAuoTIyEjT3whLAruEY+HVYTMMzDnD/eeT6iWdCEBP9yIQVSlFyc+Ziq62pi
         eEnnpkl0AWBeiKIPCwlGhTH6P+ACeDf9x7dHzEj6KFhSXiLZxgf3ZkQVOyONGIUTqO4K
         eBH/ZVZju1guAPTpk0nziCseCcb7160WI3KTY6Tkj11LbOtp/z978gGtOUMVu0Q07NCo
         wDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T5whtg5IHaYt7FU4vL1j5x4035f8sz3LCYaMVvlXCys=;
        b=EwFZpeTVF9hd/WPrHyDRtk1zT0Q99gWsamzyMdIlmgHrNEwf+TxVis53HcUoGZe0SX
         UMjrOAttvocBCjGLjEbtwk0gwt+1kUr8so2lli8C7/4jsIfvPaitKgiqoeLQIa7kyO8j
         IocmrAm1hrWE/dUL/W3sO65iwFHBIoj1uQKY4jILr7XLt59+tVu7dWzeclVe71XSZAiC
         UddJOrVVYQIH6TvMwPxpbHtZrGtII/5gqwfRFALeY6iaKmBSC2VJSE6RJOx0Dmh+kWMJ
         qLiBcY8p4OiR+0RKjfX+XZoeUgmZvI3XVcckeI43U52915eWCoHrAqFjPFW+Anv2zejA
         s1wg==
X-Gm-Message-State: APjAAAUesmFLwPw3s3XA/HVv7O+DbiatHmwpU3byVPus6/tu84RRa0WC
        r1b5J27lWiFm3jnQPwci+exufA==
X-Google-Smtp-Source: APXvYqyZPYCZb9DbtOXz/ufBfWtVSBo9pmtVjQSXuQSAeMXTbum/5xAZGdLvRAW/SebdXHBqVBVAzA==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr16038051wmk.72.1558685711732;
        Fri, 24 May 2019 01:15:11 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id e15sm1751797wme.0.2019.05.24.01.15.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 01:15:11 -0700 (PDT)
Date:   Fri, 24 May 2019 10:15:10 +0200
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
Message-ID: <20190524081510.GD2904@nanopsycho>
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

You mean in man? I can put some example there.


>
>> See this console recording which shows flashing FW on a Mellanox
>> Spectrum device:
>> https://asciinema.org/a/247926
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
