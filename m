Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB24019731C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgC3EVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:21:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgC3EVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:21:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9023915C49950;
        Sun, 29 Mar 2020 21:21:37 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:21:36 -0700 (PDT)
Message-Id: <20200329.212136.273575061630425724.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        johannes.berg@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: fix authentication with iwlwifi/mvm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200329225004.115da08b271d.I9712908b102ee30fe76fa72c9ec93c92f52ab689@changeid>
References: <20200329225004.115da08b271d.I9712908b102ee30fe76fa72c9ec93c92f52ab689@changeid>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:21:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 29 Mar 2020 22:50:06 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> The original patch didn't copy the ieee80211_is_data() condition
> because on most drivers the management frames don't go through
> this path. However, they do on iwlwifi/mvm, so we do need to keep
> the condition here.
> 
> Cc: stable@vger.kernel.org
> Fixes: ce2e1ca70307 ("mac80211: Check port authorization in the ieee80211_tx_dequeue() case")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Dave, can you please apply this directly?
> 
> (sorry, I shall remember to use git commit --amend properly)

Unfortunately v5.6 went out without this, but I'll apply it and queue
it up for -stable.

Thanks Johannes.
