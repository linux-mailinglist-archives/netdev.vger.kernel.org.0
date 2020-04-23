Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC001B645C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgDWTRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:17:50 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:34926 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWTRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587669469; x=1619205469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jt1/ckSRkhCCZj848GJDeClGoNfbc1ra8uCc3PfjFkY=;
  b=dqXRnrqR2/+l1Uf4tKHgNPmzZhRD46IjwsahmaXjm5nPou/4w18+0jhU
   RmoNaHkCcYe7E9c1xlVn+dbiUY5jlOVJMKyocxoNbSMWt6Mq+proWM4e9
   E4c4weVKTfnc00tKFjxlJb4J1okMMWTo4QCjKYJFt4eL2izu08VoK6BTp
   qbxOr33F0O1s6foZSYjDM+kTj/o/lcEMD9KHpe4xp29SUnGNrbVMonk6P
   g56XK9tFa6MLuKgeJW7UDSuPQNSFmud517yvkwSWX/V9IN9Kqvk7f3XJX
   tMrMOSWmD63A4XYN2V9Rjf4w+gcS4bfVtCOsh6lMkHZWYGz9G0ZMNUkoF
   Q==;
IronPort-SDR: rsI0zVj6PkOkATLFwBc196W/Mj98ccoaPbRdLMfh0LBkUo/oVVYeEJWYNggn0G4q9g3ysnLcu4
 mXrRpNZ1vv2YCjBpdLPNkovPAwH6uN73cdaTxhfvVncruWdnfJZo0WbIme7dL3NolM4GinBYcv
 bJWPHUMh8a89BJI7j2L9yUwy2N0yZ/ikklAp2yU8ENKtL6t6c+K+Xo4ug9TQvDvgNUb/Sfat6O
 bB1RJCdYycrquqlljExgJvurBlGsJHoUotUPfaW7cZcKjUE+hwkeJbwE12MBwbrrFcdKkka8UL
 6NM=
X-IronPort-AV: E=Sophos;i="5.73,307,1583218800"; 
   d="scan'208";a="74384503"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Apr 2020 12:17:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 Apr 2020 12:17:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 23 Apr 2020 12:17:47 -0700
Date:   Thu, 23 Apr 2020 21:17:47 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Po Liu <Po.Liu@nxp.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <claudiu.manoil@nxp.com>, <vladimir.oltean@nxp.com>,
        <alexandru.marginean@nxp.com>, <michael.chan@broadcom.com>,
        <vishal@chelsio.com>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <simon.horman@netronome.com>, <pablo@netfilter.org>,
        <moshe@mellanox.com>, <m-karicheri2@ti.com>,
        <andre.guedes@linux.intel.com>, <stephen@networkplumber.org>
Subject: Re: [v3,net-next  1/4] net: qos: introduce a gate control flow action
Message-ID: <20200423191747.vzfmh3x3qerqbx7z@ws.localdomain>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com>
 <878sim2jcs.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <878sim2jcs.fsf@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.04.2020 10:38, Vinicius Costa Gomes wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Po Liu <Po.Liu@nxp.com> writes:
>>> tc filter add dev eth0 parent ffff: protocol ip \
>>          flower src_ip 192.168.0.20 \
>>          action gate index 2 clockid CLOCK_TAI \
>>          sched-entry open 200000000 -1 8000000 \
>>          sched-entry close 100000000 -1 -1
>
>From the insight that Vladimir gave, it really makes it easier for me to
>understand if you added these filters and actions in two steps. The
>first, you would add the "time based" actions and the second you would
>plug the filters into the actions. And I think this would match real
>world usage better.
I agree.

/Allan
