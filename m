Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36127C7FA
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfGaQAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:00:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbfGaQAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 12:00:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8A401264F95F;
        Wed, 31 Jul 2019 09:00:20 -0700 (PDT)
Date:   Wed, 31 Jul 2019 09:00:20 -0700 (PDT)
Message-Id: <20190731.090020.971567041397094932.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2019-07-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731155057.23035-1-johannes@sipsolutions.net>
References: <20190731155057.23035-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 09:00:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 31 Jul 2019 17:50:56 +0200

> There's a fair number of changes here, so I thought I'd get them out.
> I've included two Intel driver cleanups because Luca is on vacation,
> I'm covering for him, and doing it all in one tree let me merge all
> of the patches at once (including mac80211 that depends on that);
> Kalle is aware.
> 
> Also, though this isn't very interesting yet, I've started looking at
> weaning the wireless subsystem off the RTNL for all operations, as it
> can cause significant lock contention, especially with slow USB devices.
> The real patches for that are some way off, but one preparation here is
> to use generic netlink's parallel_ops=true, to avoid trading one place
> with contention for another in the future, and to avoid adding more
> genl_family_attrbuf() usage (since that's no longer possible with the
> parallel_ops setting).
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.

I'm sure people like Florian Westphal will also appreciate your RTNL
elimination work...
