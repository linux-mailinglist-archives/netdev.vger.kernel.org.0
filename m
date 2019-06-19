Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7AD4BAEE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbfFSOOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:14:32 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34407 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfFSOOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:14:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id s49so27526902edb.1
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 07:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=JkqwUOJ2KhL6ElU8NiXPocHkkrgkpMm0P3iOITbTr9OPqePsNMvTdfzNMVyt4dKgHm
         /MozwMQvURD6aIie2Ra2jbp/tLM/IWS0bHrca/ryCSusAy76VML3qCeZ3B70GBk9ZW01
         mguWiA7tX8NY9sxjSDj6BhyfXb5CtGTOXD2yZ9ALW/5ETHT1bXGBZEwa/6+c5HNnG8ca
         W32Hzyk+lAFUUwr0vNSMehti348ZU5m7qprnPv6i5x7QO91f+U2Fh7Q9sOZDlMlFrM9U
         ON+EAdMBl3tLZrIIKlaSAPae6DeBBiAeGCfpgr+uULPRTaoZufoKMOkN3AURnBBixyzi
         yKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=h+W/P/cCnUpfVgzb2UZBnuTBq2MiCvisXwUK3sSoobQOiLRGpCEpkjTw9EGuB7iYHl
         +klirKzRerCHvvDdTBzYkefanwDEgWXzb/JEI7AZIFfUF6QVtcS2if8eWnfOGSKzTENg
         sKIbFnLDn7RAAIcUqBK5XjAJPNYWImIa6E1sJIGf+j1Z9h0zJ/lu5i5WhI8AMyDUc7EK
         0LEpPtOe+NXrspqkhUEOucK2TdzHoLVfGskLRlu13OD55jiWRhmUThQIB/Uhx86QqUCN
         f5aI+VT/IRrPpamMLHWXmIrpGT9FU+5SNRxeuNYYa0n+ot172/GvWAxmCa2lfabfG6hz
         m1bA==
X-Gm-Message-State: APjAAAXLkC9y0xKbBSD7FgMxByOG+/pnsEqRbqs1N0j+qxzAZFNwFS2L
        uddeLNhAs816R/VUIYLH9ZyXMw==
X-Google-Smtp-Source: APXvYqylvVlKjCkXf9SKQvYzpD2/hOMsXkUHInSzmwPZYXNUiBHg28qFA/d0E21MKPC9Y77fRLoHuA==
X-Received: by 2002:a17:906:5007:: with SMTP id s7mr65779550ejj.81.1560953669421;
        Wed, 19 Jun 2019 07:14:29 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id y20sm49633ejj.75.2019.06.19.07.14.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 07:14:28 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2 v2 2/2] uapi: update if_link.h
Date:   Wed, 19 Jun 2019 16:14:14 +0200
Message-Id: <20190619141414.4242-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190619141414.4242-1-dkirjanov@suse.com>
References: <20190619141414.4242-1-dkirjanov@suse.com>
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

