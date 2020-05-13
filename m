Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9591F1D1C1F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbgEMRVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:21:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:47979 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389826AbgEMRVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 13:21:39 -0400
IronPort-SDR: QagRezG1nYUmcyoHyfCD2YRhMze0z9EaGZwTA2Ves8KSh2T5gln5Xc88RSmUY9DT0JS1CJ7oxQ
 iP3RiBl+5qOw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 10:21:38 -0700
IronPort-SDR: 3Pjfk+tK0zejQ54nu3o3VLVamudCcl4QyGwYiVSDv0h+3A7EqFSZeUsL0rLSF+LUGGsSoOJCwv
 1GSMatrEiCyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,388,1583222400"; 
   d="scan'208";a="464203501"
Received: from ftojalx-mobl.amr.corp.intel.com (HELO ellie) ([10.255.69.219])
  by fmsmga006.fm.intel.com with ESMTP; 13 May 2020 10:21:37 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>, Po Liu <po.liu@nxp.com>,
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
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <968be6d0-813e-c820-1fec-0ac85c838e7f@ti.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <87a75br4ze.fsf@linux.intel.com> <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com> <87a74lgnad.fsf@linux.intel.com> <1c06e30e-8999-2c40-e631-1d67b3d9ce39@ti.com> <968be6d0-813e-c820-1fec-0ac85c838e7f@ti.com>
Date:   Wed, 13 May 2020 10:21:37 -0700
Message-ID: <87v9kzrbry.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

Murali Karicheri <m-karicheri2@ti.com> writes:

> Any progress on your side for a patch for the support?
>

Sorry for the delay, things got a bit crazy here for some time. 

I have a RFC-quality series that I am finishing testing, I'll try to
post it this week.

> I have posted my EST offload series for AM65x CPSW to netdev list today
> at
>
> https://marc.info/?l=linux-netdev&m=158937640015582&w=2
> https://marc.info/?l=linux-netdev&m=158937639515579&w=2
> https://marc.info/?l=linux-netdev&m=158937638315573&w=2

I'll try to have a look.

>
> Next on my list of things to do is the IET FPE support for which I need
> to have ethtool interface to allow configuring the express/preemptible
> queues and feature enable/disable. Currently I am using a ethtool
> priv-flags and some defaults. If you can post a patch, I will be able
> to integrate and test it on AM65x CPSW driver and provide my comments/
> Tested-by:

Understood. Thanks.


-- 
Vinicius
