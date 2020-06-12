Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A451F7E0D
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 22:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgFLU2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 16:28:06 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:51996 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgFLU2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 16:28:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 49kC361Shpz9vpNf
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 20:28:02 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9Pzj-BTr6U-l for <netdev@vger.kernel.org>;
        Fri, 12 Jun 2020 15:28:02 -0500 (CDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 49kC356w1tz9vpNX
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 15:28:01 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p7.oit.umn.edu 49kC356w1tz9vpNX
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p7.oit.umn.edu 49kC356w1tz9vpNX
Received: by mail-io1-f70.google.com with SMTP id r11so6824466ioa.12
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 13:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=15g7t7Uei6AmpLN3ekbAqZ45/3DFCsrsD7nCEei6vOg=;
        b=R3pCRUqHU9BitaWWtCt5Z2/yajAtRzxQgM0OvAPYqThro6GY8jb5QI3sfLmf0JHjG1
         2i1TuFSnZ7utZNNYoQ1e/ttJ5lNDz+Y1RfsBFueSj57DghPX0XxhFvGmvrtBSqsI5XBC
         g/jlLtaLjh34bTcS0P54PfMVDHa1SNU4eiuXYaVk1cwGQUmF109ois/t/BhzRlAS9atI
         nV49jCWjqSw0i+KPPiBV4dMhCO8WyXlJq3V0selPPMqWGNkZcnVgMRhJXrPwDebXt6FR
         zKR4Js63iOuGRMsJDXakKew2cezTXYOJM1khIwJJaaLklO9NUYOka3rjSmqrsk12EJAg
         YHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=15g7t7Uei6AmpLN3ekbAqZ45/3DFCsrsD7nCEei6vOg=;
        b=sqvHpqjQtjay6Y5HsoWrQYRFSBz8YOWMhL3JJQYn63Qr5xMfKLeWlCGMIuii6dDPtJ
         fH624+5cXXK2PRmjBCweYBgIcD6cksr726I0UQq1sMl63TxZvZaS30RmkM/RUvExuTYm
         ALpwVn+1El/nZKJRiT3lOdX/5FvouEWfWTnTtDMJfmvsoNAfmoeR4WYk3tDKvnr07JRk
         hCLQOn2tsg/yufOdDjRguYqesf4peymF1uK/T3SwkwweR3cFUiRjCp7G6IhWRNJ67vd5
         W8xx+vSHCjmhsPj7Qon1gpvycWU2GrUB9u15YV9XkMJaC1BAwIlzJCUggRs9+IYzGjcY
         NPbg==
X-Gm-Message-State: AOAM533C/tLvwz6BP9s6Z4TcCB0bilNg8eNFK3wfCE9WPpKpvrXAaMPY
        uHz3c/DFmgqZmmS92MRSRxVElGISmckve01ll2wRhRBYewDeE9A1GP7g7ZPGzXpIQRhRhuhUfr9
        PArixlQSgUZhI052vOaxP
X-Received: by 2002:a05:6e02:8ea:: with SMTP id n10mr14152587ilt.58.1591993681603;
        Fri, 12 Jun 2020 13:28:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrCxyRcnu/uj9UMguP3lKGMvs3vnk4/rXTUtjzr6ELOw0xUTbZ5xJTp7kURkky+wDW/4Kaww==
X-Received: by 2002:a05:6e02:8ea:: with SMTP id n10mr14152574ilt.58.1591993681403;
        Fri, 12 Jun 2020 13:28:01 -0700 (PDT)
Received: from piston-t1.hsd1.mn.comcast.net ([2601:445:4380:5b90:79cf:2597:a8f1:4c97])
        by smtp.googlemail.com with ESMTPSA id r1sm3565653iln.77.2020.06.12.13.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 13:28:00 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, wu000273@umn.edu, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rocker: fix incorrect error handling in dma_rings_init
Date:   Fri, 12 Jun 2020 15:27:55 -0500
Message-Id: <20200612202755.57418-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rocker_dma_rings_init, the goto blocks in case of errors
caused by the functions rocker_dma_cmd_ring_waits_alloc() and
rocker_dma_ring_create() are incorrect. The patch fixes the
order consistent with cleanup in rocker_dma_rings_fini().

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/ethernet/rocker/rocker_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 7585cd2270ba..fc99e7118e49 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -647,10 +647,10 @@ static int rocker_dma_rings_init(struct rocker *rocker)
 err_dma_event_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker->event_ring);
 err_dma_event_ring_create:
+	rocker_dma_cmd_ring_waits_free(rocker);
+err_dma_cmd_ring_waits_alloc:
 	rocker_dma_ring_bufs_free(rocker, &rocker->cmd_ring,
 				  PCI_DMA_BIDIRECTIONAL);
-err_dma_cmd_ring_waits_alloc:
-	rocker_dma_cmd_ring_waits_free(rocker);
 err_dma_cmd_ring_bufs_alloc:
 	rocker_dma_ring_destroy(rocker, &rocker->cmd_ring);
 	return err;
-- 
2.25.1

