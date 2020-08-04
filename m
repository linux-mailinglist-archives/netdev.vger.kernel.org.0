Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4AF23B209
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgHDBAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:00:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE47C06174A;
        Mon,  3 Aug 2020 18:00:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C193812787B36;
        Mon,  3 Aug 2020 17:44:00 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:00:45 -0700 (PDT)
Message-Id: <20200803.180045.2201368239765725500.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-08-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803121556.29405-1-johannes@sipsolutions.net>
References: <20200803121556.29405-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 17:44:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon,  3 Aug 2020 14:15:55 +0200

> Not sure you'll still take a few stragglers, but if you're
> going to make a last pass then having a few more things in
> would be nice. One (the while -> if) is something I'd even
> send as a bugfix later, the rest are just nice to have. :)
> 
> Please pull (if you still want) and let me know if there's
> any problem.

Pulled, thank you.
