Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A7224EA3E
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgHVXNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbgHVXNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:13:49 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030AAC061574
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=3/DNrqH2Afh1WBMVn2/i1ias5Uuqqyo4ZZJHTzcsYYg=; b=Pjja+9+kD+ix+oLWdd8TYVqvKI
        usM0Q7ftgl7ZvbG7nbDy0I1zGtw0AuWGCpRJqdBczYBxSTufFx8vY2yAl8Og9I2KpiJmn41GHJApG
        8cIg57qHhK+k5wpBeTnOuQNW6QYvDviJAhbuHi1HpCZKhSmL8O62f0o/Wy6S2N2t07JN7OwlE8wO7
        EfhSD4P/dVTOPT6BKBNgoWyd2lrm+8w5iXM+IwtKuvVQFq59s/bwzYieRz0sFgRqksoJpgjWE+OE9
        zwIifoqHMTmOOaqX/jU6PMyRrYxnLF/dgpCPILq7zcwgFQmlPUOYo7HvOJqtu8emuCDSTCq5knZqo
        s8+zYraw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9chg-0006Nf-U4; Sat, 22 Aug 2020 23:13:41 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/8] net: batman-adv: delete duplicated words + other fixes
Date:   Sat, 22 Aug 2020 16:13:27 -0700
Message-Id: <20200822231335.31304-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/batman-adv/.


Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>


 net/batman-adv/bridge_loop_avoidance.c |    2 +-
 net/batman-adv/fragmentation.c         |    2 +-
 net/batman-adv/hard-interface.c        |    2 +-
 net/batman-adv/multicast.c             |    2 +-
 net/batman-adv/network-coding.c        |    2 +-
 net/batman-adv/send.c                  |    2 +-
 net/batman-adv/soft-interface.c        |    4 ++--
 net/batman-adv/types.h                 |    4 ++--
 8 files changed, 10 insertions(+), 10 deletions(-)
