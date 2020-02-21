Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4A5168972
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgBUVls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:41:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:53356 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgBUVls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:41:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 13:41:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,469,1574150400"; 
   d="scan'208";a="437084627"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 21 Feb 2020 13:41:45 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <20191127094517.6255-1-Po.Liu@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
Date:   Fri, 21 Feb 2020 13:43:33 -0800
Message-ID: <87a75br4ze.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Po Liu <po.liu@nxp.com> writes:

> IEEE Std 802.1Qbu standard defined the frame preemption of port
> traffic classes. This patch introduce a method to set traffic
> classes preemption. Add a parameter 'preemption' in struct
> ethtool_link_settings. The value will be translated to a binary,
> each bit represent a traffic class. Bit "1" means preemptable
> traffic class. Bit "0" means express traffic class.  MSB represent
> high number traffic class.
>
> If hardware support the frame preemption, driver could set the
> ethernet device with hw_features and features with NETIF_F_PREEMPTION
> when initializing the port driver.
>
> User can check the feature 'tx-preemption' by command 'ethtool -k
> devname'. If hareware set preemption feature. The property would
> be a fixed value 'on' if hardware support the frame preemption.
> Feature would show a fixed value 'off' if hardware don't support
> the frame preemption.
>
> Command 'ethtool devname' and 'ethtool -s devname preemption N'
> would show/set which traffic classes are frame preemptable.
>
> Port driver would implement the frame preemption in the function
> get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>

Any updates on this series? If you think that there's something that I
could help, just tell.


Cheers,
-- 
Vinicius
