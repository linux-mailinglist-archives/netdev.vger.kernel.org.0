Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE8A1B63F7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 20:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgDWSp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 14:45:28 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:34372
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728081AbgDWSp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 14:45:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekK7x9N/IXsuExhNsWdHHkmBuZ/G/f41XWX25amcox/rDjKCUwG97/PmWKzFLni4H/HsD480W0YSrjr/2d4+THzhBCxb/cYbLj/leWjrH7SP6rTqGmB5cBsHde3hGkTJnoHuBlVm/67VFeyt/pZhRp1k8BFoMLQuyVgnIHL+BDqJPOGjQx0OASbApJwwkMONNsRzP5iPs5iEWL6FZ+UZ3tG3zq6aprXa3Hgo5hXMIQ4G+nl6D/8WuF1jN70jp3sHtZjsTykUYGW2YVSw5vUt8XWyK5ewYqq8+U1jZN2S1wfZTa2Zd5F9LOTXBVTU3o/zuNWsCCmpxeXj4OGI0hBQXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lm50xSImfHc226uAKbhkoOQydLDIx3muaWelM5F8YGU=;
 b=BWLIrZMLOXZVdwquhvW8CYaYZq3+QB7oAhA31f19wBGioOkQP6tpwSfuOdjHo7vqklRcdpgpnQmwyhjTgYroVsu5/OFGN+82KwpNHt3/Yuha45gn4qb5DKrK6Xv80tfTp8IgEjj60l4063XfGeHzZtbYymA3S4Iq/oXUfbisTlIWQc4Gu4SoXK9/0CDNiNP7+CF9SsJdYVU+nQluVqS2/sUiSpzZ8k4Swz7sZnrJzXHUbWmTEupxNnlsKBSmV/KNtqUdO4DNRydJEKlmED/lUOdSLc8bJ+L2Q4mOAFxLoBOTluvEIcD9f8qU2Qb7ff/bmwJyjlZk4QJ/GT/xYZys6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lm50xSImfHc226uAKbhkoOQydLDIx3muaWelM5F8YGU=;
 b=KRo18mTBBUpEXuDZ60M4mobiDzGpu8nUQq5jjN9hQBmJrjziIVJuCZF5Em4p0Bg2QaRbN015g+pbPjmPW0JVcRtD8ALnopUdxcO8IrLKS3DDgPIi3yspmofFhzG1GrKuXtueDBoiLa7QDxpvOGqeINWsWoXm39gFJXWTlIlV8SA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM0PR05MB6401.eurprd05.prod.outlook.com (2603:10a6:208:13e::17)
 by AM0PR05MB4417.eurprd05.prod.outlook.com (2603:10a6:208:61::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Thu, 23 Apr
 2020 18:45:22 +0000
Received: from AM0PR05MB6401.eurprd05.prod.outlook.com
 ([fe80::f980:8d53:a8e2:d7dd]) by AM0PR05MB6401.eurprd05.prod.outlook.com
 ([fe80::f980:8d53:a8e2:d7dd%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 18:45:22 +0000
Date:   Thu, 23 Apr 2020 21:45:18 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 00/24] Mass conversion to light mlx5 command
 interface
Message-ID: <20200423184518.GA3148@unreal>
References: <20200420114136.264924-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
X-ClientProxiedBy: AM0PR01CA0124.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::29) To AM0PR05MB6401.eurprd05.prod.outlook.com
 (2603:10a6:208:13e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM0PR01CA0124.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 18:45:21 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77831e67-30cb-4633-8d87-08d7e7b67a3b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4417:|AM0PR05MB4417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB44170D0FA8CA7A0A98894F0DB0D30@AM0PR05MB4417.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6401.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(7916004)(396003)(366004)(376002)(346002)(136003)(39860400002)(6496006)(66556008)(66946007)(8676002)(66476007)(4326008)(52116002)(8936002)(5660300002)(81156014)(1076003)(33716001)(110136005)(9686003)(186003)(16526019)(316002)(478600001)(6666004)(33656002)(86362001)(6486002)(6636002)(2906002)(966005)(4744005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtA3k0ORtMJdUGnp1XU2xvXX2DwwuOimDHuQ8wl0hPu2ebdDfupaIG9CfYombjidlKfVEjEBa/kP7mTQx4SUIW5wql57/dj0YhwfeF1cAkDSQzaOOe+Xh6fX9p1/lph8/e/dw4RaIswA4HINXaw47vYDbZnq6wC9SITAcMQuQ7OAjF+TUnp2vdKpNuHNfj09olsF27rlclZZgsnEZd/RJBCXR0zOpwDmiEbEHtVxpeQtUEc56enf6nYoXAu0SdhSz0BDXRomzfHJZMi0TA51Qq+AYEpgeLd5xqRv4pVuY+lQk+69SYYaAWjoX93IeAX/hdC2HVfnFpOP+KfhKu2Uyk5d+xgQPyitkzztUEWXVSe+8m1UjNA6WPYiewMLUtWtMjXrNOijFX6F2uS5XpLKrNaBMhU/spm/RjqgObenIrHcDsPBvr3IdR64Arb/yUL+0CfoZa55muAlhdzOqMMxVFxY7UXnHHE9YrGAwtld0jB6REz+HTm7h3yGODAV8tdm93OAVYFGPmA1HarzQojPCw==
X-MS-Exchange-AntiSpam-MessageData: QxYoMBreREKjAVkUP0gJvd90kEqy/+cITQdqkP2fHWVSVUj/0hHKBUin2bM8kyhTRf/xDdDoKHqQX4QigQMElEH6qZlJdGTbJ0uZAEqBb8DkEyvfAufhtWvcds6eICLYL4y1QX9rxvNnB1ICBCAqtbUUpDPxyTe/nTYCc8fpErk5ksAmDeCtEhNaKJl8OGw0BytKPPLPZbIY6L6FZ2BB3B5UkuT/4U0SqqVe4J3cGeto/L7STfZdbya6aN1bsb2MO7zk7vU6MpC4Q0ZcVVPb86sWfKyvTSvicGWQ603ZSRjv94RdIL579d/gMCAAd0ReqROL9OPPk/95e8QFsDmhlgeecLgPFgl6QuRpPFHib/JeDjeHrJLjSz40/N9BSRogU59EueAfo/HP7vPcYBjd+AM5uTzFWSgWsnnux3UtCZXWt+4DUy05yUPgg/323YYcRKIHKqOVMiAvJTMF+HLf3vJTR9fDgTxcdoLBC/DzBffAaIgvDS1+8/G/pCtGs7fieQ0T7xoz4q6xY8CQHnbeh4Q27gIqyOTCxSodcAOxWRfkpoCFugaUF5egQlMK4Y3bsnvHW/Bt458cmcQa4E+XJfPbVy6nJ/hsGEJyveDUaWqrfuDH08NrBF/q3f2sqdWsQWNj0BCkVqDleOV6ox1fVtAe251mhSUbaZBHwCiqhljG2bqKahviRwKVwzTKlF9Up1IhkI/6w3QPMDDd6tJjpHsYXiFcZ8qAxDfkLBCnpGJ8ZsCnfbFMJK9BWoogadFGOHsPsQ2vtfRgSfPD+AJuK6jlteofGj3HeNmmvf3HvUv9NDCa2tCwUihikXGYcfqF
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77831e67-30cb-4633-8d87-08d7e7b67a3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 18:45:21.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vo1EwSa5MGwMzJMbp4CX4mrHk4EOXytNq1aUF9am7WqIC6OP+oEImhhn76I65cUD2EVv8Kzr9m4FaLQr7Le4hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4417
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 02:41:12PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This is a followup to "net/mlx5: Provide simplified command interfaces" [1]
> patch with conversion of everything in mlx5_core.
>
> The patch separation is done by file to simplify bisection and they are
> all similar, but of course, I can squash it to one mega patch if it is
> necessary.
>
> Thanks
>
> [1] https://lore.kernel.org/linux-rdma/20200413142308.936946-2-leon@kernel.org
>
> Leon Romanovsky (24):

Thanks, applied to mlx5-next.
