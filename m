Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76DF616E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfKIU3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:29:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfKIU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:29:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C3FD61474A881;
        Sat,  9 Nov 2019 12:29:34 -0800 (PST)
Date:   Fri, 08 Nov 2019 11:41:22 -0800 (PST)
Message-Id: <20191108.114122.709615181984171200.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: fix 64-bit division on i386
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573223722-400-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1573223722-400-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 09 Nov 2019 12:29:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Fri,  8 Nov 2019 20:05:22 +0530

> Fix following compile error on i386 architecture.
> 
> ERROR: "__udivdi3" [drivers/net/ethernet/chelsio/cxgb4/cxgb4.ko] undefined!
> 
> Fixes: 0e395b3cb1fb ("cxgb4: add FLOWC based QoS offload")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied.
