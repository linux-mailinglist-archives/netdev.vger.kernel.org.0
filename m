Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4B23697E9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243153AbhDWRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:05:20 -0400
Received: from mail-vi1eur05on2125.outbound.protection.outlook.com ([40.107.21.125]:10124
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229549AbhDWRFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 13:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ctsw0P6B78bp8VtR505ftnZCXb4DLMPOc6OeA9BaprA8cgXxrOQI3kPtJOULh5AiHEMjdjbnyBtf2cE0z+XxJqGLkU23P47m9ad5XhazoTbor6NlAV1FBABgbyggIJJb2pWosYizpN1tbsJpHQfgLDGoUrRKJfR4aptLq+thWU8ugaeRE7gs8sdakSeizSLDyydy72/fR6J99XuA0oMOSseQLflOns5XkhbW4nS/NHRhwSWJFEGcZUwobZDYg2Gdmf3qsL8rbRhhRAkgkLkdjEBvQqqBNnarL9Zam1uPcp/Tuwb3poxShzuxiioaCY68/07LgmehO+qAC+AGrB09rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW5wje2Cfc8Lx+PRnXuZCrF/3mWm1sXM6qVMJQO6O+8=;
 b=IMMwW55xY+eNupdgzewU00LoN5b3nh5WH/9aPJ3vsGvsGUi8DgBnBgJBHpZCGrYu1YVn5tl4Jgeyd/aREHkYbiPWIuWnShEqAKvwOHi3gHqGi2nXDUmR0veH9cZELK5uRUOTMvCh2YhNXuo7tWSbmCwIgFGiJhPs7PFvJevh0ZEpZFidAqcWmmeT9/GYvLsxtmVfu0nIxbbPN23ywPS/sAIcEx9lvDbgy6+8NqK3IQVDysl02bOu9cxKe2LukQwruv8uFTP/wL1xZlJsU3oU6S12qsuSgks20T/bVaEai8mX4R3Hgg4nJyVdSUHEudhuWUjbFVP7kCflBWcu6g5sjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xW5wje2Cfc8Lx+PRnXuZCrF/3mWm1sXM6qVMJQO6O+8=;
 b=wapgNvnly7WrNqGgTTlHYp/LPdXrXjFyjw5e5Ds8Y602SJyvwtoaGHvdVxoVJmRRzSA4QgKjkGoAzNL7/nx/sDNBNbg3tWEoN7Yn2GhaE8B5WeTlojfF219di3vtmu3p/yCqYpbXuHxBJ2SxPQ0AS0Yh0SCkdP8H2EuSfyX3h94=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0396.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Fri, 23 Apr 2021 17:04:40 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 17:04:40 +0000
Date:   Fri, 23 Apr 2021 20:04:37 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/3] net: marvell: prestera: bump supported
 firmware version to 3.0
Message-ID: <20210423170437.GC17656@plvision.eu>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
 <YIL6feaar8Y/yOaZ@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIL6feaar8Y/yOaZ@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P194CA0011.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::24) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P194CA0011.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 17:04:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2ee1883-a871-4589-6acf-08d90679e1e4
X-MS-TrafficTypeDiagnostic: HE1P190MB0396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0396A4AB6FA1F59AC8A57FDF95459@HE1P190MB0396.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EmPssA883VhXaM2DdxKYmP8+1zv8XRGArYsPMo0dkzLkfOQ9H9u6Hqi6OeLvpU97AMxVYSlolJbK6N1RBqSF0qanS9E3brPzGAu5zFeccJSBXCmSZ8dsYtonFhcTVl2zQfE8sp6eEIsqTe+gNMBbCkO0bVe0eA4ycGMnda68TKET4s71nA/FvyDjx5ZhkfxPzXGKsLWlj+tYYV/MUAonVFnIKsGmZIW1zL0RYBxQ2xgg4jcit8vc6twU5WdiW/QNi7OJeqnKAvgF0lL4/Od3l7Orm4gEdRq43TMQ5foU0EnO5BtN/x0RY5dNsz74GPMBZvVWSgRjCYvwXoE8hXfa33Medk4xmWPWaPm90IuxtH7Rc2VMNilCAg33P8SLvhkUObLRjZQcanrioyaxriz7jspm4avHQgT1ZL+FA837SDkoJV42FUD5CD0+V4eRAjgZv41timWhs5DBmLROQMlEtzh3w5f6OgnCZCo/Lc2U5S8QoUPyR/TpKzUPQ1D3lQo1cBS3u08Fnwj8G8nLO+uyQia2pIwrgreZdroisHkGr9Ty/L+MXO5ST1990YqFhmu8an5j3Qg07eQGlBKlIvZc2+T8rw921nuyPa3AXtTW7I9b1fsqolRecl4o33Ujl1YICUsBf39CT3PNsZi0zLZAbCSXcMdnXZMqSMpogO+sbQs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39830400003)(346002)(186003)(4326008)(2906002)(66476007)(26005)(8676002)(52116002)(16526019)(8936002)(66556008)(44832011)(7696005)(66946007)(33656002)(8886007)(6916009)(38100700002)(55016002)(5660300002)(38350700002)(83380400001)(956004)(316002)(36756003)(1076003)(54906003)(478600001)(86362001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kqIIlJITR1VKvvdTKj7h1qYofkd0WZzk50py5H4t+keGGsnX15ZffUIxUWVb?=
 =?us-ascii?Q?vaEXGJ9cFAnoheWhV0vNopwsUfbuVD1kwtZLMVIEtTVXatRzDAskV4z0TKaY?=
 =?us-ascii?Q?HL/EV5cyBDkSW+kruI0HaAjov3RoR+3YJzn+6Wx5uhxyFLnwtHzBL3cLNN+U?=
 =?us-ascii?Q?TSDOnS4iYLoMSu2FudnAOjLeIozLNA5YEv7hzIDErIlHqT2kWnaZT5QVD5vW?=
 =?us-ascii?Q?VNChOGu2LSD8djPqO3NX8KR38ANmqNlPZgxsTNgw7HPC75C1xIb3wSt01C4V?=
 =?us-ascii?Q?lJc17HihxA0WLZgFCyEO0Lg5xf4dT0AXsQpfD7boB3J31Enls93B+VjxElTu?=
 =?us-ascii?Q?OCGrJJ+ZxcwzlSwiJGL8LekAQRdNnkhPzjeBsGVOck0S1tJi07tniDdEEa+4?=
 =?us-ascii?Q?cDFnPwjE2w1WXz2hroA6XCSn0L3s+Bv0BYA7Ex9PrCfJMuayt2Owfxasjb2W?=
 =?us-ascii?Q?d62R2Y/6OVduLDUYvKDJh3mO/d4mDHxrNiJPW8Pp8JKJB+qlk1DdVnUrvTzy?=
 =?us-ascii?Q?XMQpYDUYBClw+9kPpRRVF/0ZUBHVf51nY21dOjRSPcdzhB3Zr4S2iHeHOMNd?=
 =?us-ascii?Q?CSsH7Lnll+F23E5KUst8GYbPHufVIItljoeq9mzgyCYWE0/i5wZH4UtDbHow?=
 =?us-ascii?Q?OKGKWd1miWK9AXvX/WhPJsKHdePh8OB25iYIk9vcwRvauKHxtH/eFKtukZ3T?=
 =?us-ascii?Q?5QmLqqXo45Usi6O1deQMV76auDrSY3nnTqIBY88m2f30kham+3Hz+DGNq40X?=
 =?us-ascii?Q?jyYoUcNQAoeFv+oD2n/Vr1EcSvmBTbsMlOaj5shjiwzxu8PeBsX4oYqau7fh?=
 =?us-ascii?Q?4CqAObiPr2xWN4nXF50a8N51+FAhITZbkpKtEoZlysvNvaI0Q9WZvUD1cigp?=
 =?us-ascii?Q?bQF2MthjxvEK+A9Ivq5je7qohfuY7JinPcHtNh0laNEVnLcQ0JhljpC865Ou?=
 =?us-ascii?Q?NKeSG/8GvDI2ClaSpM0Ab3a+AOD16pjt4/iq/dA/XJ1RO9w1OQdP157fglPj?=
 =?us-ascii?Q?18sFqnyE6YQzfdjvJzuk3Y5g6JiGkJhrCd3D1vUZCGAe/uzpXKM5QwPu8JW8?=
 =?us-ascii?Q?1M1xlks4yQ5gyZpiDxW6z6ATo2R83gwPdIhQjTZefSr+DAcR8ikL4+zjj+sc?=
 =?us-ascii?Q?l5CQdlD2rmIVhoDRHqWgvf5bq3MmPuuTlL9WQj2xXtii9tHgwSEWzGKn1MNE?=
 =?us-ascii?Q?f/OGNBXpHR8WTn8pNm1MCfB9T4U6xhq3QlYvlBaoEkXwqVEEG//04QNcLtfE?=
 =?us-ascii?Q?RZCsmYRUg2i0k0LslnFm/o46l98rbbmuU28VAnhNMjWPi7hwaCVxfPh8ZDEY?=
 =?us-ascii?Q?PQBHos8/eIe+8Qzu47gJO8sR?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ee1883-a871-4589-6acf-08d90679e1e4
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 17:04:40.2597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bn19tGegwpAPhNRaVgpPUejVW/GJS8+lJS2P0RZhJK+ZdzJEpETwQo9kppwXpcSToy8UXeQU7NrEj7qvgjR0KxFzLTn2JpH5HWWXsO6BuaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Apr 23, 2021 at 06:49:01PM +0200, Andrew Lunn wrote:
> On Fri, Apr 23, 2021 at 06:59:31PM +0300, Vadym Kochan wrote:
> > From: Vadym Kochan <vkochan@marvell.com>
> > 
> > New firmware version has some ABI and feature changes like:
> > 
> >     - LAG support
> >     - initial L3 support
> >     - changed events handling logic
> > 
> > Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > index 298110119272..80fb5daf1da8 100644
> > --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > @@ -13,7 +13,7 @@
> >  
> >  #define PRESTERA_MSG_MAX_SIZE 1500
> >  
> > -#define PRESTERA_SUPP_FW_MAJ_VER	2
> > +#define PRESTERA_SUPP_FW_MAJ_VER	3
> >  #define PRESTERA_SUPP_FW_MIN_VER	0
> 
> I could be reading the code wrong, but it looks like anybody with
> firmware version 2 on their machine and this new driver version
> results in the switch not probing? And if the switch does not probe,
> do they have any networking to go get the new firmware version?
> 

Existing boards have management port which is separated from the PP.

> I think you need to provide some degree of backwards compatibly to
> older firmware. Support version 2 and 3. When version 4 comes out,
> drop support for version 2 in the driver etc.
> 
>      Andrew
