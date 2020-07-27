Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8959022FB33
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgG0VSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:18:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:19122 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgG0VSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:18:21 -0400
IronPort-SDR: qP6uePqdynF7x1jzzyE7VALNESRDKeaOs+2Ajwj0Bm6Rm8aboLTmHh6Tfq7R5ZS05HgovPvrr7
 qwsj/trgNd/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="138628001"
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="138628001"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 14:18:20 -0700
IronPort-SDR: 7U9A2+hcRqqGNyxpupPNCd80nZtSv6Oj7H2ymH04r5imwvKz+qnUVqdVKVsOSfk95o6S/b49cu
 0YmCcYL+KrGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="303605526"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 14:18:20 -0700
Subject: Re: Broken link partner advertised reporting in ethtool
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>, netdev@vger.kernel.org
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
 <20200727210141.GA1705504@lunn.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <6bc49b72-5698-ef93-9be1-a40e34be8803@intel.com>
Date:   Mon, 27 Jul 2020 14:18:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727210141.GA1705504@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 2:01 PM, Andrew Lunn wrote:
> Here are the netlink messages.
> 
> sending genetlink packet (32 bytes):
>     msg length 32 genl-ctrl
>     CTRL_CMD_GETFAMILY
>         CTRL_ATTR_FAMILY_NAME = "ethtool"
> ...
> ...
> sending genetlink packet (36 bytes):
>     msg length 36 ethool ETHTOOL_MSG_LINKMODES_GET
>     ETHTOOL_MSG_LINKMODES_GET
>         ETHTOOL_A_LINKMODES_HEADER
>             ETHTOOL_A_HEADER_DEV_NAME = "green"
> received genetlink packet (572 bytes):
>     msg length 572 ethool ETHTOOL_MSG_LINKMODES_GET_REPLY
>     ETHTOOL_MSG_LINKMODES_GET_REPLY
>         ETHTOOL_A_LINKMODES_HEADER
>             ETHTOOL_A_HEADER_DEV_INDEX = 8
>             ETHTOOL_A_HEADER_DEV_NAME = "green"
>         ETHTOOL_A_LINKMODES_AUTONEG = on
>         ETHTOOL_A_LINKMODES_OURS
>             ETHTOOL_A_BITSET_SIZE = 90
>             ETHTOOL_A_BITSET_BITS
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 0
>                     ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Half"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 1
>                     ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Full"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 2
>                     ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Half"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 3
>                     ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Full"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 5
>                     ETHTOOL_A_BITSET_BIT_NAME = "1000baseT/Full"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 6
>                     ETHTOOL_A_BITSET_BIT_NAME = "Autoneg"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 7
>                     ETHTOOL_A_BITSET_BIT_NAME = "TP"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 9
>                     ETHTOOL_A_BITSET_BIT_NAME = "MII"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 13
>                     ETHTOOL_A_BITSET_BIT_NAME = "Pause"
>                     ETHTOOL_A_BITSET_BIT_VALUE = true
>         ETHTOOL_A_LINKMODES_PEER
>             ETHTOOL_A_BITSET_NOMASK = true
>             ETHTOOL_A_BITSET_SIZE = 90
>             ETHTOOL_A_BITSET_BITS
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 0
>                     ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Half"
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 1
>                     ETHTOOL_A_BITSET_BIT_NAME = "10baseT/Full"
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 2
>                     ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Half"
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 3
>                     ETHTOOL_A_BITSET_BIT_NAME = "100baseT/Full"
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 5
>                     ETHTOOL_A_BITSET_BIT_NAME = "1000baseT/Full"
>                 ETHTOOL_A_BITSET_BITS_BIT
>                     ETHTOOL_A_BITSET_BIT_INDEX = 6
>                     ETHTOOL_A_BITSET_BIT_NAME = "Autoneg"
>         ETHTOOL_A_LINKMODES_SPEED = 1000
>         ETHTOOL_A_LINKMODES_DUPLEX = 1

Based on the netlink contents here it looks like a bug at
netlink/settings.c:357, where we check for ETHTOOL_A_BITSET_BIT_VALUE,
but these aren't sent when you send the bitset using a individual
BIT_INDEX/BIT_NAME like this. I think that's a bug.

I'm working up a simple to verify this and if my suspicion is confirmed
I can write up a patch.

Thanks,
Jake
