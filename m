Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4A61A12E0
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgDGRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:43:22 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44877 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:43:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id b72so1116415pfb.11
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 10:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3El07I0xnaXLFapWv5OJMrc/yBsvhyzN3qJMVvLQQ98=;
        b=EOLjP5mLWA9vsVBv5YHbCDwdvRhm4lUCqvgcWRaDk9ZgDM++4iOeuOvtuBsqp/htBd
         zzNTvRw2FL6VOkz/1QjNnsEoNbMdVWdHBJntQNfJUt3CkinV5lyz12a6U/5aswCRlkP9
         Bj8cxAlLz1VSJgVk7OUpyaL4+xYnyRrs0Zpns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3El07I0xnaXLFapWv5OJMrc/yBsvhyzN3qJMVvLQQ98=;
        b=IiJkKAAYMhjOdtOg9YlRj5z3X5pcdLfL0INqmTGw0dROSID9/tgQaE84TBIFjn8Vjw
         njPDLEC2j4eb3qsL5TTvMJHzLVH8y3hqnBvdvLX+sUVcmOyXc+voV8k8gwPy1Ej2ui82
         Ci9iEsUsmnkX1VLYS2mRU7C/0JktNBTyV7HIkAELP/sI2ypTPiRBkEyXKJI046zPQWMC
         R7r/X8jsX1yKH2q31x/1dnfe8aGbm1dDe7K2GWvOneD7vL5m0hOiAnqz8HmcDqnIlOv4
         ovFOO3XjCPxXqycRgeumf5gl0aHnGQLfIX6cr86Fh4bpxqB1q0Bg0SbErgXRfUnas8IQ
         6VYg==
X-Gm-Message-State: AGi0PubwEgOS3vj414VLhaS7xXs3eieujDs5DLCin5fimlWrOlhBX+rh
        0M5Yr9CAC4Fu5KebtZQW3UYrB9q3PTU=
X-Google-Smtp-Source: APiQypLrMleP3F/kEe6MCgiIsF1h3GchKk+IlV+Y/To0pyI9taLg6N+ILgyg3mKKz3rTg8Xqxr+I9A==
X-Received: by 2002:a63:58e:: with SMTP id 136mr3120616pgf.311.1586281400718;
        Tue, 07 Apr 2020 10:43:20 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id m3sm14021996pgt.27.2020.04.07.10.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 10:43:19 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH iproute2 2/2] man: replace $(NETNS_ETC_DIR) and $(NETNS_RUN_DIR) in ip-netns(8)
Date:   Tue,  7 Apr 2020 10:43:06 -0700
Message-Id: <20200407174306.145032-2-briannorris@chromium.org>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
In-Reply-To: <20200407174306.145032-1-briannorris@chromium.org>
References: <20200407174306.145032-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These can be configured to different paths. Reflect that in the
generated documentation.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 man/man8/Makefile      |  6 +++++-
 man/man8/ip-netns.8.in | 20 ++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/man/man8/Makefile b/man/man8/Makefile
index 9c62312396a2..b1fd87bdeff0 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -6,7 +6,11 @@ MAN8PAGES = $(TARGETS) $(filter-out $(TARGETS),$(wildcard *.8))
 all: $(TARGETS)
 
 %: %.in
-	sed "s|@SYSCONFDIR@|$(CONFDIR)|g" $< > $@
+	sed \
+		-e "s|@NETNS_ETC_DIR@|$(NETNS_ETC_DIR)|g" \
+		-e "s|@NETNS_RUN_DIR@|$(NETNS_RUN_DIR)|g" \
+		-e "s|@SYSCONFDIR@|$(CONFDIR)|g" \
+		$< > $@
 
 distclean: clean
 
diff --git a/man/man8/ip-netns.8.in b/man/man8/ip-netns.8.in
index c75917dac8b1..2911bdd36575 100644
--- a/man/man8/ip-netns.8.in
+++ b/man/man8/ip-netns.8.in
@@ -61,9 +61,9 @@ By default a process inherits its network namespace from its parent. Initially a
 the processes share the same default network namespace from the init process.
 
 By convention a named network namespace is an object at
-.BR "/var/run/netns/" NAME
+.BR "@NETNS_RUN_DIR@/" NAME
 that can be opened. The file descriptor resulting from opening
-.BR "/var/run/netns/" NAME
+.BR "@NETNS_RUN_DIR@/" NAME
 refers to the specified network namespace. Holding that file
 descriptor open keeps the network namespace alive. The file
 descriptor can be used with the
@@ -72,13 +72,13 @@ system call to change the network namespace associated with a task.
 
 For applications that are aware of network namespaces, the convention
 is to look for global network configuration files first in
-.BR "/etc/netns/" NAME "/"
+.BR "@NETNS_ETC_DIR@/" NAME "/"
 then in
 .BR "/etc/".
 For example, if you want a different version of
 .BR /etc/resolv.conf
 for a network namespace used to isolate your vpn you would name it
-.BR /etc/netns/myvpn/resolv.conf.
+.BR @NETNS_ETC_DIR@/myvpn/resolv.conf.
 
 .B ip netns exec
 automates handling of this configuration, file convention for network
@@ -89,24 +89,24 @@ their traditional location in /etc.
 .TP
 .B ip netns list - show all of the named network namespaces
 .sp
-This command displays all of the network namespaces in /var/run/netns
+This command displays all of the network namespaces in @NETNS_RUN_DIR@
 
 .TP
 .B ip netns add NAME - create a new named network namespace
 .sp
-If NAME is available in /var/run/netns/ this command creates a new
+If NAME is available in @NETNS_RUN_DIR@ this command creates a new
 network namespace and assigns NAME.
 
 .TP
 .B ip netns attach NAME PID - create a new named network namespace
 .sp
-If NAME is available in /var/run/netns/ this command attaches the network
+If NAME is available in @NETNS_RUN_DIR@ this command attaches the network
 namespace of the process PID to NAME as if it were created with ip netns.
 
 .TP
 .B ip [-all] netns delete [ NAME ] - delete the name of a network namespace(s)
 .sp
-If NAME is present in /var/run/netns it is umounted and the mount
+If NAME is present in @NETNS_RUN_DIR@ it is umounted and the mount
 point is removed. If this is the last user of the network namespace the
 network namespace will be freed and all physical devices will be moved to the
 default one, otherwise the network namespace persists until it has no more
@@ -160,7 +160,7 @@ Once it is assigned, it's not possible to change it.
 .TP
 .B ip netns identify [PID] - Report network namespaces names for process
 .sp
-This command walks through /var/run/netns and finds all the network
+This command walks through @NETNS_RUN_DIR@ and finds all the network
 namespace names for network namespace of the specified process, if PID is
 not specified then the current process will be used.
 
@@ -201,7 +201,7 @@ and prints a line for each event it sees.
 .sp
 Network namespace ids are used to identify a peer network namespace. This
 command displays nsids of the current network namespace and provides the
-corresponding iproute2 netns name (from /var/run/netns) if any.
+corresponding iproute2 netns name (from @NETNS_RUN_DIR@) if any.
 
 The
 .B target-nsid
-- 
2.26.0.292.g33ef6b2f38-goog

