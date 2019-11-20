Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E1D1030D1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKTAkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:40:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47480 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfKTAkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:40:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D07B4144B3066;
        Tue, 19 Nov 2019 16:40:46 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:40:46 -0800 (PST)
Message-Id: <20191119.164046.602178453231983091.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: remove unneeded semicolon for switch
 block
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574148656-21462-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1574148656-21462-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 16:40:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Tue, 19 Nov 2019 13:00:56 +0530

> Semicolon is not required at the end of switch block. So, remove it.
> 
> Addresses coccinelle warning:
> drivers/net/ethernet/chelsio/cxgb4/sge.c:2260:2-3: Unneeded semicolon
> 
> Fixes: 4846d5330daf ("cxgb4: add Tx and Rx path for ETHOFLD traffic")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied.
