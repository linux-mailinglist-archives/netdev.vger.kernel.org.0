Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA84E6F585
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 22:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfGUUWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 16:22:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34620 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfGUUWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 16:22:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CED26152639D5;
        Sun, 21 Jul 2019 13:22:30 -0700 (PDT)
Date:   Sun, 21 Jul 2019 13:22:26 -0700 (PDT)
Message-Id: <20190721.132226.202282272152745361.davem@davemloft.net>
To:     bpoirier@suse.com
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        fyang@suse.com, saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] be2net: Synchronize be_update_queues with
 dev_watchdog
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718014218.16610-1-bpoirier@suse.com>
References: <20190718014218.16610-1-bpoirier@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 13:22:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.com>
Date: Thu, 18 Jul 2019 10:42:18 +0900

> As pointed out by Firo Yang, a netdev tx timeout may trigger just before an
> ethtool set_channels operation is started. be_tx_timeout(), which dumps
> some queue structures, is not written to run concurrently with
> be_update_queues(), which frees/allocates those queues structures. Add some
> synchronization between the two.
> 
> Message-id: <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>

Applied and queued up for -stable, thanks.
