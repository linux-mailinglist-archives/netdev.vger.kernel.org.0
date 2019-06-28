Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C445A335
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfF1SLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:11:00 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45704 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1SLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:11:00 -0400
Received: by mail-pl1-f193.google.com with SMTP id bi6so3655823plb.12
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TVAz0K2pmzIeq8tmlA4T8qwEl3Ul9n421YJu9kH1K5Y=;
        b=PPbtigmNkSIbfvyRcbMGBPtTmzaBF13wOtBrwskVQRtoNxdlm1NZecKQwU0YaJ+7zX
         JYiunWffg9H+qHWtbvI3NxAEk6yUAqacGrDVExbmZTUHydYSgzTxk3eLq3VAXUliZj9x
         LZ+8eSrNdB/xg2/uUlVnLMOaA/9oBEsWmOr9oDfawVA9w1aV9KsvZzzTh2mkC9nF0rpP
         zn9ygkCSD1XlxuyJVHWrHRf2nysqFICg3gLi2Ih1JsbgnVAiTb8fSVqXOc6oSlmc17kD
         ZiRRNzTo68JjfcNlCMa/B7omiHIkWjxCOxgSWPlm2RTeJqEcRdPMQpQUyoy2qIojGjed
         o/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TVAz0K2pmzIeq8tmlA4T8qwEl3Ul9n421YJu9kH1K5Y=;
        b=Vc0YukQK86LrZwfQ1+4Wu1a3edYJaOA8Vqjh+jufBxGhRDP71STo9fcCGjJH7P9oWm
         EUmbClI7y605TV5cFbdQAz08XZy6XeSR29NMjII7/6yWOYwNW51gbA+6dWxhOZsfzPEP
         edgC2I/sNb4wbKh0hw970ofl4Xsgj0+lFss1C4e9VF0NK1FZpZJNgpduYXo7f0iiIaof
         E7TdqFLUKg+SXGwPYECjM4mksELMrg3fKnaCRcWTQGGNtzmZRix071O2jjdnAsxotgFd
         8eyOZPB2800CgrDw4/YRTARplZ0edqxJOfu+a+efkpdc2YNBuBaduUS4Az3ojvgwlkbc
         N5rA==
X-Gm-Message-State: APjAAAXrqeh0iuHmaoCnTDrDMi8au4ydrG14vtq233METYD0O1FAm79U
        rkmpZujTPpe2wQ7OIp/Sj6W8CQ==
X-Google-Smtp-Source: APXvYqxQKhFc+JkJDYTRBsEuPNUaNvzKZGoB4oFbLgsZmzxIlgoLDdNDLj5QV8FEGIA9CN1wtwve1A==
X-Received: by 2002:a17:902:9f93:: with SMTP id g19mr12948032plq.223.1561745459351;
        Fri, 28 Jun 2019 11:10:59 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v184sm3712583pfb.82.2019.06.28.11.10.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:10:59 -0700 (PDT)
Date:   Fri, 28 Jun 2019 11:10:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: Re: [PATCH net-next v2 4/4] gve: Add ethtool support
Message-ID: <20190628111052.26b7c0e2@hermes.lan>
In-Reply-To: <20190628175633.143501-5-csully@google.com>
References: <20190628175633.143501-1-csully@google.com>
        <20190628175633.143501-5-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 10:56:33 -0700
Catherine Sullivan <csully@google.com> wrote:

> +static void
> +gve_get_ethtool_stats(struct net_device *netdev,
> +		      struct ethtool_stats *stats, u64 *data)
> +{
> +	struct gve_priv *priv = netdev_priv(netdev);
> +	u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
> +	int ring;
> +	int i;
> +
> +	ASSERT_RTNL();
> +
> +	for (rx_pkts = 0, rx_bytes = 0, ring = 0;
> +	     ring < priv->rx_cfg.num_queues; ring++) {
> +		if (priv->rx) {
> +			rx_pkts += priv->rx[ring].rpackets;
> +			rx_bytes += priv->rx[ring].rbytes;
> +		}
> +	}
> +	for (tx_pkts = 0, tx_bytes = 0, ring = 0;
> +	     ring < priv->tx_cfg.num_queues; ring++) {
> +		if (priv->tx) {
> +			tx_pkts += priv->tx[ring].pkt_done;
> +			tx_bytes += priv->tx[ring].bytes_done;
> +		}
> +	}
> +	memset(data, 0, GVE_MAIN_STATS_LEN * sizeof(*data));

memset here is unnecessary since ethtool_get_stats allocates
and zeros the memory already.
