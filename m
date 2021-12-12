Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C7F471832
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 05:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhLLEMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 23:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhLLEMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 23:12:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24986C061714;
        Sat, 11 Dec 2021 20:12:54 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id x7so9580382pjn.0;
        Sat, 11 Dec 2021 20:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=iLKE4nl9vXA5y2N9rP0xI834Q5UXzM8Oml3susVm0zs=;
        b=b4KIyJ4wFPJL7zQFqD+U4+oYFbty/Org/jgRm2ETBGC0MS6d1/JTeuKBh6uoV5sp+N
         XSHPyX/U7Uwtpz4nSTDiJS+JZZS5Qb6YRmtxQw+oJ5xVnevmlybzO6y0SIKIb/De3YuJ
         eb7ctIAAH+FfLxQg0ZL84SzXr5Z18ERRa246Fw6r7yP7VJqoJeyj6ox1QpdrMjyybpDo
         UYniU0rtztsxovRL8YwNav0sVYlbcUH9BuKweu2uG4NxKsec5xIEos4Z00Fd91rQFb+3
         javGqkiEIxAdAm3Bf6NQmRBpNSA07H6RpTOLF7Wv+FIBfOz3uXxtzvJj82cPq0MDWAom
         VvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iLKE4nl9vXA5y2N9rP0xI834Q5UXzM8Oml3susVm0zs=;
        b=HxMzsBIrwxu3vLWKW+BWw5lO22TLs9nBA/qOmaXymlsIyKg8dWJUkoBE15ivJqnu9y
         vHUiy6bgtac2TcfblEaV4X0gy4apFFhDLLmWFbytXYNX7+F3InapoPRp0FfX8L2SXvZS
         6W34mkHmjHxTnvElC7Jr2cYyIROi4mDunB7QoOmspkFWOdt5yFJPyVw5L3/g+CwdY6y+
         Cu6WkjhdvSbEHzo9LSJZEXJqQMnfcOO4ot4ZcAA/DzAGzIyy3hX0ENVxEWRTEGdXx9pW
         wU8RIRYIzG0V4a4G+P897XirmRTPX6Y06sxX56eRZ8CbHp7Cq9ino7zfNBFz2HkcJdRU
         fcFw==
X-Gm-Message-State: AOAM533Elm5qEaMshTqTGz3aNWKbpd0I8prQWvpfvEUGOA6rQxnQX2Ly
        dyj4XgcULV5cJhXLCnBKkFY=
X-Google-Smtp-Source: ABdhPJwacd6V6auTrviLBQGY+c/H6yTGfxm3SX2LVC7btLkcWeDDbsbCsFeuNCQ5FXqVYOPSPs/xGg==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr87096597plg.47.1639282373371;
        Sat, 11 Dec 2021 20:12:53 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4964:df1f:902d:8530? ([2600:8802:b00:4a48:4964:df1f:902d:8530])
        by smtp.gmail.com with ESMTPSA id b16sm6381047pgi.36.2021.12.11.20.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 20:12:52 -0800 (PST)
Message-ID: <1776b726-6a96-d522-e625-f0f6b108782a@gmail.com>
Date:   Sat, 11 Dec 2021 20:12:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [net-next RFC PATCH v4 12/15] net: dsa: qca8k: add support for
 mdio read/write in Ethernet packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-13-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211211195758.28962-13-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> Add qca8k side support for mdio read/write in Ethernet packet.
> qca8k supports some specially crafted Ethernet packet that can be used
> for mdio read/write instead of the legacy method uart/internal mdio.
> This add support for the qca8k side to craft the packet and enqueue it.
> Each port and the qca8k_priv have a special struct to put data in it.
> The completion API is used to wait for the packet to be received back
> with the requested data.
> 
> The various steps are:
> 1. Craft the special packet with the qca hdr set to mdio read/write
>     mode.
> 2. Set the lock in the dedicated mdio struct.
> 3. Reinit the completion.
> 4. Enqueue the packet.
> 5. Wait the packet to be received.
> 6. Use the data set by the tagger to complete the mdio operation.
> 
> If the completion timeouts or the ack value is not true, the legacy
> mdio way is used.
> 
> It has to be considered that in the initial setup mdio is still used and
> mdio is still used until DSA is ready to accept and tag packet.
> 
> tag_proto_connect() is used to fill the required handler for the tagger
> to correctly parse and elaborate the special Ethernet mdio packet.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

[snip]

> +
> +static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> +					       int seq_num)
> +{
> +	struct mdio_ethhdr *mdio_ethhdr;
> +	struct sk_buff *skb;
> +	u16 hdr;
> +
> +	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);

No out of memory condition handling?

> +
> +	prefetchw(skb->data);

What's the point you are going to dirty the cache lines right below with 
your skb_push().

> +
> +	skb_reset_mac_header(skb);
> +	skb_set_network_header(skb, skb->len);
> +
> +	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
> +
> +	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
> +	hdr |= QCA_HDR_XMIT_FROM_CPU;
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
> +
> +	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, seq_num);
> +
> +	mdio_ethhdr->command = FIELD_PREP(QCA_HDR_MDIO_ADDR, reg);
> +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_LENGTH, 4);
> +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CMD, cmd);
> +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CHECK_CODE, MDIO_CHECK_CODE_VAL);
> +
> +	if (cmd == MDIO_WRITE)
> +		mdio_ethhdr->mdio_data = *val;
> +
> +	mdio_ethhdr->hdr = htons(hdr);
> +
> +	skb_put_zero(skb, QCA_HDR_MDIO_DATA2_LEN);
> +	skb_put_zero(skb, QCA_HDR_MDIO_PADDING_LEN);
> +
> +	return skb;
> +}
> +
> +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> +{
> +	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200);
> +	skb->dev = dsa_to_port(priv->ds, 0)->master;

Surely you should be checking that this is the CPU port and obtain it 
from DSA instead of hard coding it to 0.

> +
> +	mutex_lock(&mdio_hdr_data->mutex);
> +
> +	reinit_completion(&mdio_hdr_data->rw_done);
> +	mdio_hdr_data->seq = 200;
> +	mdio_hdr_data->ack = false;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);

msec_to_jiffies(QCA8K_ETHERNET_TIMEOUT) at least?
-- 
Florian
