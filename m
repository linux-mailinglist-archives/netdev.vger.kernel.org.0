Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D96C1E365B
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgE0DSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0DSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:18:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4036FC061A0F;
        Tue, 26 May 2020 20:18:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1A9512730EC3;
        Tue, 26 May 2020 20:18:03 -0700 (PDT)
Date:   Tue, 26 May 2020 20:18:01 -0700 (PDT)
Message-Id: <20200526.201801.1163074557874892946.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next next-2020-04-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525142233.42467-1-johannes@sipsolutions.net>
References: <20200525142233.42467-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:18:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 25 May 2020 16:22:32 +0200

> Here's a batch of updates for net-next. I didn't get through
> everything yet, but Kalle needed some of the changes here
> (the ones related to DPP) for some driver changes, so here
> it is.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
