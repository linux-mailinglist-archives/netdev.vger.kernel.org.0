Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E102564D85
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiGDGHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGDGHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:07:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76F8260E;
        Sun,  3 Jul 2022 23:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=qMsi7mfSLXEjpUiIBfsQE7qC2Jft7oQJB0gOr0K33K0=; b=X0fv9ZqNT+F+P3lSATIDqjjd5j
        8t5SKL0cA4HZHVbntVGF3Mx/UMrbgKF2esC/umWb2Z+Cl9Sv+cIgrb9nOBAjtqBvLhlULEvlPRnMx
        eBwjWKBScKUJqNrrMfRjkT+BfkL3SzOujN1Z1+R1aDPX7UGt7hi/OC92nC0t9reOUp6rMDNZnClEs
        T2IYTViUetFzKI/DPYm7ea12fwSusG2qVJjjP5zMJ3HEdlX4qfQ3xCeYjUbc4UsuC+oRoY3+ZLfF1
        UQl4gKrEkbHNZx4Eu9M0KOuj/vVRFzLAJiSF2ek2Tx6/vJkoCUNiD9sQTAGytABfAX9qIFV7U1ydz
        1+NNmbQA==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8FF8-005Gh4-3u; Mon, 04 Jul 2022 06:07:34 +0000
Message-ID: <4e13e0c4-dc70-4228-609c-288f8db6ddc3@infradead.org>
Date:   Sun, 3 Jul 2022 23:07:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] net: hns: Fix spelling mistake in comments
Content-Language: en-US
To:     Zhang Jiaming <jiaming@nfschina.com>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com
References: <20220704014204.8212-1-jiaming@nfschina.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220704014204.8212-1-jiaming@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 7/3/22 18:42, Zhang Jiaming wrote:
> There is a typo(waitting) in comments.
> FIx it.
> 
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
> ---
>  drivers/net/ethernet/hisilicon/hns_mdio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
> index 07fdab58001d..c239c407360f 100644
> --- a/drivers/net/ethernet/hisilicon/hns_mdio.c
> +++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
> @@ -174,7 +174,7 @@ static int hns_mdio_wait_ready(struct mii_bus *bus)
>  	u32 cmd_reg_value;
>  	int i;
>  
> -	/* waitting for MDIO_COMMAND_REG 's mdio_start==0 */
> +	/* waiting for MDIO_COMMAND_REG 's mdio_start==0 */

Also: no space here:   MDIO_COMMAND_REG's

>  	/* after that can do read or write*/
>  	for (i = 0; i < MDIO_TIMEOUT; i++) {
>  		cmd_reg_value = MDIO_GET_REG_BIT(mdio_dev,
> @@ -319,7 +319,7 @@ static int hns_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
>  				   MDIO_C45_READ, phy_id, devad);
>  	}
>  
> -	/* Step 5: waitting for MDIO_COMMAND_REG 's mdio_start==0,*/
> +	/* Step 5: waiting for MDIO_COMMAND_REG 's mdio_start==0,*/

Same here.

>  	/* check for read or write opt is finished */
>  	ret = hns_mdio_wait_ready(bus);
>  	if (ret) {

-- 
~Randy
