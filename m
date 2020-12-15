Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CCC2DB3DC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgLOSha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:37:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:40679 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731688AbgLOShH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 13:37:07 -0500
IronPort-SDR: +NrQmDAeJ02N1/Yhj/jqksnSO5syFREkOccieS/yfPFgvyWsT5Vm15uSf5ZaQ2LalHxDj250QO
 SnmDtU6CKAKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="162678271"
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="162678271"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 10:36:26 -0800
IronPort-SDR: hH4q2KvN5MqJXccttH8AX4REOn8lBVyFfnCOmAodejaA9cMt9BSg3bziX7FpUGSf7tPnXmJc5X
 27orHkJMgcFg==
X-IronPort-AV: E=Sophos;i="5.78,422,1599548400"; 
   d="scan'208";a="412085807"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.214.238.87]) ([10.214.238.87])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 10:36:20 -0800
Subject: Re: Fw: [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
 i219LM
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Mark Pearson <markpearson@lenovo.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Aaron Ma <aaron.ma@canonical.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Efrati, Nir" <nir.efrati@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
 <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
 <PS2PR03MB37505A15D3C9B7505D679D7BBDC70@PS2PR03MB3750.apcprd03.prod.outlook.com>
 <ae436f90-45b8-ba70-be57-d17641c4f79d@lenovo.com>
 <18c1c152-9298-a4c5-c4ed-92c9fd91ea8a@intel.com>
 <DM6PR19MB2636FA6E479914432036987BFAC60@DM6PR19MB2636.namprd19.prod.outlook.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <9bac261e-0efb-fe07-7c3e-6c4ff156bb67@intel.com>
Date:   Tue, 15 Dec 2020 20:36:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <DM6PR19MB2636FA6E479914432036987BFAC60@DM6PR19MB2636.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/2020 19:20, Limonciello, Mario wrote:
> 
>>> Absolutely - I'll ask them to look into this again.
>>>
>> we need to explain why on Windows systems required 1s and on Linux
>> systems up to 2.5s - otherwise it is not reliable approach - you will
>> encounter others buggy system.
>> (ME not POR on the Linux systems - is only one possible answer)
> 
> Sasha: In your opinion does this information need to block the series?
> or can we follow up with more changes later on as more information becomes
> available?
> 
I do not think this should block the patches series.
> For now v5 of the series extends the timeout but at least makes a mention
> that there appears to be a firmware bug when more than 1 second is taken.
> 

