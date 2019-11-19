Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CBC101086
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKSBMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:12:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKSBMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:12:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EC13150FA106;
        Mon, 18 Nov 2019 17:12:14 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:12:14 -0800 (PST)
Message-Id: <20191118.171214.1598210978663189090.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/5] selftests: Add ethtool and scale tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118075002.1699-1-idosch@idosch.org>
References: <20191118075002.1699-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:12:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 18 Nov 2019 09:49:57 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set adds generic ethtool tests and a mlxsw-specific router
> scale test for Spectrum-2.
> 
> Patches #1-#2 from Danielle add the router scale test for Spectrum-2. It
> re-uses the same test as Spectrum-1, but it is invoked with a different
> scale, according to what it is queried from devlink-resource.
> 
> Patches #3-#5 from Amit are a re-work of the ethtool tests that were
> posted in the past [1]. Patches #3-#4 add the necessary library
> routines, whereas patch #5 adds the test itself. The test checks both
> good and bad flows with autoneg on and off. The test plan it detailed in
> the commit message.
> 
> Last time Andrew and Florian (copied) provided very useful feedback that
> is incorporated in this set. Namely:
> 
> * Parse the value of the different link modes from
>   /usr/include/linux/ethtool.h
> * Differentiate between supported and advertised speeds and use the
>   latter in autoneg tests
> * Make the test generic and move it to net/forwarding/ instead of being
>   mlxsw-specific
> 
> [1] https://patchwork.ozlabs.org/cover/1112903/

Series applied, thank you.
