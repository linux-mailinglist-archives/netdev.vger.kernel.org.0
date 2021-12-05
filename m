Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAABE468B44
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhLEN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:56:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:4794 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhLEN4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 08:56:08 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="300571356"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="300571356"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 05:52:41 -0800
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514386218"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.128.183]) ([10.215.128.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 05:52:38 -0800
Message-ID: <b45fb5b5-3068-73c1-f609-ffab92a3fa60@linux.intel.com>
Date:   Sun, 5 Dec 2021 19:22:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next 2/7] net: wwan: iosm: set tx queue len
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        krishna.c.sudi@intel.com,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
References: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
 <20211205065528.1613881-3-m.chetan.kumar@linux.intel.com>
 <CAHNKnsQTLENdyrOA7wXWUCMBD2pYY-Vn9DocqcvtNFsmhZZjcw@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <CAHNKnsQTLENdyrOA7wXWUCMBD2pYY-Vn9DocqcvtNFsmhZZjcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On 12/5/2021 4:46 PM, Sergey Ryazanov wrote:
> Hello M Chetan Kumar,
> 
> On Sun, Dec 5, 2021 at 9:47 AM M Chetan Kumar
> <m.chetan.kumar@linux.intel.com> wrote:
>> Set wwan net dev tx queue len to 1000.
>>
>> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
>> ---
>>   drivers/net/wwan/iosm/iosm_ipc_wwan.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> index b571d9cedba4..e3fb926d2248 100644
>> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
>> @@ -18,6 +18,7 @@
>>   #define IOSM_IP_TYPE_IPV6 0x60
>>
>>   #define IOSM_IF_ID_PAYLOAD 2
>> +#define IOSM_QDISC_QUEUE_LEN 1000
> 
> Is this 1000 something special for the IOSM driver? If you need just
> an approximate value for the queue length, then consider using the
> common DEFAULT_TX_QUEUE_LEN macro, please.

We had set an approximate value for the queue length.
Sure, will use the common queue length macro (DEFAULT_TX_QUEUE_LEN) 
instead of defining the new macro.

Regards,
Chetan
