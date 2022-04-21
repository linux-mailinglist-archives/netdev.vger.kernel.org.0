Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D674C50AAA3
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 23:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441887AbiDUVUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 17:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441876AbiDUVUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 17:20:31 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B74F4C436;
        Thu, 21 Apr 2022 14:17:40 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id E1E6330B2948;
        Thu, 21 Apr 2022 23:17:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=hbDk3
        3ZxCTMt1n/ItJN8YwASodp90ZfV7RkeZbyKvBA=; b=JXaYXnh4S5p9PnmzC/iDG
        8xXu0hfWRsG2RAVXouI0BQG0Vz17pBvgxnZaIeeIUfEaeEV7SJyI2+gPoD3ahI3V
        VrWa35/is0O/avx9tK/SsB6bd9lHxjtaQSh7LwAlwVtfvAnQStUQegI2mg+V3tvN
        X7ZoQCTXJXrPfennmi0ooN7FanynE0AYCT5V7wBDXPrICFqS+N4HGsIYV98X2G6g
        yk75Qn8nIdBCVEpFnu09d2TCJXzeE20Y6pu7DJKbukxjImvUrqvktetlJnB0Kieb
        ES7LXEBd/231Yhr41jETg4yfMlYJUB4GKWfmW9QTor9huptSu3n8ittWNToskIZe
        w==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 309B630B2943;
        Thu, 21 Apr 2022 23:17:08 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23LLH7TQ026503;
        Thu, 21 Apr 2022 23:17:07 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23LLH7gv026502;
        Thu, 21 Apr 2022 23:17:07 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] can: ctucanfd: Remove unused including <linux/version.h>
Date:   Thu, 21 Apr 2022 23:17:07 +0200
User-Agent: KMail/1.9.10
Cc:     ondrej.ille@gmail.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220421202852.2693-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20220421202852.2693-1-jiapeng.chong@linux.alibaba.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202204212317.07635.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for checking

On Thursday 21 of April 2022 22:28:52 Jiapeng Chong wrote:
> Eliminate the follow versioncheck warning:
>
> ./drivers/net/can/ctucanfd/ctucanfd_base.c: 34 linux/version.h not
> needed.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Pave Pisa <pisa@cmp.felk.cvut.cz>

> ---
>  drivers/net/can/ctucanfd/ctucanfd_base.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c
> b/drivers/net/can/ctucanfd/ctucanfd_base.c index 7a4550f60abb..be90136be442
> 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
> @@ -31,7 +31,6 @@
>  #include <linux/can/error.h>
>  #include <linux/can/led.h>
>  #include <linux/pm_runtime.h>
> -#include <linux/version.h>
>
>  #include "ctucanfd.h"
>  #include "ctucanfd_kregs.h"


-- 
Yours sincerely

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

