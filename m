Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDB284A7F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 12:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgJFKwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 06:52:49 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:41065 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFKws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 06:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601981584; x=1633517584;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XWe73CyLKuuLoicTnYzhkWc7m8Pv7TxMKAoB74+Eo5I=;
  b=dm6tXuKG9eXeRgxCt8P+ehlXmfBTFbPL0m4MYZPOtviUfXI072oWMgTG
   jGEcZ3g5fnklQR4/pRAl5Y9zmSTCcW3xpr8GGCkkZ+E+Y74Mh54ldrJ+u
   r+yKbTpD9GQRtDyB6IAYmkTNtE8XjxJikfvt+fex2T+4GYkNhGZ4Qyo16
   SZ6knGm1OUbKBvZWv5yT/vpoH7xAkZKGFmSA8UMXPebI4u9bcgRWnQrFX
   3lAgXXiPbWcdWeehYzLcR1n172Q7YNfBpwYGFGSQYO+HAidqSIbWR+RRi
   vjU7uevym0B3wBWtsAaiSGnPzIwhqJFIDc9dKceNttuXXBX80bzq/blid
   Q==;
IronPort-SDR: 5+pWw0P3bETXIx220LLQz2A70U3JP4Ta3/3lvJJM7Z9FmDE3d5qTe0x1ddvEmVEU4EM0+0KVMA
 P3n2uBOzj3btpYOPVqFjV7tvadbJDvgy5AIGYhN8UlJMKfvNwXqF9owzNMOoRoclrAoaUnjWQq
 dAjE/DlulZLNf0+iMTJAf9wHKD7WZ4vwuYrVHNIRgSHEQvvJ6vAMsRcyxtd8vcThoH2rxkam46
 KNwEmj7O1GzQpRdnu/majVzBE56MG8c2pyUxlZAuWQgDYqM2qXJZLDoMCLxBta9y2ifJdCevq8
 8c4=
X-IronPort-AV: E=Sophos;i="5.77,343,1596524400"; 
   d="scan'208";a="91592415"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Oct 2020 03:53:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 6 Oct 2020 03:52:54 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 6 Oct 2020 03:53:03 -0700
Date:   Tue, 6 Oct 2020 12:53:02 +0200
From:   "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [net-next v2 10/11] bridge: switchdev: cfm: switchdev interface
 implementation
Message-ID: <20201006105302.gk4yur5ztgwgbbzu@ws.localdomain>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
 <20201001103019.1342470-11-henrik.bjoernlund@microchip.com>
 <20201001124929.GM8264@nanopsycho>
 <20201005130712.ybbgiddb7bnbkz6h@ws.localdomain>
 <fb313c83e6ac750d4bcdf96d2b2d7ebe4ae98dd6.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <fb313c83e6ac750d4bcdf96d2b2d7ebe4ae98dd6.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.10.2020 10:50, Nikolay Aleksandrov wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Mon, 2020-10-05 at 15:07 +0200, Allan W. Nielsen wrote:
>> Hi Jiri
>>
>> On 01.10.2020 14:49, Jiri Pirko wrote:
>> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> >
>> > Thu, Oct 01, 2020 at 12:30:18PM CEST, henrik.bjoernlund@microchip.com wrote:
>> > > This is the definition of the CFM switchdev interface.
>> > >
>> > > The interface consist of these objects:
>> > >    SWITCHDEV_OBJ_ID_MEP_CFM,
>> > >    SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM,
>> > >    SWITCHDEV_OBJ_ID_CC_CONFIG_CFM,
>> > >    SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM,
>> > >    SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM,
>> > >    SWITCHDEV_OBJ_ID_MEP_STATUS_CFM,
>> > >    SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM
>> > >
>> > > MEP instance add/del
>> > >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CFM)
>> > >    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_MEP_CFM)
>> > >
>> > > MEP cofigure
>> > >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_MEP_CONFIG_CFM)
>> > >
>> > > MEP CC cofigure
>> > >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CONFIG_CFM)
>> > >
>> > > Peer MEP add/del
>> > >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
>> > >    switchdev_port_obj_del(SWITCHDEV_OBJ_ID_CC_PEER_MEP_CFM)
>> > >
>> > > Start/stop CCM transmission
>> > >    switchdev_port_obj_add(SWITCHDEV_OBJ_ID_CC_CCM_TX_CFM)
>> > >
>> > > Get MEP status
>> > >       switchdev_port_obj_get(SWITCHDEV_OBJ_ID_MEP_STATUS_CFM)
>> > >
>> > > Get Peer MEP status
>> > >       switchdev_port_obj_get(SWITCHDEV_OBJ_ID_PEER_MEP_STATUS_CFM)
>> > >
>> > > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
>> > > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
>> >
>> > You have to submit the driver parts as a part of this patchset.
>> > Otherwise it is no good.
>> Fair enough.
>>
>> With MRP we did it like this, and after Nik asked for details on what is
>> being offload, we thought that adding this would help.
>>
>> The reason why we did not include the implementation of this interface
>> is that it is for a new SoC which is still not fully available which is
>> why we have not done the basic SwitchDev driver for it yet. But the
>> basic functionality clearly needs to come first.
>>
>> Our preference is to continue fixing the comments we got on the pure SW
>> implementation and then get back to the SwitchDev offloading.
>>
>> This will mean dropping the last 2 patches in the serie.
>>
>> Does that work for you Jiri, and Nik?
>>
>> /Allan
>>
>
>Sounds good to me. Sorry I was unresponsive last week, but I was sick and
>couldn't get to netdev@. I'll review the set today.

Perfect. Thanks for the support.

/Allan


