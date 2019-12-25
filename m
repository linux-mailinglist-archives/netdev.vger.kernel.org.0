Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7F712A68E
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 08:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLYHSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 02:18:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfLYHSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 02:18:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D481A154E95E1;
        Tue, 24 Dec 2019 23:18:38 -0800 (PST)
Date:   Tue, 24 Dec 2019 23:18:35 -0800 (PST)
Message-Id: <20191224.231835.1355628010065210167.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, andrew@lunn.ch, f.fainelli@gmail.com,
        linville@tuxdriver.com, stephen@networkplumber.org,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v8 00/14] ethtool netlink interface, part 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1577052887.git.mkubecek@suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 23:18:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon, 23 Dec 2019 00:45:14 +0100 (CET)

> This is first part of netlink based alternative userspace interface for
> ethtool. It aims to address some long known issues with the ioctl
> interface, mainly lack of extensibility, raciness, limited error reporting
> and absence of notifications. The goal is to allow userspace ethtool
> utility to provide all features it currently does but without using the
> ioctl interface. However, some features provided by ethtool ioctl API will
> be available through other netlink interfaces (rtnetlink, devlink) if it's
> more appropriate.
 ...

Please address the feedback for patch #3 (especially the u32-->u8 thing) and
then this series should be good to go!

Thanks!
