Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42BE3AEA75
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhFUNyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhFUNx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:53:56 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D05C061767;
        Mon, 21 Jun 2021 06:51:38 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso22913pjp.2;
        Mon, 21 Jun 2021 06:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oat56oXy+eq9YFjUfHTUBj0ELGqmUbrbNMdQSDvWOZY=;
        b=ORC1bRd2LED7D1ipCRVRCwk3nkwGhHzL4i9UqeoHbMer6DdHt2KPkye2SqXcJtIRJ3
         oVdK+u3KThOvxPQL/3F18SegSC79699zmm+A8L1iv3Sa9BiQZ1ehxXQyF2JEnSze2fFC
         UMAEEffmHyY7WUV7yU5yGcdC5NxJzNcB47UtvZsRHu4KeErayVmXrVWDmfNN5ztZYmTd
         Cvii20dPzgrlrE/07hTolkd77B4sTqYvBT9WMdQ0uSyjoyWuERKITiS0D0svh5Aa9yDy
         0BVObAXwMwutxtVPyzlv1hPvUxlwJdHyLDs0PToYLsHqZT+WNRtS+iAnjrN2Ms1ew62D
         oBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oat56oXy+eq9YFjUfHTUBj0ELGqmUbrbNMdQSDvWOZY=;
        b=nX80/M8l1+br0j46zj3eknLu33tzvbuew5hsCFZwcIhAl4/nGivnNimn3w90gAzbap
         ImyZiChytsIk1mDbN+82f5AflG1+GpMo/2pKjoe3S2P2pBoQxlgeg3pLCwFVim4vmzVE
         JRhgBDocM97I4aX3+l5k02qrZCq7RAr24aORFgxvaVufRi/t1kFHwUw9A/Aik70yHv6l
         o+/mlIOJVmJxSSbfddIWHzhy6BJHufED2/dp0xQ1WezWw4XnybkYrlgxNS+kLBFKQv/1
         1yWAQ4LYG7Vbr/Eo5cU3QhGm63k/D/7bQLxWZEr/YvJ0juPfa4k8P0kHJhfBgHdE0wqa
         joQg==
X-Gm-Message-State: AOAM531k/CyetBE4+I67PLs7PYU+yMNsXVa9l498AXjwnr4asONoSj0N
        UGBQq+seFGfIE9jIVOFrhbU=
X-Google-Smtp-Source: ABdhPJzJEfr27phtSC+0vjL45RQyKwZCU9Q0avkrLDXz0ep8+vIniM5cSSXGzX7VSeqGfNAYu1TzAw==
X-Received: by 2002:a17:902:9f93:b029:104:9bae:f56a with SMTP id g19-20020a1709029f93b02901049baef56amr18061276plq.75.1624283497593;
        Mon, 21 Jun 2021 06:51:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d3sm16154940pfn.141.2021.06.21.06.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:51:37 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 15/19] staging: qlge: remove the TODO item about rewriting while loops as simple for loops
Date:   Mon, 21 Jun 2021 21:48:58 +0800
Message-Id: <20210621134902.83587-16-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since all while loops that could be written as simple for loops have
been converted, remove the TODO item.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 8bb6779a5bb4..4575f35114bf 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -6,8 +6,6 @@
   split cases.
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
-* some "while" loops could be rewritten with simple "for", ex.
-  ql_wait_reg_rdy(), ql_start_rx_ring())
 * remove duplicate and useless comments
 * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
   qlge_set_multicast_list()).
-- 
2.32.0

