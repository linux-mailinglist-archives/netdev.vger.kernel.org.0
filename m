Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CE33A45B3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhFKPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:46:58 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:36551 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhFKPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:46:57 -0400
Received: by mail-ot1-f42.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so3562084otl.3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 08:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osFG+f39pXpQEXLxzVafGdsw14KUKfM7olkl4HVCl1g=;
        b=tASOgboYQ64aqE4Q83mIZzsFHc/n/ndFk4nBlemgWKnZcAslbote9h26YDSh3fWLLB
         RiEKLflrmSp1GEcYx0jDMeqsghnobctE/PznIxS90WRzJGNb2mLNCnLcebCYAQnBJ2Eu
         nan0impIx0wLl20yF6CwfF2Ni3lK37BI9t/5JptbiUNY2BBkuczQR6Jyav2MHbVBByBf
         OuPlzYmxZIVvSjaubN1sCRQalKDcsZ31Ulf2M63t1fN92tCb5RHTCiihwowUxpPjmVzt
         G32asiqkJH6VMNTdA/o0TT/5mAl37tKLH3wIjm4hZxqJAg1XHSRnLME7FZuYabJ83GP1
         OAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=osFG+f39pXpQEXLxzVafGdsw14KUKfM7olkl4HVCl1g=;
        b=CuQtifvsiN23zwFCf9bAFJWFsL5BoRXXYtGz3mVOoFiRz0sAq515pyR3WQA3F0dU4+
         wRNPEA9DlBskH59b5EDz1Jr/aOodQ4mhXZ4cM/hCr8vw5HRcJEv4yDMD0LHrrvSynsSH
         ykq1H/FrfPU4ev8xXtdmWpfREZyT+VlAJiEYL4IFx/a/QMvvc6ghnOIljcs9hbvhCwqI
         IOomhO7ZPPp88wQxPwryuyoDHfuw53y8NpJwAcO9BX5NCsItZqUiVhuW8zTDm6P1RNq5
         CmiJ3YmW2k+lcxy3XsPqBe9PMDOOU8IvYYBTlVu+PjLu651es9XwgMZIPEaikwi8daHR
         A5Yw==
X-Gm-Message-State: AOAM531r2XrdXufiNcy8f6kH4BeRSttb51gNOvy3LKJ8qgPqMSmO2Ta3
        RG7mebb1HagCAe+mDDmHdB+pkQExP+Qa7A==
X-Google-Smtp-Source: ABdhPJyi0CkEQitWvP1Ok+HI7nH3NuzO/qoiCV3Eo2U3KdHv45dQb+7DLUYAmagjrSJAo+Atje8P7A==
X-Received: by 2002:a05:6830:1b6e:: with SMTP id d14mr3715918ote.186.1623426228264;
        Fri, 11 Jun 2021 08:43:48 -0700 (PDT)
Received: from fedora.attlocal.net ([2600:1700:271:1a80::2d])
        by smtp.gmail.com with ESMTPSA id f63sm1367657otb.36.2021.06.11.08.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 08:43:47 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next] ibmvnic: fix kernel build warnings in build_hdr_descs_arr
Date:   Fri, 11 Jun 2021 10:43:39 -0500
Message-Id: <20210611154339.85017-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following kernel build warnings:
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'skb' not described in 'build_hdr_descs_arr'
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Function parameter or member 'indir_arr' not described in 'build_hdr_descs_arr'
drivers/net/ethernet/ibm/ibmvnic.c:1516: warning: Excess function parameter 'txbuff' description in 'build_hdr_descs_arr'

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 830d869e235f..497f1a7da70b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1526,7 +1526,8 @@ static int create_hdr_descs(u8 hdr_field, u8 *hdr_data, int len, int *hdr_len,
 
 /**
  * build_hdr_descs_arr - build a header descriptor array
- * @txbuff: tx buffer
+ * @skb: tx socket buffer
+ * @indir_arr: indirect array
  * @num_entries: number of descriptors to be sent
  * @hdr_field: bit field determining which headers will be sent
  *
-- 
2.23.0

