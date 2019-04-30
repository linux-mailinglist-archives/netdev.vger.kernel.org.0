Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23ADFEEF3
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 05:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfD3DIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 23:08:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbfD3DIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 23:08:05 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED3FB133FCD47;
        Mon, 29 Apr 2019 20:08:04 -0700 (PDT)
Date:   Mon, 29 Apr 2019 23:08:03 -0400 (EDT)
Message-Id: <20190429.230803.275536802508174338.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH] netlink: limit recursion depth in policy validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190426121346.11005-1-johannes@sipsolutions.net>
References: <20190426121346.11005-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 20:08:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 26 Apr 2019 14:13:46 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Now that we have nested policies, we can theoretically
> recurse forever parsing attributes if a (sub-)policy
> refers back to a higher level one. This is a situation
> that has happened in nl80211, and we've avoided it there
> by not linking it.
> 
> Add some code to netlink parsing to limit recursion depth,
> allowing us to safely change nl80211 to actually link the
> nested policy, which in turn allows some code cleanups.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This doesn't apply cleanly to 'net', is there some dependency I am
unaware of or is this because of a recent mac80211 pull into my tree?

Thanks.
