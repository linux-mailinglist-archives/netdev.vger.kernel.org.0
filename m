Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B32B2C6A44
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 17:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731652AbgK0Q4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 11:56:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730786AbgK0Qz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 11:55:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606496158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=0qAEWGn4Ygz5x+wYE49hn+EWcno4zFQXE76Tk4Ktt0U=;
        b=FRBMvmFbPl65XXCSS1YoIJIBQ5bZQRaC3IioOZyQgwOfaIMzZ6v52kfpWqEfO/eLkQIfWN
        /jJVHKWoPO71J+VqQ8mzyyvei1CZVbZH080/ZP9VOikstA+CmuRLn2tf2L8nDCi9gZWVrz
        EuBSe4E+qnalmog1J6UFMHkI3aQuKYA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-qlJM2ksRNHOrHzvka33llA-1; Fri, 27 Nov 2020 11:55:56 -0500
X-MC-Unique: qlJM2ksRNHOrHzvka33llA-1
Received: by mail-qv1-f70.google.com with SMTP id b9so3384139qvj.6
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 08:55:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0qAEWGn4Ygz5x+wYE49hn+EWcno4zFQXE76Tk4Ktt0U=;
        b=j40798uvt7WCcwBXgXU87LgWuL6bjiF/dxZWAR+r3HVJGJlJb5A7r3VWRck81WO2pk
         u3ro5IgleYkAflh91jYbpa563gjxjLXezmxlq4nzLq1eU2H3N7JCQwlKtWPECiJizeHv
         wrHyoTZJvrvw2ixLtTeUKi+6IFBVi5sC9HkJiRhdUauCCzbS2hzMKElZbP9PmkG9Ob88
         aLQOlVEFyR0bMxDwy4sxgQ3a/zgl4mPkUKFpMc1TIUWWwmFycJny5KTH/VXl9CcNecnd
         gjzW5u+C2mpBZSvcqubd46hYydD/HjduMRqqoxEbRPDB7lJKmwCazCdFzylyJGlsSpY9
         2+mg==
X-Gm-Message-State: AOAM530yvLUxnNvWhvd4EKNz4uQG6yXe77HkP1cudjXycRMjbttHc70C
        GZZE2BfElWG0yJ49rFQVnUXx5YzYUVU9k2di7I99iz+AUjH12EbzGgESzisBdHt5eAG++bOXET2
        rgbm2XFlXoyXcWlpB
X-Received: by 2002:a37:a110:: with SMTP id k16mr9555200qke.285.1606496156229;
        Fri, 27 Nov 2020 08:55:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSjRkCIMmHlbhF+qAGpDupEyuAN7UzDqXzDZ1x6otsrSiDo0dj6dYBQosnGyGKPZosb1ZsvA==
X-Received: by 2002:a37:a110:: with SMTP id k16mr9555181qke.285.1606496156067;
        Fri, 27 Nov 2020 08:55:56 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w54sm6942776qtb.0.2020.11.27.08.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:55:55 -0800 (PST)
From:   trix@redhat.com
To:     rmody@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: bna: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 08:55:50 -0800
Message-Id: <20201127165550.2693417-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
index f335b7115c1b..4b19855017d7 100644
--- a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
+++ b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
@@ -218,7 +218,7 @@ do {									\
 
 /* Set the coalescing timer for the given ib */
 #define bna_ib_coalescing_timer_set(_i_dbell, _cls_timer)		\
-	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0));
+	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0))
 
 /* Acks 'events' # of events for a given ib while disabling interrupts */
 #define bna_ib_ack_disable_irq(_i_dbell, _events)			\
@@ -260,7 +260,7 @@ do {									\
 
 #define bna_txq_prod_indx_doorbell(_tcb)				\
 	(writel(BNA_DOORBELL_Q_PRD_IDX((_tcb)->producer_index), \
-		(_tcb)->q_dbell));
+		(_tcb)->q_dbell))
 
 #define bna_rxq_prod_indx_doorbell(_rcb)				\
 	(writel(BNA_DOORBELL_Q_PRD_IDX((_rcb)->producer_index), \
-- 
2.18.4

