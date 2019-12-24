Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8E12A01C
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 11:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfLXK2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 05:28:32 -0500
Received: from mail-eopbgr50095.outbound.protection.outlook.com ([40.107.5.95]:6829
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfLXK2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 05:28:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaurMVRvf/NeyqFOxd6+vpyTE8+3hSv0arP3ZhDSZbHhdU/JtyBE65w7rVnBdWDGejoD1EIGz52lJtTsUcT7nX0HuqHQEIQdzCRnTn7Si7j+c83pvp/UrcVrcQaS4X43hn3jZ8fq+a5xCfU/bp96x1nIHT/xfOWGkO5iuHJrxI91wiVdB0nU4H69jYKiYkbOSzzq7OqAc9wrSBOhCx+8JW7Lba6tZsK7LMVmw4ZQd9ubuT3lr9cJ71tMlOHscejO+cRctCw/oAIoIXif14PDGQQLYEw5rk7Q/tknxiZuNq5sIYDQI7Vug9h9ERI7M4/rM2tBOvHG+CzV9dSLtiuoGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DTNrjZo65ISOtFzEG/FPldy+s1ou6FxTqOAyOitf2k=;
 b=LKxUc1umN8+pPRfHnITRciqxl2kqlRjRDdIaLITWyJg5Z5qZNDN4fVGTyaV50NbtvnmF6aIS6ME0aegegE+5Xv4Dda08NJC5UODRgEhYiXM8WmMwXg8tQI7ziQvAgAA5S2TAh8tCfwbKgKZQwptGbpddxrunRzIpF6DicNaBW+Xyyof5qYLQ4eZ5G7iXcdn6u6e6FQl3eKnMd4vDkUgHaxVjIG7CqClMCoc2T0GGMYhU+CE/Y6bJER8TErrCSs/Y/cZJ87vYEb0zS538DT8ancz22U37K/KXKJ2QtWBiRhTTWg0tL21riGjjdd8hm772zooPGg/VZxHTnLLvAMNJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DTNrjZo65ISOtFzEG/FPldy+s1ou6FxTqOAyOitf2k=;
 b=FLIYHdDdzlFh8uAunte0Xb0MeF7jWgRbADteocigtrLyYSrpO4QsueS0q0UKNLxnxE/n874GgeOgGX4uvHqXkKONZAfSCZm430yAmPTQh2PUk68aVP4GmllbAsbCkBR47p980NwU3wVd1NVQ/BSmYwbi/1fV7ZAqxPRcFEkOb1M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB5741.eurprd07.prod.outlook.com (20.177.203.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Tue, 24 Dec 2019 10:28:29 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::780c:216f:7598:e572]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::780c:216f:7598:e572%6]) with mapi id 15.20.2581.007; Tue, 24 Dec 2019
 10:28:29 +0000
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
 <20191204171336.GF21904@lunn.ch>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <c03b1cc5-d5a9-980c-e615-af5b821b500d@televic.com>
Date:   Tue, 24 Dec 2019 11:28:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
In-Reply-To: <20191204171336.GF21904@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0054.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::31) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM0PR06CA0054.eurprd06.prod.outlook.com (2603:10a6:208:aa::31) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 24 Dec 2019 10:28:28 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26ab66a-7704-43e2-54ff-08d7885c0468
X-MS-TrafficTypeDiagnostic: VI1PR07MB5741:
X-Microsoft-Antispam-PRVS: <VI1PR07MB574188F930FA95236402A443FF290@VI1PR07MB5741.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0261CCEEDF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(136003)(396003)(376002)(346002)(366004)(199004)(189003)(54906003)(6916009)(2616005)(8936002)(81166006)(6486002)(5660300002)(66476007)(26005)(66556008)(316002)(4744005)(8676002)(2906002)(66574012)(16576012)(81156014)(956004)(86362001)(4326008)(16526019)(478600001)(53546011)(36756003)(31686004)(52116002)(31696002)(66946007)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB5741;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qdw8g1cswkHs6BPN3rIUCGXMwcnZ4xmVTvHlIHFCdkMeo8bz2lOv0dtGK4tHboQVBoGE0AhJQAn/kLC2jmDBeollf/YRiccV3siJ48gLKs6Rn8g8Jn8rpxY0abrFeQ31B1mpFm/hhH7wmvduDBA9Q+Sauiobs56skb0WTzA3Oa5U9bvBtlQ/4/UJypnUW0F+tbXxcB5l7Slk2DHwn0Hm0GHssJUlLZHgG7kRTYyGVBVD/g0vCvSvnZ1+wLPvqfKHZ/SZTM6GF568vJb40ObmspvD9uO1bL8zy5K7Zl/+7wW8iZw9JnFx/iTebeU7xSBo+amoeVLstEdHpI+dzSCHrspCqlz2TR0w0Z8rj/P1+D4LX/ZoyTsuQ6C0vQjQLTOPIwiI1RhszOm7W3YlSStJ4miDQ7HSm+qc6M7E93/lMlshB5SXazGq3oqOL70v9TEa
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26ab66a-7704-43e2-54ff-08d7885c0468
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2019 10:28:29.1218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBDWGFl3Bjr2ao6sHgAkrVdisDtPFi0Rmm9VjgJKQyzuQDu5HHrdEtlmwwLbYRUHV9Mbl22yB49ZaUEEEcbTIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 6:13 PM, Andrew Lunn wrote:
> But returning 0x0000 is odd. Normally, if an MDIO device does not
> respond, you read 0xffff, because of the pull up resistor on the bus.
>
> The fact you find it ones means it is something like this, some minor
> configuration problem, power management, etc.

Hi Adrew,

to close this issue: you were right: the Marvell clock, that comes from the iMX clocking block ENET1_REF_CLK_25M suddenly stops running:

an oscilloscope showed that the Marvell main clock stops shortly after the first probe, and only comes back 5s later at the end of booting when the fixed-phy is configured.
It is not the fec that stops the clock, because if fec1 is "disabled" also the clock stops, but then does not come back.

We did not found yet how to keep the clock enabled (independent of the fec), so if you have any hints - more than welcome.


Best regards,

Jürgen

