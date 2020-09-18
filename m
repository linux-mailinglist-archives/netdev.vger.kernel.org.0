Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7097526F52B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIREfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIREfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B501C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=n4Gc+0RvzGQWA10Fpg9SvRLZH3LW5Dpcmb7wY0vEI5s=; b=swoNplKOuGHYbPhRnS4tCFklXm
        THaQRyuX640zuQALsnWu1EPu6Uocsxl7aPuF3Lk49WIgobJUvueydwnCa2o43LihyA1dSbZ8cfkvI
        Ww4V9VBe5FL5iL2/TwVk8PrDNCJbWqcCcNqPEyJzlloprpm2v6rwIe3g3ou2gHf+dvsUtFqm1kR87
        jwY0TWkvAE/f9DVeuJR/SSjE9j+qOsGXbDkXkoq4hQBGNhexZZx2l0ddO2Ct2IBHbYqCYYFTTQpvn
        PDk5LFZcPrNBy4oVX20dx7iXYCBtd5/mc4brhT5ldAm75jFzzYvR2FBGG8vUlitRbZRNm281J9P/h
        /Ic7IeFQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87I-0003Ci-Hn; Fri, 18 Sep 2020 04:35:26 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/7 net-next] net: various: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:14 -0700
Message-Id: <20200918043521.17346-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[PATCH 1/7 net-next] net: core: delete duplicated words
[PATCH 2/7 net-next] net: rds: delete duplicated words
[PATCH 3/7 net-next] net: ipv6: delete duplicated words
[PATCH 4/7 net-next] net: bluetooth: delete duplicated words
[PATCH 5/7 net-next] net: tipc: delete duplicated words
[PATCH 6/7 net-next] net: atm: delete duplicated words
[PATCH 7/7 net-next] net: bridge: delete duplicated words


Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

 net/atm/lec.c            |    2 +-
 net/atm/signaling.c      |    2 +-
 net/bluetooth/hci_conn.c |    2 +-
 net/bluetooth/hci_core.c |    2 +-
 net/bridge/br_ioctl.c    |    2 +-
 net/bridge/br_vlan.c     |    2 +-
 net/core/dev.c           |    4 ++--
 net/ipv6/ip6_output.c    |    2 +-
 net/ipv6/tcp_ipv6.c      |    2 +-
 net/rds/cong.c           |    2 +-
 net/rds/ib_cm.c          |    2 +-
 net/tipc/msg.c           |    2 +-
 net/tipc/socket.c        |    2 +-
 13 files changed, 14 insertions(+), 14 deletions(-)
