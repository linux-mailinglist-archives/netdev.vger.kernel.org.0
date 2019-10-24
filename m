Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABAEE3E3C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbfJXVbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:31:42 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40593 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfJXVbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:31:41 -0400
Received: by mail-lj1-f195.google.com with SMTP id u22so253744lji.7;
        Thu, 24 Oct 2019 14:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eSQ3m+e1MU4dsQtSCsit4VaAvQDaKTn6EdmojNuKjSc=;
        b=NZ4aahfnXpfmG4v61UhNZ9t7J+0jrG3GJ4nh3YI98GcIV/6jRgCwZR7kYfoeh/+DyC
         pzGSWcOEjKw64BWaRhIV06rtXMgnkHsBYhkGB4ZV7jbBwu901zxcW2IXthWIWqMFJDoe
         Df7iGNVRcg3RY/vJr7gnRUrhhb2R9Px2vMG080yQhwpW1YnwA2nEZ2fkL6P1VEc1rr8V
         XoRJ/TtkT50zq9LCWJCE0KPukh+687r2T/Gux5HHz1Pj0yrkBfso3IwvkscO2awx4ywP
         NByLwLiyAu4RiEnCAPoS4h6dRLLlmQwwxTGs+UbMP/ys0EvEGkbR7IWwk0iw9By6sSJn
         OwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eSQ3m+e1MU4dsQtSCsit4VaAvQDaKTn6EdmojNuKjSc=;
        b=C7bAWZp0TazJshTutp8hmKxdQqbkSK3oXuzG3A/G3FSqbr75po2eATuOExHkZbFm0n
         iHdEtASp7wgWk9aGK7aTfiEdsNXAwnSymxYb1FcFDezwxb7fSJJnACK7dq6N+oBlcdgB
         u7+df8zmMpIN75iEilkXffeUqgq7L7kJUmE10thcYhv3X1jaulf7riGhlKRHHX2zO13L
         nilvwyXFfIut897C9HQvuV+csuqc3UYffR9DpQh3UsYPjPyux/CAHfXZfZxGJJcR7Reh
         9w0KP10HpLlHhtHCpM9IQYw/UrlhDg20UiKNOeoJZ9ni8nvPo6/x9/3xLole+XYJkBvl
         Yb4Q==
X-Gm-Message-State: APjAAAXkdHc1GfS68cXx5Eq73Ff0GmWR02TQex/ZprwNt2kyOcDQdI/8
        niW/JB0x295l1UdVpa6dLYY=
X-Google-Smtp-Source: APXvYqzC0nwCxdi3VvyO1zohmAjYqJFlsSgakuNgILaQ+FnFsVqoq3/yMLnmQgg55KmRQ8gQrCMblA==
X-Received: by 2002:a2e:4751:: with SMTP id u78mr27323211lja.210.1571952698932;
        Thu, 24 Oct 2019 14:31:38 -0700 (PDT)
Received: from localhost.localdomain ([93.152.168.243])
        by smtp.gmail.com with ESMTPSA id t8sm20228336ljd.18.2019.10.24.14.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 14:31:38 -0700 (PDT)
From:   Samuil Ivanov <samuil.ivanovbg@gmail.com>
To:     gregkh@linuxfoundation.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Cc:     samuil.ivanovbg@gmail.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: qlge: Rename prefix of a function to qlge
Date:   Fri, 25 Oct 2019 00:29:41 +0300
Message-Id: <20191024212941.28149-4-samuil.ivanovbg@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ql_mb_about_fw renamed to
qlge_mb_about_fw and it's clients updated.

Signed-off-by: Samuil Ivanov <samuil.ivanovbg@gmail.com>
---
 drivers/staging/qlge/qlge.h      | 2 +-
 drivers/staging/qlge/qlge_main.c | 2 +-
 drivers/staging/qlge/qlge_mpi.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index d3f10c95c781..649f1fd10739 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2266,7 +2266,7 @@ int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev);
 int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf, u32 ram_addr,
 			  int word_count);
 int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump);
-int ql_mb_about_fw(struct ql_adapter *qdev);
+int qlge_mb_about_fw(struct ql_adapter *qdev);
 int ql_mb_wol_set_magic(struct ql_adapter *qdev, u32 enable_wol);
 int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol);
 int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 0c381d91faa6..b8f4f4e5e579 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -880,7 +880,7 @@ static int ql_8000_port_initialize(struct ql_adapter *qdev)
 	 * Get MPI firmware version for driver banner
 	 * and ethool info.
 	 */
-	status = ql_mb_about_fw(qdev);
+	status = qlge_mb_about_fw(qdev);
 	if (status)
 		goto exit;
 	status = ql_mb_get_fw_state(qdev);
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index ccffe0b256fa..092695719c58 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -612,7 +612,7 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
  * driver banner and for ethtool info.
  * Returns zero on success.
  */
-int ql_mb_about_fw(struct ql_adapter *qdev)
+int qlge_mb_about_fw(struct ql_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
-- 
2.17.1

