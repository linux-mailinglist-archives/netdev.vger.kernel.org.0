Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5BF2618DC
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgIHR6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731537AbgIHQMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:12:14 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B85C061361
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 05:35:29 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a15so19879320ljk.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJG3RPIP22/4fnZGUTOwicNC/qGcsSinndMdsuerY6w=;
        b=u0sN0GRZn8/7EWQyZ2PkgN39PQZF0Wz7tM3T0nduaEa9i4FfDqSI1VnSXAi30Fl+Qa
         6l3C/Kb6tRrggjHAElj/oRmI/4z6xY+LsLTlCSGDKNmmEbGhtoeSUcnKc0zxsrEQge99
         R4K6WnknVsR/Qf0ary005SdteXXDqCSdnmTBKjuozq13xmXQ65MgC7dOM9v/vfJrgHmt
         a4JuGA7t4cnoI5Zs5fIZkCpeI1g8op76rCsp3e7/Ke/l0084AhOGEoYxbbgjjqUGsJe+
         CAmT8fZgm7ZktuYbreeEVvZ658JGhF82PIO5U7e9svs6/0e6FwKztncH/hgaJ71tt//s
         dJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJG3RPIP22/4fnZGUTOwicNC/qGcsSinndMdsuerY6w=;
        b=Hu5IscAFLadjgCq4o4Q2yPCh7cbM8fdszaeAkK1sF68oPdYN6JuxjkQ1bss7OmZ5++
         2N4r0dYKpLwJcKcXgSMKBx2ag6fA0+upXporQ+8FEM8DmEYstSLwHPiHR/d3PktM7EvZ
         Bsi0I1d5qK6AGkkPlG01cVHbxbtnrsFtovX7ySTuWS/41cejFMkX6FOQd3e/nxttSWGN
         oQ0u1x6dqCL5w3v7UWjDhfuq06zi9HvcbCFo2zmyf0o8+9T/IkhiVv2RQCp094fErXfh
         c/OqU5veV6pDXg1CH9iw9srMrOXHhKC8GmlerGxDEK5yG9XO9bYGyt9q7zUMM1XhJS06
         zLGw==
X-Gm-Message-State: AOAM531O5LuPplJGnQrOuZCITkqojAdqaZjobnhsVQH4RhCIE2SOMs7g
        NbjHoiXsfERVeRqd/mGAOq4=
X-Google-Smtp-Source: ABdhPJwdjeDEwO1KNZEqt59uK3srFnagNPAeYLrZHCwjP9TaMVhOtr7RRjMZhcHyHLGEQoSaDNRRbA==
X-Received: by 2002:a2e:b5c5:: with SMTP id g5mr13360071ljn.319.1599568528382;
        Tue, 08 Sep 2020 05:35:28 -0700 (PDT)
Received: from localhost.localdomain ([81.219.202.87])
        by smtp.gmail.com with ESMTPSA id 190sm10519186lfa.81.2020.09.08.05.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:35:27 -0700 (PDT)
From:   Marek Majtyka <alardam@gmail.com>
X-Google-Original-From: Marek Majtyka <marekx.majtyka@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     Marek Majtyka <marekx.majtyka@intel.com>,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmain.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next] i40e: remove redundant assigment
Date:   Tue,  8 Sep 2020 14:34:40 +0200
Message-Id: <20200908123440.11278-1-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a redundant assigment of the software ring pointer in the i40e
driver. The variable is assigned twice with no use in between, so just
get rid of the first occurrence.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2a1153d8957b..8661f461f620 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -306,7 +306,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			continue;
 		}
 
-		bi = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
 		size = (qword & I40E_RXD_QW1_LENGTH_PBUF_MASK) >>
 		       I40E_RXD_QW1_LENGTH_PBUF_SHIFT;
 		if (!size)
-- 
2.20.1

