Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBF31DA132
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgESTpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:45:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:54726 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgESTpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 15:45:15 -0400
IronPort-SDR: rSc0Pb+NTgwSILIhE8DOvoEAOn7/0dcPyPmwn3esXyL5YqBgHWknq4jebGzU4UzPGk5E6Raa5O
 TeiEjJBuJu4w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 12:45:14 -0700
IronPort-SDR: +VRyjyOwI2DfE8ajEDx3DrCLJxoui51Hkn0w51kn/Ek/uRZuQtCjL0HANFGASZu27SiLjWxzFQ
 C2cK+thZC3zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="289080565"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.251.149.217]) ([10.251.149.217])
  by fmsmga004.fm.intel.com with ESMTP; 19 May 2020 12:45:12 -0700
Subject: Re: [RFC v2] current devlink extension plan for NICs
To:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
 <20200515093016.GE2676@nanopsycho>
 <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
 <20200518065207.GA2193@nanopsycho>
 <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
 <AM0PR05MB4866687F67EE56BEBB0D9B3AD1B90@AM0PR05MB4866.eurprd05.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <82e82079-44fe-8de2-5aa4-65755b21a9cb@intel.com>
Date:   Tue, 19 May 2020 12:45:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR05MB4866687F67EE56BEBB0D9B3AD1B90@AM0PR05MB4866.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/2020 10:17 PM, Parav Pandit wrote:
> Hi Jake,
> 

>> Ok. So in the smart NIC CPU, we'd see the primary PF and some child PFs,
>> and in the host system we'd see a "primary PF" that is the other end of the
>> associated Child PF, and might be able to manage its own subswitch.
>>
>> Ok this is making more sense now.
>>
>> I think I had imagined that was what subfuntions were. But really
>> subfunctions are a bit different, they're more similar to expanded VFs?
>>
>  
> 1. Sub functions are more light weight than VFs because,
> 2. They share the same PCI device (BAR, IRQs) as that of PF/VF on which it is deployed.
> 3. Unlike VFs which are enabled/disabled in bulk, subfunctions are created, deployed in unit of 1.
> 
> Since this RFC content is overwhelming, I expanded the SF plumbing details more in [1] in previous RFC version.
> You can replace 'devlink slice' with 'devlink port func' in [1].
> 
> [1] https://marc.info/?l=linux-netdev&m=158555928517777&w=2
> 

Thanks! Indeed, this makes things a lot more clear to me now.

Regards,
Jake
