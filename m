Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B264755A1
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbhLOJ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbhLOJ6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:58:09 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1124C061574;
        Wed, 15 Dec 2021 01:58:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y12so71784498eda.12;
        Wed, 15 Dec 2021 01:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PsVQTE3+0yARLaD49Bsg2KdbNb/Yv/hCz+fFtZL4PK0=;
        b=Yy7kggNriFF4JVYqSFub5z8NmIvDn87Ag270u5Tligws8Okh4Ra84AGa7WqiyRRcln
         qRp5wSV4IEhowM+rBr60B8fHpYgPJUSWhhYqf68L5eBgU8aJA6HmEqmio+/zL4fxaLyc
         4hq+dELdXvrXe0v/aiVZr7PhRTeU041kjRwq+5nI+fWFWR54yI3I5NkoEdDd6VhkY0X2
         dc1b1gAlRPmLlV0GdtvjYAYPFfaxikYOrATIuAwNx3A5tffIwSmA2tcZuKW+qxLPLd2w
         MCzLL0o9oAryltduc3vwx4RKf2fppB89K7xeRHmd5S4E6XLqC5vBRsQ8ywX9JmDG5wmh
         /VnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PsVQTE3+0yARLaD49Bsg2KdbNb/Yv/hCz+fFtZL4PK0=;
        b=KEsXAc++z5knAW6Bm9pR2iewHS52Es30/vFyEFEYRGK/jXD8Fd3dpsd4RBhuLN2dA2
         yxrLtd/EszK0juUZI7aH6f0gtKeR3ATMK8+kbt4jR7nybi/XzJeUvPQZe0Rc8C2KyRL3
         twqATcCFWHD92EVfKx8GYe7DE4eJqEgXmRdJQHWyneV2cQorlDnx758i44Cg1uKVjxKC
         nb6MvN9wDf/yWGjx+ZgMTQcugyBxMLT5OFxxchYVN5Kv6O3seqZex8r1lUpfVmpLNK89
         MkCSx+Z5T/JHLq2TSJDQ4dDZ1UUNs1G0dOtbwcQL8D3pWPq1qYztuIW905hBDSo5+DJ1
         SzaA==
X-Gm-Message-State: AOAM531098PbjmcSqv9SfnpN+BNc0MXmreNbE6RD4q4Dq0nbPnDfw9cO
        VfzhmwvDiwtLW7xny1Hbfjs=
X-Google-Smtp-Source: ABdhPJw6QH7y8qOtOZIy/KY44DcPbmUWD6OBLLOJN+dqPOQZhLtblYhkEUUylaOGUdkjgm7yJ0iAOA==
X-Received: by 2002:a17:907:1c92:: with SMTP id nb18mr10164137ejc.687.1639562287271;
        Wed, 15 Dec 2021 01:58:07 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id z22sm773016edd.78.2021.12.15.01.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:58:06 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:58:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 08/16] net: dsa: tag_qca: add define for
 handling mdio Ethernet packet
Message-ID: <20211215095805.pqzh34lnpijixopv@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214224409.5770-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:44:01PM +0100, Ansuel Smith wrote:
> Add all the required define to prepare support for mdio read/write in
> Ethernet packet. Any packet of this type has to be dropped as the only
> use of these special packet is receive ack for an mdio write request or
> receive data for an mdio read request.
> A struct is used that emulates the Ethernet header but is used for a
> different purpose.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  include/linux/dsa/tag_qca.h | 41 +++++++++++++++++++++++++++++++++++++
>  net/dsa/tag_qca.c           | 13 +++++++++---
>  2 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index c02d2d39ff4a..21cd0db5acc2 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -12,10 +12,51 @@
>  #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
>  #define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
>  
> +/* Packet type for recv */
> +#define QCA_HDR_RECV_TYPE_NORMAL	0x0
> +#define QCA_HDR_RECV_TYPE_MIB		0x1
> +#define QCA_HDR_RECV_TYPE_RW_REG_ACK	0x2
> +
>  #define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
>  #define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
>  #define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
>  #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
>  #define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
>  
> +/* Packet type for xmit */
> +#define QCA_HDR_XMIT_TYPE_NORMAL	0x0
> +#define QCA_HDR_XMIT_TYPE_RW_REG	0x1
> +
> +#define MDIO_CHECK_CODE_VAL		0x5
> +
> +/* Specific define for in-band MDIO read/write with Ethernet packet */
> +#define QCA_HDR_MDIO_SEQ_LEN		4 /* 4 byte for the seq */
> +#define QCA_HDR_MDIO_COMMAND_LEN	4 /* 4 byte for the command */
> +#define QCA_HDR_MDIO_DATA1_LEN		4 /* First 4 byte for the mdio data */
> +#define QCA_HDR_MDIO_HEADER_LEN		(QCA_HDR_MDIO_SEQ_LEN + \
> +					QCA_HDR_MDIO_COMMAND_LEN + \
> +					QCA_HDR_MDIO_DATA1_LEN)
> +
> +#define QCA_HDR_MDIO_DATA2_LEN		12 /* Other 12 byte for the mdio data */
> +#define QCA_HDR_MDIO_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
> +
> +#define QCA_HDR_MDIO_PKG_LEN		(QCA_HDR_MDIO_HEADER_LEN + \
> +					QCA_HDR_LEN + \
> +					QCA_HDR_MDIO_DATA2_LEN + \
> +					QCA_HDR_MDIO_PADDING_LEN)
> +
> +#define QCA_HDR_MDIO_SEQ_NUM		GENMASK(31, 0)  /* 63, 32 */
> +#define QCA_HDR_MDIO_CHECK_CODE		GENMASK(31, 29) /* 31, 29 */
> +#define QCA_HDR_MDIO_CMD		BIT(28)		/* 28 */
> +#define QCA_HDR_MDIO_LENGTH		GENMASK(23, 20) /* 23, 20 */
> +#define QCA_HDR_MDIO_ADDR		GENMASK(18, 0)  /* 18, 0 */
> +
> +/* Special struct emulating a Ethernet header */
> +struct mdio_ethhdr {
> +	u32 command;		/* command bit 31:0 */
> +	u32 seq;		/* seq 63:32 */
> +	u32 mdio_data;		/* first 4byte mdio */
> +	__be16 hdr;		/* qca hdr */
> +} __packed;
> +
>  #endif /* __TAG_QCA_H */
> diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
> index f8df49d5956f..d30249b5205d 100644
> --- a/net/dsa/tag_qca.c
> +++ b/net/dsa/tag_qca.c
> @@ -32,10 +32,10 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  {
> -	u8 ver;
> -	u16  hdr;
> -	int port;
> +	u16  hdr, pk_type;

Why the two spaces between "u16" and "hdr"?

>  	__be16 *phdr;
> +	int port;
> +	u8 ver;
>  
>  	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
>  		return NULL;
> @@ -48,6 +48,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>  	if (unlikely(ver != QCA_HDR_VERSION))
>  		return NULL;
>  
> +	/* Get pk type */
> +	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
> +
> +	/* Ethernet MDIO read/write packet */
> +	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
> +		return NULL;
> +
>  	/* Remove QCA tag and recalculate checksum */
>  	skb_pull_rcsum(skb, QCA_HDR_LEN);
>  	dsa_strip_etype_header(skb, QCA_HDR_LEN);
> -- 
> 2.33.1
> 

