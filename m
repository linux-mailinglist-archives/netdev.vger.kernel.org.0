Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CFC96CAA
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfHTXFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:05:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfHTXFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 19:05:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59CFD14C652CF;
        Tue, 20 Aug 2019 16:05:18 -0700 (PDT)
Date:   Tue, 20 Aug 2019 16:05:17 -0700 (PDT)
Message-Id: <20190820.160517.617004656524634921.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     jakub.kicinski@netronome.com
Subject: various TLS bug fixes...
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 16:05:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub,

I just did a batch of networking -stable submissions, however I ran
into some troubles with the various TLS backports.

I was able to backport commit 414776621d10 ("net/tls: prevent
skb_orphan() from leaking TLS plain text with offload") to v5.2
but not to v4.19

I was not able to backport neither d85f01775850 ("net: tls, fix
sk_write_space NULL write when tx disabled") nor commit 57c722e932cf
("net/tls: swap sk_write_space on close") to any release.  It seems
like there are a bunch of dependencies and perhaps other fixes.

I suspect you've triaged through this already on your side for other
reasons, so perhaps you could help come up with a sane set of TLS
bug fix backports that would be appropriate for -stable?

Thanks!

