Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92D24806C
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgHRIUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:20:23 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:42334 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbgHRIUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 04:20:22 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowACHjxs5jztfmH8kAw--.22912S2;
        Tue, 18 Aug 2020 16:20:09 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] libbpf: simplify the return expression of build_map_pin_path()
Date:   Tue, 18 Aug 2020 08:20:08 +0000
Message-Id: <20200818082008.12143-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowACHjxs5jztfmH8kAw--.22912S2
X-Coremail-Antispam: 1UD129KBjvdXoWrGr48AFykWr43Zr4DJF1DJrb_yoWxXrc_A3
        W8XF4xGrZ8GFWay3yrCrZ0vryxAas5Grs5uFs2qrsxJF1jkFW5ArZrCF95JFyYgw4xKFy7
        AF93Ary7Ar43ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbg8YjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVWxJr0_Gc
        WlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0Y40E4IxF1VCIxcxG6Fyj
        6r4UJwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4
        AK67AK6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
        rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
        CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI
        0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7x
        RM4E_DUUUUU==
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQUMA102ZgiJnQAAsS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 tools/lib/bpf/libbpf.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5055e1531e43..b423fdaae0b6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1935,11 +1935,7 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
 	else if (len >= PATH_MAX)
 		return -ENAMETOOLONG;
 
-	err = bpf_map__set_pin_path(map, buf);
-	if (err)
-		return err;
-
-	return 0;
+	return bpf_map__set_pin_path(map, buf);
 }
 
 
-- 
2.17.1

