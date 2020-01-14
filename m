Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A2B13B333
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgANTtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:49:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgANTtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:49:11 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF4DE154936D1;
        Tue, 14 Jan 2020 11:49:10 -0800 (PST)
Date:   Tue, 14 Jan 2020 11:49:10 -0800 (PST)
Message-Id: <20200114.114910.1428492219974475547.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] skb_list_walk_safe refactoring for
 net/*'s skb_gso_segment usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 11:49:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 13 Jan 2020 18:42:25 -0500

> This patchset adjusts all return values of skb_gso_segment in net/* to
> use the new skb_list_walk_safe helper.
> 
> First we fix a minor bug in the helper macro that didn't come up in the
> last patchset's uses. Then we adjust several cases throughout net/. The
> xfrm changes were a bit hairy, but doable. Reading and thinking about
> the code in mac80211 indicates a memory leak, which the commit
> addresses. All the other cases were pretty trivial.

Series applied, thanks Jason.
