Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304C8350FFF
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 09:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhDAHU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 03:20:57 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:24056 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbhDAHUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 03:20:49 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id F1F509803BB;
        Thu,  1 Apr 2021 15:20:46 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] linux/bpf.h: Remove repeated struct declaration
Date:   Thu,  1 Apr 2021 15:20:37 +0800
Message-Id: <20210401072037.995849-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHUhLGENIGB0dH0sdVkpNSkxJTUpNT0xPS0NVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MRA6DAw4MD8KFjQJQiw5ShkK
        GlYwFAhVSlVKTUpMSU1KTU9MTENJVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKQktINwY+
X-HM-Tid: 0a788c4e55cbd992kuwsf1f509803bb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct btf_type is declared twice. One is declared at 35th line.
The blew one is not needed. Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 include/linux/bpf.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3625f019767d..2fd8e775a17e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -903,7 +903,6 @@ struct bpf_link_primer {
 };
 
 struct bpf_struct_ops_value;
-struct btf_type;
 struct btf_member;
 
 #define BPF_STRUCT_OPS_MAX_NR_MEMBERS 64
-- 
2.25.1

