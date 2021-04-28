Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4386C36DA80
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240861AbhD1O4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:56:21 -0400
Received: from mail-eopbgr80118.outbound.protection.outlook.com ([40.107.8.118]:50849
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239904AbhD1OzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 10:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gC6vVXs2QIenVaIb5PemuhH+XMLCdOY+qqowWNY84hVXBvPuiz8TXWgX09ZV1j9vJEqqWv30hQ1IMygYcKPkv/Jq0URT6qrN6HUVaVT1ONxo/Ado3ufMlK4N2TeKC1GUzgemc1Plt71v1YGSUAB/JtZTeO50Vu4gGCkr9aubDnttYf8+Hig01iMUJdQNNe3wc4yRKefYIIxa1hgG4hQM/WFI/hXb9uvLIfKfsdjRRmKsgaDLiQwMi78Jde/TBk1OD6ASjAEWCPib8WI4wNO6CwXjSuZeiKZuiudHl/yOc/NLNoF6sETKoCggRzIhpbAu72KfCrRiAOeMhhC//rY94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mur6xXsCedE+NzT0TNssfFauiuVi79RglXRgt2zh3qg=;
 b=ejrPQbCwEZTllq/Dh2z7NzuhNkWEBoracWke9dtFbnKn7GFmSQjYFs28LosbyQ9EMUq6Bgoj+WchS7alIj1/nM9q5ZpWKS6csmW+hrNiZGXQBnG8modoQqGBLoJdxzYQ6Ag7brxsT9gS4uviR9b5/xqoc/4FlS/GAGGF7Kmbqf5O0eYWKNP9lTk+gpWLMxRFrm584aPr+Le9DGPSqCB9i74H5chs03/BGDnqhTMDjxFZpCavqoPtw5ikFn8RyfTkg6ZD4iI0w8cgDkSv0yLaNhRyrKUsIevLkhodKKQSgCzMImxS6glDPT90xRj2RNTrMBhBMxXdqpvXeVs0iUxiUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mur6xXsCedE+NzT0TNssfFauiuVi79RglXRgt2zh3qg=;
 b=W7+WS8VWflE3KXXyVqtQs6UvjS/pii8HWO3STrcKlvxMt21VcLqBnLmdcD2kQSq7T2W1hvR3KY+jWFxfMq/EDWgu3krhiGyBorDOMuG4O4H9tHl8xiXAPX6q8yHWWiWyQDwX11XSKji0Gjni0a++xyPwGvOqhDH7ffhn6Jsy6z4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.25; Wed, 28 Apr 2021 14:54:37 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 14:54:37 +0000
Date:   Wed, 28 Apr 2021 17:54:34 +0300
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
Message-ID: <20210428145434.GD9325@plvision.eu>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
 <YIL6feaar8Y/yOaZ@lunn.ch>
 <20210423170437.GC17656@plvision.eu>
 <YIMLcsstbpY215oJ@lunn.ch>
 <20210428134724.GA405@plvision.eu>
 <YIluzFlPtSRvS/dR@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIluzFlPtSRvS/dR@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::29) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P191CA0016.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 14:54:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6b4fb35-e5b0-44c3-d1f3-08d90a558aab
X-MS-TrafficTypeDiagnostic: HE1P190MB0026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB002683157157AD93D406B31A95409@HE1P190MB0026.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LtJ/p5XN3HIxY/xoQiwCVAWgL5BBOJVnL0eA28fQOD2e73gv3c69Nuh5qIPj9IDm5whdTldhjtWQXYUSdgdom53cElJW9FuEQc2jxDq5/wr4dHq4msDrjNTJDTXYvOmRxNaruujUq6sT91KdsML41DruF3SYzK/6A1E0jGAddKC387ADtBeo4idRwgkwJFtv7HhVft0VZmhlRwH6KsHFZI8Vbqcwg4i/7pzp3anYzGFqE2Vy9IEDSsAW8c3YvqGErUKiCC2eyNB7Kj3ynr6Z1wRcPQox86LqB6bJ6FElu4U/LliceIIToQzr1c4+KvWMEI6zUw9zg2n/S0FyZjUL/x5GKRrrJLammAAHOd9uFjNsoc9TY8RWyCouyX2yrM9umQhvQ8NtRLC2/kZznw+4CU+FVBqfbP56f/fZNXefBDufS0g8XF57AXoD32kxTcdao+sX41Cz9P8jU6gc19nXnvgYxcs6iksYTqYaf6EBsNAR/CamSe/GpnT5JeuXomixVHyGF8QSlV01w3SDEggsGocYJrRDBevFldDDXvKGoRoCgsBvcl9lO4H5KtsDB68P1JPJYEYMmzKLSZKJIJwpeKpo1Ql7Y+cypcKzwJPISyGea9ay3FG2nlB1w/2adUjxR7QCpfY0KJWUaCYFrBzd8H5CBzjeRTycZuo68Ef14HA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(376002)(366004)(136003)(396003)(55016002)(36756003)(316002)(16526019)(83380400001)(7696005)(6916009)(956004)(8936002)(186003)(38100700002)(26005)(44832011)(33656002)(2906002)(478600001)(8676002)(38350700002)(5660300002)(8886007)(66476007)(66946007)(1076003)(86362001)(54906003)(52116002)(4326008)(2616005)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2NyiTAPFaCLcJtGghQzfA//qFFL8ICR3R0lFvwyCKxzEhY0ecQOImrsp98fA?=
 =?us-ascii?Q?/YpQYAtR9Cs+S4be6yyiFqyDrRM45UquAlo9JvBafX5Yy7Ysty9MfSt/f9hw?=
 =?us-ascii?Q?CIiU+M6etfbG7VMijBswEmTlNqZu4PEA/1ga2UlEaSHy2hf1P+vx+Jfi31lJ?=
 =?us-ascii?Q?wuq7BSKvVL6d/RJNCR3XiuVhPYXQGaocET3mVeU3gMyTnh53DgZwuhNeNF/w?=
 =?us-ascii?Q?l1u1YjGsEuscxH88TCv9seXZ453NZUnuzVw6Y9EjSkha2Vi3S8OW+SrVSrrR?=
 =?us-ascii?Q?kR1nGLIUcCLPGP9jjUrXDu0knk5C+zK6cKgagPbB9ourn3wRSjzA46zF5OXU?=
 =?us-ascii?Q?mVelHtiZjSP4/Kj9FRO8lJHEuyiP/1H9e+HGDThm1J20jfffj2ugzDgoGF6N?=
 =?us-ascii?Q?h7xAhRX/9Zu28YDWv0/QfITwe6gp2gnMQZhgeX46dzwc90D4rTsQe+SoxpUO?=
 =?us-ascii?Q?YJo4ghz7cR76mTKP95uQ7G9c7ugX0xJdfVFlvWH66QgLqt6ZaSPtOTfmLvK+?=
 =?us-ascii?Q?Bob/GcY89WrqofcxxYiM8A/VptLs1tA9DnKX8Lc3ZFYakOfplNDBOuz/blZT?=
 =?us-ascii?Q?Ey1OhKtYk0yEiu0NYSvXqfyKaOkJJMJlNgcXVCivnrQ53Uy1mIoGfqI9DgFt?=
 =?us-ascii?Q?+MZVzj8KXek7d77J3Y1R+fCLB0LjCXDXZLkhBxQdbACV5fVB94cEBNt9rTFG?=
 =?us-ascii?Q?EcpfW2M7dvYyFXhWCB6Zy7iWl61dI21AzKTteOm8c7faPLWZN0j8PY9THXZQ?=
 =?us-ascii?Q?plT/iQI/3zQcGHeIePcqlpRlYPNTUB5N0lyH8by+nZRdTf/T/TDS5A4hJIeY?=
 =?us-ascii?Q?x8mu16YIa6TSFv9wP7wDOnJlQVIcXchp50wJcIvn2Vz57w/xcGNDYA6/m+Sy?=
 =?us-ascii?Q?xMU7PkZdZSg8QYNyh1E90P8iuIwSOHpZUtEO0cPrW2mVX+9iqn5gRhjgbCjU?=
 =?us-ascii?Q?+1yf63P4DaRWF5gdfNS+29yw/xv6v3T+T0sERMId9k5PRW6lkReDTKcupgb/?=
 =?us-ascii?Q?1yQwQ2OZsdkj3Pcxd26005uYOxxtPhaz/5RZSA/6e7KeSNiIfX6ork57fava?=
 =?us-ascii?Q?X0G+EaIlOG/OGzvZR4jRHCOJ3PN8c6NS+Fl8OzCqalIvS+dZDtJHqhWGMmQ2?=
 =?us-ascii?Q?TNGUk+SDK0ItbzIcz75N3pgbe1cfECeckzJJgyD+b7f+Ot4WH/s7HMB3rhRZ?=
 =?us-ascii?Q?I91fWJCtJ6FRVqRFUHuvy+IZ8N4AMISEHLeavw75W18So8pV+gA5LVLwPdB4?=
 =?us-ascii?Q?drqPyTCKTcFhETUm4/VAj2OYioXdOObSzrhhM8MyMFxeDFhTFllf3bVSuSE6?=
 =?us-ascii?Q?jjLx2XgtlJ4wUpc053wbhCGp?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f6b4fb35-e5b0-44c3-d1f3-08d90a558aab
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 14:54:36.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5w/wRjRgSW6A8m6gCwidZIjrdlx9x18xAJPW+IR5juYt4lnC+F4UC2uae3t8DNoj1wQkUd9rRAq/rT3OlPGPmHiSZghh4x4wDitsnMyKlVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 04:18:52PM +0200, Andrew Lunn wrote:
> > Regarding the distribution issue when the driver version might be released
> > earlier than the firmware, it looks like that the probability of such
> > case is very low because the distributor of the target Linux system will
> > keep track (actually this is how I see it) that driver and firmware
> > versions are aligned.
> 
> You really expect Debian, Redhat, openWRT, SuSE to keep a close eye on
> your kernel driver and update their packages at a time you suggest?
> 

No, I don't think these distros will keep track it because they are
targeted for wider usages).
But I think that NOS specifc distro (which may be based on top of which
you listed) will do it (sure this is just my assumption).

> I'm also not sure your management port argument is valid. This is an
> enterprise switch, not a TOR. It is probably installed in some broom
> cupboard at a satellite facility. The management port is not likely to
> have its own dedicated link back to the central management
> site. Upgrades are going to be applied over the network, and you have
> a real danger of turning it into a remote brick, needing local access
> to restore it.
> 
> I really think you need to support two firmware generations.
> 
>   Andrew

I am just trying to clarify if it really worth of it because it will
lead to the hairy code and keep structs for previous FW version.
Ofcourse it may have not a big impact if it will be possible to handle
FW differences in prestera_hw.c only.

I really appreciate your comments, just sharing some concerns/doubts
to discuss.

Thanks,
Vadym Kochan
