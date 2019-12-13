Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF5611DB7E
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfLMBHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:07:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfLMBHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:07:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58E3B15422CD6;
        Thu, 12 Dec 2019 17:07:49 -0800 (PST)
Date:   Thu, 12 Dec 2019 17:07:48 -0800 (PST)
Message-Id: <20191212.170748.409220660557209092.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, andrew@lunn.ch, f.fainelli@gmail.com,
        linville@tuxdriver.com, stephen@networkplumber.org,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/5] ethtool netlink interface, preliminary
 part
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576057593.git.mkubecek@suse.cz>
References: <cover.1576057593.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 17:07:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 11 Dec 2019 10:58:09 +0100 (CET)

> As Jakub Kicinski suggested in ethtool netlink v7 discussion, this
> submission consists only of preliminary patches which raised no objections;
> first four patches already have Acked-by or Reviewed-by.
> 
> - patch 1 exposes permanent hardware address (as shown by "ethtool -P")
>   via rtnetlink
> - patch 2 is renames existing netlink helper to a better name
> - patch 3 and 4 reorganize existing ethtool code (no functional change)
> - patch 5 makes the table of link mode names available as an ethtool string
>   set (will be needed for the netlink interface) 
> 
> Once we get these out of the way, v8 of the first part of the ethtool
> netlink interface will follow.
> 
> Changes from v2 to v3: fix SPDX licence identifiers (patch 3 and 5).
> 
> Changes from v1 to v2: restore build time check that all link modes have
> assigned a name (patch 5).

Series applied to net-next, thanks.
