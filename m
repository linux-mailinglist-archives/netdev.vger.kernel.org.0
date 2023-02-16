Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F0E6990D7
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBPKOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBPKO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:14:26 -0500
X-Greylist: delayed 1169 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 02:14:24 PST
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9259CAD3A;
        Thu, 16 Feb 2023 02:14:24 -0800 (PST)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 89ACC30D1678;
        Thu, 16 Feb 2023 10:36:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=yxm6j
        kXhPMCS5jwIHq6ZkaR2lJ2JDWuZtj3/ryEZqvk=; b=UASl2ta87kVq2IXf2MtJL
        g8N+GUtSRnaVnVN4hvNfXb7y2louz1STFaireccylC7YdmaKLOgW5rqwiBCU0+A+
        rh3p7HQkDmexTnMCbv4nLirfXJ07IVgGnWzwnzGKq6D1ZhECaDUL2iK81fg7ar5P
        dP4JKDIEk3fGpxzW9JIkwbW0TEVZJVTtZ8ONhZ8b7mqAqFOloB2gFERsq6eGEM7u
        yz+iGSIXkpI5XAM+0OSlX3pE67VxtGp/qoVg1rieihRq1QnIIacFSGRdN3ZB1XVL
        YpfmrdIRuNUzjTmtZNmgvnocKOA5JGIeZFqIuMoHmhIcKBTkRYHxST4YXuR8dLS6
        A==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 74A0830B295F;
        Thu, 16 Feb 2023 10:36:33 +0100 (CET)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 31G9aXfO005477;
        Thu, 16 Feb 2023 10:36:33 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 31G9aWGA005476;
        Thu, 16 Feb 2023 10:36:32 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH -next] can: ctucanfd: Use devm_platform_ioremap_resource()
Date:   Thu, 16 Feb 2023 10:36:27 +0100
User-Agent: KMail/1.9.10
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        ondrej.ille@gmail.com, wg@grandegger.com, mkl@pengutronix.de,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202302161036.27507.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 16 of February 2023 10:06:10 Yang Li wrote:
> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to Use devm_platform_ioremap_resource(), as this is exactly
> what this function does.
>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

> ---
>  drivers/net/can/ctucanfd/ctucanfd_platform.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> b/drivers/net/can/ctucanfd/ctucanfd_platform.c index
> f83684f006ea..a17561d97192 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> @@ -47,7 +47,6 @@ static void ctucan_platform_set_drvdata(struct device
> *dev, */
>  static int ctucan_platform_probe(struct platform_device *pdev)
>  {
> -	struct resource *res; /* IO mem resources */
>  	struct device	*dev = &pdev->dev;
>  	void __iomem *addr;
>  	int ret;
> @@ -55,8 +54,7 @@ static int ctucan_platform_probe(struct platform_device
> *pdev) int irq;
>
>  	/* Get the virtual base address for the device */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	addr = devm_ioremap_resource(dev, res);
> +	addr = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(addr)) {
>  		ret = PTR_ERR(addr);
>  		goto err;


-- 
                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

