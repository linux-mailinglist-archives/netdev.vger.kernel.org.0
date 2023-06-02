Return-Path: <netdev+bounces-7343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A2F71FCC7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 800CA1C20BEE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BE414286;
	Fri,  2 Jun 2023 08:54:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1994046AA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:54:53 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63BFE52
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:54:31 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3528sKK9027659;
	Fri, 2 Jun 2023 03:54:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1685696060;
	bh=V2p+jq8Ctw9rByWsLTNS2arqzG00Bxp9ytj9ysO8HGw=;
	h=Date:CC:Subject:To:References:From:In-Reply-To;
	b=rk9UqGyacQ2R4SXNTXEM3kA6HEHyWHn24lnvZ5k5zkB8Tgp1XC4kLUcWRj9wZCYLt
	 RZCBlpJWYHpXlM5ZjvoRS+ocs5K2K5094sLcE3UNiQs5McYX9IIYwM52E/lhPHJhFT
	 aQaURvbW/34doanV2vRuJQ2AmfEUda0/uXtXuu0s=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3528sKt0009490
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 2 Jun 2023 03:54:20 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 2
 Jun 2023 03:54:19 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 2 Jun 2023 03:54:19 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3528sGGV094792;
	Fri, 2 Jun 2023 03:54:17 -0500
Message-ID: <2fd8d661-8c1b-5e33-4b04-1d0f2fedd6fc@ti.com>
Date: Fri, 2 Jun 2023 14:24:16 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
CC: <pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <davem@davemloft.net>, <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next] net: lan743x: Remove extranous gotos
Content-Language: en-US
To: Moritz Fischer <moritzf@google.com>, <netdev@vger.kernel.org>
References: <20230602000414.3294036-1-moritzf@google.com>
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20230602000414.3294036-1-moritzf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 02/06/23 05:34, Moritz Fischer wrote:
> The gotos for cleanup aren't required, the function
> might as well just return the actual error code.
> 
> Signed-off-by: Moritz Fischer <moritzf@google.com>

Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>

> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 20 +++++--------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 957d96a91a8a..f1bded993edc 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -160,16 +160,13 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
>  {
>  	struct lan743x_csr *csr = &adapter->csr;
>  	resource_size_t bar_start, bar_length;
> -	int result;
>  
>  	bar_start = pci_resource_start(adapter->pdev, 0);
>  	bar_length = pci_resource_len(adapter->pdev, 0);
>  	csr->csr_address = devm_ioremap(&adapter->pdev->dev,
>  					bar_start, bar_length);
> -	if (!csr->csr_address) {
> -		result = -ENOMEM;
> -		goto clean_up;
> -	}
> +	if (!csr->csr_address)
> +		return -ENOMEM;
>  
>  	csr->id_rev = lan743x_csr_read(adapter, ID_REV);
>  	csr->fpga_rev = lan743x_csr_read(adapter, FPGA_REV);
> @@ -177,10 +174,8 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
>  		   "ID_REV = 0x%08X, FPGA_REV = %d.%d\n",
>  		   csr->id_rev,	FPGA_REV_GET_MAJOR_(csr->fpga_rev),
>  		   FPGA_REV_GET_MINOR_(csr->fpga_rev));
> -	if (!ID_REV_IS_VALID_CHIP_ID_(csr->id_rev)) {
> -		result = -ENODEV;
> -		goto clean_up;
> -	}
> +	if (!ID_REV_IS_VALID_CHIP_ID_(csr->id_rev))
> +		return -ENODEV;
>  
>  	csr->flags = LAN743X_CSR_FLAG_SUPPORTS_INTR_AUTO_SET_CLR;
>  	switch (csr->id_rev & ID_REV_CHIP_REV_MASK_) {
> @@ -193,12 +188,7 @@ static int lan743x_csr_init(struct lan743x_adapter *adapter)
>  		break;
>  	}
>  
> -	result = lan743x_csr_light_reset(adapter);
> -	if (result)
> -		goto clean_up;
> -	return 0;
> -clean_up:
> -	return result;
> +	return lan743x_csr_light_reset(adapter);
>  }
>  
>  static void lan743x_intr_software_isr(struct lan743x_adapter *adapter)

-- 
Regards,
Siddharth.

