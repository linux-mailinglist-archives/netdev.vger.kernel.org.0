Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BF43A35B0
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFJVNo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Jun 2021 17:13:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49980 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFJVNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:13:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AA6424F7DFB91;
        Thu, 10 Jun 2021 14:11:46 -0700 (PDT)
Date:   Thu, 10 Jun 2021 14:11:42 -0700 (PDT)
Message-Id: <20210610.141142.1384244468678097702.davem@davemloft.net>
To:     hbut_tan@163.com
Cc:     elder@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tanzhongjun@yulong.com
Subject: Re: [PATCH] soc: qcom: ipa: Remove superfluous error message
 around platform_get_irq()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210610140118.1437-1-hbut_tan@163.com>
References: <20210610140118.1437-1-hbut_tan@163.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Jun 2021 14:11:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:  Zhongjun Tan <hbut_tan@163.com>
Date: Thu, 10 Jun 2021 22:01:18 +0800

> diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
> index 34b68dc43886..93270e50b6b3 100644
> --- a/drivers/net/ipa/ipa_smp2p.c
> +++ b/drivers/net/ipa/ipa_smp2p.c
> @@ -177,11 +177,8 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
>  	int ret;
>  
>  	ret = platform_get_irq_byname(smp2p->ipa->pdev, name);
> -	if (ret <= 0) {
> -		dev_err(dev, "DT error %d getting \"%s\" IRQ property\n",
> -			ret, name);
> +	if (ret <= 0)
Applied, but this code still rejects an irq of zero which is a valid irq number.

