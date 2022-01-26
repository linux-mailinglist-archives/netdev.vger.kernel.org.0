Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010DA49C25B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiAZD5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbiAZD5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:57:14 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB8EC06161C;
        Tue, 25 Jan 2022 19:57:14 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id w190so15391468pfw.7;
        Tue, 25 Jan 2022 19:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=YV1zTxzK/cL80YKh5C7Q+2qU/mN/EUwAAXT6OGx6VQc=;
        b=IMl1VzH/GwBMc+2r/CP5K7NMsuoyzlpL8Yozj1pJypKFAfUGkv6VVeoxF8t3I/433t
         ATP5/a/gURAVJ1+v35RAAD+iUSVcnpiFXDOR1SNqptMLBIELCD3RNsC5jfDICGdGc8TT
         IZ+RjMGDFiqWCtSitgY7wQJUccRTdCceJIiSTsioSM6bK+yxKaPvKhFqBUJ8r6l2mBC3
         sCA7lbc1sXjBJ6RePqMZ6H7daMbnZh7Cg1MxBHbmMIxaroJb/SXTjAAGjphSuxvnPjdC
         +Sn0v089fmaO4C1xqCWcp+ZrOug+NOk9zET7dPPu65QUWIxw+yUyroZ86HFrJ9UGpw0q
         UIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YV1zTxzK/cL80YKh5C7Q+2qU/mN/EUwAAXT6OGx6VQc=;
        b=V4NTRcHi1Suy2/XO5Ytoe7G0CEjikfb5hxiwHREtB2rvkW9SlG/63YQuQwlzivmqWh
         0CoB/YIurZMevWtgD/auJ6JEuh0oSrmjZmaalMFpA8hU8K1SmyDLAF69l2AbcLEEuBuR
         zKNf3Nnu6NQg4qLjmI5HcC48GPhV7kW5lgh9BwpvyqoOGrPTnSa8RWA6q6b5IdgY0eGA
         xj7dz0CjE2ogF9h6ITDNR1zPLrD0WecXqu8jcR+lYV7pR7ANYy6ELq4UtXn+C7/tvdh9
         Bmiw3zkkL1e3QM+RNcuUDcicb4kiEZ19tJFs32MPbRqJa0LjKQqmb0LVDS4l5aYKqzFY
         w/Hw==
X-Gm-Message-State: AOAM533RQyaXFQZ/Bwl4GJPAbUV2/Ub2Iw4V2dmRWF7tmlLRt/m0z39T
        ZgO6DhKA2i4sky5EOzm25y8=
X-Google-Smtp-Source: ABdhPJxoMcbeHTERBg3AEQZqz2BnaL3IosjmeGG9n3aZMtsZ4opUmRFfem7PHjxh2QYk5jQxnFVdmw==
X-Received: by 2002:a63:6b85:: with SMTP id g127mr17257525pgc.409.1643169433963;
        Tue, 25 Jan 2022 19:57:13 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y42sm482786pfa.5.2022.01.25.19.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:57:13 -0800 (PST)
Message-ID: <b5d362d1-3b08-73bf-d8ac-712cfe953569@gmail.com>
Date:   Tue, 25 Jan 2022 19:57:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling
 mgmt Ethernet packet
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-7-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Add all the required define to prepare support for mgmt read/write in
> Ethernet packet. Any packet of this type has to be dropped as the only
> use of these special packet is receive ack for an mgmt write request or
> receive data for an mgmt read request.
> A struct is used that emulates the Ethernet header but is used for a
> different purpose.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   include/linux/dsa/tag_qca.h | 44 +++++++++++++++++++++++++++++++++++++
>   net/dsa/tag_qca.c           | 13 ++++++++---
>   2 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index c02d2d39ff4a..1a02f695f3a3 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -12,10 +12,54 @@
>   #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
>   #define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
>   
> +/* Packet type for recv */
> +#define QCA_HDR_RECV_TYPE_NORMAL	0x0
> +#define QCA_HDR_RECV_TYPE_MIB		0x1
> +#define QCA_HDR_RECV_TYPE_RW_REG_ACK	0x2
> +
>   #define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
>   #define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
>   #define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
>   #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
>   #define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
>   
> +/* Packet type for xmit */
> +#define QCA_HDR_XMIT_TYPE_NORMAL	0x0
> +#define QCA_HDR_XMIT_TYPE_RW_REG	0x1
> +
> +/* Check code for a valid mgmt packet. Switch will ignore the packet
> + * with this wrong.
> + */
> +#define QCA_HDR_MGMT_CHECK_CODE_VAL	0x5
> +
> +/* Specific define for in-band MDIO read/write with Ethernet packet */
> +#define QCA_HDR_MGMT_SEQ_LEN		4 /* 4 byte for the seq */
> +#define QCA_HDR_MGMT_COMMAND_LEN	4 /* 4 byte for the command */
> +#define QCA_HDR_MGMT_DATA1_LEN		4 /* First 4 byte for the mdio data */
> +#define QCA_HDR_MGMT_HEADER_LEN		(QCA_HDR_MGMT_SEQ_LEN + \
> +					QCA_HDR_MGMT_COMMAND_LEN + \
> +					QCA_HDR_MGMT_DATA1_LEN)
> +
> +#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
> +#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
> +
> +#define QCA_HDR_MGMT_PKG_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
> +					QCA_HDR_LEN + \
> +					QCA_HDR_MGMT_DATA2_LEN + \
> +					QCA_HDR_MGMT_PADDING_LEN)
> +
> +#define QCA_HDR_MGMT_SEQ_NUM		GENMASK(31, 0)  /* 63, 32 */
> +#define QCA_HDR_MGMT_CHECK_CODE		GENMASK(31, 29) /* 31, 29 */
> +#define QCA_HDR_MGMT_CMD		BIT(28)		/* 28 */
> +#define QCA_HDR_MGMT_LENGTH		GENMASK(23, 20) /* 23, 20 */
> +#define QCA_HDR_MGMT_ADDR		GENMASK(18, 0)  /* 18, 0 */
> +
> +/* Special struct emulating a Ethernet header */
> +struct mgmt_ethhdr {
> +	u32 command;		/* command bit 31:0 */
> +	u32 seq;		/* seq 63:32 */
> +	u32 mdio_data;		/* first 4byte mdio */
> +	__be16 hdr;		/* qca hdr */
> +} __packed;
> +
>   #endif /* __TAG_QCA_H */
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index f8df49d5956f..c57d6e1a0c0c 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -32,10 +32,10 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>   
>   static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>   {
> -	u8 ver;
> -	u16  hdr;
> -	int port;
> +	u16 hdr, pk_type;

Should pk_type be u8 since there are only 5 bits for QCA_HDR_RECV_TYPE?

With Vladimir's comments addressed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
