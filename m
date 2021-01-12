Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276FE2F2875
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbhALGnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387756AbhALGnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:43:50 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1267C06179F
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:09 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id q6so351576ooo.8
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o4Xmc9wfwqZ8rH9tMXF4rzLE1R2SsM9VUBBGWoN0w4A=;
        b=r62LVyqxKCRurNsd/AUxSdLLuxtOjw4z0hzQMOh6yhgHK0h6ry8HGusCj3eGwBc4Hw
         DdnPBirQf6HvhONDGYbqAHa3EhaIaPCUks/01eJ8HTQiT9Ba/NE64Z5chfHVgym3HNAD
         vVQ9iUOK0Cxm2YSHiJ2cRtCfCZdZthBf5Zis6o9z478hOU5iF3lLjLqXGifRJybffgr0
         qD3gEQvZyZ5LE+wIyVpoLGtVnJBMcQwRVE3lZpvh+Bw5mKb13IXShXEH3PI1tQyH0KgK
         mcnOVyUUNy3p4xyqVh+1MLotes6EF9GUgLo/0jU20KovTCDFQTTWxRNbGXga7FZzYnhi
         hW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o4Xmc9wfwqZ8rH9tMXF4rzLE1R2SsM9VUBBGWoN0w4A=;
        b=YzXWLIq0B6eMc9l6hLVgSg2bWRQyxZYAtUaQQVDockRHlThvv16/kOex5eLH3pistv
         s7MzgHimNFul+aMytqj6+js+kkZ8+gxseM6c7koi2519a6yGYCR5OvzM1ZZDnTpx99GX
         vFPqjeJ7RAjLlTG6elDstsRCpoYP1YxRLwuk24DdKJZxYG46g3wPPFsAhOmg8L8554B9
         rRrt2Y9aw2FLG7to6C0dLZqYk32t2gfgXQ8sQWN7qx0HlOhmG1elBXtjRENttZP9cadp
         A9grQafBCk46h22A3lT9P5Z3Nu8GJrCaW/j0JHQn8RGOsPLJ46wR2Hm2oRFhk79c+pQS
         dBaw==
X-Gm-Message-State: AOAM533+jsO4CptINbxt5N5+KskrNxi4ZzNx7yUOUMa5qz9OxOEB20zu
        izNp9polq402YXeUJgCGGhJS7Kbr3/Y6kw==
X-Google-Smtp-Source: ABdhPJzegDNxamqARdi3lfbnFuj8YLN3GUQYP2uVjcPG548cUGzZzpMZJalKfmPnOw41HGl70QU09A==
X-Received: by 2002:a4a:d197:: with SMTP id j23mr1912106oor.19.1610433789274;
        Mon, 11 Jan 2021 22:43:09 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:09 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 3/7] ibmvnic: fix braces
Date:   Tue, 12 Jan 2021 00:43:01 -0600
Message-Id: <20210112064305.31606-4-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following checkpatch warning:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index fe08c5415b9e..eb3ab0e6156f 100644
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

