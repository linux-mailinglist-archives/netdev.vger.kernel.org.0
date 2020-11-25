Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D4A2C37FF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgKYEUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E7C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=9eXnDktDfqGJ+NC4j0WUnqA8KoJDcvzdw9wfvl8FSYY=; b=lBrNHWTo447p+lcT2+5R1eCHNu
        Jf0PrJFVCHWBF+B0/Co+G3djRLY7AG45mcHNXaY3+VxIn+4kfzgoaYZYg40uaLobd55d0ecEslAiG
        e/25+Xnaf8N8rFtV3bRhI/qh6vy0gqXX68x+oC2qywFa581gAIUz3ZxWUrfPKg1alAEahlIAuCgKD
        qe2rxYJfX2Um249l5+9qhNnmNfs3DtR5C9PVZShh7Xu5mYtFX7rZa0b+bcQoTw5EFpvcNCymNah2j
        wjSJMlR7zQTngdwlgJxFqJEQJzcBdXMQAad+XFa8QdtnaEiD7FydboSn+MxEkrEXEIQeRoRVjKwM9
        OU0Rruwg==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIA-0000SB-23; Wed, 25 Nov 2020 04:20:31 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 00/10 net-next] net/tipc: fix all kernel-doc and add TIPC networking chapter
Date:   Tue, 24 Nov 2020 20:20:16 -0800
Message-Id: <20201125042026.25374-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix lots of net/tipc/ kernel-doc warnings. Add many struct field and
function parameter descriptions.

Then add a TIPC chapter to the networking documentation book.


Note: some of the struct members and function parameters are marked
with "FIXME". They could use some additional descriptions if
someone could help add to them. Thanks.


Question: is net/tipc/discover.c, in tipc_disc_delete() kernel-doc,
what is the word "duest"?  Should it be changed?


Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

[PATCH 01/10 net-next] net/tipc: fix tipc header files for kernel-doc
[PATCH 02/10 net-next] net/tipc: fix various kernel-doc warnings
[PATCH 03/10 net-next] net/tipc: fix bearer.c for kernel-doc
[PATCH 04/10 net-next] net/tipc: fix link.c kernel-doc
[PATCH 05/10 net-next] net/tipc: fix name_distr.c kernel-doc
[PATCH 06/10 net-next] net/tipc: fix name_table.c kernel-doc
[PATCH 07/10 net-next] net/tipc: fix node.c kernel-doc
[PATCH 08/10 net-next] net/tipc: fix socket.c kernel-doc
[PATCH 09/10 net-next] net/tipc: fix all function Return: notation
[PATCH 10/10 net-next] net/tipc: add TIPC chapter to networking Documentation


 Documentation/networking/index.rst |    1 
 Documentation/networking/tipc.rst  |  101 +++++++++++++++++++++++++++
 net/tipc/bearer.c                  |   22 +++++
 net/tipc/bearer.h                  |   10 +-
 net/tipc/crypto.c                  |   55 ++++++++------
 net/tipc/crypto.h                  |    6 -
 net/tipc/discover.c                |    3 
 net/tipc/link.c                    |   46 ++++++++++--
 net/tipc/msg.c                     |   29 ++++---
 net/tipc/name_distr.c              |   29 +++++++
 net/tipc/name_distr.h              |    2 
 net/tipc/name_table.c              |   46 +++++++++---
 net/tipc/name_table.h              |    9 +-
 net/tipc/node.c                    |   37 ++++++++-
 net/tipc/socket.c                  |   92 +++++++++++++++---------
 net/tipc/subscr.c                  |    8 +-
 net/tipc/subscr.h                  |   11 +-
 net/tipc/trace.c                   |    2 
 net/tipc/udp_media.c               |    8 +-
 19 files changed, 404 insertions(+), 113 deletions(-)
