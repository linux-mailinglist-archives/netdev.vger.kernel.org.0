Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE0339C74
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 07:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhCMGul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 01:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbhCMGuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 01:50:06 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6634C061574;
        Fri, 12 Mar 2021 22:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=eFNvnL8zLJRq7lDSRdeDQTkvUtR6qc0g5L8oYiirzk8=; b=lAMHYzYvu1zYHq0gOkL6+Nzonh
        VDMq+1XRpxbBSaCiIeDtY4SIk8GxFooJnoKYlFLSyHqafb4m5Ul0BXXU67gTLJUojhK6PWtA/AlId
        pt6/Gzc9lB12vF3YuShUesLnBs9Q+WZkQdPX2xvj8Kv4CU78qxRnv9IX49i+lCmki830CiY2iImDa
        SWExzYtjycVAEBW0c5sct2ORjU/oZm8u2QFOKXcKJVCd0nkQrx6MGohc8r3aMMarHkNt79nkG2okP
        B2ijUlm58GX55YEGnp9/CI/ppcgInU1aFzbcAFrzPKgb/4eRHh31/Br58tFm5JQohBzfUTYHgIW53
        y8duaUkw==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKy64-0017is-Tz; Sat, 13 Mar 2021 06:50:02 +0000
Subject: Re: [PATCH] net: ethernet: marvell: Fixed typo in the file sky2.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, mlindner@marvell.com,
        stephen@networkplumber.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210313054536.1182-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <37c013eb-1419-9bf9-07d0-f1ff6d621296@infradead.org>
Date:   Fri, 12 Mar 2021 22:49:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210313054536.1182-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 9:45 PM, Bhaskar Chowdhury wrote:
> 
> s/calclation/calculation/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


Subject: should say "Fix typo", not "Fixed typo".

> ---
>  drivers/net/ethernet/marvell/sky2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
> index ebe1406c6e64..18a3db2fd337 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4135,7 +4135,7 @@ static int sky2_set_coalesce(struct net_device *dev,
>  /*
>   * Hardware is limited to min of 128 and max of 2048 for ring size
>   * and  rounded up to next power of two
> - * to avoid division in modulus calclation
> + * to avoid division in modulus calculation
>   */
>  static unsigned long roundup_ring_size(unsigned long pending)
>  {
> --


-- 
~Randy

