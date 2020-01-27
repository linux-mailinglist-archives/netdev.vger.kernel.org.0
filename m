Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F1C14A3B2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgA0MVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:21:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbgA0MVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:21:18 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 830EC15383A8D;
        Mon, 27 Jan 2020 04:21:16 -0800 (PST)
Date:   Mon, 27 Jan 2020 13:21:14 +0100 (CET)
Message-Id: <20200127.132114.1673510566926844794.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, snelson@pensando.io, michal.kalderon@marvell.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200127054955.GG3870@unreal>
References: <20200126210850.GB3870@unreal>
        <20200126133353.77f5cb7e@cakuba>
        <20200127054955.GG3870@unreal>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 04:21:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 27 Jan 2020 07:49:55 +0200

> We, RDMA and many other subsystems mentioned in that ksummit thread,
> removed MODULE_VERSION() a long time ago and got zero complains from
> the real users.

Changes to RDMA have a disproportionate level of impact compared to
all of netdev.

So comparing the level of real or perceived potential impact is quite
intellectually dishonest.
