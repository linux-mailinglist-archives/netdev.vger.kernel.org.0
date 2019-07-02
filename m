Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F211A5D97E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfGCApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:45:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45210 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGCApg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:45:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4489013CEE056;
        Tue,  2 Jul 2019 15:13:29 -0700 (PDT)
Date:   Tue, 02 Jul 2019 15:13:28 -0700 (PDT)
Message-Id: <20190702.151328.1681208493198386546.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com,
        ying.xue@windriver.com, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] tipc: remove ub->ubsock checks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d59889f395b2c224131046c832fe1a8056209107.1562000239.git.lucien.xin@gmail.com>
References: <d59889f395b2c224131046c832fe1a8056209107.1562000239.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 15:13:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  2 Jul 2019 00:57:19 +0800

> Both tipc_udp_enable and tipc_udp_disable are called under rtnl_lock,
> ub->ubsock could never be NULL in tipc_udp_disable and cleanup_bearer,
> so remove the check.
> 
> Also remove the one in tipc_udp_enable by adding "free" label.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Looks good, applied.
