Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994A519EB9C
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgDENuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:50:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52143 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgDENuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:50:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id z7so11923187wmk.1
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=g+EzbDgNHcny7V1/rXInEyYbJZPFkFyRAooC47Bhups=;
        b=s7Po536R5z1GomtZidxxfWwidSMT34gztFZDCVBI/fVVufVQNV0SiCDLd97dsIVJv0
         pdQhQtqqbE5+d4e9kIfbIKVLBR98F33ZO5mBMYpoTdSnBfGo9L3lMdDw/tXnlvopT+O5
         iSY2sWXIKvDKpBgYx8IO8lK9svXJMvA3cWcc2YNe9H004benAr1GCxdk7dQRzjNSTblG
         Ocv8FsdX/ZQRmSpx27xDZ2JBxaXZq+u66OYUQJ3DqJ9oGp1roN8Kh7xLIxeh0VBwYh6F
         MtcNEuYbRkFgJlTF01s0yXxNxjEADMdw/Gp10RM3pBmbrKgvvyfS77S4TbKyVK5EYIit
         s9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=g+EzbDgNHcny7V1/rXInEyYbJZPFkFyRAooC47Bhups=;
        b=BN5VFPrvJie69reulBZrC0Qilt67l6U9nihAdkKXlx48bTEh/Du7vQjLZ8CryZHx0M
         2wPm0bRpufO67g3lmYZ2qcywJ/0Khtcmz5O26fx6cSJUNfYmIAjVX3N8ACpWTNtUDAOV
         sUkkcx9A+909//NzDZ20oZQmG+YayualO3YNFNoe3im9Qnvin7iBqp3tVxY3U3ffHqyf
         L+OlfVHEdy+f8pFLzPqwOvDFpj35kJuuAnFGrwwZ4V8l2FkOUHBuWXF+853aow9Aup4Z
         lUgvwa3YkS5vQ985JIsLRxv+5wpdkmJ02hMczqvYuZLJcZhB2zlVwXKVOoxoSXTqJHZl
         XSDQ==
X-Gm-Message-State: AGi0PuZMGM4ZEXejc2mgu+vzxvgvgXw2Mv9fqOt9oQvRyaluqOqmbtww
        5VEnnVQapxopzqyXdv8aZos2X0iU
X-Google-Smtp-Source: APiQypK7Dzk3vQzlaYQzTuQQPFNfuo9kWhSmxEmpgWJTj/+Jodny6K3vJrd6Bg92UUBee6TBfPOhew==
X-Received: by 2002:a1c:cc16:: with SMTP id h22mr17302087wmb.47.1586094609082;
        Sun, 05 Apr 2020 06:50:09 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id n64sm1922294wme.45.2020.04.05.06.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:50:08 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH iproute2 5/6] Document root_block option
Date:   Sun,  5 Apr 2020 15:48:57 +0200
Message-Id: <20200405134859.57232-6-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Root_block is also called root guard, document it.

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 53aebb60..96ea4827 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -372,6 +372,11 @@ enabled on the bridge. By default the flag is off.
 Controls whether a given port is allowed to become root port or not. Only used
 when STP is enabled on the bridge. By default the flag is off.
 
+This feature is also called root port guard.
+If BPDU is received from a leaf (edge) port, it should not
+be elected as root port. This could be used if using STP on a bridge and the downstream bridges are not fully
+trusted; this prevents a hostile guest for rerouting traffic.
+
 .TP
 .BR "learning on " or " learning off "
 Controls whether a given port will learn MAC addresses from received traffic or
-- 
2.25.1

