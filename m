Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729763D92C2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237398AbhG1QIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:08:06 -0400
Received: from m34-101.88.com ([104.250.34.101]:43659 "HELO 88.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
        id S237699AbhG1QGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 12:06:38 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2021 12:06:37 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cn;
        s=dkim; h=From:To:Date; bh=+0wI7mv8XUU8mTLbxor4A/f7cmasr0sNeQo/+
        h10VfE=; b=Lzl9S29cJ09P3Nnj9lH4xUNIMgRrLqjq79yqXJQcdL+ahOnSRRf21
        ca1Gpju7Ix7thIicLtYFZLFqbTytF2wJMK8Jlzqy/uT325oOk2rbXnARMyMcQMFw
        RYFC7RxBYIa70mmAtkCZJOhVm5eYV5nDUg8Or3fFOyxaBa4xFMeh2g=
Received: from localhost.localdomain (unknown [113.251.14.68])
        by v_coremail2-frontend-1 (Coremail) with SMTP id LCKnCgDn9QTQfgFhsjoLAA--.39671S2;
        Wed, 28 Jul 2021 23:59:13 +0800 (CST)
From:   Hu Haowen <src.res@email.cn>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: networking: add ioam6-sysctl into index
Date:   Wed, 28 Jul 2021 23:59:12 +0800
Message-Id: <20210728155912.9293-1-src.res@email.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LCKnCgDn9QTQfgFhsjoLAA--.39671S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5-7k0a2IF6w4kM7kC6x804xWl1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
        x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWU
        JVW8JwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        74AGY7Cv6cx26F4UJr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04
        k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26F4UJr1UMxC20s026xCaFVCjc4AY6r1j
        6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
        AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
        2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
        C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
        nUUI43ZEXa7IUnLSdPUUUUU==
X-Originating-IP: [113.251.14.68]
X-CM-SenderInfo: hvufh21hv6vzxdlohubq/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Append ioam6-sysctl to toctree in order to get rid of building warnings.

Signed-off-by: Hu Haowen <src.res@email.cn>
---
 Documentation/networking/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e9ce55992aa9..a91a2739f8ed 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -57,6 +57,7 @@ Contents:
    gen_stats
    gtp
    ila
+   ioam6-sysctl
    ipddp
    ip_dynaddr
    ipsec
-- 
2.25.1

