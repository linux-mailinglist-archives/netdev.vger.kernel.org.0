Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D781CDF51
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbgEKPpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:45:09 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:45294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726687AbgEKPpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:45:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aW//jh6o5A5Gy42UA/qhXHdDxHCEK0fEmyJIHcw49m8KSQxnxn0ghiqlPraYES+AAdyIM4VA3sn8vhqfaYAEoqE+OqK5glKa2VFDuEdAgPBpKGLCE7O+SYukiHByIy0DF+aSwrnluxld7CUUJe2x5rb0mgMBYYW1OOs3h0Oq81qRnyoOGg0Osm4Y3VQxA9RrZ7f6blI05xj+SDbwTEn/GlW7CEisRf6RWVGkgsaQ/QB3Rfda2XuqrZgAi2a6nbRB5ffGo2wBa/Swq2Ghy7TL1pRB0xU5gP7T1rpxXPfGf/6gZFIrEkA1WRu0vMSPbbaOcPjaT2Ac0B/ewQcpCGgz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSfRHP01lr9OGIc5afosFB+Tf3156xCfgHwGW4V2CZg=;
 b=YC3MJNsx5LdKS3KESQ2U8m7v782baA5/d3U2bdiktoM08m+GOWKolOOLQPbCeLjpC74Nwhaosasajz4zYDQnZqe6apx17rsqMT9xccrua03Goks+quX1Q/ArnWEiZjLwZZML/jHPp0ISTprOLMLoAC3NjaTUWR+aRssDr2hDpBQcvaNgbV/Z/9QRdwBltDpcjO6uH1nBl4NV5vwLJmTVGog9s7gxYTQnXMXbPMEjMg6N2tVOrQNvT0ImNCA8v0rBsySUQiEOVIa5h+f8wlik2iWdZ9ekPIQesliYeXowOwuEY30lyN6t/UCg/qgK7fCMu/oT8rHkwoNYYnqSXq26MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CSfRHP01lr9OGIc5afosFB+Tf3156xCfgHwGW4V2CZg=;
 b=GSQK32dnSxrwXGExqc9A1WiYsfbbkbFLHPPZmaNkE6ZELmkWTuF2RR/LXMPTJs1th49RzqD8M56Z55KBMvJpuLZBnF4OjYZljaiXmxCR5LuPWMqAM6ngkCXWd5TcOMRF9xi1/OYwtpOxSFxhwfhHSP/J7Xz9RtwwQDinN/XZzKA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=orolia.com;
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13) by AM0PR0602MB3748.eurprd06.prod.outlook.com
 (2603:10a6:208:6::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Mon, 11 May
 2020 15:45:04 +0000
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368]) by AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:45:04 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
From:   Julien Beraud <julien.beraud@orolia.com>
Subject: net: phylink: supported modes set to 0 with genphy sfp module
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
Date:   Mon, 11 May 2020 17:45:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0189.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::33) To AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:862c:3100:f406:ebd3:1008:85ef] (2a01:cb00:862c:3100:f406:ebd3:1008:85ef) by PR0P264CA0189.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Mon, 11 May 2020 15:45:03 +0000
X-Originating-IP: [2a01:cb00:862c:3100:f406:ebd3:1008:85ef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac460718-c68e-4eec-41b5-08d7f5c245d8
X-MS-TrafficTypeDiagnostic: AM0PR0602MB3748:
X-Microsoft-Antispam-PRVS: <AM0PR0602MB37488F6288BB1B7AC4A347FA99A10@AM0PR0602MB3748.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNYX14TyxEOISRvnHLSa7+wUkRr7ukwNmaSd2qOTgkMloExBbxabQBonv/aBbqCwpXnl8G1RJRqX7K0wAkAhmf+sB7jU8goXyZtnA9pvRJD6CIQEbp6Rpr3C1wVd0j6GuOeXuYx7qgbnqK6SkPLbZ3rlnEeZsN6JdccNt9pFKF3g+Ha9XjtjXeR0jHi8P7Fs2Elo/M2dTny7su9GPqLbKOe1HbrUNrQ7RMijYKNHsl7bmVudc6Ijf/NUcvLDGzRmNhh2MOIJqvPjbNyZmflwtRCuAeWUJ2YtyMpfLNk47E0a62TeggjMqT1JsO0uZiVWvbUuYjjFsKgTEPKsdACtKiz32H4USmh8voJdwoUTOuzLTG+8u+jexRIaG2Rc/pG9qHyKg5JmwXZdMl4aq+4UPmsTEFxo0VHbi9IvxRJLXkuSQ7Gpynwp62on4bcQmF9bUgAEYr09N2ALMe81AC3aJ66+FyZlC2DHrgZIm5pCs/wSw3NHEdoxJ8oDfOKIGtAhWMaKDUiGMjkkdwvj7+4u+NJCMf1U7l/oDX/uW04+DJjuy4ZIrTqfYu9Iui3H0Uix
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3380.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39850400004)(346002)(376002)(136003)(33430700001)(36756003)(186003)(66556008)(66476007)(31696002)(16526019)(66946007)(2616005)(4326008)(478600001)(31686004)(8936002)(2906002)(8676002)(44832011)(4744005)(52116002)(110136005)(316002)(54906003)(5660300002)(86362001)(33440700001)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C++Pe5zkaEv+zqJlCuZFRkpnYr4DwySo1aE+1VGjpxue9wGJEkSVLIeRTorZOZ7p+tznMq08NaPIFRuienSQdqpmJ1rBfMPpWjusw+XY7irMdHv2vePZm5mNxDnT+GqLsaLozj+gVF1N/RzI3nk4zBk1OXqxFn+9DFuK7BOKzkwVPqD0s3QlOxsERwPxv0wFP+9mERNcnjv6Y/fR2NUYa4KK3bCaMhNRqAlYYjI/6AWiCkg94Js2OfZ60xJw6GuKL+z1csSIVFJJHXmYkQWL76FwcYErltj2PwIp1fD5IO8WuQ44iQnte+lA8F4UnY86E+mnue9umh24pLU2EJNUevn+o2rMvCfbPg0jilsJC6DlNHXAtG/aKuLjKKe8BWh1k+F8byk+CqXs85CeZKGkRbC4iPiudt+GG4wlclvp7BjjYZ0BAIUtSKNyF0yKv49Yy0UXdSMwFLQ+eg8wmVXOqZoqPnbKBls017z6RvbCg248+xXS6zKeT4so3rTvREOuRWOiQEk8GQGA1lZXAj50dNrkx5OjzBq6aRJTmxnrdepSG21gd9RKNb8hGzePen6U
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac460718-c68e-4eec-41b5-08d7f5c245d8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:45:04.3333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7bnwRAeYRzBAl7SHrOL/4QUNtL7noEot8u4vAcUeZAw2RUWA5CMHPyKu4cfePH5hA5sA2ceEw0yAOm7kFTqU7Z+0a4ZdqSOnDGiSpRDcsW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0602MB3748
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following commit:

commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87
Author: Russell King <rmk+kernel@armlinux.org.uk>
Date:   Wed Dec 11 10:56:45 2019 +0000

     net: phylink: delay MAC configuration for copper SFP modules


In function phylink_sfp_connect_phy, phylink_sfp_config is called before 
phylink_attach_phy.

In the case of a genphy, the "supported" field of the phy_device is 
filled by:
phylink_attach_phy->phy_attach_direct->phy_probe->genphy_read_abilities.

It means that:

ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
will have phy->supported with no bits set, and then the first call to 
phylink_validate in phylink_sfp_config will return an error:

return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;

this results in putting the sfp driver in "failed" state.

Thanks,
Julien Beraud




