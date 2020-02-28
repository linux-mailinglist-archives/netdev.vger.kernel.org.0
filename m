Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964391740EC
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 21:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgB1UZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 15:25:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1UZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 15:25:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2291115A007F2;
        Fri, 28 Feb 2020 12:25:35 -0800 (PST)
Date:   Fri, 28 Feb 2020 12:25:34 -0800 (PST)
Message-Id: <20200228.122534.2100427304852735810.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        secdev@chelsio.com, varun@chelsio.com
Subject: Re: [PATCH net-next v2 1/6] cxgb4/chcr : Register to tls add and
 del callbacks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200228183945.11594-2-rohitm@chelsio.com>
References: <20200228183945.11594-1-rohitm@chelsio.com>
        <20200228183945.11594-2-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Feb 2020 12:25:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Sat, 29 Feb 2020 00:09:40 +0530

> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
> +/* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
> + * @adap: adapter info
> + * @enable: 1 to enable / 0 to disable ktls settings.
> + */
> +static void cxgb4_set_ktls_feature(struct adapter *adap, bool enable)
> +{
> +	int ret = 0;
> +	u32 params = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
> +		      FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_KTLS_TX_HW) |
> +		      FW_PARAMS_PARAM_Y_V(enable));
> +	ret = t4_set_params(adap, adap->mbox, adap->pf, 0, 1, &params, &params);
> +	/* if fw returns failure, clear the ktls flag */
> +	if (ret)
> +		adap->params.crypto &= ~ULP_CRYPTO_KTLS_INLINE;

Please put an empty line between local variable declarations and code.

Please order local variables in reverse christmas tree ordering.

Thank you.
