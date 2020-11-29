Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DBE2C7A9B
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgK2Sdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2Sdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:33:39 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48895C0613D2
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xD2ngAEq0AWMoW0hW5AsWaTLfCLG6WxvGtDvZWC+Xzo=; b=sqeHD4oYwUnidqLiG8TJe2vrZ+
        Uq/IoLfDgZ50qc7AlB5+CUIZIrvH6LFtTtqJOJVoI5J22v3WasraFIeTgY32a7YNTdDYlCa41oLmi
        ba3/bmMiupRgmFRF29a1yEvdRC5LOIsQVtpZ9RPWHvpw00OGWEWCWx8FxVUTy6HJt0XgShoZE0eV+
        yEkGSlIe+pob6tRdO9LLX//u2hu/oOXlSFpbjMq7H+mb20M46q2H38wGxWo37ipnTHSwlBR3ze+qd
        G8OFH+WMek6CUNWt1mn8V4dipf6gwlbeOdoIqYcQR9RbMHadnasVwbpWxSMJmXN9Vf9T0VMLJ5Rg3
        iZD5tszw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVI-00011y-4n; Sun, 29 Nov 2020 18:32:56 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 00/10 net-next v2] net/tipc: fix all kernel-doc and add TIPC networking chapter
Date:   Sun, 29 Nov 2020 10:32:41 -0800
Message-Id: <20201129183251.7049-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix lots of net/tipc/ kernel-doc warnings. Add many struct field and
function parameter descriptions.

Then add a TIPC chapter to the networking documentation book.

All patches have been rebased to current net-next.


Note: some of the struct members and function parameters are marked
with "FIXME". They could use some additional descriptions if
someone could help add to them. Thanks.


Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

[PATCH 01/10 net-next v2] net/tipc: fix tipc header files for kernel-doc
[PATCH 02/10 net-next v2] net/tipc: fix various kernel-doc warnings
[PATCH 03/10 net-next v2] net/tipc: fix bearer.c for kernel-doc
[PATCH 04/10 net-next v2] net/tipc: fix link.c kernel-doc
[PATCH 05/10 net-next v2] net/tipc: fix name_distr.c kernel-doc
[PATCH 06/10 net-next v2] net/tipc: fix name_table.c kernel-doc
[PATCH 07/10 net-next v2] net/tipc: fix node.c kernel-doc
[PATCH 08/10 net-next v2] net/tipc: fix socket.c kernel-doc
[PATCH 09/10 net-next v2] net/tipc: fix all function Return: notation
[PATCH 10/10 net-next v2] net/tipc: add TIPC chapter to networking Documentation


 Documentation/networking/index.rst |    1 
 Documentation/networking/tipc.rst  |  101 +++++++++++++++++++++++++++
 net/tipc/bearer.c                  |   22 +++++
 net/tipc/bearer.h                  |   10 +-
 net/tipc/crypto.c                  |   55 ++++++++------
 net/tipc/crypto.h                  |    6 -
 net/tipc/discover.c                |    5 -
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
 19 files changed, 405 insertions(+), 114 deletions(-)
