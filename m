Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F4197DF7
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 17:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfHUPCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 11:02:22 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:45476 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfHUPCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 11:02:21 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x7LF2H3Q115452;
        Wed, 21 Aug 2019 10:02:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1566399737;
        bh=9U6VgUhs0WUhDkB5sgJHbbn7p+rrmYQHaH8DyLgbm0k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=WKZKmhCzTM92U3edVWZZeYK4kHibPRD0XAY8t4dJraauANMKIyKyr1+385o/bgEGX
         ueKkwTe+Q2z6jj6avJRaK4VH4oYZRpVGXZ6PJ2E3bXMbVV6OwfqWKvQy+B+uL0xpJW
         trbrL78+ft4yyD/sbq/jPIEKYFfiU7HYvGhB9g5g=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x7LF2H1R046792
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Aug 2019 10:02:17 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 21
 Aug 2019 10:02:16 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 21 Aug 2019 10:02:17 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x7LF2Eeg041638;
        Wed, 21 Aug 2019 10:02:15 -0500
Subject: Re: [PATCH net] net: cpsw: fix NULL pointer exception in the probe
 error path
To:     Antoine Tenart <antoine.tenart@bootlin.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maxime.chevallier@bootlin.com>
References: <20190821144123.22248-1-antoine.tenart@bootlin.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <139cd66e-e8f8-0d18-a876-59e791bb8624@ti.com>
Date:   Wed, 21 Aug 2019 18:02:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821144123.22248-1-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/08/2019 17:41, Antoine Tenart wrote:
> In certain cases when the probe function fails the error path calls
> cpsw_remove_dt() before calling platform_set_drvdata(). This is an
> issue as cpsw_remove_dt() uses platform_get_drvdata() to retrieve the
> cpsw_common data and leds to a NULL pointer exception. This patches
> fixes it by calling platform_set_drvdata() earlier in the probe.
> 
> Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
> Reported-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> ---
>   drivers/net/ethernet/ti/cpsw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thank you.
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
