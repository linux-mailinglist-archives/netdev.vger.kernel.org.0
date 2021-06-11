Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25DC3A4639
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFKQOb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Jun 2021 12:14:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:3788 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhFKQO3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:14:29 -0400
IronPort-SDR: glJEyLZvCS+tSt6CpbgQ92PrxohRMeIeK04rCu65L/QGx+tX/a451S5EbcqqZ2JUTdKHzPU++C
 B9UM3/7kaJ9w==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="291186011"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="291186011"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:12:29 -0700
IronPort-SDR: hYweaGxaI7yIu9RoJ5cDtL4ZzMjbpf6PDj6vl8pQKBonCgwUo3XoTke2a2/hBCPki0E+XgCvwG
 fodlEZNQ1BEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="483316279"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 11 Jun 2021 09:12:28 -0700
Received: from lcsmsx601.ger.corp.intel.com (10.109.210.10) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 11 Jun 2021 09:12:27 -0700
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 LCSMSX601.ger.corp.intel.com (10.109.210.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 11 Jun 2021 19:12:25 +0300
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.2242.008;
 Fri, 11 Jun 2021 19:12:25 +0300
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi83@gmail.com>,
        "ryder.lee@mediatek.com" <ryder.lee@mediatek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "joe@perches.com" <joe@perches.com>,
        "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>,
        "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "jiaxun.yang@flygoat.com" <jiaxun.yang@flygoat.com>,
        "zhangqing@loongson.cn" <zhangqing@loongson.cn>,
        "jbhayana@google.com" <jbhayana@google.com>,
        "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        "shayne.chen@mediatek.com" <shayne.chen@mediatek.com>,
        "Soul.Huang@mediatek.com" <Soul.Huang@mediatek.com>,
        "shorne@gmail.com" <shorne@gmail.com>,
        "gsomlo@gmail.com" <gsomlo@gmail.com>,
        "pczarnecki@internships.antmicro.com" 
        <pczarnecki@internships.antmicro.com>,
        "mholenko@antmicro.com" <mholenko@antmicro.com>,
        "davidgow@google.com" <davidgow@google.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: RE: [PATCH 2/7] mei: hdcp: SPDX tag should be the first line
Thread-Topic: [PATCH 2/7] mei: hdcp: SPDX tag should be the first line
Thread-Index: AQHXXkH6CZWhH34xEEKudrvKO6IQEasO/INA
Date:   Fri, 11 Jun 2021 16:12:24 +0000
Message-ID: <22a4dc49b49348438d71be0fb02e3ab1@intel.com>
References: <20210610214438.3161140-1-trix@redhat.com>
 <20210610214438.3161140-4-trix@redhat.com>
In-Reply-To: <20210610214438.3161140-4-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> From: Tom Rix <trix@redhat.com>
> 
> checkpatch looks for the tag on the first line.
> So delete empty first line
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/misc/mei/hdcp/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/misc/mei/hdcp/Kconfig b/drivers/misc/mei/hdcp/Kconfig
> index 95b2d6d37f102..54e1c95269096 100644
> --- a/drivers/misc/mei/hdcp/Kconfig
> +++ b/drivers/misc/mei/hdcp/Kconfig
> @@ -1,4 +1,3 @@
> -
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (c) 2019, Intel Corporation. All rights reserved.
>  #
> --
> 2.26.3

