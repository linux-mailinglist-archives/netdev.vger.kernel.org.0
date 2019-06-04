Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E953A351C3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDVV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:21:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52550 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:21:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C35A414FD0C64;
        Tue,  4 Jun 2019 14:21:56 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:21:56 -0700 (PDT)
Message-Id: <20190604.142156.883212235599705133.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [patch net-next v3 0/8] expose flash update status to user
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:21:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue,  4 Jun 2019 15:40:36 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> When user is flashing device using devlink, he currenly does not see any
> information about what is going on, percentages, etc.
> Drivers, for example mlxsw and mlx5, have notion about the progress
> and what is happening. This patchset exposes this progress
> information to userspace.
> 
> Example output for existing flash command:
> $ devlink dev flash pci/0000:01:00.0 file firmware.bin
> Preparing to flash
> Flashing 100%
> Flashing done
> 
> See this console recording which shows flashing FW on a Mellanox
> Spectrum device:
> https://asciinema.org/a/247926

Series applied, thanks.
