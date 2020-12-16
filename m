Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD78E2DB969
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgLPCry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:47:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9207 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPCry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 21:47:54 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cwfdq6CSZzkqTM;
        Wed, 16 Dec 2020 10:46:23 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Wed, 16 Dec 2020 10:47:06 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH] bpf: remove unused including <linux/version.h>
Date:   Wed, 16 Dec 2020 10:47:15 +0800
Message-ID: <1608086835-54523-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 kernel/bpf/syscall.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4caf06f..c3bb03c8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -17,7 +17,6 @@
 #include <linux/fs.h>
 #include <linux/license.h>
 #include <linux/filter.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/idr.h>
 #include <linux/cred.h>
-- 
2.7.4

