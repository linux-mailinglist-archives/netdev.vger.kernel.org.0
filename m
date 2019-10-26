Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71A4E5DE1
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfJZPLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 11:11:31 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43575 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfJZPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 11:11:30 -0400
Received: by mail-yw1-f65.google.com with SMTP id g77so2103736ywb.10
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 08:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=EUuMwUZAF3XeoEXT2139Y7T1weEKSqhdCDgcy9JEUQU=;
        b=LFH4Md2fQFCpFka5XIjS5IY4185oJk+4v7V2tW0QgQn42LpYBkWgTk+RrXwCvUfBP9
         Xi5fRa6RiAPYcc4Mx8ga29HxsXJN19jDk/StlQ+fhPO/GkOJVy6tAOCqdcMLju8dGYLn
         98dwrZPejBeZj2DhzNDooqN54nW/mruaxopavHS8D9H+AQewcS8FXUjyx95S782/FtGs
         ZOMrowBZ+jkuqz/hdgLFEoRzasuOHV2v8fzMKKbpUXejA0IxsykYbL3AuTRnLRNf9N09
         ZK3+rrRmR7zHEs8k5pNdXviyPWwj5DZ26P69QJPvHhIDCvGSpoi0dCdAFFw4jqOWl7SV
         6tZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EUuMwUZAF3XeoEXT2139Y7T1weEKSqhdCDgcy9JEUQU=;
        b=NWrYMtlQ3R/cknXEQNhEokct0knCXL/Gp8KlGoOX/zbi4M2+c329Zar/Hn6SHtzFSG
         I2c0sWJdtSuC2S0OsigTTYSOpLF3Pg/0FN2OWpqukWpvFfSBiH2w1lS1VTR7pYjGGAy7
         /OdyYS1lbM6ueai5YDVex5xbYpBdticEHRjyshpKegMI5T7oxpjl8M4I8BzTuYuJwtPE
         Kt3l38zQxbGycUrl52zdpG6sz+zf3ZSUmpc2jcpKrE8r+gOXFgjUbaLNdk4ap+lOMamj
         BJArRVzXoBCJeXcFdoeBmxisdh3sVbA8ElG48+ZEWG6XIYCP1cfonPIp5qL5JB0TxtdO
         yeoA==
X-Gm-Message-State: APjAAAWtdxNSczvQWFirTGoCVuIpsFA/1LxT/QgucausCTn84k0HOpAk
        AUl/A9LWyvsLPDSP+4QnRTKRkA==
X-Google-Smtp-Source: APXvYqw8xi6AGFI6rXINa2H6wO4BDm4GVN838fohJ1GLtMzc6xkzUM9iUeAU87UmLhp3rXsNv2Poxw==
X-Received: by 2002:a81:9884:: with SMTP id p126mr6232372ywg.486.1572102689719;
        Sat, 26 Oct 2019 08:11:29 -0700 (PDT)
Received: from mojatatu.com ([74.127.202.187])
        by smtp.gmail.com with ESMTPSA id n185sm1588809ywf.86.2019.10.26.08.11.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 26 Oct 2019 08:11:29 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: list required kernel options for act_ct action
Date:   Sat, 26 Oct 2019 11:11:09 -0400
Message-Id: <1572102669-19910-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated config with required kernel options for conntrac TC action,
so that tdc can run the tests.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tools/testing/selftests/tc-testing/config | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 7c551968d184..477bc61b374a 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -1,3 +1,12 @@
+#
+# Core Netfilter Configuration
+#
+CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CONNTRACK_MARK=y
+CONFIG_NF_CONNTRACK_ZONES=y
+CONFIG_NF_CONNTRACK_LABELS=y
+CONFIG_NF_NAT=m
+
 CONFIG_NET_SCHED=y
 
 #
@@ -42,6 +51,7 @@ CONFIG_NET_ACT_CTINFO=m
 CONFIG_NET_ACT_SKBMOD=m
 CONFIG_NET_ACT_IFE=m
 CONFIG_NET_ACT_TUNNEL_KEY=m
+CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_MPLS=m
 CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
-- 
2.7.4

