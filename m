Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5F511FE86
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLPGoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:08 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:43033 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfLPGoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:07 -0500
Received: by mail-pj1-f49.google.com with SMTP id g4so2532447pjs.10
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CUo0IT2rz5u5mxNOTF03IjLY7vKSxV7kYfH3bgfJwUc=;
        b=EFs0/M1FfhPQG8FwXx3/p+tyiOKtTFKCfTcwdHS3RN2TUGkooZ4vXVQ52vtnTogzrw
         LLgWajx3uMtBQFbwK98D3K8bsBRopdph7QZJiCKUjNFTekI8Fjq34sa3HO4waIOjMI/2
         KNomad8vQudE4knlEP8rMh+/iOw7jOPRkBuzQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CUo0IT2rz5u5mxNOTF03IjLY7vKSxV7kYfH3bgfJwUc=;
        b=qI2g4iGVjkXitAxixPAvel3Zoa2zLU3JHmz8Dyx+LRrS4xH/mYiFBBJMbHAOzsFThs
         xmuFBaPFT1wueBgiXnk1Oi4JCrDbN+dh8gUBhTPBjLkAaei19qsRC537OIf3IVUZTD4l
         8LzYhIooOWfBpVRURHLKA0J4kg/soJ5r1Lfw8u3LiJyUDjxVa/9+OX5kuN+cvCZOREyt
         kVVfle6ku0IbKSY0oAloihfP1wKkFlxSOdUTZMKWkF9w6INhzGVMk0nLJ/5rUhsizGnU
         27nTXyCcEa23FADQpserbbom8sqxKQa8RSI1ViL8hE9zUJ3BE5O7yfrqpqi5QixM+t7f
         iNkQ==
X-Gm-Message-State: APjAAAXyT5jRGMBSGT5e4mbGAGvaXdN0+uE6vCbcBL/Qko1Q2L0Kn1BX
        tu7qaiZt5GzCZG9rSOMn9eE0sezPtOM=
X-Google-Smtp-Source: APXvYqxmln2oA+6vBpyFAZRJgGs+vhfodLv2uAQu81xKqOiEA+ESJU3a2LfTVYbGfHTu91hJsG4R+A==
X-Received: by 2002:a17:90a:2188:: with SMTP id q8mr15936325pjc.47.1576478646995;
        Sun, 15 Dec 2019 22:44:06 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:06 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 1/8] json_print: Remove declaration without implementation
Date:   Mon, 16 Dec 2019 15:43:37 +0900
Message-Id: <20191216064344.1470824-2-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 6377572f0aa8 ("ip: ip_print: add new API to print JSON or regular format output")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 include/json_print.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index fe92d14c..6695654f 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -34,8 +34,6 @@ void delete_json_obj(void);
 
 bool is_json_context(void);
 
-void fflush_fp(void);
-
 void open_json_object(const char *str);
 void close_json_object(void);
 void open_json_array(enum output_type type, const char *delim);
-- 
2.24.0

