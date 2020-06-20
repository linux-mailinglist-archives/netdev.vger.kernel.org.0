Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155ED2025FE
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 20:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgFTSgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 14:36:16 -0400
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:6084
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728385AbgFTSgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 14:36:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVaXbyMPkN0ex3O1V6CqRjJg2ak465kUBAktZ50v7RPAcsDVskwfBHPS4eQZKhicD6VOaSaIv9nfClrw4b3FXNaTZkHW8CQYZqe18rNH7qC8Tc3R15dloIQ/Nbds+27JTu+zGZomJVonWTkQ5gc5ZS2BPyCX9YiKUwHdPgVjkWBmyTmlK6NqHbXjMDhrSY7Lj2iOerb12KOl7/KdXSLLmkvz2cndXiVU9kwDqzGBxfcYQF9z+usydckAxBZOSU8vbb9fM7cU958BZ20AWokv7u4vmlsVTpgIVSfBMYIpyqekkQDw3HMNOypN54gKiEPli6Y6yQhvv6iviGaEBj0zoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HT/LVvRHWNSWHympFbjCMGHISZLsQoqQa7mY3gnSGwI=;
 b=Ze1O+16cxtc8BOMrfnTKmOsbQWaEZ927b556ImCPEvULkukq9cpqRSatUR6V65vU9N6HUkrw3bXOwvcA1jXQHg4bQOIQG2DH7YunGHdeMQwLohDo+Moub/vwJSBipK9Ild+h4jKpt5Klp/5+IU7NaR0eOEaBLfTaridWDacOwjtpN/BufQEbZvKuxWrbfW1IM7Rz3amqapg85ulOmfa9SyHFDLGCgCy0TymH8/zVotWrAItpcyIrfNBAfPkVvamOXWZhKLm2cUTvkYxWHL1KDTgZyB4WTVlsPkQeCr3gAwWBh0bBjpnm3hDrYTbPoxP1189jqsIsXr1+2aoB/SwdoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HT/LVvRHWNSWHympFbjCMGHISZLsQoqQa7mY3gnSGwI=;
 b=hD44f3E3S3DtQ2ynv78/Alfm7HyaenIY2Bngnm4mqK3TuRIEZS9wYkEr96Te17uHVVEZij4pUYTWvzQw1XlUZSZPpKIQaBs6wuvj5+yaKOMqOwEYEqHNs7/NWdqzqrAA1YLiZH+XEIIzfYNDMaV5kx91QZMPN2qOie+GWc4x3QQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR05MB6162.eurprd05.prod.outlook.com (2603:10a6:208:110::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Sat, 20 Jun
 2020 18:36:11 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f%7]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 18:36:11 +0000
Date:   Sat, 20 Jun 2020 21:35:58 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     ozsh@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: mlx5e uplink hairpin forwarding
Message-ID: <20200620183558.GA194992@mtl-vdi-166.wap.labs.mlnx>
References: <CAMDZJNXW-SsgYiw8j1b5Rv8PhfGt=TxZZKjCPzsQWiADjy6zew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMDZJNXW-SsgYiw8j1b5Rv8PhfGt=TxZZKjCPzsQWiADjy6zew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM3PR05CA0121.eurprd05.prod.outlook.com
 (2603:10a6:207:2::23) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM3PR05CA0121.eurprd05.prod.outlook.com (2603:10a6:207:2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 18:36:10 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 16596c5a-a1ca-4606-6385-08d81548cdb2
X-MS-TrafficTypeDiagnostic: AM0PR05MB6162:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB61627DE6C31A00C88D9B0BE6C5990@AM0PR05MB6162.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tho10lMiMn4hOceT4t+iz+RAT3t+S00MhrhfOmMYCAomj79FPrR0iyMA/0Rg5daUP9J7t3frez0taQZorkFUzq5sROmrJ9UB3avcMl8yjYhdV29b8op8e0oRuDP/eE6GpzK/EJ1B5UUQ8AfjhOrfa1wMVo16jnrZIM0lsrCPXDahGeuKGT5nohmv8gKITNMi9bl9phP2E3Df/nAnIuyUOg0j2FeGSCo3Qlu06jmUXwFM48ukZCINyu3DOInfivrEZhKstWarSjx8HM9qal4qdAg27QZ6gVzIwdxqgfqZ1WxbhRD4IQTkR9rxebhCoy8I4uwZ8FVriDzJ92dh9PHxTsLz+OloiKUqy0kErd9z8zNczz58UineVSJjzLze5ZncT3b4qEhVczEaHHVMvYrhfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(39850400004)(346002)(376002)(478600001)(83380400001)(8936002)(6916009)(54906003)(6666004)(86362001)(9686003)(8676002)(2906002)(55016002)(66476007)(66556008)(66946007)(5660300002)(316002)(4744005)(1076003)(16526019)(956004)(6506007)(26005)(4326008)(7696005)(186003)(52116002)(33656002)(42413003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hHDGR7aV+/CTZ+rIzUOUQYKVO3Mo6cpM4Tr9CA9V29yGUh7UcZ/kx7AKZJ1/vYEibjpZgF9oE4ahplh9wwua36pEqD+2w01mswP7g/RKMakuDB4QR2QBhiw3nMIvI3CT/ncx1h9Y1zAmU56S917GSn1VqaXQZcvTC98uESfQbZEkH52xUV17c1VNNobCLeNYRIW4FHPUeQfgA1E+buQXc0biuzJdiD+tOx9wacWHf2FS4KPa9oRH1J/b+koQA3ELvsO6GK+Zt1AI02OeE9dxpOICKiz3ojSpsnyGsA2wysACzTXw+uqNcwenJPjG77of9aieG6FjfOatzXStguwdFn0+lO+nUM7R4cux0U2XiYgQ1TMSHrH5jx+K7jVCo9+8/UH0rIcpZV2ldmjTGfeFJl4ZdcO/WHatFPdP563T1YpQLoo++H8GewBNmaaw4u0b4oqUHxiGS9fyaaJWcHIdgqANO7ajNUAFwV8mBuY9IxU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16596c5a-a1ca-4606-6385-08d81548cdb2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 18:36:10.8792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5OCuFaPcfFv2CZTZ0t7f6mx6E6uiMywqpnX9iMxfNkpCFEPBWgFnHk0QudQx4ch2QnMMWA5OFwP748/dJLMdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6162
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 08:02:19PM +0800, Tonghao Zhang wrote:
> Hi Eli
> 
> I review your patches and try to test it.
> $ tc filter add dev enp130s0f0  protocol ip prio 1 root flower dst_ip
> 11.12.13.14 skip_sw action mirred egress redirect dev enp130s0f1
> or
> $ tc filter add dev enp130s0f0  protocol ip prio 1 parent ffff: flower
> dst_ip 11.12.13.14 skip_sw action mirred egress redirect dev
> enp130s0f1
> 
> TC can't install the rules above. The error message:
> mlx5_core: devices are both uplink, can't offload forwarding.
> 
> So how can I install hairpin rules between uplink and uplink forwarding ?
> 
> The test environment
> kernel 5.8.0-rc1+, the last commit id:69119673bd50b176ded34032fadd41530fb5af21
> NIC MCX512A-ACA_Ax
> FW 16.27.2008
> enp130s0f0、enp130s0f1 are uplink rep.
>

Hi Tonghao,
please note that hairpin is supported on the same uplink representor.
You cannot hairpin from one uplink to another.
