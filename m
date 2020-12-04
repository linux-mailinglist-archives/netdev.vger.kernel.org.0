Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE4A2CECD7
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgLDLOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:14:22 -0500
Received: from m12-17.163.com ([220.181.12.17]:59569 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727591AbgLDLOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Message-ID:Date:MIME-Version; bh=vaYzQ
        yAj5GQDP+q+9HgqqemT1QT6XTcclli4xZYcRpc=; b=ftnx+weSxfUNrR8iW5UAi
        9yHD5uoP/Mo9FG7TC0c26Nk++aml8s37pcpVNI5isSu4eaVbeZ0TvML8BkgWzCjA
        POsFa04LdSocvTDg4z8n041jQHBtNZSobMr1K7LY8HS8Pv6eZus7gIX46Z/vazP/
        w7BOrqp7TG/XTS965FyYL4=
Received: from [10.8.1.234] (unknown [36.111.140.26])
        by smtp13 (Coremail) with SMTP id EcCowAA3No4Z9clfbGzzXg--.24472S2;
        Fri, 04 Dec 2020 16:36:43 +0800 (CST)
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] mptcp: print new line in mptcp_seq_show() if mptcp isn't in
 use
To:     netdev@vger.kernel.org
Cc:     mathew.j.martineau@linux.intel.com, pabeni@redhat.com,
        fw@strlen.de, davem@davemloft.net
Message-ID: <c1d61ab4-7626-7c97-7363-73dbc5fa3629@163.com>
Date:   Fri, 4 Dec 2020 16:36:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EcCowAA3No4Z9clfbGzzXg--.24472S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUgvPSUUUUU
X-Originating-IP: [36.111.140.26]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbBiBvwkFaD9Tl72gAAsL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 net/mptcp/mib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 84d1194..b921cbd 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -67,6 +67,7 @@ void mptcp_seq_show(struct seq_file *seq)
 		for (i = 0; mptcp_snmp_list[i].name; i++)
 			seq_puts(seq, " 0");

+		seq_putc(seq, '\n');
 		return;
 	}

-- 
1.8.3.1

