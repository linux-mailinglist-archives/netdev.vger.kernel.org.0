Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04F314D133
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 20:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgA2T3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 14:29:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgA2T3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 14:29:31 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2E5B15C1894A;
        Wed, 29 Jan 2020 11:29:29 -0800 (PST)
Date:   Wed, 29 Jan 2020 20:29:25 +0100 (CET)
Message-Id: <20200129.202925.1646206232932778594.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, rdunlap@infradead.org
Subject: Re: [PATCH net] Revert "MAINTAINERS: mptcp@ mailing list is
 moderated"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200129174137.22948-1-mathew.j.martineau@linux.intel.com>
References: <20200129174137.22948-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 11:29:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Wed, 29 Jan 2020 09:41:37 -0800

> This reverts commit 74759e1693311a8d1441de836c4080c192374238.
> 
> mptcp@lists.01.org accepts messages from non-subscribers. There was an
> invisible and unexpected server-wide rule limiting the number of
> recipients for subscribers and non-subscribers alike, and that has now
> been turned off for this list.
> 
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied, thanks.
