Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32DC597F8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfF1Jyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:54:37 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36908 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfF1Jyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:54:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so10198267eds.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=pcJbfKjM2ad/y+5/UddgYg5Cz58j5AZ0qF4vYduQT5G6UbZUJQpTEoZGGg1usZKLP9
         KYS+X07KCpm94g3IW66CGdJociXACubVTm7SNwzltVsVoOB8DfXrZtFc1yjjXL/Zjzll
         L7Z90vOpaCfSK7UggqwkBnKcfHQvnt9Ow9kmpwXhb8c/HnAgmC4IUNJdrDy6b91k8vh1
         f+v7UaDLu9ZNVl2MabYbx27TiH18GvTG9PjGQyRZRjotblzuWlLmbokwCqb4pmIseqPu
         qqtFkxSoNdrQhgmF+3s/HIFzPqCcmktNIqWoNQXpWN59juFzfGXnZjDT3l6pC7ekVMYy
         ITZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=Gyi5hTbDzt0rGPr1S45kXycP2TXWIbdNE/8mPqWi9SnGDDZ6drXYuFqKA7wOcZ3Wb7
         0aTY9lo9OLETGBVKNBGI5nPtyiOQMiUA8qbZWrU7Sq3B4tUBur5pZlFkt0lEmPq5CQvt
         8boqAvFBfNjjxhZs5M8v6wKNjpOXN9VrXzEvaZg4lsFB3lbA37Tb7Tr5Jq6ppYYbeyP/
         xjm5S3V327Gg7HzTwT23Vdt5xiImessLIY+QqLOZETTtHwnZM6uVlUv4z6YRQJpR6dZN
         C2EuVcZHUoDMo8q3hh3NEGnYb+ALRy4pOl7foRxoBw8RfkvbSNhhFLigcye3UeP4/hqJ
         7XzA==
X-Gm-Message-State: APjAAAXtrQyb+ZxOkP2OoGr5hK7ZevQObKFeBJXCySftovlIWOyCIkMF
        Yl/ZQST79OZnANb9b6nYmPy6hw==
X-Google-Smtp-Source: APXvYqz0piUDWyHsW3RnYXb/wRndogljwovgfmSHoyN0JEmE5i8Kz+TBlL9R3yKWDt/16Qv/u9SAGQ==
X-Received: by 2002:a50:f98a:: with SMTP id q10mr10106210edn.267.1561715674240;
        Fri, 28 Jun 2019 02:54:34 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id e12sm536721edb.72.2019.06.28.02.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 02:54:33 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2-next v4 2/2] uapi: update if_link.h
Date:   Fri, 28 Jun 2019 11:54:26 +0200
Message-Id: <20190628095426.2819-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190628095426.2819-1-dkirjanov@suse.com>
References: <20190628095426.2819-1-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

update if_link.h to commit 75345f888f700c4ab2448287e35d48c760b202e6
("ipoib: show VF broadcast address")

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/uapi/linux/if_link.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index bfe7f9e6..5f271d84 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -692,6 +692,7 @@ enum {
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
+	IFLA_VF_BROADCAST,      /* VF broadcast */
 	__IFLA_VF_MAX,
 };
 
@@ -702,6 +703,10 @@ struct ifla_vf_mac {
 	__u8 mac[32]; /* MAX_ADDR_LEN */
 };
 
+struct ifla_vf_broadcast {
+	__u8 broadcast[32];
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
-- 
2.12.3

