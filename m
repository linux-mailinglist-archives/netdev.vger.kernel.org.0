Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5734ED2D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhC3QGm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Mar 2021 12:06:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49357 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbhC3QGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:06:18 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lRGsT-0003UA-CF; Tue, 30 Mar 2021 16:06:01 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 8EE0A61DDA; Tue, 30 Mar 2021 09:05:59 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 873C4A0453;
        Tue, 30 Mar 2021 09:05:59 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        vfalico@gmail.com, andrew@lunn.ch, elder@kernel.org,
        netdev@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, huangdaode@huawei.com,
        linuxarm@openeuler.org, linuxarm@huawei.com,
        Peng Li <lipeng321@huawei.com>
Subject: Re: [RESEND net-next 2/4] net: bonding: remove repeated word
In-reply-to: <1617089276-30268-3-git-send-email-tanhuazhong@huawei.com>
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com> <1617089276-30268-3-git-send-email-tanhuazhong@huawei.com>
Comments: In-reply-to Huazhong Tan <tanhuazhong@huawei.com>
   message dated "Tue, 30 Mar 2021 15:27:54 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17077.1617120359.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 30 Mar 2021 09:05:59 -0700
Message-ID: <17079.1617120359@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huazhong Tan <tanhuazhong@huawei.com> wrote:

>From: Peng Li <lipeng321@huawei.com>
>
>Remove repeated word "that".
>
>Signed-off-by: Peng Li <lipeng321@huawei.com>
>Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>---
> drivers/net/bonding/bond_alb.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index c3091e0..3455f2c 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -1098,7 +1098,7 @@ static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
>  * If @slave's permanent hw address is different both from its current
>  * address and from @bond's address, then somewhere in the bond there's
>  * a slave that has @slave's permanet address as its current address.
>- * We'll make sure that that slave no longer uses @slave's permanent address.
>+ * We'll make sure that slave no longer uses @slave's permanent address.

	This is actually correct as written, but I can see that it's a
bit confusing.  Rather than removing the second that, I'd suggest
changing it to "... make sure the other slave no longer uses ..." to be
clearer.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
