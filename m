Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB515FEA2F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJNIKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJNIKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:10:35 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E2B7F08E;
        Fri, 14 Oct 2022 01:10:32 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mpf8c4MkVz1P7QT;
        Fri, 14 Oct 2022 16:05:52 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 16:10:28 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <quentin@isovalent.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [bpf-next v9 3/3] bpftool: Update the bash completion(add autoattach to prog load)
Date:   Fri, 14 Oct 2022 16:31:15 +0800
Message-ID: <1665736275-28143-4-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1665736275-28143-1-git-send-email-wangyufen@huawei.com>
References: <1665736275-28143-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add autoattach optional to prog load|loadall for supporting
one-step load-attach-pin_link.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index dc1641e..2957b42 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -505,6 +505,7 @@ _bpftool()
                             _bpftool_once_attr 'type'
                             _bpftool_once_attr 'dev'
                             _bpftool_once_attr 'pinmaps'
+                            _bpftool_once_attr 'autoattach'
                             return 0
                             ;;
                     esac
-- 
1.8.3.1

