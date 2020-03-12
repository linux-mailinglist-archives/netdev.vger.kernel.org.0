Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D278183C89
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCLWc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:32:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgCLWc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:32:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DB2215841951;
        Thu, 12 Mar 2020 15:32:55 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:32:52 -0700 (PDT)
Message-Id: <20200312.153252.145444897248947088.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jiri@resnulli.us,
        andrew@lunn.ch, f.fainelli@gmail.com, linville@tuxdriver.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/15] ethtool netlink interface, part 3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:32:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 12 Mar 2020 21:07:33 +0100 (CET)

> Implementation of more netlink request types:
> 
>   - netdev features (ethtool -k/-K, patches 3-6)
>   - private flags (--show-priv-flags / --set-priv-flags, patches 7-9)
>   - ring sizes (ethtool -g/-G, patches 10-12)
>   - channel counts (ethtool -l/-L, patches 13-15)
> 
> Patch 1 is a style cleanup suggested in part 2 review and patch 2 updates
> the mapping between netdev features and legacy ioctl requests (which are
> still used by ethtool for backward compatibility).
> 
> Changes in v2:
>   - fix netdev reference leaks in error path of ethnl_set_rings() and
>     ethnl_set_channels() (found by Jakub Kicinski)
>   - use __set_bit() rather than set_bit() (suggested by David Miller)
>   - in replies to RINGS_GET and CHANNELS_GET requests, omit ring and
>     channel types not supported by driver/device (suggested by Jakub
>     Kicinski)
>   - more descriptive message size calculations in rings_reply_size() and
>     channels_reply_size() (suggested by Jakub Kicinski)
>   - coding style cleanup (suggested by Jakub Kicinski)

Series applied, thanks Michal.
