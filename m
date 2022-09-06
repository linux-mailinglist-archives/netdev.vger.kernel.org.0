Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF62F5AF73A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiIFVq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiIFVq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:46:28 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD673B69FE
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:46:20 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id e28so9150405qts.1
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 14:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=QHsK7fY0BVmEigxPnYNUCQtnk8EwsrjgHkiTNFUKK3w=;
        b=I9bbnMrq/zJ33KhI5hO/x10sfdQ9ODSLDWza83wDuupcGEMbiz1PEgpPhgv1s/G3mF
         vkd3A5t+Oe7rA/fHO8xN7x3WW85OYBMv4gFh7OBEEljcculbde2diLV2zIDO0b38ZpMT
         1SJpWMDWU3rd7vlzwlv1EgJAr9wZ2UKtLbRd7yiWoOnqL3WsWOR7599Y1/FG9Ts7J5tb
         CeT/Wf//srIApFG/UVsTy24Yt1BE/RaEWHjpiBfK+A6lph8aYilpAIDtUjcFfA3o2MC8
         PVbDFkw7dGTq5h+dJi0t27aKLXjrRhXiCkXjnZruaVb4XwNqfjbUegwHCZAvVMJ2Qp4+
         gjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QHsK7fY0BVmEigxPnYNUCQtnk8EwsrjgHkiTNFUKK3w=;
        b=bWvaU0usiTve3e9u5ekRwUpqKxoqH4gZRlxgQv+ss+JPvUuhSyOg4Lvr0Ih+xezEPS
         Wy2qK6KdgFoHo2CrZpA392kTsa/Z+uTc9joiQUc9/tYVf3mZZWGQpQw3Bk8r5/03KU4Z
         hixhLBTdllxOhQ/eWnyRodri9eyQ0LRSs+0iw+joDkb/wiRF5DWws4IEjtPbOT58POyG
         ZEkM8ycMT8lVtchKcwiTYaRUlaHgth4+6sQsfQYbZzMNmtEy4epyWxpeRggPBv2g5ip+
         VA+sJt356JlEpnmpYvZ8u9ZCShGaphQC78LN52eq3ZGhGTKpcwb6HFmdZTqHprwu4+sH
         Q9aw==
X-Gm-Message-State: ACgBeo0FVePDEWh7+YZgXsxVDKqO+LVZulaRPNsmnAaqlzsrl03FKVve
        dN0WUePB1ciUEv+cMaQvK6Q=
X-Google-Smtp-Source: AA6agR5obtIL2PtVl84dL5FjS6LzKB54TCEcIDS5xGPGhqn7ZKjzWGQB3AeU1kEIfNOgJKkwIt5HXA==
X-Received: by 2002:a05:622a:1651:b0:344:5d06:7449 with SMTP id y17-20020a05622a165100b003445d067449mr618614qtj.292.1662500779830;
        Tue, 06 Sep 2022 14:46:19 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u14-20020a05622a14ce00b00341a807ed21sm2381603qtx.72.2022.09.06.14.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 14:46:19 -0700 (PDT)
Message-ID: <d0908a9e-cfe3-a178-1b40-a93b12b980da@gmail.com>
Date:   Tue, 6 Sep 2022 14:46:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next v4 1/6] net: dsa: mv88e6xxx: Add RMU enable for
 select switches.
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
 <20220906063450.3698671-2-mattias.forsblad@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220906063450.3698671-2-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2022 11:34 PM, Mattias Forsblad wrote:
> Add RMU enable functionality for some Marvell SOHO switches.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---

[snip]

> +int mv88e6085_g1_rmu_enable(struct mv88e6xxx_chip *chip, int upstream_port)
> +{
> +	int val = MV88E6352_G1_CTL2_RMU_MODE_DISABLED;
> +
> +	dev_dbg(chip->dev, "RMU: Enabling on port %d", upstream_port);

This debug print is in every chip-specific function, so maybe you can 
consider moving it to mv88e6xxx_master_change()?

> +
> +	switch (upstream_port) {
> +	case 9:
> +		val = MV88E6085_G1_CTL2_RM_ENABLE;
> +		break;
> +	case 10:
> +		val = MV88E6085_G1_CTL2_RM_ENABLE | MV88E6085_G1_CTL2_P10RM;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6085_G1_CTL2_P10RM |
> +				      MV88E6085_G1_CTL2_RM_ENABLE, val);
> +}
> +
>   int mv88e6352_g1_rmu_disable(struct mv88e6xxx_chip *chip)
>   {
>   	return mv88e6xxx_g1_ctl2_mask(chip, MV88E6352_G1_CTL2_RMU_MODE_MASK,
>   				      MV88E6352_G1_CTL2_RMU_MODE_DISABLED);
>   }
>   
> +int mv88e6352_g1_rmu_enable(struct mv88e6xxx_chip *chip, int port)

Can we name this argument upstream_port and pass it a 
dsa_switch_upstream_port() port already?
-- 
Florian
