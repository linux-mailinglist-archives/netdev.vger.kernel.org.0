Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1F22F0C7F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbhAKF2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbhAKF2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:28:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F8022795;
        Mon, 11 Jan 2021 05:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342883;
        bh=mc5svK7kNbk2ItAXXTBb/+K43sl6Ln8jhje+t0jeH5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Opl1fKORp1bLGzZNhgW0zgzDWmE5HlEGKk0y1iZVfTEqBbA7puExqB736EPu5twfV
         TQ8MUTvn02oX4WqQXOXIWEJgRa/IpEnhEWa4LMdvYNg4ii3IIUBfk2HJt4DYdkW4ho
         fdfdm+UvfRgeLkDxxypB6rNkxjcApkENyWS5LXHSlwCl1NmdQ9eWMo5Z4qbvbeGfna
         5TPgTt/2XZTP+WX07rTzw0BQaIWgHmVigFKT5BlV+QhYr218up5KEEXW1m9a55RtCw
         ccBxR20n+K8HLrWdsC7Wfi899zmlOhNTzlzGwoBSGyRxdkGvI1i77qjtP0hmGtbfY3
         7TNPMQoTRUkEw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net 2/9] MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
Date:   Sun, 10 Jan 2021 21:27:52 -0800
Message-Id: <20210111052759.2144758-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111052759.2144758-1-kuba@kernel.org>
References: <20210111052759.2144758-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move Alexey to CREDITS.

I am probably not giving him enough justice with
the description line..

Subsystem NETWORKING [IPv4/IPv6]
  Changes 1535 / 5111 (30%)
  Last activity: 2020-12-10
  "David S. Miller" <davem@davemloft.net>:
    Author b7e4ba9a91df 2020-12-09 00:00:00 407
    Committer e0fecb289ad3 2020-12-10 00:00:00 3992
    Tags e0fecb289ad3 2020-12-10 00:00:00 3978
  Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
  Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>:
    Tags d5d8760b78d0 2016-06-16 00:00:00 8
  Top reviewers:
    [225]: edumazet@google.com
    [222]: dsahern@gmail.com
    [176]: ncardwell@google.com
  INACTIVE MAINTAINER Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 59a704a45170..3dceea737694 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2142,6 +2142,10 @@ E: seasons@falcon.sch.bme.hu
 E: seasons@makosteszta.sote.hu
 D: Original author of software suspend
 
+N: Alexey Kuznetsov
+E: kuznet@ms2.inr.ac.ru
+D: Author and maintainer of large parts of the networking stack
+
 N: Jaroslav Kysela
 E: perex@perex.cz
 W: https://www.perex.cz
diff --git a/MAINTAINERS b/MAINTAINERS
index 57e17762d411..c6e7f6bf7f6d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12417,7 +12417,6 @@ F:	tools/testing/selftests/net/ipsec.c
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
-M:	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
 M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.26.2

