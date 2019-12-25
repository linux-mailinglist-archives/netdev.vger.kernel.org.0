Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7620D12A66C
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 07:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfLYGf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 01:35:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfLYGf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 01:35:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1F65154D8940;
        Tue, 24 Dec 2019 22:35:28 -0800 (PST)
Date:   Tue, 24 Dec 2019 22:35:28 -0800 (PST)
Message-Id: <20191224.223528.197681217171143712.davem@davemloft.net>
To:     dbolotin@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com
Subject: Re: [PATCH net-next] qede: Implement ndo_tx_timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191222140722.32304-1-dbolotin@marvell.com>
References: <20191222140722.32304-1-dbolotin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 22:35:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Bolotin <dbolotin@marvell.com>
Date: Sun, 22 Dec 2019 16:07:22 +0200

> Disable carrier and print TX queue info on TX timeout.
> 
> Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>

You need to do more than just dump some state.

You have to actually reset the device so that there is a chance that
packets can start flowing again.

If the network is the only way administrators can access the machine
or see the log messages, your state dump will be seen by no-one unless
you reset the device and get it working again.

I'm not applying this, sorry.
