Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E06353878
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 16:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhDDOad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 10:30:33 -0400
Received: from m34-101.88.com ([104.250.34.101]:25506 "EHLO 88.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229633AbhDDOac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 10:30:32 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Apr 2021 10:30:32 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cn;
        s=dkim; h=Date:From:To; bh=mmOAa3zoT6ufDTLqeXxhGN1PhY5m47l+ZktD7
        /giQH4=; b=IeYeTwr27YGhHn34EOtNHHrhzUNHam+jmxVxdE90pIH3uVymtQxIE
        40hiZu027SjnOVFgizrLa6TRBk2Y66WAIZz9A6rKerg6IMzpL/omrDP/WgAWWzee
        ve5RBT2ucnvZw9PLCGpyi/vFZag1+I3iF5d10jeeOFfASkXAzzNjUg=
Received: from bobwxc.top (unknown [120.238.248.129])
        by v_coremail2-frontend-2 (Coremail) with SMTP id GiKnCgAXoiLTy2lg79RbAA--.6057S2;
        Sun, 04 Apr 2021 22:23:17 +0800 (CST)
Date:   Sun, 4 Apr 2021 22:23:15 +0800
From:   Wu XiangCheng <bobwxc@email.cn>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] tipc: Fix a kernel-doc warning in name_table.c
Message-ID: <20210404142313.GA2471@bobwxc.top>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CM-TRANSID: GiKnCgAXoiLTy2lg79RbAA--.6057S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF4fWr4xXrW8CrWxtFWkZwb_yoW8JFyrpF
        nxJFWktFy3Wr1Uta18AF47Kr18Wr4kK3yxGFZay3y3tayqqF18GF4S9FnxuFsa9FZYvFZr
        ZF47Kr15Xw1kArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgab7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j6r4UM28EF7xvwVC2
        z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0x
        vYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_
        Cr1UJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkIecxEwVAFwVW5XwCF04
        k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26F4UJr1UMxC20s026xCaFVCjc4AY6r1j
        6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
        AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
        2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
        C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73
        UjIFyTuYvjxUTIztUUUUU
X-Originating-IP: [120.238.248.129]
X-CM-SenderInfo: pere453f6hztlloou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix kernel-doc warning:

Documentation/networking/tipc:66: /home/sfr/next/next/net/tipc/name_table.c
  :558: WARNING: Unexpected indentation.
Documentation/networking/tipc:66: /home/sfr/next/next/net/tipc/name_table.c
  :559: WARNING: Block quote ends without a blank line; unexpected unindent.

Due to blank line missing.

Fixes: 908148bc5046 ("tipc: refactor tipc_sendmsg() and tipc_lookup_anycast()")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: https://lore.kernel.org/netdev/20210318172255.63185609@canb.auug.org.au/
Signed-off-by: Wu XiangCheng <bobwxc@email.cn>
---
 net/tipc/name_table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 6db9f9e7c0ac..b4017945d3e5 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -553,7 +553,9 @@ struct publication *tipc_nametbl_remove_publ(struct net *net,
  *
  * On entry, a non-zero 'sk->node' indicates the node where we want lookup to be
  * performed, which may not be this one.
+ *
  * On exit:
+ *
  * - If lookup is deferred to another node, leave 'sk->node' unchanged and
  *   return 'true'.
  * - If lookup is successful, set the 'sk->node' and 'sk->ref' (== portid) which
-- 
2.20.1

