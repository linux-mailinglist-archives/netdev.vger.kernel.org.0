Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8D318548
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 07:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBKGoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 01:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhBKGoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 01:44:18 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7355C0613D6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:37 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id i3so5016576oif.1
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 22:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2XP67/P4figV1G8mvagTyWJ4pRaX6cBiE+2myvoFuA=;
        b=LtIE6FyzYWzJ/wKDjthZdhi3Dc34k1/c/EHf7Lk7p9JDiYQgN0a7nDlUZciv5SVaCR
         dIQWoBmyhTZemWXXGakkdSk6MLuQmw9ORJOT9MRoKIHsstxULP8xxTjqW1HXyUUCUD+h
         kqxt0RLj72qYrBv8KoLYSI/a/jrLa1O2srrZ3kkvrFcxL2kfBhOo/K+/Zm7JGrjf+lJF
         nVKoVcZ7W0r0NKynDw3wGUCqq0n+Mnd3wPUTu0kVjluVO3hb9XPoCjHK1HXqs9Ps7dSC
         itkoCqtzIecX2EKbXbkuWNdqWCB0czQW5qZqesEuKxx3sXSFEYHFcVBjFrnMmSy521su
         qsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2XP67/P4figV1G8mvagTyWJ4pRaX6cBiE+2myvoFuA=;
        b=bLtc2JWv3AV0hgMYBLpJlFyuPi0jm5p4FIdcWMc0MhRqmJk/s+VNDLh5DV+sOCUuZv
         XOhTEoygXCGIK1jdqdbckkkIIuua5Y/TuL6srguAuUNJ9z5awhy7WCkI6LLO3+MZR/oT
         xgeDUswskQvTlk1yG+aPxQqPRBpdhxEo4o3KhYy2zb7yn34Owai/3ts9DOD9FRcnGB2t
         5FfOw+B8Q6EMW5i1SCTnGU7Ufld6NsLTNgVCyVCUpTONXt9xZvHbQQouHTsZz4G3Y4Jc
         tpZgxu6lrNwzVCB76ptm3PvhlYdJ9eXnhMOsIlhXmUTcWYDbTAWgm9+LPs5j81FXpbNn
         Hevg==
X-Gm-Message-State: AOAM533Icy7mLmVp1QAXCm9PpcaxNNrBPOHV/2WhrisQkqO02W7tIgV2
        SdjrEoRIDXYLtMWvShkb2K7YurP4y8Q=
X-Google-Smtp-Source: ABdhPJxYBTgFk0oSqRY7YaHmpsYjpJqbQ0cAOThUUejEhkTuJwpy9K35vmF47DDajNQMbbzlA50HMA==
X-Received: by 2002:aca:3b8b:: with SMTP id i133mr1837685oia.132.1613025817195;
        Wed, 10 Feb 2021 22:43:37 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:302d:c724:5317:9751])
        by smtp.gmail.com with ESMTPSA id y65sm993375oie.50.2021.02.10.22.43.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 22:43:36 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 3/8] ibmvnic: fix braces
Date:   Thu, 11 Feb 2021 00:43:20 -0600
Message-Id: <20210211064325.80591-4-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
References: <20210211064325.80591-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warning:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5c6f6a7b2e3f..6c1fc73d66dc 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2040,9 +2040,8 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		}
 
 		rc = ibmvnic_login(netdev);
-		if (rc) {
+		if (rc)
 			goto out;
-		}
 
 		if (adapter->reset_reason == VNIC_RESET_CHANGE_PARAM) {
 			rc = init_resources(adapter);
-- 
2.23.0

