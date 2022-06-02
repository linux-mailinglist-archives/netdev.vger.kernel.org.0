Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B338E53B120
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiFBBHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbiFBBHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:07:05 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49E213F0F;
        Wed,  1 Jun 2022 18:07:01 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 2 Jun 2022
 09:07:04 +0800
Received: from [172.16.137.70] (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 2 Jun
 2022 09:06:59 +0800
Message-ID: <840dde56-18ab-40a6-d317-6288df5485ea@meizu.com>
Date:   Thu, 2 Jun 2022 09:06:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: tulip: de4x5: remove unused variable
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1654068277-6691-1-git-send-email-baihaowen@meizu.com>
From:   baihaowen <baihaowen@meizu.com>
In-Reply-To: <1654068277-6691-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/6/1 下午3:24, Haowen Bai 写道:
> The variable imr is initialized but never used otherwise.
>
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/ethernet/dec/tulip/de4x5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
> index 71730ef4cd57..40a54827d599 100644
> --- a/drivers/net/ethernet/dec/tulip/de4x5.c
> +++ b/drivers/net/ethernet/dec/tulip/de4x5.c
> @@ -3817,10 +3817,9 @@ de4x5_setup_intr(struct net_device *dev)
>  {
>      struct de4x5_private *lp = netdev_priv(dev);
>      u_long iobase = dev->base_addr;
> -    s32 imr, sts;
> +    s32 sts;
>  
>      if (inl(DE4X5_OMR) & OMR_SR) {   /* Only unmask if TX/RX is enabled */
> -	imr = 0;
>  	UNMASK_IRQs;
>  	sts = inl(DE4X5_STS);        /* Reset any pending (stale) interrupts */
>  	outl(sts, DE4X5_STS);
Sorry, ignore this patch.

-- 
Haowen Bai

