Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1CB49C23F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbiAZDpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiAZDpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:45:32 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC1EC06161C;
        Tue, 25 Jan 2022 19:45:32 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n16-20020a17090a091000b001b46196d572so4909026pjn.5;
        Tue, 25 Jan 2022 19:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Y5k1KdzrfQy9R0Q6jWDmCaI0pej0PO9iHSgKmPIfsKM=;
        b=Bj+yRGwmDRNNuGmMtHVjYiujDJxZRkJO6N00RZ8Eljf4LZlBhm0oId59uoZnMN1bR0
         0LsYHyxoy91xjHgCj2eS8il9gS9YsNZND943Swh9NL2Cw73fLUM1M0zLOZPRtJeFPPq4
         Kjc7/BCC+dEYcv3juOZ0YUXjPh5fzlO88PDlsVhEwI1SAY/uUV8Fc7+fkE9mSYPzHWv+
         PHLSdcOEkGxloWef927hU/pkf6L2gC9230uUgaNFKLSUJNwcp1jtCMcKUVKxaWPAruhQ
         vwh21SqLDdRcKryDfYWFXfmR37RqWY4gyp8g8LLtCLHTnukJWo1lsjs5Mb5nIhu8nmD8
         PEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y5k1KdzrfQy9R0Q6jWDmCaI0pej0PO9iHSgKmPIfsKM=;
        b=4veuTLVq0QDRPT00fIGAjzLOUfzH8nLm4ByqfE9K4QOZLk8RMAcqNMKmSwMKbeW6be
         1ed4ZSJyUjDFhr0O77WGzRVK72J5SW5KuW0kWlmZflfgZoIDjXcYuwIjmMlYA3K6Ur4q
         tEw1hRPbqWki34qAvBnBySDZVwKBZ3e9GcvoYXJn3rCgwbF1eKa8XEeHwuQ+wvLHg1sG
         OQOgIh529WI4n0+HeC5ZIaGPO1As6qM9oNijuRFQeySMjAf24VCAfV5KXcorg2OJz/eQ
         xyAOSKNXTf8G/db5OLw3u2HkkyLS2cbBKynV3U27lZuOHjNYjpk2BYeEM0fF9FJBCUWS
         JNJQ==
X-Gm-Message-State: AOAM5314I6uT6mBRCSM4cNazuMuGEX8NAmhsekSgAchiHcqwhXejx3i6
        8Ua7Tz5EZf+1xUfkbbxTi+o=
X-Google-Smtp-Source: ABdhPJz//jmjNY7+r0Yayp+N6JWgYxt27idOZawyuxSlzMq3wQbdDMbIjqjrQVzNs5zsHUQJeoL+og==
X-Received: by 2002:a17:90a:56:: with SMTP id 22mr6701540pjb.199.1643168731511;
        Tue, 25 Jan 2022 19:45:31 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id on5sm1856416pjb.26.2022.01.25.19.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:45:30 -0800 (PST)
Message-ID: <e40b4f78-5ac8-80fe-7c09-127ce01dde92@gmail.com>
Date:   Tue, 25 Jan 2022 19:45:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 16/16] net: dsa: qca8k: introduce
 qca8k_bulk_read/write function
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-17-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-17-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Introduce qca8k_bulk_read/write() function to use mgmt Ethernet way to
> read/write packet in bulk. Make use of this new function in the fdb
> function.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

[snip]

>   static int
>   qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>   {
> @@ -535,17 +572,13 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
>   static int
>   qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
>   {
> -	u32 reg[4], val;
> -	int i, ret;
> +	u32 reg[4];
> +	int ret;
>   
>   	/* load the ARL table into an array */
> -	for (i = 0; i < 4; i++) {
> -		ret = qca8k_read(priv, QCA8K_REG_ATU_DATA0 + (i * 4), &val);
> -		if (ret < 0)
> -			return ret;
> -
> -		reg[i] = val;
> -	}
> +	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, 12);

sizeof(reg)? How did you come up with 12 if we were executing the loop 4 
times before or were we reading too much?

> +	if (ret)
> +		return ret;
>   
>   	/* vid - 83:72 */
>   	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
> @@ -569,7 +602,6 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
>   		u8 aging)
>   {
>   	u32 reg[3] = { 0 };
> -	int i;
>   
>   	/* vid - 83:72 */
>   	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
> @@ -586,8 +618,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
>   	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
>   
>   	/* load the array into the ARL table */
> -	for (i = 0; i < 3; i++)
> -		qca8k_write(priv, QCA8K_REG_ATU_DATA0 + (i * 4), reg[i]);
> +	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, 12);

sizeof(reg) would be more adequate here.
-- 
Florian
