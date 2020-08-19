Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A5024A190
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgHSOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:19:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgHSOS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 10:18:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8OvY-00A5sj-LI; Wed, 19 Aug 2020 16:18:56 +0200
Date:   Wed, 19 Aug 2020 16:18:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     sameehj@amazon.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V2 net-next 2/4] net: ena: ethtool: Add new device
 statistics
Message-ID: <20200819141856.GF2403519@lunn.ch>
References: <20200819134349.22129-1-sameehj@amazon.com>
 <20200819134349.22129-3-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819134349.22129-3-sameehj@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (eni_stats_needed) {
> +		ena_update_hw_stats(adapter);
> +		for (i = 0; i < ENA_STATS_ARRAY_ENI(adapter); i++) {
> +			ena_stats = &ena_stats_eni_strings[i];
> +
> +			ptr = (u64 *)((unsigned long)&adapter->eni_stats +
> +				ena_stats->stat_offset);

Yet more ugly casts. Please fix this. If done correctly, you should
not need any casts at all.

    Andrew
