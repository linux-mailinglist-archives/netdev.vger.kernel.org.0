Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FDA20A00E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 15:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405159AbgFYNe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 09:34:59 -0400
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:34880
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404883AbgFYNe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 09:34:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUINO6NPzZsA7wGpdjbIlQsHh2V1Mb8nPrWVG83OsUglkjRb9TX1CJIvq4QghYaBXakPb3eeK4zIBCYWjym7airVUl9Rr8tJWVvrTj2t16P5rM3ZVSNtMcFlLPkOrurzNFRZZcTAf5Z2srlqqVR3yiRLwZvUSnorh081WU10LnJWYj3zvP966m0IvpvWwF681PMriT05211h1geySaMHAFM3wtOdjrKLBe/EGwENow4oWfdLiO5Pj3qCEQAt2o0uKw0LYbwgNR10Lj3zZbOR0Ay1ENKBKHjM2Lvdvm9aNI6ZqrWbCdfcjSF9X5Ybh+5mG7kUEomcpyW6h9rEFyydwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNHIAUyno/3zpoCoGPCo80X7RaXYMExd06F7VispgAU=;
 b=eqkVXBsAdXxSWREbVC5Bugp3fw6xWuRiyI0u9gkFxzHc3AwHHu59v2BSK9ZDBVnaK+NB84X74xZFZCEgI533F47+r+cEeEO55FPCtYXPvvWS8Xe3iCkYGZkWZtyfoJi31u4MOJoVZQcYGGHotFZq5v8UFC5GCZpj2huioA8OjY7vM+JwVh3r/E/C0n74dvzA1UIqpGApx8H3P9qIhFt+fH2xuA11TEb2+BTA6rJeC5f0irZZDBJVuGBADF105MVxVI8UI6nASK362yf8Ch0rbYDLfpW5U3H+qwvDME+IIg0Q91NzOmv8UX3VsGHA90nSoAzdlu8SXt418F4iDIls+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNHIAUyno/3zpoCoGPCo80X7RaXYMExd06F7VispgAU=;
 b=Z5j1nRqiCOTAPm5Ywya3Yp8myyGHK31Uy1qGOCCYmWyP9sDmCXWKcS0h4mKJA+A3t4gd98yUW9aeMR5t6JahDcIxExF2+8Wk/+EWcr37S7dI2hcl/EPOVdAhiopNgmUdcokIT70XcpfzjgbYYGNk49HQ6PB6LHxdilS0UlfZX+I=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM4PR0501MB2179.eurprd05.prod.outlook.com
 (2603:10a6:200:52::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 25 Jun
 2020 13:34:52 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9%7]) with mapi id 15.20.3131.023; Thu, 25 Jun 2020
 13:34:52 +0000
Subject: Re: [PATCH net-next 04/10] Documentation: networking:
 ethtool-netlink: Add link extended state
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, mkubecek@suse.cz,
        andrew@lunn.ch, f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
References: <20200624081923.89483-1-idosch@idosch.org>
 <20200624081923.89483-5-idosch@idosch.org>
 <b8aca89b-02f1-047c-a582-dacebfb8e480@intel.com>
From:   Amit Cohen <amitc@mellanox.com>
Message-ID: <9718cf64-544a-9efb-409d-ada7c2d927f1@mellanox.com>
Date:   Thu, 25 Jun 2020 16:34:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <b8aca89b-02f1-047c-a582-dacebfb8e480@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:122::29) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.3] (77.125.76.133) by AM0PR04CA0016.eurprd04.prod.outlook.com (2603:10a6:208:122::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Thu, 25 Jun 2020 13:34:50 +0000
X-Originating-IP: [77.125.76.133]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 31d49449-0189-4a3c-19de-08d8190c8a1e
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2179:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0501MB21797E08A2FA3CEE7828F18CD7920@AM4PR0501MB2179.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ska90qG+24V3dQfsaN3SLIVbB4vEGYda6dcfR5QXKamD5sAUwZgYQuaAjqsKBLHjPYShJLyNKETOmj+i+bZOx873GWdPFlgbBJuUJofdEYZFuCNJ8OHCCqUO2xBYCdKsXYYaipY3NGSaAQ+3r+8pZ0l6kQpXK4PK+qcXcvDTU/bHhxWxFRBR+Jo4nt6DNvl2se3UKXiI2Bs6IxJg+IDRyjLpsyxyxYm/mcge6ToFL/1VD8Rjomftrip2cNMywyaU49HLy7az2P0OrvzMO9i4BOSyuUooVqfZoCNmbFWsSittzykWUX/7zWlT9AHkONxM02rk8ZWvUNGfRaMMVe19eMcJw65MDA6bBKcw6Br0sMEJwR9Rq3/ToVXv0fiShsF8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(26005)(53546011)(5660300002)(8936002)(86362001)(8676002)(66556008)(186003)(2906002)(16526019)(66946007)(36756003)(66476007)(16576012)(956004)(2616005)(31696002)(4326008)(478600001)(316002)(31686004)(6916009)(6486002)(83380400001)(107886003)(52116002)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vYElHfuTE1V6X449p8S2Df/DwYPHXNF82LKT5xy6Sow0FpcA/HnFU0yX/lwMLt+MfAZ1ltWNOfPeblBf4RMwCOhDdauDZBPWZcZ3+YQIe5MoeW0vMlfDNyHSMxetqF7WD9/B4LEczXgOxaORPKFfsN/Uf5g0epXLtqIS9vrCENXCqRV0QHATdP7OHDpQz/jElyJdVnRZJLt+DDsAMeDqRII/PrXKHkyK/RV0hwwRZCNeO4gKzUGuXp4ld4IpmZy8L87/i/XAX+5JEa2gV2cCM2Jvori+VFRhGq2mByIYBQoDzTqdmaSMxLLMU59y1FA6SEhYGpyHs+F6MqXkbIA9D/ay3XjNJ62pSx+Wp3JnfcRdVE6dhWECUhssVo2Wa3qinDajFavK3gMdtdcReeKsgRM3uKBitu/ZKUcHOeacM8z7wkQRu6Q/FSS8xrwWLzKrlRvd/aIeKegCxhvfVcV+0nBfTWglIkXUD55cNJJyH7w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31d49449-0189-4a3c-19de-08d8190c8a1e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 13:34:52.2144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BrsU7UEpBsPLcXBgZvd8AUxU0DncU9WUcUAC21vX+jAPAAIVCBIoL6cMMh0C2uT5D179SkUaXn6UTe0Reo68mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24-Jun-20 22:07, Jacob Keller wrote:
> 
> 
> On 6/24/2020 1:19 AM, Ido Schimmel wrote:
>> From: Amit Cohen <amitc@mellanox.com>
>>
>> Add link extended state attributes.
>>
>> Signed-off-by: Amit Cohen <amitc@mellanox.com>
>> Reviewed-by: Petr Machata <petrm@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> 
> I really like this concept.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> 
>> ---
>>  Documentation/networking/ethtool-netlink.rst | 110 ++++++++++++++++++-
>>  1 file changed, 106 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index 82470c36c27a..a7cc53f905f5 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -443,10 +443,11 @@ supports.
>>  LINKSTATE_GET
>>  =============
>>  
>> -Requests link state information. At the moment, only link up/down flag (as
>> -provided by ``ETHTOOL_GLINK`` ioctl command) is provided but some future
>> -extensions are planned (e.g. link down reason). This request does not have any
>> -attributes.
>> +Requests link state information. Link up/down flag (as provided by
>> +``ETHTOOL_GLINK`` ioctl command) is provided. Optionally, extended state might
>> +be provided as well. In general, extended state describes reasons for why a port
>> +is down, or why it operates in some non-obvious mode. This request does not have
>> +any attributes.
>>  
> 
> Ok, so basically in addition to the standard ETHTOOL_GLINK data, we also
> add additional optional extended attributes over the netlink interface.
> Neat.
> 
>>  Request contents:
>>  
>> @@ -461,16 +462,117 @@ Kernel response contents:
>>    ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
>>    ``ETHTOOL_A_LINKSTATE_SQI``           u32     Current Signal Quality Index
>>    ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
>> +  ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
>> +  ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
>>    ====================================  ======  ============================
> 
> Ok so we have categories (state) and each category can have sub-states
> indicating the specific failure. Good.
> 
>>  
>>  For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
>>  carrier flag provided by ``netif_carrier_ok()`` but there are drivers which
>>  define their own handler.
>>  
>> +``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE`` are
>> +optional values. ethtool core can provide either both
>> +``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``,
>> +or only ``ETHTOOL_A_LINKSTATE_EXT_STATE``, or none of them.
>> +
>>  ``LINKSTATE_GET`` allows dump requests (kernel returns reply messages for all
>>  devices supporting the request).
>>  
> 
> Good to clarify that it is allowed to specify only the main state, if a
> substate isn't known.
> 

I described above all the options:
"ethtool core can provide either (1) both ``ETHTOOL_A_LINKSTATE_EXT_STATE``
and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``, or (2) only ``ETHTOOL_A_LINKSTATE_EXT_STATE``,
or (3) none of them"

I think that #2 is what you want, no?

>>  
>> +Link extended states:
>> +
>> +  ============================    =============================================
>> +  ``Autoneg``                     States relating to the autonegotiation or
>> +                                  issues therein
>> +
>> +  ``Link training failure``       Failure during link training
>> +
>> +  ``Link logical mismatch``       Logical mismatch in physical coding sublayer
>> +                                  or forward error correction sublayer
>> +
>> +  ``Bad signal integrity``        Signal integrity issues
>> +
>> +  ``No cable``                    No cable connected
>> +
>> +  ``Cable issue``                 Failure is related to cable,
>> +                                  e.g., unsupported cable
>> +
>> +  ``EEPROM issue``                Failure is related to EEPROM, e.g., failure
>> +                                  during reading or parsing the data
>> +
>> +  ``Calibration failure``         Failure during calibration algorithm
>> +
>> +  ``Power budget exceeded``       The hardware is not able to provide the
>> +                                  power required from cable or module
>> +
>> +  ``Overheat``                    The module is overheated
>> +  ============================    =============================================
> 
> A nice variety of states. I think it could be argued that "no cable" is
> a sub-state of "cable issues" but personally I like that it's separate.
> 
> I can't think of any other states offhand, but we have a u8, so we have
> plenty of space to add more states if/when we think of them in the future.
> 
>> +
>> +Link extended substates:
>> +
>> +  Autoneg substates:
>> +
>> +  ==============================================    =============================================
>> +  ``No partner detected``                           Peer side is down
>> +
>> +  ``Ack not received``                              Ack not received from peer side
>> +
>> +  ``Next page exchange failed``                     Next page exchange failed
>> +
>> +  ``No partner detected during force mode``         Peer side is down during force mode or there
>> +                                                    is no agreement of speed
>> +
> 
> This feels like it could be two separate states. It seems weird to
> combine "peer side is down during force" with "no agreement of speed".
> Am I missing something here?
> 

From high-level API point of view it makes sense, but we get this reason from our FW for both cases.
When link is configured to force mode, it doesn't know his partner's state, so partner is down and partner has different speed are same.

>> +  ``FEC mismatch during override``                  Forward error correction modes in both sides
>> +                                                    are mismatched
>> +
>> +  ``No HCD``                                        No Highest Common Denominator
>> +  ==============================================    =============================================
>> +
>> +  Link training substates:
>> +
>> +  ==============================================    =============================================
>> +  ``KR frame lock not acquired``                    Frames were not recognized, the lock failed
>> +
>> +  ``KR link inhibit timeout``                       The lock did not occur before timeout
>> +
>> +  ``KR Link partner did not set receiver ready``    Peer side did not send ready signal after
>> +                                                    training process
>> +
>> +  ``Remote side is not ready yet``                  Remote side is not ready yet
>> +
>> +  ==============================================    =============================================
>> +
>> +  Link logical mismatch substates:
>> +
>> +  ==============================================    =============================================
>> +  ``PCS did not acquire block lock``                Physical coding sublayer was not locked in
>> +                                                    first phase - block lock
>> +
>> +  ``PCS did not acquire AM lock``                   Physical coding sublayer was not locked in
>> +                                                    second phase - alignment markers lock
>> +
>> +  ``PCS did not get align_status``                  Physical coding sublayer did not get align
>> +                                                    status
>> +
>> +  ``FC FEC is not locked``                          FC forward error correction is not locked
>> +
>> +  ``RS FEC is not locked``                          RS forward error correction is not locked
>> +  ==============================================    =============================================
>> +
>> +  Bad signal integrity substates:
>> +
>> +  ==============================================    =============================================
>> +  ``Large number of physical errors``               Large number of physical errors
>> +
>> +  ``Unsupported rate``                              The system attempted to operate the cable at
>> +                                                    a rate that is not formally supported, which
>> +                                                    led to signal integrity issues
>> +
>> +  ``Unsupported cable``                             Unsupported cable
>> +
>> +  ``Cable test failure``                            Cable test failure
>> +  ==============================================    =============================================
>> +
> 
> Not every state has substates. Makes sense, since some of the main
> states are pretty straight forward.
> 
> This feels very promising, and enables providing some useful information
> to users about why something isn't working as expected. I think it's a
> significant improvement to the status quo, given that a device can
> report this data.
> 
> Thanks,
> Jake
> 

Thanks for the comments.

>>  DEBUG_GET
>>  =========
>>  
>>

