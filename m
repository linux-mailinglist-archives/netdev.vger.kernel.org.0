Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887411095C6
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKYWsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:48:06 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37534 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfKYWsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:48:06 -0500
Received: by mail-pj1-f67.google.com with SMTP id bb19so3743188pjb.4
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 14:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6jBfVwBzKUAVplKgJo4hL6w4g+nMxu55ORvKvhv3lQs=;
        b=UKkDt1DndOYnNL9uAn89wmlWJWGw+dcJxyMdE87DAywBUEaJN5cjHxtI3S8QrF/05k
         I5SeQl1LCjQyXBriz33As94QXwexqhGLWkfyZLXnJXdWtgVsDweQ3bMKC4475vlrcD2L
         Ch+dZ4A5h75ULCmvs3KBEJEinYJWo289M7dM/oMNbBlSHFFbU1VuhNdB4A8ytdpiZeK3
         KYK18VOZu8WlauHHLasIsSI+Qw3jjeJOK+2XGCr2savMbFZQCmNuJLbo0R4TUERzzvs5
         rMe3Q8SMIt2mguteW4BNl6No0T+OWeihecA7CjKCblv3SnsyaMmrT+IBDl1GjVGhwjsv
         vzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6jBfVwBzKUAVplKgJo4hL6w4g+nMxu55ORvKvhv3lQs=;
        b=iI6RCZ6aIiwMDTf9YJ5m/zlEbLlaGdhXwRlIbb/lqRA12znbzmS6GlcALwhS79hSXW
         7Intjfo/nE0X+D7hOiGQ93ESJ2XnLsz11FgUomBr/7YYv0Ir6MrmXDUy7bTBGc167K+n
         oTJFQv6tHBBxiSMwtTusDMMOwpZ215WL6W7nQEO6jmIe1AbB5aebpuL3T0xQOo7S3B+A
         JJuy7DMfUb+Vk7I3Let56+1DDJBIbKFAyvwxKrLntqshFmIB9iG2qF2ZkqaSDxEuX/uT
         Kc/d/WvJoHRcMXMMIUaF8XjlNOpI/N8QqsKQXF4PraW46/oGvf/tFZRSuPGok7Ehm0Vi
         jiRw==
X-Gm-Message-State: APjAAAUzgBX2utydgQOUBZbWX6PQXr7HO8mmw+J3PPq6YRvxygbktzAF
        sCvYOEhcwBs88oohI6M6fKw=
X-Google-Smtp-Source: APXvYqxe7kYqCYOuCYb5w5Xk9nAWzJXWj0W/3tjkn0qAVM/L5dHHzJWGu1b3Txor595gUZGEagsJDQ==
X-Received: by 2002:a17:902:ac97:: with SMTP id h23mr24859935plr.237.1574722085641;
        Mon, 25 Nov 2019 14:48:05 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id q70sm400625pjq.26.2019.11.25.14.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 14:48:04 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?Jakub=20Kici=C5=84ski?= <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net: Fix a documentation bug wrt. ip_unprivileged_port_start
Date:   Mon, 25 Nov 2019 14:48:00 -0800
Message-Id: <20191125224800.147072-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <20191125144332.23d7640e@cakuba.hsd1.ca.comcast.net>
References: <20191125144332.23d7640e@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

It cannot overlap with the local port range - ie. with autobind selectable
ports - and not with reserved ports.

Indeed 'ip_local_reserved_ports' isn't even a range, it's a (by default
empty) set.

Fixes: 4548b683b781 ("Introduce a sysctl that modifies the value of PROT_SOCK.")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 Documentation/networking/ip-sysctl.txt | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 099a55bd1432..fd26788e8c96 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -904,8 +904,9 @@ ip_local_port_range - 2 INTEGERS
 	Defines the local port range that is used by TCP and UDP to
 	choose the local port. The first number is the first, the
 	second the last local port number.
-	If possible, it is better these numbers have different parity.
-	(one even and one odd values)
+	If possible, it is better these numbers have different parity
+	(one even and one odd value).
+	Must be greater than or equal to ip_unprivileged_port_start.
 	The default values are 32768 and 60999 respectively.
 
 ip_local_reserved_ports - list of comma separated ranges
@@ -943,8 +944,8 @@ ip_unprivileged_port_start - INTEGER
 	This is a per-namespace sysctl.  It defines the first
 	unprivileged port in the network namespace.  Privileged ports
 	require root or CAP_NET_BIND_SERVICE in order to bind to them.
-	To disable all privileged ports, set this to 0.  It may not
-	overlap with the ip_local_reserved_ports range.
+	To disable all privileged ports, set this to 0.  They must not
+	overlap with the ip_local_port_range.
 
 	Default: 1024
 
-- 
2.24.0.432.g9d3f5f5b63-goog

