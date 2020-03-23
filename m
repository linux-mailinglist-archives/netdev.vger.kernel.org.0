Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8226C18F5F0
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgCWNmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:42:17 -0400
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:25516
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727649AbgCWNmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 09:42:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kI57FTd+p+8sTz56GkQovoHKIlqVkPKfXdZHuYrEdDK0QMN4/Y/rgPxZf5L9lGQDXKOszlTqwqaZEeuH7klvdXKWKzLd4SD8ShIfLijd46Wq06QFnahikceFVYh98dzSK++uLP6A1a+gUnHWGLuvxs+R9JjJsab0x+lONEN0P6qlsT8xUPXY4EwJfA9sS740MR0/O4RsDLhHjt5+HQkH8NUmb2kYJgDcVIoy0K070PE0gw62wVNEXOhb/54IFxV8+RNlIE4SMENNzyFk4ZzthCyQI4RlP3Yd4xWpKipVx9tcAqApLj1YBVAcb/t1IUSlQ33GEa3nocb+cRWGEosKeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GibuhyV3q1aaJifR0jWJBjN9A0YyQkbyC9d7jZ0Mrao=;
 b=jDQ0s7ZrBwJSZATSH+6DXunZEXcA/1miiajNba6vVWCukgS0xR8bLfjeQuQK+6/CeR2tAcCfT3SGGCopPS8VT+qcT1gXPnQDVUqthZb0KlMQLZf4i10FDoyDuSTvIiVaJiudSt4n9y7cbdBZSGnVhfOxkxA47vH8qTsKtorOPkomvSclphl6IDzQsDCRtnPR7xMALI38enJudYkEgaeCxgVu15w3Ll5KM6m38eu8Uqvpqosfg55w26iPYtGmTthqfrZOt3na1TfKAtff6SJSGpGWRIEaM1vRKvQCr7NuFvlM8zDcKVuaFuK9jbU+kvJPQTSvwLP0hG9Nv+I0NHpXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GibuhyV3q1aaJifR0jWJBjN9A0YyQkbyC9d7jZ0Mrao=;
 b=XJ/XXaH66r9KsWAfgrV1824qyqGMUGbvMlqyiNxXvZ4Tz+gFpVHYsmYuFRL7PN7JA7U9SQUKvDAkRbXlleu0sKdyqMFG2v4yoegVu+3nGKHTdlfIq8eTo4MJBV+RoKn020NydLRGligFfT6vetkklJl9J+XE7VKyUE1ZePIleUo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB3215.eurprd05.prod.outlook.com (10.175.245.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Mon, 23 Mar 2020 13:42:14 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 13:42:14 +0000
References: <1584765584-4168-1-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     saeedm@mellanox.com, paulb@mellanox.com, vladbu@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/2] net/mlx5e: add indr block support in the FT mode
In-reply-to: <1584765584-4168-1-git-send-email-wenxu@ucloud.cn>
Date:   Mon, 23 Mar 2020 15:42:10 +0200
Message-ID: <vbfa747nq6l.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0077.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::17) To VI1PR05MB3359.eurprd05.prod.outlook.com
 (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0077.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Mon, 23 Mar 2020 13:42:13 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8966922e-fdae-45ea-8eec-08d7cf2ffe8d
X-MS-TrafficTypeDiagnostic: VI1PR05MB3215:|VI1PR05MB3215:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3215AFF31DCC219E463B3BD7ADF00@VI1PR05MB3215.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(199004)(956004)(66476007)(66556008)(36756003)(66946007)(5660300002)(4744005)(478600001)(81156014)(8676002)(8936002)(81166006)(4326008)(86362001)(2616005)(2906002)(16526019)(186003)(316002)(6916009)(7696005)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3215;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2ntZwO7u4J8BDNjcQOTemFm+Sh+VpHnOG/+HUMSBJ2+0gOaw7OW8aZXSmGco2BuQTzDuCmrdx/Prat6eLrrnKVCZhImSM6O8jKaaJLnxdWbaJTxu/ACQyhiGhg431QjSzdcL2r0xvh2VCWFQdVfdrFg6UQ0Rno1FY9wW/KHvFuYx9GTrQ+lzrPQn4wp4BuLfg4OUN8M7QRBpv4I+UZ74X8rsPTKwSXoicMltfZmx8duYqgcjs6eVvi8s0GyMZiJT2nVIee5+ogOpv+w0GLgda2SDe9X/APvEMLfcfIxViwEb5skHbR9vOoEeyY6h/QoKZlSeQXhjR4WinRCDfPA96J70WP90pE34HKl8874lgR+b3iORmBEP96UJMMCJKsP6vFBf8ErLTylX7y9WA66NvDL0hvT4DgcCvFaQ9wd+b9L6Tew4DAXfx7mLJ4F4Vz7
X-MS-Exchange-AntiSpam-MessageData: dHEY00sxhY5ANB4kiMz7i+Pks/8kB9Gz6w1ZwFMq03yKIT851gUIz4gDQULWAq2+8KEfiot4HYZgVMa3NM7m4P45d13FP4vg4Q7/tHoFPfgTxuLYCBZlPIBLzv7M6DWvRtRDDSQvAY+zFKu6lV6uKQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8966922e-fdae-45ea-8eec-08d7cf2ffe8d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 13:42:14.1064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T14zYDufi2ROX3ECRMgC3HlHQhSwbEb/WlphzRuFaO9ZSO1Kdnv4U+oUxb3mOZTs/fo1IztfA8Z7jVCdLmJKqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 21 Mar 2020 at 06:39, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>

Hi wenxu,

Can you please provide some description for this functionality and
example commands that can be used to test it?

>
>
> wenxu (2):
>   net/mlx5e: refactor indr setup block
>   net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 94 ++++++++++++++++++------
>  1 file changed, 73 insertions(+), 21 deletions(-)
