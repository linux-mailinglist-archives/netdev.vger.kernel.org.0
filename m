Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8324223199F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgG2GdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2GdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 02:33:23 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EF0C061794;
        Tue, 28 Jul 2020 23:33:22 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id C9EDDC01F; Wed, 29 Jul 2020 08:33:21 +0200 (CEST)
Date:   Wed, 29 Jul 2020 08:33:06 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] 9p update for 5.8
Message-ID: <20200729063306.GA19549@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late request, I took some time to fix my test setup and to
be convinced these two patches are worth sending now and not wait until
the next merge window.

(the "weird" -2 at the end of the tag is because I had already used
9p-for-5.8 for the original -rc1 pull)


The following changes since commit 11ba468877bb23f28956a35e896356252d63c983:

  Linux 5.8-rc5 (2020-07-12 16:34:50 -0700)

are available in the Git repository at:

  https://github.com/martinetd/linux tags/9p-for-5.8-2

for you to fetch changes up to 74d6a5d5662975aed7f25952f62efbb6f6dadd29:

  9p/trans_fd: Fix concurrency del of req_list in
  p9_fd_cancelled/p9_read_work (2020-07-19 14:58:47 +0200)

----------------------------------------------------------------
A couple of syzcaller fixes for 5.8

the first one in particular has been quite noisy ("broke" in -rc5)
so this would be worth landing even this late even if users likely
won't see a difference

----------------------------------------------------------------
Christoph Hellwig (1):
      net/9p: validate fds in p9_fd_open

Wang Hai (1):
      9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work

 net/9p/trans_fd.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)
-- 
Dominique
