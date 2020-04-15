Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91E11AB0B1
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 20:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438114AbgDOS2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 14:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438068AbgDOS2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 14:28:12 -0400
X-Greylist: delayed 80155 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Apr 2020 11:28:12 PDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A10C061A0C;
        Wed, 15 Apr 2020 11:28:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC8B6128AD8C4;
        Wed, 15 Apr 2020 11:28:08 -0700 (PDT)
Date:   Wed, 15 Apr 2020 11:28:05 -0700 (PDT)
Message-Id: <20200415.112805.1849793207144816748.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-04-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415084427.31107-1-johannes@sipsolutions.net>
References: <20200415084427.31107-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 11:28:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 15 Apr 2020 10:44:26 +0200

> So far we only have a few fixes for wireless, nothing really
> that important.
> 
> However, over Easter I found an Easter egg in the form of some
> netlink validation and the policy export patches that I made
> a little more than a year ago (and then evidently forgot about).
> I'll send those once you reopen net-next, but wanted to already
> say that they will depend on pulling the FTM responder policy
> fix into that. Obviously this isn't at all urgent, but for that
> I'd appreciate if you could pull net (with this pull request
> included) into net-next at some point.
> 
> Please pull and let me know if there's any problem.

Thanks for the heads up, pulled.

I'll have net merged into net-next by the time I open that back
up for sure.
