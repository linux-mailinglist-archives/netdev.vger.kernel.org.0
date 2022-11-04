Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B930C6192B4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiKDI3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKDI3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:29:31 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0AB2610E;
        Fri,  4 Nov 2022 01:29:28 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A48T9Bd069390;
        Fri, 4 Nov 2022 03:29:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667550549;
        bh=wzdyeQtA1BJFPKnF5UKy36+Fr9fVVXAI8Q/OlNVXBsk=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=U29cRoJmjFecnW5p9q+pt23BjQUaQ8tufeNyxZXCvmCG4vFMTI1xK3naAdZyDI7HT
         G3Gy5y08wveSmFGiug3pjpnB142cpN8s7G/vQXN8a86H5E7GmcvWhIwP75YaQMDF7B
         6ORiZsJNohPCl2vcjR8sfSQmXZA0C7a+eI86O2hw=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A48T9Yi010735
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Nov 2022 03:29:09 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 4 Nov
 2022 03:29:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 4 Nov 2022 03:29:09 -0500
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A48T4dP124620;
        Fri, 4 Nov 2022 03:29:04 -0500
Message-ID: <dea2ce94-5d0c-67ad-ac2f-21d6c281d54b@ti.com>
Date:   Fri, 4 Nov 2022 13:59:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nm@ti.com>, <ssantosh@kernel.org>,
        <s-anna@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@kernel.org>, <vigneshr@ti.com>, <robh+dt@kernel.org>,
        <afd@ti.com>, <andrew@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-3-p-mohan@ti.com>
 <fee7c767e1a57822bddc88fb6096673838e93ee4.camel@redhat.com>
From:   Md Danish Anwar <a0501179@ti.com>
In-Reply-To: <fee7c767e1a57822bddc88fb6096673838e93ee4.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

I am Danish, new addition to TI team. Puranjay left TI, I'll be posting
upstream patches for Programmable Real-time Unit and Industrial Communication
Subsystem Gigabit (PRU_ICSSG).

On 31/05/22 16:53, Paolo Abeni wrote:
> On Tue, 2022-05-31 at 15:21 +0530, Puranjay Mohan wrote:
> [...]
>> +static int emac_tx_complete_packets(struct prueth_emac *emac, int chn,
>> +				    int budget)
>> +{
>> +	struct net_device *ndev = emac->ndev;
>> +	struct cppi5_host_desc_t *desc_tx;
>> +	struct netdev_queue *netif_txq;
>> +	struct prueth_tx_chn *tx_chn;
>> +	unsigned int total_bytes = 0;
>> +	struct sk_buff *skb;
>> +	dma_addr_t desc_dma;
>> +	int res, num_tx = 0;
>> +	void **swdata;
>> +
>> +	tx_chn = &emac->tx_chns[chn];
>> +
>> +	while (budget--) {
>> +		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
>> +		if (res == -ENODATA)
>> +			break;
>> +
>> +		/* teardown completion */
>> +		if (cppi5_desc_is_tdcm(desc_dma)) {
>> +			if (atomic_dec_and_test(&emac->tdown_cnt))
>> +				complete(&emac->tdown_complete);
>> +			break;
>> +		}
>> +
>> +		desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
>> +						     desc_dma);
>> +		swdata = cppi5_hdesc_get_swdata(desc_tx);
>> +
>> +		skb = *(swdata);
>> +		prueth_xmit_free(tx_chn, desc_tx);
>> +
>> +		ndev = skb->dev;
>> +		ndev->stats.tx_packets++;
>> +		ndev->stats.tx_bytes += skb->len;
>> +		total_bytes += skb->len;
>> +		napi_consume_skb(skb, budget);
> 
> The above is uncorrect. In this loop's last iteration 'budget' will  be
> 0 and napi_consume_skb will wrongly assume the caller is not in NAPI
> context. 
> 

Yes, in the current approach, in last iteration budget will be zero. To avoid
this, we can change the looping condition. Instead of while(budget--), it could
be while(budget) and budget will be decreamented at the end of the loop.
This way in the last iteration budget value will not be zero.

The while loop will look like this.

while (budget) {
    res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
	if (res == -ENODATA)
		break;

	/* teardown completion */
	if (cppi5_desc_is_tdcm(desc_dma)) {
		if (atomic_dec_and_test(&emac->tdown_cnt))
			complete(&emac->tdown_complete);
		break;
	}

	desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
					     desc_dma);
	swdata = cppi5_hdesc_get_swdata(desc_tx);

	skb = *(swdata);
	prueth_xmit_free(tx_chn, desc_tx);

	ndev = skb->dev;
	ndev->stats.tx_packets++;
	ndev->stats.tx_bytes += skb->len;
	total_bytes += skb->len;
	napi_consume_skb(skb, budget);
	num_tx++;
        budget--;
}

Please let me know if this seems ok.


>> +static int prueth_dma_rx_push(struct prueth_emac *emac,
>> +			      struct sk_buff *skb,
>> +			      struct prueth_rx_chn *rx_chn)
>> +{
>> +	struct cppi5_host_desc_t *desc_rx;
>> +	struct net_device *ndev = emac->ndev;
>> +	dma_addr_t desc_dma;
>> +	dma_addr_t buf_dma;
>> +	u32 pkt_len = skb_tailroom(skb);
>> +	void **swdata;
>> +
>> +	desc_rx = k3_cppi_desc_pool_alloc(rx_chn->desc_pool);
>> +	if (!desc_rx) {
>> +		netdev_err(ndev, "rx push: failed to allocate descriptor\n");
>> +		return -ENOMEM;
>> +	}
>> +	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
>> +
>> +	buf_dma = dma_map_single(rx_chn->dma_dev, skb->data, pkt_len, DMA_FROM_DEVICE);
>> +	if (unlikely(dma_mapping_error(rx_chn->dma_dev, buf_dma))) {
>> +		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
>> +		netdev_err(ndev, "rx push: failed to map rx pkt buffer\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
>> +			 PRUETH_NAV_PS_DATA_SIZE);
>> +	k3_udma_glue_rx_dma_to_cppi5_addr(rx_chn->rx_chn, &buf_dma);
>> +	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
>> +
>> +	swdata = cppi5_hdesc_get_swdata(desc_rx);
>> +	*swdata = skb;
>> +
>> +	return k3_udma_glue_push_rx_chn(rx_chn->rx_chn, 0,
>> +					desc_rx, desc_dma);
>> +}
>> +
>> +static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id)
>> +{
>> +	struct prueth_rx_chn *rx_chn = &emac->rx_chns;
>> +	struct net_device *ndev = emac->ndev;
>> +	struct cppi5_host_desc_t *desc_rx;
>> +	dma_addr_t desc_dma, buf_dma;
>> +	u32 buf_dma_len, pkt_len, port_id = 0;
>> +	int ret;
>> +	void **swdata;
>> +	struct sk_buff *skb, *new_skb;
>> +
>> +	ret = k3_udma_glue_pop_rx_chn(rx_chn->rx_chn, flow_id, &desc_dma);
>> +	if (ret) {
>> +		if (ret != -ENODATA)
>> +			netdev_err(ndev, "rx pop: failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	if (cppi5_desc_is_tdcm(desc_dma)) /* Teardown ? */
>> +		return 0;
>> +
>> +	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
>> +
>> +	swdata = cppi5_hdesc_get_swdata(desc_rx);
>> +	skb = *swdata;
>> +
>> +	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
>> +	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
>> +	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
>> +	/* firmware adds 4 CRC bytes, strip them */
>> +	pkt_len -= 4;
>> +	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
>> +
>> +	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
>> +	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
>> +
>> +	skb->dev = ndev;
>> +	if (!netif_running(skb->dev)) {
>> +		dev_kfree_skb_any(skb);
>> +		return 0;
>> +	}
>> +
>> +	new_skb = netdev_alloc_skb_ip_align(ndev, PRUETH_MAX_PKT_SIZE);
>> +	/* if allocation fails we drop the packet but push the
>> +	 * descriptor back to the ring with old skb to prevent a stall
>> +	 */
>> +	if (!new_skb) {
>> +		ndev->stats.rx_dropped++;
>> +		new_skb = skb;
>> +	} else {
>> +		/* send the filled skb up the n/w stack */
>> +		skb_put(skb, pkt_len);
>> +		skb->protocol = eth_type_trans(skb, ndev);
>> +		netif_receive_skb(skb);
> 
> This is (apparently) in napi context. You should use napi_gro_receive()
> or napi_gro_frags()
> 

Here instead of the below line,
	netif_receive_skb(skb);
I will add the below line.
	napi_gro_receive(&emac->napi_rx,skb);

> 
> Cheers!
> 
> Paolo
> 
>

Thanks and Regards,
Md Danish Anwar.

> From mboxrd@z Thu Jan  1 00:00:00 1970
> Return-Path: <linux-arm-kernel-bounces+linux-arm-kernel=archiver.kernel.org@lists.infradead.org>
> X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
> 	aws-us-west-2-korg-lkml-1.web.codeaurora.org
> Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D786C433F5
> 	for <linux-arm-kernel@archiver.kernel.org>; Tue, 31 May 2022 11:25:15 +0000 (UTC)
> DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
> 	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
> 	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
> 	List-Archive:List-Unsubscribe:List-Id:MIME-Version:References:In-Reply-To:
> 	Date:Cc:To:From:Subject:Message-ID:Reply-To:Content-ID:Content-Description:
> 	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
> 	List-Owner; bh=G6tJbk7sQR1mDcrAEuhdOI2yoBQYm8IZy4P83gbmA5I=; b=b9Mfw3uDtLFHrB
> 	NWAtz9tl5UTBd63L1taDo96GeRFEK2UFO0N+PDA2axuNFxwGia7rnX77QsxtDIwcsIM54iQ4bqgkV
> 	cRjIWVy+hV15u6iqB4AOb8koWEtcNBOhHlkFdhEcaiBjSF3bkGVZfkevi5DXApAN7dRZ5RRIjoreK
> 	8Z2H7S5Ra1ySKmznpQuVTegkT1RWQOeRAEWBInn0tMY9IWAkDvgwaxLFMysYAr7l9nDwn5ZyPr9IH
> 	IxMiVdJl9Mm8oqCfD0sSjX2nMbCT5njTvzc+CNtUYq+QmowBNFA4dXRxjN5QTV8tFktoZohMNbE0b
> 	ku0VtX5brHWK2Ah+XLPw==;
> Received: from localhost ([::1] helo=bombadil.infradead.org)
> 	by bombadil.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
> 	id 1nvzyl-00AQPx-Hr; Tue, 31 May 2022 11:24:03 +0000
> Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124])
> 	by bombadil.infradead.org with esmtps (Exim 4.94.2 #2 (Red Hat Linux))
> 	id 1nvzyd-00AQGI-TY
> 	for linux-arm-kernel@lists.infradead.org; Tue, 31 May 2022 11:24:01 +0000
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
> 	s=mimecast20190719; t=1653996227;
> 	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
> 	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
> 	 content-transfer-encoding:content-transfer-encoding:
> 	 in-reply-to:in-reply-to:references:references;
> 	bh=cb0uCHMo8aU2h1eNWnUmV0rqWGFcvOyZ9KFWz5IpS3o=;
> 	b=h22ZTXxxwt9hyc7KbHSr62yigwFCCTio7owsb2WAm5cp6e8Kiuk3fJGffx8nfPDdVJJkFN
> 	OREBfOrrzVHd+ASgkpchKc0gLVuQ6fqS/T0+zTlFfQfviUXAQsUZyFBgXUB7+hYmxkX5n8
> 	F/2G78qChsTPJo2XWwVmmZHI/gYbzbw=
> Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
>  [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
>  (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
>  us-mta-571-TQPFR5jZOvmNDrKiJr3Xvg-1; Tue, 31 May 2022 07:23:46 -0400
> X-MC-Unique: TQPFR5jZOvmNDrKiJr3Xvg-1
> Received: by mail-qk1-f200.google.com with SMTP id v14-20020a05620a0f0e00b00699f4ea852cso10297976qkl.9
>         for <linux-arm-kernel@lists.infradead.org>; Tue, 31 May 2022 04:23:46 -0700 (PDT)
> X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>         d=1e100.net; s=20210112;
>         h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
>          :references:user-agent:mime-version:content-transfer-encoding;
>         bh=cb0uCHMo8aU2h1eNWnUmV0rqWGFcvOyZ9KFWz5IpS3o=;
>         b=LqfkbB8wXsz3y7UBmnT/YVVBZ7S0Y60UrJo5mC3q599z5+eFofo5rfCIPIAyXzm5JZ
>          3sHnSAp8Hp8XyFTwwCDRIXb6jJhKz4J9cBLmCaQ3d1/pjbTZUthlYYNnSKK0tjTqoPNI
>          iTiCrg26k39q9Znhg0nQ72/+TrHomUqUs0r17ymA1dVbA1hcySoC09m08SHtLS5eUOSH
>          u4FJ3qUwrJibIqrdObz2Pi29aPHOwhdi1ax5xk3EDrJM8RLtEWAexx8l1vsm9SiAuWdW
>          KnYidUxP+vsyesflHI38sjxaaFjde2vifXOrnyArcLRsAsHqyqwfqNVSjfTf4LbMzv0c
>          M3fQ==
> X-Gm-Message-State: AOAM532rTtItItwMr1nw+byJldJCXtJ/u45688HjEb4OLqmB4ExjHSKA
> 	cBaCX44yNzplF0RGG6P6cnWGPOU9aPqJ5KDHkieG7iqQYrjlpCaVkBWGv4mtJOwK/ksP+dlc1Oi
> 	Ojtg8QWc+0xb2gu+IBjsJsR72JtdOiLLrYWU=
> X-Received: by 2002:a05:620a:12fb:b0:6a5:816e:43d6 with SMTP id f27-20020a05620a12fb00b006a5816e43d6mr23692501qkl.692.1653996226020;
>         Tue, 31 May 2022 04:23:46 -0700 (PDT)
> X-Google-Smtp-Source: ABdhPJzcKltOlg/kYOsBwY4ck89LyJGn1h8RwebGLbLyGZQf6VOtbjGuWUhQQKGVPYXnPktvmybIag==
> X-Received: by 2002:a05:620a:12fb:b0:6a5:816e:43d6 with SMTP id f27-20020a05620a12fb00b006a5816e43d6mr23692486qkl.692.1653996225758;
>         Tue, 31 May 2022 04:23:45 -0700 (PDT)
> Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
>         by smtp.gmail.com with ESMTPSA id b26-20020a05620a271a00b0069fe1fc72e7sm9204894qkp.90.2022.05.31.04.23.42
>         (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
>         Tue, 31 May 2022 04:23:45 -0700 (PDT)
> Message-ID: <fee7c767e1a57822bddc88fb6096673838e93ee4.camel@redhat.com>
> Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
> From: Paolo Abeni <pabeni@redhat.com>
> To: Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org
> Cc: davem@davemloft.net, edumazet@google.com,
>  krzysztof.kozlowski+dt@linaro.org,  netdev@vger.kernel.org,
>  devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org,  s-anna@ti.com,
>  linux-arm-kernel@lists.infradead.org, rogerq@kernel.org, 
>  grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
>  robh+dt@kernel.org,  afd@ti.com, andrew@lunn.ch
> Date: Tue, 31 May 2022 13:23:40 +0200
> In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
> References: <20220531095108.21757-1-p-mohan@ti.com>
> 	 <20220531095108.21757-3-p-mohan@ti.com>
> User-Agent: Evolution 3.42.4 (3.42.4-2.fc35)
> MIME-Version: 1.0
> Authentication-Results: relay.mimecast.com;
> 	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pabeni@redhat.com
> X-Mimecast-Spam-Score: 0
> X-Mimecast-Originator: redhat.com
> X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
> X-CRM114-CacheID: sfid-20220531_042356_091497_CF385DF2 
> X-CRM114-Status: GOOD (  17.59  )
> X-BeenThere: linux-arm-kernel@lists.infradead.org
> X-Mailman-Version: 2.1.34
> Precedence: list
> List-Id: <linux-arm-kernel.lists.infradead.org>
> List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
>  <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
> List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
> List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
> List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
> List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
>  <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
> Content-Type: text/plain; charset="us-ascii"
> Content-Transfer-Encoding: 7bit
> Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
> Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=archiver.kernel.org@lists.infradead.org
> 
> On Tue, 2022-05-31 at 15:21 +0530, Puranjay Mohan wrote:
> [...]
>> +static int emac_tx_complete_packets(struct prueth_emac *emac, int chn,
>> +				    int budget)
>> +{
>> +	struct net_device *ndev = emac->ndev;
>> +	struct cppi5_host_desc_t *desc_tx;
>> +	struct netdev_queue *netif_txq;
>> +	struct prueth_tx_chn *tx_chn;
>> +	unsigned int total_bytes = 0;
>> +	struct sk_buff *skb;
>> +	dma_addr_t desc_dma;
>> +	int res, num_tx = 0;
>> +	void **swdata;
>> +
>> +	tx_chn = &emac->tx_chns[chn];
>> +
>> +	while (budget--) {
>> +		res = k3_udma_glue_pop_tx_chn(tx_chn->tx_chn, &desc_dma);
>> +		if (res == -ENODATA)
>> +			break;
>> +
>> +		/* teardown completion */
>> +		if (cppi5_desc_is_tdcm(desc_dma)) {
>> +			if (atomic_dec_and_test(&emac->tdown_cnt))
>> +				complete(&emac->tdown_complete);
>> +			break;
>> +		}
>> +
>> +		desc_tx = k3_cppi_desc_pool_dma2virt(tx_chn->desc_pool,
>> +						     desc_dma);
>> +		swdata = cppi5_hdesc_get_swdata(desc_tx);
>> +
>> +		skb = *(swdata);
>> +		prueth_xmit_free(tx_chn, desc_tx);
>> +
>> +		ndev = skb->dev;
>> +		ndev->stats.tx_packets++;
>> +		ndev->stats.tx_bytes += skb->len;
>> +		total_bytes += skb->len;
>> +		napi_consume_skb(skb, budget);
> 
> The above is uncorrect. In this loop's last iteration 'budget' will  be
> 0 and napi_consume_skb will wrongly assume the caller is not in NAPI
> context. 
> 
>> +static int prueth_dma_rx_push(struct prueth_emac *emac,
>> +			      struct sk_buff *skb,
>> +			      struct prueth_rx_chn *rx_chn)
>> +{
>> +	struct cppi5_host_desc_t *desc_rx;
>> +	struct net_device *ndev = emac->ndev;
>> +	dma_addr_t desc_dma;
>> +	dma_addr_t buf_dma;
>> +	u32 pkt_len = skb_tailroom(skb);
>> +	void **swdata;
>> +
>> +	desc_rx = k3_cppi_desc_pool_alloc(rx_chn->desc_pool);
>> +	if (!desc_rx) {
>> +		netdev_err(ndev, "rx push: failed to allocate descriptor\n");
>> +		return -ENOMEM;
>> +	}
>> +	desc_dma = k3_cppi_desc_pool_virt2dma(rx_chn->desc_pool, desc_rx);
>> +
>> +	buf_dma = dma_map_single(rx_chn->dma_dev, skb->data, pkt_len, DMA_FROM_DEVICE);
>> +	if (unlikely(dma_mapping_error(rx_chn->dma_dev, buf_dma))) {
>> +		k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
>> +		netdev_err(ndev, "rx push: failed to map rx pkt buffer\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	cppi5_hdesc_init(desc_rx, CPPI5_INFO0_HDESC_EPIB_PRESENT,
>> +			 PRUETH_NAV_PS_DATA_SIZE);
>> +	k3_udma_glue_rx_dma_to_cppi5_addr(rx_chn->rx_chn, &buf_dma);
>> +	cppi5_hdesc_attach_buf(desc_rx, buf_dma, skb_tailroom(skb), buf_dma, skb_tailroom(skb));
>> +
>> +	swdata = cppi5_hdesc_get_swdata(desc_rx);
>> +	*swdata = skb;
>> +
>> +	return k3_udma_glue_push_rx_chn(rx_chn->rx_chn, 0,
>> +					desc_rx, desc_dma);
>> +}
>> +
>> +static int emac_rx_packet(struct prueth_emac *emac, u32 flow_id)
>> +{
>> +	struct prueth_rx_chn *rx_chn = &emac->rx_chns;
>> +	struct net_device *ndev = emac->ndev;
>> +	struct cppi5_host_desc_t *desc_rx;
>> +	dma_addr_t desc_dma, buf_dma;
>> +	u32 buf_dma_len, pkt_len, port_id = 0;
>> +	int ret;
>> +	void **swdata;
>> +	struct sk_buff *skb, *new_skb;
>> +
>> +	ret = k3_udma_glue_pop_rx_chn(rx_chn->rx_chn, flow_id, &desc_dma);
>> +	if (ret) {
>> +		if (ret != -ENODATA)
>> +			netdev_err(ndev, "rx pop: failed: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	if (cppi5_desc_is_tdcm(desc_dma)) /* Teardown ? */
>> +		return 0;
>> +
>> +	desc_rx = k3_cppi_desc_pool_dma2virt(rx_chn->desc_pool, desc_dma);
>> +
>> +	swdata = cppi5_hdesc_get_swdata(desc_rx);
>> +	skb = *swdata;
>> +
>> +	cppi5_hdesc_get_obuf(desc_rx, &buf_dma, &buf_dma_len);
>> +	k3_udma_glue_rx_cppi5_to_dma_addr(rx_chn->rx_chn, &buf_dma);
>> +	pkt_len = cppi5_hdesc_get_pktlen(desc_rx);
>> +	/* firmware adds 4 CRC bytes, strip them */
>> +	pkt_len -= 4;
>> +	cppi5_desc_get_tags_ids(&desc_rx->hdr, &port_id, NULL);
>> +
>> +	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
>> +	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
>> +
>> +	skb->dev = ndev;
>> +	if (!netif_running(skb->dev)) {
>> +		dev_kfree_skb_any(skb);
>> +		return 0;
>> +	}
>> +
>> +	new_skb = netdev_alloc_skb_ip_align(ndev, PRUETH_MAX_PKT_SIZE);
>> +	/* if allocation fails we drop the packet but push the
>> +	 * descriptor back to the ring with old skb to prevent a stall
>> +	 */
>> +	if (!new_skb) {
>> +		ndev->stats.rx_dropped++;
>> +		new_skb = skb;
>> +	} else {
>> +		/* send the filled skb up the n/w stack */
>> +		skb_put(skb, pkt_len);
>> +		skb->protocol = eth_type_trans(skb, ndev);
>> +		netif_receive_skb(skb);
> 
> This is (apparently) in napi context. You should use napi_gro_receive()
> or napi_gro_frags()
> 
> 
> Cheers!
> 
> Paolo
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 
