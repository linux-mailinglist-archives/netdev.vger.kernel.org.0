Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3ED49C24B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbiAZDsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiAZDsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:48:30 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15F3C06161C;
        Tue, 25 Jan 2022 19:48:30 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 133so20075489pgb.0;
        Tue, 25 Jan 2022 19:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=TvmsIKFhwG0Oxyte7zJT1aBGrLC1c5skK284g7Q3daI=;
        b=Ev0o1x/1EkrVhcSo80n1SERy2Dn5NsKkxRzHyyuNlSaAebKgPqXnudDHdzVflaNH8c
         GwLwvmJsm/7uieaBRsogDoBUACO+k2AMGOZWFTk+eYDKKqQZoDHC8XoLu4D/2uqos5xa
         SP6nGOvoi0BzD/cgbyizZvtq7q65R+k371b3t3yEEYGDUFWZwaA5Hx5Pqc9B6eLONE0o
         0DsGEPND0UvblhbsfSOochESVCbX5YRv8VLVyk40SyCtLrvKZSiVZqnwM2jM/qc0RdZM
         ivVOYQ4bZdzNtn4dChPeuvblBfMVqXKRtc8bvFNkPJcq+lkTdmTe2h3p+jiT1IdYTYm1
         re5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TvmsIKFhwG0Oxyte7zJT1aBGrLC1c5skK284g7Q3daI=;
        b=CgF02cQKS6QQkcSFY7Ku404M8l/jjaaDLlJWdoGRo02/kA2HBbkGVOaKJN5Kz1JZhe
         U7tl83gq6Fb1iVKJV+En1BNxlzQe8h5bd9r6TaEzjutG4IJLD1TfQMF+7zcrdSJqY1bq
         ylLLe0YogZgwo4zsryGVbXPfQxIWn2Ljk4E9Y0k1KVfd+f2pTv7H7eh/oFT3yhctrNR/
         RH/1TjusA0aBtN51JUZqOuKGj7uNorcdHNClHDAkMPrdLDoxIXqSL9GNsvUnJuzZs3Tu
         wwFW4gWpuhh4M+dAyVMoOFcF338uNrNbnMblmesHY5RjM2fr2MIbU6c7qkoXKQz2jiUS
         rU1g==
X-Gm-Message-State: AOAM533ZTSFcm7HAm4IlW8xHt9wzP6ireUl8eFFbOzA+MGpW5OyWmqFF
        WQ9mPPwvnsWQKuWwWP09t4loCR7Ux5Q=
X-Google-Smtp-Source: ABdhPJyZyJ1ajvdIrJmp2Uz06Xxt+gM6mRf3OWZHPrG74YybUmh6XkruG/YgnggxXF5m3eEReoefhQ==
X-Received: by 2002:a63:82c7:: with SMTP id w190mr1289844pgd.612.1643168910118;
        Tue, 25 Jan 2022 19:48:30 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f9sm15590479pgf.94.2022.01.25.19.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:48:29 -0800 (PST)
Message-ID: <ce5891d1-d0ae-ba59-65ad-3ece92496c86@gmail.com>
Date:   Tue, 25 Jan 2022 19:48:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 15/16] net: da: qca8k: add support for larger
 read/write size with mgmt Ethernet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-16-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-16-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> mgmt Ethernet packet can read/write up to 16byte at times. The len reg
> is limited to 15 (0xf). The switch actually sends and accepts data in 4
> different steps of len values.
> Len steps:
> - 0: nothing
> - 1-4: first 4 byte
> - 5-6: first 12 byte
> - 7-15: all 16 byte

This is really odd, it almost felt like the length was a byte enable 
bitmask, but it is not?

> 
> In the allock skb function we check if the len is 16 and we fix it to a
> len of 15.

s/allock/alloc/

> It the read/write function interest to extract the real asked
> data. The tagger handler will always copy the fully 16byte with a READ
> command. This is useful for some big regs like the fdb reg that are
> more than 4byte of data. This permits to introduce a bulk function that
> will send and request the entire entry in one go.
> Write function is changed and it does now require to pass the pointer to
> val to also handle array val.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 56 ++++++++++++++++++++++++++++++-----------
>   1 file changed, 41 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 2a43fb9aeef2..0183ce2d5b74 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -219,7 +219,9 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
>   	if (cmd == MDIO_READ) {
>   		mgmt_hdr_data->data[0] = mgmt_ethhdr->mdio_data;
>   
> -		/* Get the rest of the 12 byte of data */
> +		/* Get the rest of the 12 byte of data.
> +		 * The read/write function will extract the requested data.
> +		 */
>   		if (len > QCA_HDR_MGMT_DATA1_LEN)
>   			memcpy(mgmt_hdr_data->data + 1, skb->data,
>   			       QCA_HDR_MGMT_DATA2_LEN);
> @@ -229,16 +231,30 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
>   }
>   
>   static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> -					       int seq_num, int priority)
> +					       int seq_num, int priority, int len)

unsigned int len

>   {
>   	struct mgmt_ethhdr *mgmt_ethhdr;
>   	struct sk_buff *skb;
> +	int real_len;

Likewise.

> +	u32 *data2;
>   	u16 hdr;
>   
>   	skb = dev_alloc_skb(QCA_HDR_MGMT_PKG_LEN);
>   	if (!skb)
>   		return NULL;
>   
> +	/* Max value for len reg is 15 (0xf) but the switch actually return 16 byte
> +	 * Actually for some reason the steps are:
> +	 * 0: nothing
> +	 * 1-4: first 4 byte
> +	 * 5-6: first 12 byte
> +	 * 7-15: all 16 byte
> +	 */
> +	if (len == 16)
> +		real_len = 15;
> +	else
> +		real_len = len;
> +
>   	skb_reset_mac_header(skb);
>   	skb_set_network_header(skb, skb->len);
>   
> @@ -253,7 +269,7 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
>   	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
>   
>   	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
> -	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
> +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
>   	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
>   	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
>   					   QCA_HDR_MGMT_CHECK_CODE_VAL);
> @@ -263,19 +279,22 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
>   
>   	mgmt_ethhdr->hdr = htons(hdr);
>   
> -	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
> +	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
> +	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
> +		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
>   
>   	return skb;
>   }
>   
> -static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>   {
>   	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
>   	struct sk_buff *skb;
>   	bool ack;
>   	int ret;
>   
> -	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200,
> +				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
>   	if (!skb)
>   		return -ENOMEM;
>   
> @@ -297,6 +316,9 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
>   					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
>   
>   	*val = mgmt_hdr_data->data[0];
> +	if (len > QCA_HDR_MGMT_DATA1_LEN)
> +		memcpy(val + 1, mgmt_hdr_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
> +
>   	ack = mgmt_hdr_data->ack;
>   
>   	mutex_unlock(&mgmt_hdr_data->mutex);
> @@ -310,14 +332,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
>   	return 0;
>   }
>   
> -static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
> +static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
>   {
>   	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
>   	struct sk_buff *skb;
>   	bool ack;
>   	int ret;
>   
> -	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> +	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val, 200,
> +				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
>   	if (!skb)
>   		return -ENOMEM;
>   
> @@ -357,14 +380,14 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
>   	u32 val = 0;
>   	int ret;
>   
> -	ret = qca8k_read_eth(priv, reg, &val);
> +	ret = qca8k_read_eth(priv, reg, &val, 4);

sizeof(val) instead of 4.

>   	if (ret)
>   		return ret;
>   
>   	val &= ~mask;
>   	val |= write_val;
>   
> -	return qca8k_write_eth(priv, reg, val);
> +	return qca8k_write_eth(priv, reg, &val, 4);

Likewise

>   }
>   
>   static int
> @@ -376,7 +399,7 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>   	u16 r1, r2, page;
>   	int ret;
>   
> -	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))
> +	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val, 4))

Likewise and everywhere below as well.
-- 
Florian
