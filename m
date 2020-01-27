Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B0514A0FB
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgA0Jky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:40:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36552 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgA0Jky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:40:54 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DD7814F4667D;
        Mon, 27 Jan 2020 01:40:51 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:40:49 +0100 (CET)
Message-Id: <20200127.104049.2252228859572866640.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us,
        andrew@lunn.ch, f.fainelli@gmail.com, linville@tuxdriver.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] ethtool netlink interface, part 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 01:40:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Sun, 26 Jan 2020 23:10:58 +0100 (CET)

> This shorter series adds support for getting and setting of wake-on-lan
> settings and message mask (originally message level). Together with the
> code already in net-next, this will allow full implementation of
> "ethtool <dev>" and "ethtool -s <dev> ...".
> 
> Older versions of the ethtool netlink series allowed getting WoL settings
> by unprivileged users and only filtered out the password but this was
> a source of controversy so for now, ETHTOOL_MSG_WOL_GET request always
> requires CAP_NET_ADMIN as ETHTOOL_GWOL ioctl request does.

It looks like this will need to be respun at least once, and net-next
is closing today so....
