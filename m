Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD114CA32
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbfFTJDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:03:00 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44417 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfFTJC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:02:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so3558283edr.11
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 02:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=qnaFRngisyT+p14PuQM4uTC8dlxFiXIfU6jhp7Cwm2GDz6fgwVmQt8USkBDUT9Ux95
         L1xy6efGE6QX/urt3iDy8AkQY9e0rp6dzWbjonUY8fW69+l5UovSuqt+APkg2MRZ/vax
         ZToLBDjPMXcvoLE3x4JCXrn4nq3ZmQp2Gg/cQwe/0MJbVu3oFmvGCflWisu10SPdO9rz
         3Ch4QLir3pcuVONevW3GpvAhUm7AO8Cf8T5gA0Zc00A6ti2K2s4ITCI3oFQU79TXOAHo
         ntIvsahdv/hv2/2QAKy9u2VPAeoy0pWCtp1vFHcvhjzF/uUxk+F7Edz4Dz+6Eq9RY5Sk
         iuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HNmoLH7L65zh+oviWZRmLVKzaZLwx+ZIkWckjpUyKBQ=;
        b=sr5eEMDKqeuz0K0O6wwOQ0wWfC/SdjzY7XeyMTSRfFfW+JgRhgOXUNX3rBsyf/ZfW2
         xbd8B6WIlIh8U6ZZxdoVdJlH1P+2Ee9d9MadZ/N/n/uy5/A8ZI0j1fsuEhzxwXHv/zvq
         9e0nYO/eNQQoRDUI0huQOVW+EbNaofhSGh9Lgs11D+GOsiNGzTIhkH0duKVv7Q+MQ+XT
         dKTA4607Ks2mMhCymxWAQZoNn48UXQNpUY9CVf0ZU/EnbqJv3sWlhPjYd/elP8oj8cQC
         cRVrdMkXixvOLmOnaCp+y/4CEsBth3RQ+sx3iSXDmTDvafR3OsbOf4GU67p4j1ebHZdN
         UPeg==
X-Gm-Message-State: APjAAAXr1ooI+jyiBEr2nethz1S+ZeFU688d3Ltv4GS90/G/cz7BIvDs
        kYnZn6hoYefCCWEw78VQWiwkDA==
X-Google-Smtp-Source: APXvYqzrbhv+xcfbMgnz6jmUlvVpz6aC2jzgDXXjRbBQJJaUWmHpbKIPoK1CcFCy4e77AdJLom+Oqg==
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr187614ejd.83.1561021378154;
        Thu, 20 Jun 2019 02:02:58 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id i18sm3765803ede.65.2019.06.20.02.02.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 02:02:57 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2-next v2 2/2] uapi: update if_link.h
Date:   Thu, 20 Jun 2019 11:02:49 +0200
Message-Id: <20190620090249.106704-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190620090249.106704-1-dkirjanov@suse.com>
References: <20190620090249.106704-1-dkirjanov@suse.com>
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

