Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92E82C6E31
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgK1BfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:35:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731107AbgK0T71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 14:59:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606507152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=3cBR/GAHSZu/mG/kVh3pbERrLW8qnpOV0nfvW9Q+mXU=;
        b=UoTHEUklWlpqlQbQUiYQFUAeivaC/NIiouxNwSjnun3K6Nm7GcyhOKdkk8aZ71VSiWHmf4
        hZL733RRuxvgiz7i9cjA2O0BvQEkzwMojK2J08gdIvmOupR/FMmwwA+/PlUkrYw46W1vUC
        NWtgSf6OS162AJ8cMQiu+ywaKJBUV08=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-R6H6khhJNzis2VRNa8uteQ-1; Fri, 27 Nov 2020 14:20:40 -0500
X-MC-Unique: R6H6khhJNzis2VRNa8uteQ-1
Received: by mail-qt1-f200.google.com with SMTP id o12so3498127qtw.14
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:20:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3cBR/GAHSZu/mG/kVh3pbERrLW8qnpOV0nfvW9Q+mXU=;
        b=SSW0ZNd1VM71SMN8xELFqf31KAOrnwPIW976QxBJLLWv8KeQiIFoFcwqqmMAL1DuYP
         Hk4BtWWGDBsxs4bMzL0zTvM/e+nV3CCFvZ6hgz52WtNzflpEkiel7r8QQ/HrKxF4gRih
         2GddOCj28OtqEm0GVe+xdoQNouo/rV2sdz6JLzDhC1LGsZ29w/5tjZstTVImFIVZDRSM
         6xm8MnGAsJqLJk/F1Zr+h4dE8+dcDMxRHxmz+VsQU1MabMXry10Nv0D6p8tV81nXVkgg
         kBeMYvzgYqjIaHFt6q/82e6dH2glJQljO5ShtJIGqsFOueoziJAC/mb5lBzVWYhVxb0U
         ymbQ==
X-Gm-Message-State: AOAM531+RL23zB3uQvBpZPfybmdY5lCnFV8tGk54IxKEpl6hNBKDr3eH
        oYzHPcU7e0cZZYBUHSyr85WPrOW7UUewZaIeZXR9q8aS4bj7UMk622Bu1asASUOyw2Y/RyOjkah
        j8K8giGlnm2gKmc0F
X-Received: by 2002:aed:2f81:: with SMTP id m1mr9264794qtd.209.1606504840013;
        Fri, 27 Nov 2020 11:20:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwow2CpnnXkAmPv5elf6jRYc2fUaRyRZggyU2yVjFNSThGuDv/h+bB3I0vDIjnpmjS8h7gaFA==
X-Received: by 2002:aed:2f81:: with SMTP id m1mr9264774qtd.209.1606504839841;
        Fri, 27 Nov 2020 11:20:39 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id h4sm7327013qkh.93.2020.11.27.11.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:20:39 -0800 (PST)
From:   trix@redhat.com
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] netfilter: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 11:20:34 -0800
Message-Id: <20201127192034.2858213-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 include/net/netfilter/nf_tables_offload.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 1d34fe154fe0..ae8160b62b10 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -81,7 +81,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 
 #define NFT_OFFLOAD_MATCH_EXACT(__key, __base, __field, __len, __reg)	\
 	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
-	memset(&(__reg)->mask, 0xff, (__reg)->len);
+	memset(&(__reg)->mask, 0xff, (__reg)->len)
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
-- 
2.18.4

