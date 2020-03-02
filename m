Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B31751B3
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 03:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgCBCE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 21:04:29 -0500
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:44973
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726673AbgCBCE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 21:04:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXqMJtZNiomE+Ahd5+ScR1ZFHxvvkoD0WiLtAUVMhAivdhxhlF7id9wdgqPDtx96bIDq5+dErAz/I45pYPLkJFsVOO6nwWIHwij9ABQv/UGQ2kszcRTKRpmt/BlNPD3w7CkhRrdak9wx95bFRaxQkfp0xSW+ZuInIiOd95wrCnUYoLtTcIqKeHywOLaW45PFtwl83jrfF25JAju85cYCKrE8NA8s/9qX90DoT882mIq6MYRGo0UTDGG0p8w4XIbX897MbXQZRyGlGMwdKlxdJs53Jw5LwoCYX7dOsBoqye44wOtrUf7aCEHYSucZmBG/ZA5iIXdeSxbUJGG5v2OL/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1d7zwYcGAeo4QoCiEHh822N8Mr0MKE7cOFcfQfH9w6s=;
 b=bHVivNvYJLZcqCU2SY+WtgFp9XuB1XB0tMPxNBsxCui43RFZjiVhxRq5QK+IawNUFury8a73K6GZ3zqz3LIUGr6uJeU0ERefoD/jmSw3G8svOBJcgVxad29eWZVEyJlkooZqaQfWtULtp3JQpHbUhDDnGBk/C8I75fxIj+usYgerQGn8JDP3hV7VNo8WNAx23UAYpmj+QAqQi6EfJRZMbmYckcI1dQ7N9ydjinN2c4dJ7LTWaR4mgwcTsaFWclrD/4cE09UmzFIOFEHNtwLVih9D0iQ9+DSzaCsUu6bW/SjHeSI3xFAsMmhE9QbadrDR89jggnXHyexQqHLkk7tYIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1d7zwYcGAeo4QoCiEHh822N8Mr0MKE7cOFcfQfH9w6s=;
 b=jFGmuEbHV1ufU20ztTjIUxqVZMuei088Y0hohRwYSVgb0Dq+MEha1kONKB06jPgXs6kqlJvV9vMbCxS/PsUso26kIG6zYlHgZsZhkXNrCzVCn7EFdcHlpO3vsnGbJZqJFH6bah/EjgvKLNB5oK+k3VgpKH8LhF8IObC+irHuNv8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com (20.178.127.148) by
 VI1PR05MB6493.eurprd05.prod.outlook.com (20.179.25.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Mon, 2 Mar 2020 02:04:24 +0000
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::30bb:bd37:e18:ef64]) by VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::30bb:bd37:e18:ef64%7]) with mapi id 15.20.2772.018; Mon, 2 Mar 2020
 02:04:24 +0000
Date:   Mon, 2 Mar 2020 02:04:20 +0000
From:   Jianbo Liu <jianbol@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Message-ID: <20200302020420.GA14695@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
 <20200228004446.159497-9-saeedm@mellanox.com>
 <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: PR0P264CA0056.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::20) To VI1PR05MB6255.eurprd05.prod.outlook.com
 (2603:10a6:803:e6::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mellanox.com (37.142.13.130) by PR0P264CA0056.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Mon, 2 Mar 2020 02:04:23 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2fe644a6-c728-4f8c-a3c8-08d7be4e07fa
X-MS-TrafficTypeDiagnostic: VI1PR05MB6493:|VI1PR05MB6493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6493173A71CA2AC76995C7B8C8E70@VI1PR05MB6493.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(189003)(199004)(54906003)(4326008)(316002)(86362001)(2616005)(956004)(478600001)(2906002)(8886007)(36756003)(26005)(33656002)(16526019)(186003)(107886003)(8676002)(6916009)(55016002)(8936002)(7696005)(52116002)(5660300002)(81166006)(81156014)(66476007)(66556008)(66946007)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6493;H:VI1PR05MB6255.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJlb1hzilnLd3FgRq1Mbh9t4QCYRH5ukmJ814vg24et2daNJn6v7cYlovuXTjCnHmHz8XUnmVnuF1k/cGPCH7j4OqNjzSbeilrV8CH+GzovUU2wZA+RAv37ay2NmOdzpxcN5fdtSMXR6fnf/u0jjHbWyiHhMYfXXjCzhObvS73asYoIjrjU2pd+g6POTbplvcQIRwF73GD4yV32Y2/rXq49DSU9qlJ0u0LqQK6zluko2gEkp9VBft97eY4LtYJfXWg4coh+cGgh2wq0IB+T/sDsMeS0dU57rbf3n0ok16ptzhe4kWR+e4q8KjScFPhdNfM50MMnCX2TPbIFKjxr3EvZarB9WgzzakOo+Wf/VE3BYFHr9C15Uojdaez7AN0COpGjIDawUvx/53xFMiaLsfwztfRVGCR6/pMmv2/zQbUz+Bg7ldb+QDtC3nLhVAvE1
X-MS-Exchange-AntiSpam-MessageData: HggrXlcGCmKmqHmEnXFVRD4psgss0KwLRgFEE+pObJxo/+96ot5YR19XD69Sg8sISpQe6oliW6KMlNRMX6kB8UezpjOUA8K28o3kqedp0M+QB8VmNnz/IaqFSO7R8mb9A5YR1wXdfa217VlM6ozvIw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe644a6-c728-4f8c-a3c8-08d7be4e07fa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 02:04:24.8356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NziY7GYzgQWqV0syA1JkHkZpynDVzuu7pcfzqtjob+2gRMP/07kMddlvbDaP0KnjnJFHRFKvTp34sgyUpKSN7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6493
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/28/2020 11:10, Jakub Kicinski wrote:
> On Thu, 27 Feb 2020 16:44:38 -0800 Saeed Mahameed wrote:
> > From: Jianbo Liu <jianbol@mellanox.com>
> > 
> > Add a devlink parameter to control the number of large groups in a
> > autogrouped flow table. The default value is 15, and the range is between 1
> > and 1024.
> > 
> > The size of each large group can be calculated according to the following
> > formula: size = 4M / (fdb_large_groups + 1).
> > 
> > Examples:
> > - Set the number of large groups to 20.
> >     $ devlink dev param set pci/0000:82:00.0 name fdb_large_groups \
> >       cmode driverinit value 20
> > 
> >   Then run devlink reload command to apply the new value.
> >     $ devlink dev reload pci/0000:82:00.0
> > 
> > - Read the number of large groups in flow table.
> >     $ devlink dev param show pci/0000:82:00.0 name fdb_large_groups
> >     pci/0000:82:00.0:
> >       name fdb_large_groups type driver-specific
> >         values:
> >           cmode driverinit value 20
> > 
> > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
> > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> Slicing memory up sounds like something that should be supported via
> the devlink-resource API, not by params and non-obvious calculations :(

No, it's not to configure memory resource. It is to control how many
large groups in FW FDB. The calculations to to tell how many rules in each
large group.

-- 
