Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2598788
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 00:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfHUWuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 18:50:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbfHUWuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 18:50:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C51D014DE8714;
        Wed, 21 Aug 2019 15:50:15 -0700 (PDT)
Date:   Wed, 21 Aug 2019 15:50:13 -0700 (PDT)
Message-Id: <20190821.155013.1723892743521935274.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 15:50:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Wed, 21 Aug 2019 18:00:09 -0400

> I was just made aware of the skb extension work, and it looks very
> appealing from a LSM perspective.  As some of you probably remember,
> we (the LSM folks) have wanted a proper security blob in the skb for
> quite some time, but netdev has been resistant to this idea thus far.
> 
> If I were to propose a patchset to add a SKB_EXT_SECURITY skb
> extension (a single extension ID to be shared among the different
> LSMs), would that be something that netdev would consider merging, or
> is there still a philosophical objection to things like this?

Unlike it's main intended user (MPTCP), it sounds like LSM's would use
this in a way such that it would be enabled on most systems all the
time.

That really defeats the whole purpose of making it dynamic. :-/
