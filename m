Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B53268246
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 03:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgINBYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 21:24:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgINBYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 21:24:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHdE5-00EX9N-74; Mon, 14 Sep 2020 03:24:13 +0200
Date:   Mon, 14 Sep 2020 03:24:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oded Gabbay <oded.gabbay@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using
 coresight
Message-ID: <20200914012413.GB3463198@lunn.ch>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
 <20200912144106.11799-13-oded.gabbay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912144106.11799-13-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct gaudi_nic_ethtool_stats gaudi_nic_mac_stats_rx[] = {
> +	{"Rx MAC counters", 0},
> +	{"  etherStatsOctets", 0x0},
> +	{"  OctetsReceivedOK", 0x4},
> +	{"  aAlignmentErrors", 0x8},
> +	{"  aPAUSEMACCtrlFramesReceived", 0xC},
> +	{"  aFrameTooLongErrors", 0x10},
> +	{"  aInRangeLengthErrors", 0x14},
> +	{"  aFramesReceivedOK", 0x18},
> +	{"  VLANReceivedOK", 0x1C},
> +	{"  aFrameCheckSequenceErrors", 0x20},
> +	{"  ifInErrors", 0x24},
> +	{"  ifInUcastPkts", 0x28},
> +	{"  ifInMulticastPkts", 0x2C},
> +	{"  ifInBroadcastPkts", 0x30},
> +	{"  etherStatsDropEvents", 0x34},
> +	{"  etherStatsUndersizePkts", 0x38},
> +	{"  etherStatsPkts", 0x3C},
> +	{"  etherStatsPkts64Octets", 0x40},
> +	{"  etherStatsPkts65to127Octets", 0x44},
> +	{"  etherStatsPkts128to255Octets", 0x48},
> +	{"  etherStatsPkts256to511Octets", 0x4C},
> +	{"  etherStatsPkts512to1023Octets", 0x50},
> +	{"  etherStatsPkts1024to1518Octets", 0x54},
> +	{"  etherStatsPkts1519toMaxOctets", 0x58},
> +	{"  etherStatsOversizePkts", 0x5C},
> +	{"  etherStatsJabbers", 0x60},
> +	{"  etherStatsFragments", 0x64},
> +	{"  aCBFCPAUSEFramesReceived_0", 0x68},
> +	{"  aCBFCPAUSEFramesReceived_1", 0x6C},
> +	{"  aCBFCPAUSEFramesReceived_2", 0x70},
> +	{"  aCBFCPAUSEFramesReceived_3", 0x74},
> +	{"  aCBFCPAUSEFramesReceived_4", 0x78},
> +	{"  aCBFCPAUSEFramesReceived_5", 0x7C},
> +	{"  aCBFCPAUSEFramesReceived_6", 0x80},
> +	{"  aCBFCPAUSEFramesReceived_7", 0x84},
> +	{"  aMACControlFramesReceived", 0x88}
> +};
> +
> +static struct gaudi_nic_ethtool_stats gaudi_nic_mac_stats_tx[] = {
> +	{"Tx MAC counters", 0},
> +	{"  etherStatsOctets", 0x0},
> +	{"  OctetsTransmittedOK", 0x4},
> +	{"  aPAUSEMACCtrlFramesTransmitted", 0x8},
> +	{"  aFramesTransmittedOK", 0xC},
> +	{"  VLANTransmittedOK", 0x10},
> +	{"  ifOutErrors", 0x14},
> +	{"  ifOutUcastPkts", 0x18},
> +	{"  ifOutMulticastPkts", 0x1C},
> +	{"  ifOutBroadcastPkts", 0x20},
> +	{"  etherStatsPkts64Octets", 0x24},
> +	{"  etherStatsPkts65to127Octets", 0x28},
> +	{"  etherStatsPkts128to255Octets", 0x2C},
> +	{"  etherStatsPkts256to511Octets", 0x30},
> +	{"  etherStatsPkts512to1023Octets", 0x34},
> +	{"  etherStatsPkts1024to1518Octets", 0x38},
> +	{"  etherStatsPkts1519toMaxOctets", 0x3C},
> +	{"  aCBFCPAUSEFramesTransmitted_0", 0x40},
> +	{"  aCBFCPAUSEFramesTransmitted_1", 0x44},
> +	{"  aCBFCPAUSEFramesTransmitted_2", 0x48},
> +	{"  aCBFCPAUSEFramesTransmitted_3", 0x4C},
> +	{"  aCBFCPAUSEFramesTransmitted_4", 0x50},
> +	{"  aCBFCPAUSEFramesTransmitted_5", 0x54},
> +	{"  aCBFCPAUSEFramesTransmitted_6", 0x58},
> +	{"  aCBFCPAUSEFramesTransmitted_7", 0x5C},
> +	{"  aMACControlFramesTransmitted", 0x60},
> +	{"  etherStatsPkts", 0x64}
> +};

...

> +static void gaudi_nic_get_internal_stats(struct net_device *netdev, u64 *data)
> +{
> +	struct gaudi_nic_device **ptr = netdev_priv(netdev);
> +	struct gaudi_nic_device *gaudi_nic = *ptr;
> +	struct hl_device *hdev = gaudi_nic->hdev;
> +	u32 port = gaudi_nic->port;
> +	u32 num_spmus;
> +	int i;
> +
> +	num_spmus = (port & 1) ? NIC_SPMU1_STATS_LEN : NIC_SPMU0_STATS_LEN;
> +
> +	gaudi_sample_spmu_nic(hdev, port, num_spmus, data);
> +	data += num_spmus;
> +
> +	/* first entry is title */
> +	data[0] = 0;

Hi Jakub

You have been looking at statistics names recently. What do you think
of this data[0]?

   Andrew
