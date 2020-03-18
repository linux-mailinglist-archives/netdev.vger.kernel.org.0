Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5829E189C91
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgCRNHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:07:37 -0400
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:53000
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbgCRNHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 09:07:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LA9pOCW5bjJGAOESTqaNfKEkQdOw65Nm3lIgwouFAYfgmqGYn3LKoH3H4INaNRdhJqxPvHKmpS4wNFQPoM3EIshZLNmdee5NYh/kPeB73js9yYABTk44LxxcHJ6Ll9UWGq+EpjqHhzc+2N2wtqham5XtY1AIfVZU2ehdrJonTq0L/XNz4qSaHQTWoVYs5OFXtMzyENaGsMBkJkw37tU1Xmc3F4JoDJ0fNcK7EBUrTD8wFQTZ0XE/h9ookqDixE0vvZc49aLuBM77iNwEa+op6CbNM8ammItFsqVtQt7tzlTCjAVbmoC4u52TgH9QmrfcJQ9fndqNBDSyEPBbwWuwsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtZNwiXc/MdbPQ/wpTDfV933hBOKEZXAqy5Y5Ut3Azg=;
 b=c91OqbIcLiQcAqHfU1mjK5ujl+eMcHB9hBOXCI14tzahGgO0FUy/bSwAqUi4YgqZCwgPRk9EhbpVJpxS69fH0rfDhESA5twzHhgCMuI+mT5/wmZGQFzMWjjoq82uwaNp73xhoc/D3l1zvr8odiJGRUr364AqFuDZrUUfVsdP0lhZA9D1ScJimgP7rwjLixOdHW9aXBQQOWU06eMlcWpV8Z75hpzSgzL6988HGZfpj4XlQKiWhM+7YW8EsGLh5Wq1F/qfxuNmlNQfeh3b96FHtP5fcd3K3L7uJEUXPYnNCNvtLw3QKwebvIE8qYaXRWukRDI0ni6Fz8/1K2S659ps2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtZNwiXc/MdbPQ/wpTDfV933hBOKEZXAqy5Y5Ut3Azg=;
 b=WWIcAU2i3B1HBNHQbY2UkGjI8VNADNVi0aRkkvswrmYPm5cdXPOXU3sdxzJ9T/iuZvxqHZ/3BNcNmIAw9+kKp0DI5clVy47UAkqWze+lSZpvv5cXFjNklK7KMzGYPiCa+xGuMAPwip59SHuGyWI/qyqMIZz5yzYDWfNMQo3IO+Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB5016.eurprd05.prod.outlook.com (20.177.36.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.18; Wed, 18 Mar 2020 13:07:34 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 13:07:34 +0000
Date:   Wed, 18 Mar 2020 15:07:20 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net-next 08/11] s390/qeth: don't report hard-coded driver
 version
Message-ID: <20200318130720.GW3351@unreal>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
 <20200318125455.5838-9-jwi@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318125455.5838-9-jwi@linux.ibm.com>
X-ClientProxiedBy: AM0PR01CA0041.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:e6::18) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::393) by AM0PR01CA0041.eurprd01.prod.exchangelabs.com (2603:10a6:208:e6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Wed, 18 Mar 2020 13:07:29 +0000
X-Originating-IP: [2a00:a040:183:2d::393]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8c7a9ce-8be3-4050-dc73-08d7cb3d501a
X-MS-TrafficTypeDiagnostic: AM6PR05MB5016:
X-Microsoft-Antispam-PRVS: <AM6PR05MB50160712A9E944C36EF28E2CB0F70@AM6PR05MB5016.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(39860400002)(136003)(366004)(376002)(396003)(346002)(199004)(16526019)(186003)(33656002)(6666004)(8936002)(6496006)(52116002)(86362001)(1076003)(4744005)(478600001)(66946007)(66556008)(66476007)(6486002)(9686003)(4326008)(2906002)(8676002)(6916009)(54906003)(316002)(81166006)(5660300002)(81156014)(33716001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5016;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzEvqAFYmYSr9aPVNHde+kntU85AmuaB/czFR4RfYZEzCTjxgUCsAxS3EzMBywaH079sGhV88bdBP714tJR8nfkneNeUben+r4Yn7BTXCYWez3dwqab+Tu3bLnJQxWpJQmnMqYFNeqUBolwOvHqTp5GQKPo1n0wNrLCtSNgn0jdNfr1nTcQxEREARfcUosfkuZ7qzw9BuXBgmlN5X2Uw+KNxrx/uwu1bes0JFkK8hsT9ic2pFhDte/4dyKIYRzNT7pwWuqNL3cItjSWyodhMPvY4WvFNGzzJAXhKTjnbunSr61F3TPhfYBttbdAGVQDSLE416/SnZIw2sleFumvk9LqNgTc+uMu0JRNxg3PCCdbtz9y02xJ38zgwta+xrrNNiC2mQbSCKukxyIuhh7EeiFgbUT9bOXQOu/D/0bWjSXgg4GyRQpowCldcgcFyWFJ4
X-MS-Exchange-AntiSpam-MessageData: sMb/2ybHg7hshYdu2q/dTrqHFjc1IrDAdnAv7frCG12Q/zWN8FIjcR+toC9XXCxedR/9o1J8AyVeSzSsK4gih3HRN2R2zSOfuWXKnigVlnPfRtenCfMtC7gfwhK3YlvZ9T/YvDmq3HAu1qmawsjW37LNYtB28xTJFP357Ih9O3o=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8c7a9ce-8be3-4050-dc73-08d7cb3d501a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 13:07:31.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwSK+7qCyR3CxXzjPNG0NajwMI29rRCsVzS3PFoIdyonf40qB1w5qv3U7IatKH5WxfMzg/BiEck++xBkNtHJ4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 01:54:52PM +0100, Julian Wiedmann wrote:
> Versions are meaningless for an in-kernel driver.
> Instead use the UTS_RELEASE that is set by ethtool_get_drvinfo().
>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  drivers/s390/net/qeth_ethtool.c | 1 -
>  1 file changed, 1 deletion(-)
>

Thanks a lot for the patch,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
