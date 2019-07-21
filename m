Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01EC6F4B4
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfGUSjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:39:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfGUSjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:39:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA8E115258949;
        Sun, 21 Jul 2019 11:39:29 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:39:27 -0700 (PDT)
Message-Id: <20190721.113927.1404537511431420116.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-07-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190720202456.8444-1-johannes@sipsolutions.net>
References: <20190720202456.8444-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:39:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 20 Jul 2019 22:24:55 +0200

> Sorry, this really should've gone out much earlier, in partilar
> the vendor command fixes. Not much for now, more -next material
> will come later.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
