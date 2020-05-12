Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4BC1CF19A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 11:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgELJ2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 05:28:47 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:16743
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728525AbgELJ2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 05:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Du5q0qKAAuTJFJ1Pm0c0JrxTxOwGQwxsiYvgqQSuWrIgGszF7BbHXjXcONFXZUzQvGp+4h/JCV0NaR+Mhv6kYXJM6x+e86R+b0ln9lgHZUC2GiP3ebLEUjnbhLzNH0jwnUF5V9mm29XEY11In8+lSn3aArnqXR/6BmMGv6buvUZ3phAdG0Lji44Lmoz8p+6nqCKUQLmgTa6adu565REYsOCA2ZkwzvrtWyBfDlWIoML89zAH30bMmX4Hx/lx9KNeZlrMNnEdkpccTV/LTYROVkCkXyY8+5u6CIX1WkFwzBIjIQRRDM5c3dwAE34u/oqRAROiq1K2Ybgz+0snQfYbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEiMLE2vzp+kUZfHG6sIgka1Tce7ZV1h0dzKjjKTLR8=;
 b=JzbzrSTCcWfWH48M6RlPrH2x4g+ygRuUj8jptf2RQIYKYiJUKhk+5gLjoD0V52fruqvHWVlm/avg+GY9H3eF0ioreJzR/cRgAFPkxDBcMvyoqXtxQqGklmxSKSBby25GgYj4mVmUw4i65/Lr2wpAgUeRRuELjQcsD1Ys30wNZYoFJnP5mMQq21wapyoAiEhm/OUJJyxFw6sw4wOXfCDNdpzbT5fsWytlJTTOuKe2tMbyEIqEdBy3ijGvylZppDU6fNzMkyddfY4FhN/ED5zEx0h45oA4KddUCEf/ymBmHkr2w84mWl3BJfe7+H0kllgdoOID1BNwk14aKbebjMqGaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEiMLE2vzp+kUZfHG6sIgka1Tce7ZV1h0dzKjjKTLR8=;
 b=Ge+8igjwk2r+a+kaKQHc0RQnyIEwsLsQEb3KDAGbZsfUbk2SmsCOWhcL7yBvn+g4MpDeMDS9hxe5XvrYTMvgqvgpYbBuMnTpdfSsZ5M5pb8XkKXn+P3VqLcZnBZGfmyS0m0W0bJ3mrlJjkSCGDR+0XVIq6RiXruzRCsMOmEHMd4=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=orolia.com;
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13) by AM0PR0602MB3394.eurprd06.prod.outlook.com
 (2603:10a6:208:24::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Tue, 12 May
 2020 09:28:41 +0000
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368]) by AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 09:28:41 +0000
Subject: Re: net: phylink: supported modes set to 0 with genphy sfp module
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
References: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
 <20200511182954.GV1551@shell.armlinux.org.uk>
 <4894f014-88ed-227a-7563-e3bf3b16e00c@gmail.com>
From:   Julien Beraud <julien.beraud@orolia.com>
Message-ID: <1b0a20fa-b2ee-e7fa-fdfb-dedabe81b03f@orolia.com>
Date:   Tue, 12 May 2020 11:28:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <4894f014-88ed-227a-7563-e3bf3b16e00c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P193CA0017.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::22) To AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:862c:3100:f406:ebd3:1008:85ef] (2a01:cb00:862c:3100:f406:ebd3:1008:85ef) by PR3P193CA0017.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Tue, 12 May 2020 09:28:41 +0000
X-Originating-IP: [2a01:cb00:862c:3100:f406:ebd3:1008:85ef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04f9217f-1fd6-4512-41bd-08d7f656dc2d
X-MS-TrafficTypeDiagnostic: AM0PR0602MB3394:
X-Microsoft-Antispam-PRVS: <AM0PR0602MB33941177C030A75179E1F45F99BE0@AM0PR0602MB3394.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tPpLII8frhF8USuSMJTYcpYvtyJ1iaIcWZDZkdRpFmYkUJg7qcUqoAtT1jun3gSn2tLdii45bmixVm6CdzhCb5JLnI5DsBf3uYvQOaBs/u46HTlOsWR+aZ5ns4cTJyUQx5KN9Tv+PPgqGmidHRSeqCJUI3572Frnkumms3OMieVlNbuTitvQgzUf5I+y21eIJ3InvJoVX34Uh2qurSYnz0p/tRf1qBDJyvTlYKivRc0QdL84Xg6YE3qCIlGd5QdBJsYslaQTb9zb8UtFhzj3QFjMWnfA+SsBrBSimPWY3L8FUq3UHd5viNH5WIBeiZaAWXoj2dDwQuzlSj6IILcZYZDz9Ldd0iAuSJ2qwWPi0KBVBSe8jejdld994uKTIpTCuWldTReEQiPDU4tpk9xz+0Mj73DT82CD3w1oZRg85kHL7UGHKQdCN9AvpGFv/qDR1aMuVEVmqTTyAsl05vwICIupu0jSYbosVU2q52t3N+WN52GwlIJq1vCY1Q1ycduFGBkWKqlqJxr2aMQiC8qf+i5ApmKUjId/NzBQ/wUpa8TVhSfuVhpE/g8JhvGKjS/x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3380.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39850400004)(136003)(33430700001)(31696002)(6486002)(110136005)(44832011)(2616005)(36756003)(316002)(8936002)(54906003)(33440700001)(5660300002)(2906002)(31686004)(8676002)(86362001)(66476007)(478600001)(16526019)(66946007)(53546011)(4326008)(66556008)(52116002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cfuIbqCowdGs6Wpdtw+TmYq5DvJ2X0IiLjotIZsIMT4UwsphrBa5WIoY1GE3FJIrDi2wA3KVlMOnHGpw6mNAILh4e9iTNRb4LQkAhLl31wzT0tjGCJWLcnGhwbuWlXwC33GDJnK8lycx3qK6Z0UrPpm6vHM3GHXrsb+1RD33aG3Jh18ra4T5Sd2oNMpmar+DjIPXbSJdt0hViutySAbXIEA8b4zLStR5fXvnvvZsbT0LyFvdrTUpsoqcQUFO9+MYP9mO3lfDmwy+KSXoUm3UGRc6fX4VmvYoDpCk8JXNnA3yfV3qx6D4DHtJptEYjwmSGcNe74i8qdTEBiGllq3lbI7W8XXepJpBguX24DkESHz7vWkI0M1YyM+eikwhKXkEopyrB/fyRJWv++J6hr1fWJpQIZ8/WlKXxuIN/ClfDj3AVXh/XRae1gXEYnuxQTu/fXp/O8tN0nFi9CaddutfuOQeNHcRhZnYvNdLHr14UuhkbKEe02pf3oB22tjtjCydDTt5DscHU8JrYE+BS0ZLqsfsMynvGAcGN6IVwvlqRc6qwdbH0WhxUI6zu31xs7y0
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04f9217f-1fd6-4512-41bd-08d7f656dc2d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 09:28:41.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vPpl4P1KvcDgXYSkHwl0tgTIc2PceLur5hotJzwvA3EKIlOZwXFTWkBMY6mKoSt39kvbpj3dibiEOxcBIthbmlscf0La/5wORm+eXVzenlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0602MB3394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/05/2020 21:06, Florian Fainelli wrote:
> 
> 
> On 5/11/2020 11:29 AM, Russell King - ARM Linux admin wrote:
>> On Mon, May 11, 2020 at 05:45:02PM +0200, Julien Beraud wrote:
>>> Following commit:
>>>
>>> commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87
>>> Author: Russell King <rmk+kernel@armlinux.org.uk>
>>> Date:   Wed Dec 11 10:56:45 2019 +0000
>>>
>>>      net: phylink: delay MAC configuration for copper SFP modules
>>>
>>>
>>> In function phylink_sfp_connect_phy, phylink_sfp_config is called before
>>> phylink_attach_phy.
>>>
>>> In the case of a genphy, the "supported" field of the phy_device is filled
>>> by:
>>> phylink_attach_phy->phy_attach_direct->phy_probe->genphy_read_abilities.
>>>
>>> It means that:
>>>
>>> ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
>>> will have phy->supported with no bits set, and then the first call to
>>> phylink_validate in phylink_sfp_config will return an error:
>>>
>>> return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
>>>
>>> this results in putting the sfp driver in "failed" state.
>>
>> Which PHY is this?

The phy seems to be Marvell 88E1111, so the simple solution is to just add the driver for this PHY to my config.
That said, if for some reason someone plugs a module for which no phy driver is found the issue will happen again.

> 
> Using the generic PHY with a copper SFP module does not sound like a
> great idea because without a specialized PHY driver (that is, not the
> Generic PHY driver) there is not usually much that can happen.
Thanks for the info. I don't have an advice on whether it is a good idea to use a copper sfp without a specialized driver,
but before commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87, it used to work and I could at least get a network connection.

Moreover, this commit didn't explicitely intend to forbid this behavior and the error is not explicit either.

If phylink+sfp still supports using genphy as a fallback, It may be good to fix the current behavior.
If not, maybe adding an explicit warning or error would be preferrable.

-------------------
A bit more details about the issue:
- The board I am using has a MAC connected to a PCS, connected to an sfp cage, so no PHY on-board.

- No driver is found for the PHY that's on the sfp module I am using.

- The MAC + PCS driver's conversion to phylink still needs to be upstreamed, and we'll send patches soon hopefully.
I can make the code available if needed, but the issue doesn't depend on the MAC+PCS driver.
It has been reproduced on mcbin by Antoine Tenart (thanks!) by just removing the driver for the phy he is using from his kernel.
It should be reproducible on any board with such a setup. The IP I am using is altera triple speed ethernet MAC + PCS.

- The issue happens when plugging an sfp module in the sfp cage which is copper and embeds a PHY for which no driver is found and falls back to genphy.

The error that happens is the following (call trace plus debug prints plus a few debug prints I have added :

[   27.607215] sfp soc:sfp1: mod-def0 1 -> 0
[   27.611235] sfp soc:sfp1: tx-fault 0 -> 1
[   27.615247] sfp soc:sfp1: SM: enter present:up:fail event remove
[   27.626668] sfp soc:sfp1: module removed
[   27.632415] sfp soc:sfp1: tx disable 0 -> 1
[   27.636618] sfp soc:sfp1: SM: exit empty:up:down
[   27.644541] sfp soc:sfp1: SM: enter empty:up:down event tx_fault
[   27.652282] sfp soc:sfp1: SM: exit empty:up:down
[   29.077218] sfp soc:sfp1: mod-def0 0 -> 1
[   29.081238] sfp soc:sfp1: tx-fault 1 -> 0
[   29.085250] sfp soc:sfp1: SM: enter empty:up:down event insert
[   29.096669] sfp soc:sfp1: SM: exit probe:up:down
[   29.109535] sfp soc:sfp1: SM: enter probe:up:down event tx_clear
[   29.116892] sfp soc:sfp1: SM: exit probe:up:down
[   29.397193] sfp soc:sfp1: SM: enter probe:up:down event timeout
[   29.415422] sfp soc:sfp1: module AVAGO            ABCU-5731ARZ rev      sn AGC14275317E     dc 140704
[   29.425204] sfp soc:sfp1: tx disable 1 -> 0
[   29.429448] sfp soc:sfp1: SM: exit present:up:wait
[   29.487209] sfp soc:sfp1: SM: enter present:up:wait event timeout
[   29.502605] sfp soc:sfp1: sfp_sm_probe_phy, support 00,00000000,00000000
[   29.509396] altera_tse c0200000.ethernet eth0: phylink_sfp_connect_phy-1, support 00,00000000,00000000
[   29.518749] altera_tse c0200000.ethernet eth0: alt_tse_validate, support 00,00000000,00000000
[   29.527311] altera_tse c0200000.ethernet eth0: supported : 00,00000000,00000000
[   29.534614] altera_tse c0200000.ethernet eth0: validation with support 00,00000000,00000000 failed: -22
[   29.544232] sfp soc:sfp1: sfp_add_phy failed: -22
[   29.548999] sfp soc:sfp1: SM: exit present:up:fail
[   29.557243] sfp soc:sfp1: los 1 -> 0
[   29.560833] sfp soc:sfp1: SM: enter present:up:fail event los_low
[   29.566918] sfp soc:sfp1: SM: exit present:up:fail
[   29.677195] sfp soc:sfp1: los 0 -> 1
[   29.680782] sfp soc:sfp1: SM: enter present:up:fail event los_high
[   29.686950] sfp soc:sfp1: SM: exit present:up:fail

And the call trace leading to the phylink_validate call that fails :
  => phylink_validate
  => phylink_sfp_config
  => phylink_sfp_connect_phy
  => sfp_add_phy
  => sfp_sm_probe_phy
  => sfp_sm_event
  => sfp_timeout
  => process_one_work
  => worker_thread
  => kthread
  => ret_from_fork
  => 0

------------------------------------------------------------
This issue disappears when I revert commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87, and the network connection seems to work.

It seems that before this commit, the call to phylink_attach_phy was made before calling phylink_sfp_config.
It also seems that in case the sfp module embeds a PHY for which there no specific driver is found,
the phy_probe function which fills the phy->supported field is called following the call to phylink_attach_phy.
So the subsequent call to phylink_sfp_config is passed with phy->supported set to 0, resulting in :
"validation with support 00,00000000,00000000 failed: -22"

Antoine proposed me the following patch as a workaround and it gets back to working like before with it:
-----------------------------------------------------
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0f23bec431c1..737da4d146ce 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2002,6 +2002,8 @@ static bool phylink_phy_no_inband(struct phy_device *phy)
  
  static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
  {
+       unsigned long *supported, *advertising;
+       bool genphy = !phy->mdio.dev.driver;
         struct phylink *pl = upstream;
         phy_interface_t interface;
         u8 mode;
@@ -2021,8 +2023,15 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
         else
                 mode = MLO_AN_INBAND;
  
+       /* If a PHY driver has been probed use the PHY's reported capabilities;
+        * otherwise we're using genphy and the PHY capabilities won't be known
+        * before the PHY has been attached.
+        */
+       supported = genphy ? pl->sfp_support : phy->supported;
+       advertising = genphy ? pl->sfp_support : phy->advertising;
+
         /* Do the initial configuration */
-       ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
+       ret = phylink_sfp_config(pl, mode, supported, advertising);
         if (ret < 0)
                 return ret;
  
---------------------------------------------------------

I haven't spent time digging a bit more about the consequences of such a patch and neither did he afaik.
I hope this info is valuable, thanks.

Regards,
Julien
