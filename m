Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA23A209D2
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 16:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfEPOc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 10:32:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32897 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfEPOcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 10:32:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id z28so1965344pfk.0;
        Thu, 16 May 2019 07:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XzcXovfk6M1ai4anrssUPYvlW9XMFBcxcOHWl/n19fA=;
        b=mpBn4/QyUX+VBAJzrHdoOr4Ad0i8Vtss/xr/1aGBYMSMYRM38x690fr4c49BWISrCR
         x1C0XvYrLp94EcjPAL7UdrifA5iGEK/8z5Eo6ILMmgHz+G7RDSRW9kST0+80tOPLXPHM
         RHfp7btATaGqhESrp6jpJ+6hJZQcwFnKuQAMmdez4LKsMZbRAE+iZXkKJ0NfBhXrlNGc
         6g+4jAgAMDbSrfFFVemOgSzaWWW7D7jwW+J9PUqk1gYzVTJg2+0PZzYPQEQ8Te7+hZ0I
         7VjNkNrJZ7kOKxSSo4JBD5d2Uw//x5evUgme/5HUUsgKd/xxuZtDnGiTqgmC5+t733dE
         7DZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XzcXovfk6M1ai4anrssUPYvlW9XMFBcxcOHWl/n19fA=;
        b=sJBvDs/GmcgOTdF4PAQbds2YGc7naxY0oYsFydSQlpnQwtTX5C/iPCMsKhl7LLcrSd
         stnaHS7ld4xqdORJV4vkza7JVPg+h+wtP6tlANjkGqVE9bjVKZ8VTN0CHP2NzWKo24Pt
         J7q1hTHKZyzQIrX5v2Hgeb1LJcX71DUU2iGWX5AfYJYJIPC6n269sYdaLw9aGCfNYuf9
         xO7+3pCIQxzOGXH4jfsJil+akQ7pZDAFfP9q1zdUtrjkHWAQVo6g4jYzIalg7fS1Z5jI
         5C5KmTRiPtJwJGCpslesqzgX73HwXM3QZfQpKqq+PjBEU+wmcLsEAzOf+f5IR9lsF0mp
         8NPA==
X-Gm-Message-State: APjAAAU24A0ysVAxRB1lQcFA6FsGDkP/7uffSa9LhcASPKbelyCeKMza
        h7/WKVZeshYrOoWGVtEqeAI=
X-Google-Smtp-Source: APXvYqzCXMn1ygqP4NyyZ/WRS34wxQXP4/PQuk+YoCmahtN9410BzLInVWqebP+iI0+rdPUeeWVPVw==
X-Received: by 2002:aa7:87c3:: with SMTP id i3mr53019103pfo.85.1558017175090;
        Thu, 16 May 2019 07:32:55 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id s198sm8312079pfs.34.2019.05.16.07.32.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 May 2019 07:32:54 -0700 (PDT)
Date:   Thu, 16 May 2019 07:32:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] enetc: add hardware timestamping support
Message-ID: <20190516143251.akbt3ns6ue2jrhl5@localhost>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516100028.48256-2-yangbo.lu@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 09:59:08AM +0000, Y.b. Lu wrote:

> +config FSL_ENETC_HW_TIMESTAMPING
> +	bool "ENETC hardware timestamping support"
> +	depends on FSL_ENETC || FSL_ENETC_VF
> +	help
> +	  Enable hardware timestamping support on the Ethernet packets
> +	  using the SO_TIMESTAMPING API. Because the RX BD ring dynamic
> +	  allocation hasn't been supported and it's too expensive to use

s/it's/it is/

> +	  extended RX BDs if timestamping isn't used, the option was used
> +	  to control hardware timestamping/extended RX BDs to be enabled
> +	  or not.

..., this option enables extended RX BDs in order to support hardware
timestamping.

>  static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
>  {
>  	struct net_device *ndev = tx_ring->ndev;
> +	struct enetc_ndev_priv *priv = netdev_priv(ndev);
>  	int tx_frm_cnt = 0, tx_byte_cnt = 0;
>  	struct enetc_tx_swbd *tx_swbd;
> +	union enetc_tx_bd *txbd;
> +	bool do_tstamp;
>  	int i, bds_to_clean;
> +	u64 tstamp = 0;

Please keep in reverse Christmas tree order as much as possible:

	union enetc_tx_bd *txbd;
	int i, bds_to_clean;
	bool do_tstamp;
	u64 tstamp = 0;
  
>  	i = tx_ring->next_to_clean;
>  	tx_swbd = &tx_ring->tx_swbd[i];
>  	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
>  
> +	do_tstamp = false;
> +
>  	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
>  		bool is_eof = !!tx_swbd->skb;
>  
> +		if (unlikely(tx_swbd->check_wb)) {
> +			txbd = ENETC_TXBD(*tx_ring, i);
> +
> +			if (!(txbd->flags & ENETC_TXBD_FLAGS_W))
> +				goto no_wb;
> +
> +			if (tx_swbd->do_tstamp) {
> +				enetc_get_tx_tstamp(&priv->si->hw, txbd,
> +						    &tstamp);
> +				do_tstamp = true;
> +			}
> +		}
> +no_wb:

This goto seems strange and unnecessary.  How about this instead?

			if (txbd->flags & ENETC_TXBD_FLAGS_W &&
			    tx_swbd->do_tstamp) {
				enetc_get_tx_tstamp(&priv->si->hw, txbd, &tstamp);
				do_tstamp = true;
			}

>  		enetc_unmap_tx_buff(tx_ring, tx_swbd);
>  		if (is_eof) {
> +			if (unlikely(do_tstamp)) {
> +				enetc_tstamp_tx(tx_swbd->skb, tstamp);
> +				do_tstamp = false;
> +			}
>  			napi_consume_skb(tx_swbd->skb, napi_budget);
>  			tx_swbd->skb = NULL;
>  		}
> @@ -167,6 +169,11 @@ struct enetc_cls_rule {
>  
>  #define ENETC_MAX_BDR_INT	2 /* fixed to max # of available cpus */
>  
> +enum enetc_hw_features {

This is a poor choice of name.  It sounds like it describes HW
capabilities, but you use it to track whether a feature is requested
at run time.

> +	ENETC_F_RX_TSTAMP	= BIT(0),
> +	ENETC_F_TX_TSTAMP	= BIT(1),
> +};
> +
>  struct enetc_ndev_priv {
>  	struct net_device *ndev;
>  	struct device *dev; /* dma-mapping device */
> @@ -178,6 +185,7 @@ struct enetc_ndev_priv {
>  	u16 rx_bd_count, tx_bd_count;
>  
>  	u16 msg_enable;
> +	int hw_features;

This is also poorly named.  How about "tstamp_request" instead?

>  
>  	struct enetc_bdr *tx_ring[16];
>  	struct enetc_bdr *rx_ring[16];

Thanks,
Richard
