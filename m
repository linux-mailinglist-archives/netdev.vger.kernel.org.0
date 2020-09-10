Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CE9265392
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgIJVhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:37:13 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:39578 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgIJNe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:34:57 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 983ED455AE1;
        Thu, 10 Sep 2020 15:34:40 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1kGMim-0000hO-Ga; Thu, 10 Sep 2020 15:34:40 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net] netlink: fix doc about nlmsg_parse/nla_validate
Date:   Thu, 10 Sep 2020 15:34:39 +0200
Message-Id: <20200910133439.2608-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no @validate argument.

CC: Johannes Berg <johannes.berg@intel.com>
Fixes: 3de644035446 ("netlink: re-add parse/validate functions in strict mode")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/netlink.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index c0411f14fb53..8e0eb2c9c528 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -726,7 +726,6 @@ static inline int __nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
  * @hdrlen: length of family specific header
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
- * @validate: validation strictness
  * @extack: extended ACK report struct
  *
  * See nla_parse()
@@ -824,7 +823,6 @@ static inline int nla_validate_deprecated(const struct nlattr *head, int len,
  * @len: length of attribute stream
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
- * @validate: validation strictness
  * @extack: extended ACK report struct
  *
  * Validates all attributes in the specified attribute stream against the
-- 
2.26.2

