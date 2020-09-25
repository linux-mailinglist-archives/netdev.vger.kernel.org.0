Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A7277E45
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 04:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIYC6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 22:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgIYC6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 22:58:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54B4C0613CE;
        Thu, 24 Sep 2020 19:58:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88C79135F8F0C;
        Thu, 24 Sep 2020 19:42:02 -0700 (PDT)
Date:   Thu, 24 Sep 2020 19:58:48 -0700 (PDT)
Message-Id: <20200924.195848.729334260699047552.davem@davemloft.net>
To:     geliangtang@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [MPTCP][PATCH net-next 00/16] mptcp: RM_ADDR/ADD_ADDR
 enhancements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:42:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Thu, 24 Sep 2020 08:29:46 +0800

> This series include two enhancements for the MPTCP path management,
> namely RM_ADDR support and ADD_ADDR echo support, as specified by RFC
> sections 3.4.1 and 3.4.2.
> 
> 1 RM_ADDR support include 9 patches (1-3 and 8-13):
> 
> Patch 1 is the helper for patch 2, these two patches add the RM_ADDR
> outgoing functions, which are derived from ADD_ADDR's corresponding
> functions.
> 
> Patch 3 adds the RM_ADDR incoming logic, when RM_ADDR suboption is
> received, close the subflow matching the rm_id, and update PM counter.
> 
> Patch 8 is the main remove routine. When the PM netlink removes an address,
> we traverse all the existing msk sockets to find the relevant sockets. Then
> trigger the RM_ADDR signal and remove the subflow which using this local
> address, this subflow removing functions has been implemented in patch 9.
> 
> Finally, patches 10-13 are the self-tests for RM_ADDR.
> 
> 2 ADD_ADDR echo support include 7 patches (4-7 and 14-16).
> 
> Patch 4 adds the ADD_ADDR echo logic, when the ADD_ADDR suboption has been
> received, send out the same ADD_ADDR suboption with echo-flag, and no HMAC
> included.
> 
> Patches 5 and 6 are the self-tests for ADD_ADDR echo. Patch 7 is a little
> cleaning up.
> 
> Patch 14 and 15 are the helpers for patch 16. These three patches add
> the ADD_ADDR retransmition when no ADD_ADDR echo is received.

Series applied, thank you.
