Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80C716EE23
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgBYSjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:39:21 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:33696 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgBYSjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 13:39:20 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01PHprpF117879;
        Tue, 25 Feb 2020 11:51:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582653113;
        bh=/d5Vd5oiaQH19vYJUAtx0fN3kkFJcOQ0EtyuBQuYOwY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kCihkCk38atKc2IxuB5xoD9DirvUYwJcUd1ugSK0if2KKycinf/7Bm1jPAKnj1+9u
         UE9pvz+empMdjcCuQuojTptgqCD8G4tT/qQbWxs2MArXWVSmxrHnvO+dmTOjjnTWgh
         A6zZFtxD6fYyHo/PENXqmEicRNBEraLhBTf+hQ9g=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01PHprKL018788
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Feb 2020 11:51:53 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 25
 Feb 2020 11:51:53 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 25 Feb 2020 11:51:53 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01PHpppQ060872;
        Tue, 25 Feb 2020 11:51:51 -0600
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
To:     Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87a75br4ze.fsf@linux.intel.com>
 <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <7d68d83c-c81d-5221-b843-07adb40e4b93@ti.com>
Date:   Tue, 25 Feb 2020 12:59:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<<< No Message Collected >>>
