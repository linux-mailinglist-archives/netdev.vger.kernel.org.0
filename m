Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C082D511E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgLJDFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:05:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33056 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgLJDFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:05:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 3F0294D259C1F;
        Wed,  9 Dec 2020 19:04:50 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:04:49 -0800 (PST)
Message-Id: <20201209.190449.1520052078880395868.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, geliangtang@gmail.com,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 00/11] mptcp: Add port parameter to ADD_ADDR
 option
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
References: <20201209235128.175473-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:04:50 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Wed,  9 Dec 2020 15:51:17 -0800

> The ADD_ADDR MPTCP option is used to announce available IP addresses
> that a peer may connect to when adding more TCP subflows to an existing
> MPTCP connection. There is an optional port number field in that
> ADD_ADDR header, and this patch set adds capability for that port number
> to be sent and received.
> 
> Patches 1, 2, and 4 refactor existing ADD_ADDR code to simplify implementation
> of port number support.
> 
> Patches 3 and 5 are the main functional changes, for sending and
> receiving the port number in the MPTCP ADD_ADDR option.
> 
> Patch 6 sends the ADD_ADDR option with port number on a bare TCP ACK,
> since the extra length of the option may run in to cases where
> sufficient TCP option space is not available on a data packet.
> 
> Patch 7 plumbs in port number support for the in-kernel MPTCP path
> manager.
> 
> Patches 8-11 add some optional debug output and a little more cleanup
> refactoring.

Series applied, thanks.
