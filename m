Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967C094985
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfHSQL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:11:27 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:35433 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfHSQL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 12:11:26 -0400
Received: from grover.flets-west.jp (softbank126125143222.bbtec.net [126.125.143.222]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x7JGAjJ4031644;
        Tue, 20 Aug 2019 01:10:45 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x7JGAjJ4031644
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1566231046;
        bh=UiQIcbV+7eg30mI6THf1kYVPy2WAYixEsvCpcmTCFhM=;
        h=From:To:Cc:Subject:Date:From;
        b=YSzJXcvNZk3opw9EGUfvvNCh+2OaVE5XfF9SnJ+0HjVGvf9Rugq2S0vocu2jys61+
         RyMwumxKkBC5m/714VI5i1lwnFahOnRal/eQEFpDxOMMUqCF0PYIbsVUZFn9TRSyJL
         isf4rTAyCnMb2HPcHzmN7Jhey0SxXyjy2y/TemisPS9mvMcHm573skHdBSfYkG8/C8
         jF9It1AaGmi5mCH1crKm5Ih0T1Ch3+T6wL3Ie8mhb2d6KoHc68alfWFgtoRNVO75kj
         eLOOTS/TAp2UILpMeaev5o/QxUml7FpENq7OiG7oK0sT2OxtYOb++sE8sCV3LJWzTU
         Ff/5pYn3YmafQ==
X-Nifty-SrcIP: [126.125.143.222]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpfilter/verifier: add include guard to tnum.h
Date:   Tue, 20 Aug 2019 01:10:35 +0900
Message-Id: <20190819161035.21826-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a header include guard just in case.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 include/linux/tnum.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/tnum.h b/include/linux/tnum.h
index c7dc2b5902c0..c17af77f3fae 100644
--- a/include/linux/tnum.h
+++ b/include/linux/tnum.h
@@ -5,6 +5,10 @@
  * propagate the unknown bits such that the tnum result represents all the
  * possible results for possible values of the operands.
  */
+
+#ifndef _LINUX_TNUM_H
+#define _LINUX_TNUM_H
+
 #include <linux/types.h>
 
 struct tnum {
@@ -81,3 +85,5 @@ bool tnum_in(struct tnum a, struct tnum b);
 int tnum_strn(char *str, size_t size, struct tnum a);
 /* Format a tnum as tristate binary expansion */
 int tnum_sbin(char *str, size_t size, struct tnum a);
+
+#endif /* _LINUX_TNUM_H */
-- 
2.17.1

