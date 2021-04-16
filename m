Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D9362A4A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344280AbhDPV0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235451AbhDPV0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 17:26:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61809613B0;
        Fri, 16 Apr 2021 21:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618608375;
        bh=Wjw0dbu4d626kO9bHefuoUFuynnhMq9K2YsAhXb6QNQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dunQfbz0M0XCqtya3QGtPB1QB1nG6iXzacSsJVzAshluynjIn94fIRvHyShy2aC7y
         d9z7VG6WIttQ5zichJLxVW1u+uLOaXSUmXthIX/asDwHaG1qfhxdHrOhzjxWbfYqgS
         IuEiTFqr5gYNNRYSfq5j0FAVr2PP7/jFFK+uxS/TIEqNj4p/PL0Mclt93hrDmtVe6R
         J/eP2t9gifqyuAwXw4TG5GGai6WWBtkmRMLigcElFW0A0aF6+RzKU8BplRiDTgdSpz
         UwQjcLMN2Q5j5rTnCalYvDWyAgqM6ukBZxnaodl8oyepw+FtNMRKoxBYPVr1TA7Q3o
         8UHIhVzYZkjug==
Date:   Fri, 16 Apr 2021 14:26:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next 09/10] net: sparx5: add ethtool configuration
 and statistics support
Message-ID: <20210416142613.7307cbc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416131657.3151464-10-steen.hegelund@microchip.com>
References: <20210416131657.3151464-1-steen.hegelund@microchip.com>
        <20210416131657.3151464-10-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 15:16:56 +0200 Steen Hegelund wrote:
> +	"rx_in_bytes",
> +	"rx_symbol_err",
> +	"rx_pause",
> +	"rx_unsup_opcode",
> +	"rx_ok_bytes",
> +	"rx_bad_bytes",
> +	"rx_unicast",
> +	"rx_multicast",
> +	"rx_broadcast",
> +	"rx_crc_err",
> +	"rx_undersize",
> +	"rx_fragments",
> +	"rx_inrangelen_err",
> +	"rx_outofrangelen_err",
> +	"rx_oversize",
> +	"rx_jabbers",
> +	"rx_size64",
> +	"rx_size65_127",
> +	"rx_size128_255",
> +	"rx_size256_511",
> +	"rx_size512_1023",
> +	"rx_size1024_1518",
> +	"rx_size1519_max",
> +	"pmac_rx_symbol_err",
> +	"pmac_rx_pause",
> +	"pmac_rx_unsup_opcode",
> +	"pmac_rx_ok_bytes",
> +	"pmac_rx_bad_bytes",
> +	"pmac_rx_unicast",
> +	"pmac_rx_multicast",
> +	"pmac_rx_broadcast",
> +	"pmac_rx_crc_err",
> +	"pmac_rx_undersize",
> +	"pmac_rx_fragments",
> +	"pmac_rx_inrangelen_err",
> +	"pmac_rx_outofrangelen_err",
> +	"pmac_rx_oversize",
> +	"pmac_rx_jabbers",
> +	"pmac_rx_size64",
> +	"pmac_rx_size65_127",
> +	"pmac_rx_size128_255",
> +	"pmac_rx_size256_511",
> +	"pmac_rx_size512_1023",
> +	"pmac_rx_size1024_1518",
> +	"pmac_rx_size1519_max",

> +	"rx_local_drop",
> +	"rx_port_policer_drop",
> +	"tx_out_bytes",
> +	"tx_pause",
> +	"tx_ok_bytes",
> +	"tx_unicast",
> +	"tx_multicast",
> +	"tx_broadcast",
> +	"tx_size64",
> +	"tx_size65_127",
> +	"tx_size128_255",
> +	"tx_size256_511",
> +	"tx_size512_1023",
> +	"tx_size1024_1518",
> +	"tx_size1519_max",
> +	"tx_multi_coll",
> +	"tx_late_coll",
> +	"tx_xcoll",
> +	"tx_defer",
> +	"tx_xdefer",
> +	"tx_backoff1",
> +	"pmac_tx_pause",
> +	"pmac_tx_ok_bytes",
> +	"pmac_tx_unicast",
> +	"pmac_tx_multicast",
> +	"pmac_tx_broadcast",
> +	"pmac_tx_size64",
> +	"pmac_tx_size65_127",
> +	"pmac_tx_size128_255",
> +	"pmac_tx_size256_511",
> +	"pmac_tx_size512_1023",
> +	"pmac_tx_size1024_1518",
> +	"pmac_tx_size1519_max",

Please see 

https://patchwork.kernel.org/project/netdevbpf/list/?series=468795

(hopefully to be merged by the end of the week) and earlier patches for
pause and FEC stats. Anything that has a standardized interface is off
limits for the random ethtool -S grab bag.
