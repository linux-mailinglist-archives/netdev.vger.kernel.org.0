Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077B2112E8F
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfLDPfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:35:47 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59676 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbfLDPfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 10:35:46 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4FZRHd036622;
        Wed, 4 Dec 2019 09:35:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575473727;
        bh=FvlNoIX6ApcPKndL3eu45z9/asZFZM9jL2WL43h3wJ0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QwfE/JxAzZ6hhfTrW2OZkc+tasr+iakhNJrx3KQZbc732fc0kepLaD/rtmTk6+6bT
         YNSVXf6Bi4kCk8MSI8Z958HR17QP8g3jyv6VBxMiXbSSZA09DhZKRqUN8TcPRQ1gE2
         hi1zfWvgdy4sZb1OILNZEDf0P7xfkJOTW0lP19RY=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB4FZRW1099706
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Dec 2019 09:35:27 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 09:35:26 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 09:35:26 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4FZOHK036177;
        Wed, 4 Dec 2019 09:35:24 -0600
Subject: Re: linux-next: Tree for Dec 3 (switchdev & TI_CPSW_SWITCHDEV)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20191203155405.31404722@canb.auug.org.au>
 <58aebf62-54f8-9084-147b-801ea65327bb@infradead.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <f2700b07-df9b-94ce-0323-a4fece236838@ti.com>
Date:   Wed, 4 Dec 2019 17:35:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <58aebf62-54f8-9084-147b-801ea65327bb@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/12/2019 01:43, Randy Dunlap wrote:
> On 12/2/19 8:54 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Please do not add any material for v5.6 to your linux-next included
>> trees until after v5.5-rc1 has been released.
>>
>> Changes since 20191202:
> 
> I am seeing this (happens to be on i386; I doubt that it matters):
> CONFIG_COMPILE_TEST=y
> 
> 
> WARNING: unmet direct dependencies detected for NET_SWITCHDEV
>    Depends on [n]: NET [=y] && INET [=n]
>    Selected by [y]:
>    - TI_CPSW_SWITCHDEV [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_TI [=y] && (ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST [=y])
> 
> because TI_CPSW_SWITCHDEV blindly selects NET_SWITCHDEV even though
> INET is not set/enabled, while NET_SWITCHDEV depends on INET.
> 
> However, the build succeeds, including net/switchdev/*.
> 
> So why does NET_SWITCHDEV depend on INET?
> 
> It looks like TI_CPSW_SWITCHDEV should depend on INET (based on the
> Kconfig rules), but in practice it doesn't seem to matter to the build.
> 

Thanks for reporting this. I'd like to ask for some advice of how to proceed?
a) change it to "depends on NET_SWITCHDEV" (as it's done in other drivers),
but this will require to add NET_SWITCHDEV in defconfig

b) change it to "imply NET_SWITCHDEV", but then NET_SWITCHDEV can be switched off
manually or by random build and cause build failure of cpsw_new.
To fix build below diff can be used, but TI_CPSW_SWITCHDEV will not be functional

---
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 71215db7934b..22e8fc548d48 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -368,8 +368,9 @@ static void cpsw_rx_handler(void *token, int len, int status)
                 page_pool_recycle_direct(pool, page);
                 goto requeue;
         }
-
+#ifdef CONFIG_NET_SWITCHDEV
         skb->offload_fwd_mark = priv->offload_fwd_mark;
+#endif
         skb_reserve(skb, headroom);
         skb_put(skb, len);
         skb->dev = ndev;

Thank you.

-- 
Best regards,
grygorii
