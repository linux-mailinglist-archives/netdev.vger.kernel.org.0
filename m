Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3ED5A893
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 04:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF2CoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 22:44:23 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37271 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF2CoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 22:44:23 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so16607391iok.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 19:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HKuZLHM77AUJp5DOS30hCboCsBmTKWqBFJFNSQjkd5Q=;
        b=IHNFiAyaQl8eoCh04+bhXyh3kSs6ya1G3jWIdmNqv+0rmB1butGvi97pSzIDSJx3wV
         a4I1TpgsR1PAo/f4QA/jehQTSJHTko8GMoSI33+A2QgZdo0dcnl0hOMeG/NfaFWMOJc3
         6b698fTl91Rsu4i6TXJ3Qar7RL7hzfc8c0XyNKEXA3ti/r/egwzHS2N3Ga95iUq5Lm/1
         rnH0pu4citWx3RfHsukV1oPRz2BtmnyVzlnmAZfLgdv2wRpb4ig22atc1NwLawdDGI+Z
         2ahFA1m05VaOMg5o96Hd7c1OgFJhH/+Sghl2q9OFk/6DKt0s5t5eLpFyQT5ky7REzw7o
         PSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HKuZLHM77AUJp5DOS30hCboCsBmTKWqBFJFNSQjkd5Q=;
        b=eQ6dwTfYNNCB7iT2GVDlIX4iURZHhoP1V/DzQpWGGwxRzlWuMcPntaIne81lCyoWQj
         w9Er8NUckA30NNPFE7DudMPLV5m4XjxcH0kHbIH4595waALJ3j9OMbD2EkvNRk4ctLR6
         CWMmx8WNMvF4VrVIRZaFEMoJ0KWm02AyQiX+mGM3lAjOw9rgBwnzEPn+d/6nfvpujgBp
         d8MoIZBTM/Tx8OP8YVCnKbPJhMzDuXB6rOKw+jzzPYHBWPWb80Qmq5HU3pKs7XStbmq/
         cy696OHawSiqakUenGEaCPktZqY+xzCtd4vTYvu87FEHrBxregEF3D64AZwsUmmvmx4W
         li5g==
X-Gm-Message-State: APjAAAU1v/6coIHSyRStLP4vvOTR/jNExKzSm+GqGsCU29YKs3CKrat1
        Bz2iRpX0rI3pO2nSG/tnScScyhkb
X-Google-Smtp-Source: APXvYqxoVkvdj3FYnCeF9kRkw3K7E5xCYEt8NhRaiMMROGSkij6g4ovdDRiP0w0gCHvUB/X+IxcZvQ==
X-Received: by 2002:a6b:fb0f:: with SMTP id h15mr14901385iog.266.1561776262767;
        Fri, 28 Jun 2019 19:44:22 -0700 (PDT)
Received: from [10.230.27.119] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id c11sm4608590ioi.72.2019.06.28.19.44.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 19:44:21 -0700 (PDT)
Subject: Re: [net-next 4/4] gve: Add ethtool support
To:     Catherine Sullivan <csully@google.com>, netdev@vger.kernel.org
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
References: <20190626185251.205687-1-csully@google.com>
 <20190626185251.205687-5-csully@google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <efa71935-3ec3-0df9-2d9c-25cb9e134a40@gmail.com>
Date:   Fri, 28 Jun 2019 19:44:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190626185251.205687-5-csully@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/2019 11:52 AM, Catherine Sullivan wrote:

[snip]

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
> +	if (!netif_carrier_ok(netdev))
> +		return;
> +
> +	for (rx_pkts = 0, rx_bytes = 0, ring = 0;
> +	     ring < priv->rx_cfg.num_queues; ring++) {
> +		rx_pkts += priv->rx[ring].rpackets;
> +		rx_bytes += priv->rx[ring].rbytes;
> +	}
> +	for (tx_pkts = 0, tx_bytes = 0, ring = 0;
> +	     ring < priv->tx_cfg.num_queues; ring++) {
> +		tx_pkts += priv->tx[ring].pkt_done;
> +		tx_bytes += priv->tx[ring].bytes_done;
> +	}

Maybe you do not need to support 32-bit guests with that driver, but you
might as well be correct and use the include/linux/u64_stats_sync.h
primitives to help return consistent 64-bit stats on 32-bit machines.

[snip]

> +int gve_adjust_queues(struct gve_priv *priv,
> +		      struct gve_queue_config new_rx_config,
> +		      struct gve_queue_config new_tx_config)
> +{
> +	int err;
> +
> +	if (netif_carrier_ok(priv->dev)) {

Should not that be netif_running()?
-- 
Florian
