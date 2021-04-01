Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE7A351A3C
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbhDAR6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:58:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16317 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236828AbhDARzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:55:22 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FB4yh0Yz6z9s4H;
        Thu,  1 Apr 2021 22:17:48 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Thu, 1 Apr 2021
 22:19:48 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <ast@kernel.org>
Subject: [PATCH -next] libbpf: remove redundant semi-colon
Date:   Thu, 1 Apr 2021 22:23:01 +0800
Message-ID: <20210401142301.1686904-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 tools/lib/bpf/linker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 46b16cbdcda3..4e08bc07e635 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1895,7 +1895,7 @@ static int finalize_btf_ext(struct bpf_linker *linker)
 	hdr->func_info_len = funcs_sz;
 	hdr->line_info_off = funcs_sz;
 	hdr->line_info_len = lines_sz;
-	hdr->core_relo_off = funcs_sz + lines_sz;;
+	hdr->core_relo_off = funcs_sz + lines_sz;
 	hdr->core_relo_len = core_relos_sz;
 
 	if (funcs_sz) {
-- 
2.25.1

