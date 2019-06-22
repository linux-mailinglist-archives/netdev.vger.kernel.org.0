Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517384F7B3
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 20:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFVSAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 14:00:48 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36146 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfFVSAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 14:00:48 -0400
Received: by mail-ed1-f67.google.com with SMTP id k21so15033037edq.3
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 11:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=FLf3IyfJ1VYMzJgCflOEKzJtxEF9klU2hqrRafarqLq51L3pP+EAg6aUWiv1vx1uyW
         HlWKpSLMjMsQxBU7PpK9+xVVTem0i3i/Em+ndm22JYPkysoE/ZrEuIFWYeGsVo/i732P
         t2LcwubTAyH7c4gW253uaShu+GTuSK+r+J2q9NjdDYHkg7BFf0eQ/CQTN/SnBbjxA/SW
         cRe1MqwaFLNTLEkFR51C8wmDc1KQxcO+QWT8wYEHdvnJIj/aYiDuRHO0PCEWWlQbsv8Y
         qWRZU+aw+K7jZ6OhYkuKX7tnyD7By8xbM4opnxfFpvE7f5FqC02ML0dn0J0pHwWtG+nS
         czRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=MXMPion4aJ9ZOY5sHFc9CBe1O1qpbtywtLMwNHGdpygZzmCqyYgNpRLzUXobNpvh3r
         AhKrREpy1dPn026DC9uzdFJB9X1W7UgUMvJKrV/7WcsS031LQPOgPHvbbh3ghfhNjRux
         G+XmGNx4QJfC0FKGD5roBvasC/NKNCmIwzLq3YaCvEIc52Z/TWqWmgeUsmvCO96V5FhZ
         V3nASKin/RD3HX1AWnDU69faLfubKDjV4pvG38RVMlsuHFCcUbxYiVPTwWt4YnV3PXOE
         7gMEd3vU3r+tf4nndka0o8crfpViu/0u/F1iSGHs8tc0Q+a5xHe3pxraNZMQfDfj3Mvf
         3ihQ==
X-Gm-Message-State: APjAAAWVs498FWXDrNgyfHNXPpWspPukPMD9KV3tkcFbAsYLpfGAcUu9
        BkzgwZygZl8Al+Z1mLVDV06QSQ==
X-Google-Smtp-Source: APXvYqyjgncSed+ayGuSbUV16y6JUYqnCUlwUX+TEnKQZaL4n3RbGLo2gnmODtddEUn/3Q0K3oULqA==
X-Received: by 2002:a05:6402:134c:: with SMTP id y12mr53190421edw.96.1561226447015;
        Sat, 22 Jun 2019 11:00:47 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id a8sm1955560edt.56.2019.06.22.11.00.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 11:00:46 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2-next v3 2/2] uapi: update if_link.h
Date:   Sat, 22 Jun 2019 20:00:35 +0200
Message-Id: <20190622180035.40245-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190622180035.40245-1-dkirjanov@suse.com>
References: <20190622180035.40245-1-dkirjanov@suse.com>
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

