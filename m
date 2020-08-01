Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A133234F58
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 03:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHABwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 21:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHABwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 21:52:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8595CC06174A;
        Fri, 31 Jul 2020 18:52:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02FDB11E58FBA;
        Fri, 31 Jul 2020 18:35:21 -0700 (PDT)
Date:   Fri, 31 Jul 2020 18:52:06 -0700 (PDT)
Message-Id: <20200731.185206.111699583152610019.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-07-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731165403.31899-1-johannes@sipsolutions.net>
References: <20200731165403.31899-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 18:35:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 31 Jul 2020 18:54:02 +0200

> Here's a set of patches for -next, in case we get a release
> on Sunday :-) If not I may have some more next week, but no
> point waiting now with this.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
