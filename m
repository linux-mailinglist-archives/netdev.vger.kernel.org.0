Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8333A25817D
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHaTCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgHaTCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:02:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603C9C061573;
        Mon, 31 Aug 2020 12:02:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F6B212869E83;
        Mon, 31 Aug 2020 11:46:05 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:02:50 -0700 (PDT)
Message-Id: <20200831.120250.1316279201672077612.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        johannes.berg@intel.com,
        syzbot+353df1490da781637624@syzkaller.appspotmail.com
Subject: Re: [PATCH] netlink: policy: correct validation type check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831202805.8ca5a2fe1ffb.I46f0d5bee0a774517aeec539620895a473dd2299@changeid>
References: <000000000000ee7d1a05ae2f2720@google.com>
        <20200831202805.8ca5a2fe1ffb.I46f0d5bee0a774517aeec539620895a473dd2299@changeid>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 11:46:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 31 Aug 2020 20:28:05 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> In the policy export for binary attributes I erroneously used
> a != NLA_VALIDATE_NONE comparison instead of checking for the
> two possible values, which meant that if a validation function
> pointer ended up aliasing the min/max as negatives, we'd hit
> a warning in nla_get_range_unsigned().
> 
> Fix this to correctly check for only the two types that should
> be handled here, i.e. range with or without warn-too-long.
> 
> Reported-by: syzbot+353df1490da781637624@syzkaller.appspotmail.com
> Fixes: 8aa26c575fb3 ("netlink: make NLA_BINARY validation more flexible")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thank you.
