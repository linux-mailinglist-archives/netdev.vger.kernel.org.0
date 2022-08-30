Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0907F5A64E7
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiH3NhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiH3NhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:37:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A31AD980
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 06:37:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bs25so14284442wrb.2
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 06:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=+q3Kcm7Z8JcF1d1hb0GI/ucgVEvk8yb2HItfmD3paZk=;
        b=NU3/EStJBPHlk7kN6uEG1oz84H5Jcs+QKIu8/T+eB/3agx+f6pCskn8M4SDPWD7Dyq
         q66EgziiJZ3EdGRB2x0QZF0ph1SxDX7zaqKnqMJne5GdZfQ4wBqEajYGSoos5VbOVBL3
         8il6dedrXJzyFPi4QcVDTsG96O8uo174kTXjtGUbnrtRF6npeLqqL8JPIoB41MzzFX86
         xwa2w1kVBYdgy8SaK2jnXy+8VdVV5uCkJRk0kIfKeg7t9DnQSmkodAUSrrGpw4wNr9o5
         g2nYirYCEjT0UMph0lOxsMILoLFsaOaHCdso/wavDP/Dk2L1u3o8MI6nKX4MW4cQi+R6
         sG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+q3Kcm7Z8JcF1d1hb0GI/ucgVEvk8yb2HItfmD3paZk=;
        b=dYOBmNiPXsSm/BVFcskdHMXjrqU3BFJ2ceZI8d91QMTAfWwx1rvp153MPO51XvhhzH
         /36Qw0EYHZA7Xq4RbKxGug13iiFFYQF7RuPeCrKs7yWmXzU+pOjxPK4lZOzBGyQaArks
         6OioA1Rf9WQLmT9ztgFqSZta7wJVgiaXrBsMMqOPGaG2z08zKRQz38vXkO+IPkXbeG92
         5zaTbTwz3sAvpz1RH5LrIwWu0c7d50ytoq4/dxjCHyRYo61wzBpn8C9tkTNAmJFvxE46
         HcLIN34vjVkc5Akgqn3XHUKjdVf0oSYZZ0RTbzQO/OcbOmM84AoZRpfA0p+vprz1/gST
         mb0g==
X-Gm-Message-State: ACgBeo1yKJ3fPAx+LlPms6KDFpnHQoWeeaF5zelv7EycArBCIgAzSzFb
        YRvIo8kFGpeODKbvUdkyvFiFPw==
X-Google-Smtp-Source: AA6agR7lWkpWZIi5bIEym5Qu4vx/h9f4HQXzOy/VgIM2LgtlZz93g9irL0WAuwvzH65xnDqgHu1sfw==
X-Received: by 2002:a5d:69c5:0:b0:226:e04f:eb2c with SMTP id s5-20020a5d69c5000000b00226e04feb2cmr2813035wrw.523.1661866626547;
        Tue, 30 Aug 2022 06:37:06 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id b17-20020adfde11000000b0021eaf4138aesm11283959wrm.108.2022.08.30.06.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 06:37:05 -0700 (PDT)
Message-ID: <ddae21bf-a51b-7266-60ba-8a10c293888a@linaro.org>
Date:   Tue, 30 Aug 2022 14:37:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 07/14] nvmem: core: add per-cell post processing
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-8-michael@walle.cc>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220825214423.903672-8-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/08/2022 22:44, Michael Walle wrote:
> Instead of relying on the name the consumer is using for the cell, like
> it is done for the nvmem .cell_post_process configuration parameter,
> provide a per-cell post processing hook. This can then be populated by
> the NVMEM provider (or the NVMEM layout) when adding the cell.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   drivers/nvmem/core.c           | 16 ++++++++++++++++
>   include/linux/nvmem-consumer.h |  5 +++++
>   2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index 5357fc378700..cbfbe6264e6c 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -52,6 +52,7 @@ struct nvmem_cell_entry {
>   	int			bytes;
>   	int			bit_offset;
>   	int			nbits;
> +	nvmem_cell_post_process_t post_process;


two post_processing callbacks for cells is confusing tbh, we could 
totally move to use of cell->post_process.

one idea is to point cell->post_process to nvmem->cell_post_process 
during cell creation time which should clean this up a bit.

Other option is to move to using layouts for every thing.

prefixing post_process with read should also make it explicit that this 
callback is very specific to reads only.


>   	struct device_node	*np;
>   	struct nvmem_device	*nvmem;
>   	struct list_head	node;
> @@ -468,6 +469,7 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
>   	cell->offset = info->offset;
>   	cell->bytes = info->bytes;
>   	cell->name = info->name;
> +	cell->post_process = info->post_process;
>   
>   	cell->bit_offset = info->bit_offset;
>   	cell->nbits = info->nbits;
> @@ -1500,6 +1502,13 @@ static int __nvmem_cell_read(struct nvmem_device *nvmem,
>   	if (cell->bit_offset || cell->nbits)
>   		nvmem_shift_read_buffer_in_place(cell, buf);
>   
> +	if (cell->post_process) {
> +		rc = cell->post_process(nvmem->priv, id, index,
> +					cell->offset, buf, cell->bytes);
> +		if (rc)
> +			return rc;
> +	}
> +
>   	if (nvmem->cell_post_process) {
>   		rc = nvmem->cell_post_process(nvmem->priv, id, index,
>   					      cell->offset, buf, cell->bytes);
> @@ -1608,6 +1617,13 @@ static int __nvmem_cell_entry_write(struct nvmem_cell_entry *cell, void *buf, si
>   	    (cell->bit_offset == 0 && len != cell->bytes))
>   		return -EINVAL;
>   
> +	/*
> +	 * Any cells which have a post_process hook are read-only because we
> +	 * cannot reverse the operation and it might affect other cells, too.
> +	 */
> +	if (cell->post_process)
> +		return -EINVAL;

Post process was always implicitly for reads only, this check should 
also tie the loose ends of cell_post_processing callback.


--srini
> +
>   	if (cell->bit_offset || cell->nbits) {
>   		buf = nvmem_cell_prepare_write_buffer(cell, buf, len);
>   		if (IS_ERR(buf))
> diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
> index 980f9c9ac0bc..761b8ef78adc 100644
> --- a/include/linux/nvmem-consumer.h
> +++ b/include/linux/nvmem-consumer.h
> @@ -19,6 +19,10 @@ struct device_node;
>   struct nvmem_cell;
>   struct nvmem_device;
>   
> +/* duplicated from nvmem-provider.h */
> +typedef int (*nvmem_cell_post_process_t)(void *priv, const char *id, int index,
> +					 unsigned int offset, void *buf, size_t bytes);
> +
>   struct nvmem_cell_info {
>   	const char		*name;
>   	unsigned int		offset;
> @@ -26,6 +30,7 @@ struct nvmem_cell_info {
>   	unsigned int		bit_offset;
>   	unsigned int		nbits;
>   	struct device_node	*np;
> +	nvmem_cell_post_process_t post_process;
>   };
>   
>   /**
