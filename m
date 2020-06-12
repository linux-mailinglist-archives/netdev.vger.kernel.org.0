Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721451F7DE2
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 22:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgFLUCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 16:02:00 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:34140 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLUB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 16:01:59 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 49kBT32b21z9vZTV
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 20:01:59 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XHsw3Xeb3SQ7 for <netdev@vger.kernel.org>;
        Fri, 12 Jun 2020 15:01:59 -0500 (CDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 49kBT30t7Gz9vZTK
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 15:01:59 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p8.oit.umn.edu 49kBT30t7Gz9vZTK
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p8.oit.umn.edu 49kBT30t7Gz9vZTK
Received: by mail-io1-f72.google.com with SMTP id z12so6839031iow.15
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=imHRrGBvGVpcQig7cLuElCC6UJZ82NGJhVcu/IBvqQM=;
        b=nn5atouCc/tNlop8bGQTSwAWR1UpUfAftV6DdLjiUZ8BpCnJokk+Xc/nFUSUXGqGXx
         Z9ufGv1umv18UE2bvYoMJGJGiovJrb/fLS3rx//EFUYE2K0QFdN34Yjj9rXNH29dulnB
         nLOe2RIbVYtscO7M0XkmkvhPBl/avIo1Rd1IxvFh4eD71h0em69a2Pe02mSp16teRu1w
         mCxiUI+cFFwVu5AUPnLVl5wc8OvgYWutc+IuahNAW5xQxZzoLMdHlvK3vgeO19aPlqQi
         wH9f0z5HwrtsktF6mqkBu7KvX3k4ufWYj12ozM2C+qdIN2LMOxPag/3jyGbJw9rYYRRp
         phrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=imHRrGBvGVpcQig7cLuElCC6UJZ82NGJhVcu/IBvqQM=;
        b=GyfggTWkq7GG//+dAGXf6BFEYFbb5/6WJKNg2mOzHFvQKo50W8toruvYwv/MHFT6fu
         2+qHWahwLKfpNcYbv8UH4bkL/uM/LBvNDkWeGEJN51PB02IhAV9BPDrbo5L9B1h6JI+e
         SSm1G/hx7pN8oUPi+7gY1alpSkpd8rV+YBR4Um97ZJL5+fwcTjm6Q+CUhg8giF6vTVV3
         fupuQZgU3fOHc8y+0gk9JfWYVbtyoY7zOsCW5ihfYeWLoEXgbuJTie014QucJrymNC3L
         633dwwpR+cf1FE+w330wmMb+0/+k6VyVzSNGnYgnNQIo8NNRxWOMJEEvZtlBpkf/iInU
         /9pA==
X-Gm-Message-State: AOAM530WeF/2aO6BZig1K6+zjSCJDYML2Cty6UhWNM8o2R2mlu4bRZac
        OSZVryfPV4CL4PjoW3EQ4y8UNNyVaipVwao4O7Of7YORGGBWugXhzwxPfM1/ax9Q+LLl22HQrAn
        jfHknbx+cy2D5y4CynFKM
X-Received: by 2002:a6b:9054:: with SMTP id s81mr15219654iod.122.1591992118585;
        Fri, 12 Jun 2020 13:01:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRUmPTr/16TxYq2aOphiwdmxs3OwZOEejbQPuzgta6zECKOw59nmZGUZlqZ3H10vZwXLg9cQ==
X-Received: by 2002:a6b:9054:: with SMTP id s81mr15219629iod.122.1591992118398;
        Fri, 12 Jun 2020 13:01:58 -0700 (PDT)
Received: from piston-t1.hsd1.mn.comcast.net ([2601:445:4380:5b90:79cf:2597:a8f1:4c97])
        by smtp.googlemail.com with ESMTPSA id d1sm3559363ilq.3.2020.06.12.13.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 13:01:58 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, wu000273@umn.edu, Jiri Pirko <jiri@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] test_objagg: Fix potential memory leak in error handling
Date:   Fri, 12 Jun 2020 15:01:54 -0500
Message-Id: <20200612200154.55243-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of failure of check_expect_hints_stats(), the resources
allocated by objagg_hints_get should be freed. The patch fixes
this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 lib/test_objagg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index 72c1abfa154d..da137939a410 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -979,10 +979,10 @@ static int test_hints_case(const struct hints_case *hints_case)
 err_world2_obj_get:
 	for (i--; i >= 0; i--)
 		world_obj_put(&world2, objagg, hints_case->key_ids[i]);
-	objagg_hints_put(hints);
-	objagg_destroy(objagg2);
 	i = hints_case->key_ids_count;
+	objagg_destroy(objagg2);
 err_check_expect_hints_stats:
+	objagg_hints_put(hints);
 err_hints_get:
 err_check_expect_stats:
 err_world_obj_get:
-- 
2.25.1

