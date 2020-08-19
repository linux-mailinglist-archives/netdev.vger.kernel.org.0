Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1D124A981
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgHSWkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1848FC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A489F11E4576A;
        Wed, 19 Aug 2020 15:23:30 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:16 -0700 (PDT)
Message-Id: <20200819.154016.1340246971401987099.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com
Subject: Re: [PATCH v2] netlink: fix state reallocation in policy export
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819215238.830c1bd10b2e.I316de8a67c79a393ae1826a1b2dcc08f31b1856e@changeid>
References: <20200819215238.830c1bd10b2e.I316de8a67c79a393ae1826a1b2dcc08f31b1856e@changeid>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 15:23:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 19 Aug 2020 21:52:38 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Evidently, when I did this previously, we didn't have more than
> 10 policies and didn't run into the reallocation path, because
> it's missing a memset() for the unused policies. Fix that.
> 
> Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and queued up for -stable, thanks Johannes.
