Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146CE3A950A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhFPIcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:32:18 -0400
Received: from mail-vi1eur05on2110.outbound.protection.outlook.com ([40.107.21.110]:12242
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231318AbhFPIcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 04:32:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHb8nnyjYE247vFv+2nrXdMrYlg9PSqkKqDldQtivoLh5BORVLdP5FITSs5i9k+Ww/flTNgLRlfRnxuZ/w6BHh9jcPsCV+OxlDA2/R4yJ7mMOeFPeotp5k8EzjIFYW5qCKmaphaiaQHJ2R8mhQQpsBgyhnZh+E7IUjjm+NuGJV8qqZsNINc0ITfJFs+c5d7Kws/8Cyy5UUarRkf9q7LnvSC9Suy64+DIf3yVuYDeTiQpnqfFioLQ77P53RhYsu1b2Bid+wRKLV8J13D+u1xglCj5MjOyZp08IdCTM65969mG7G7MToH+5faM8h+NGRlTtI7vrBj9uz5+qNmszK0bGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFB63cQ2DEdoH8jNCbltBgauQOMiFMBpubDv3dnHlDc=;
 b=c7LO/w6BScoLOcYKV4PitT13wiV8iHTPJjaPijYR1yuPXCpYbdoS0AzuACC0m0XIz6yts4xVwci28CNqH+2udsMz0GpHeYLmd07AwUicahZEmK2hVkE0GxHYxOCBpeiY9KFAoQPa6h7BCfHzZoWDqCi/IvtTX6i1BhplLAaMl41C6DllLmppWOQEEDsjOIjA9Z4ehipmihlUF1uwGdizg5X8oc7vdsC+59E6fY2rLqMsj1ZoDWoWN6bCpOjJZF2BNQxxMhESO8isYETnqIh+6B+t4UCWjLPGjrBg2BBIuU6+uX0rd1HghZx/VPj/5klecu+5UPbE1dw9m4fFW1u8vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFB63cQ2DEdoH8jNCbltBgauQOMiFMBpubDv3dnHlDc=;
 b=Hy735016yrlNHzoPm2FudH3ZLlHb/Ihz4L8OnrqeiaLRcPhoKcOvQAG/6KO6ln8hcj4a/EZ96sELJwfXumQhDMw22u8lqBqKyho4/Dg1grRd+MLXfI044zutXYcuEEPMjWpKZO4g96WbI2XFSWrnSHEOz1+tdwQ+QTRobKP4d+U=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1298.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 08:30:09 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 08:30:08 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org, sfr@canb.auug.org.au,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next v2] documentation: networking: devlink: fix prestera.rst formatting that causes build warnings
Date:   Wed, 16 Jun 2021 11:29:19 +0300
Message-Id: <20210616082919.927-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P192CA0106.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::47) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P192CA0106.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 08:30:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19d8dc18-1ade-4950-be61-08d930a0f375
X-MS-TrafficTypeDiagnostic: AM9P190MB1298:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1298CABCB585738EF7F1AF3AE40F9@AM9P190MB1298.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ht515NGO3VtWR8LHfz/jExqbMJ0QyJhfflRRDxFFHuBsdQ/DEymeHaITrnnG4bzke8ErBMARMyKL5qYXbwT6PZOnKQieL3z5UoRnDGVMwqzEtkU31/RGZF+LUQ0eNw4GqJX6UY9YC9jnmTzW+vOkixd+SK70iDWB5P1ZZegHo4TzYZ+JjggKO8j29R1OjOXEEN/HGdsQAgwLez8cvrFwsBeLEakqLZPeZ/nYLMxz0LPWjFquLPFnN8cH1pQoC4Blxm0+RdhG4dI0EIfoUGf4rwLAcyk8KsQE8R2FtJ4vHCt4uCivDBROSGP8EhZTD/HYSYTg+Kl55YrGqdtz7yIV3id8rJJu3j+WHJjt4jd9FuCifMBHFFJB1Hfx/YSNsFgr1MkNRRd3rB/UeLQp62jz3HytxF/c2wgKmOsh8j4F9b4xaJl3U5fdm9E8XFk6nc3C/P2rPYupFtSISE8Bi3j4wo+PmUQ38mM5omStCxNyHTbIw+Qc86UkwK3N1pfui0cGDwtbQWdBcKj9O58LplVVEEykEU0WsOAmLLNurdKGCItbyosu7uZzDTF1OS5QsvGe8BnyXTYSocCt/YPpkLd4u2gCyk4YXNpymbkRWU7jcvX7nAgXIhj/EpC4LvvNm+aT6q+pfaUfumA3vwjDmvf5ComyTO1IQPXhR7ozZZ7ldFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39830400003)(396003)(376002)(366004)(136003)(36756003)(2906002)(8676002)(66946007)(66476007)(6506007)(6486002)(66556008)(52116002)(6666004)(26005)(186003)(16526019)(1076003)(6916009)(83380400001)(7416002)(2616005)(956004)(86362001)(4326008)(6512007)(8936002)(38350700002)(38100700002)(316002)(44832011)(5660300002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5icmaF/GLM/4xFOTo6jZSX7Z5sYVP3CCZz0MyPzaTMzsVbLVSAE2Y63zr6RX?=
 =?us-ascii?Q?rW5SWK5YoPcImxLctnOJKyz3iPjEav0of0bqB8bqNrBfxoqIo3Wfwn4GDqtO?=
 =?us-ascii?Q?9kJ4OMLrk0vuWoRpcqasWEzFD84lMpvKZBSCRJCZYGIGkn2umuHL9JshuASR?=
 =?us-ascii?Q?ObONQGF+QLv+C5jDRsuxqiMsgF719qvxVuHbXpSZKffO7BsEOgmfQdjxGY9i?=
 =?us-ascii?Q?lSkgNGdRK98U+LzciBSKGUdmGzq9LuJd9my2T3VNWZDufrCLtIYr/+C9wOWv?=
 =?us-ascii?Q?/N0m7oRfzqMZCYmg1iiqV+3CgH3px396My6qHchUCVfZD1zoqMEJH6eU20XZ?=
 =?us-ascii?Q?1QUr9CF7f+nOsj0u8N3FAx/HdjxZy0KFHPtwVDHjOyS5nzVbQA1YnD6F4Qr2?=
 =?us-ascii?Q?ByFAAGDgEsV4+IkegI7SUufDMeR7MtjH1liSLfvwjJ3gj7/Nc7BVk3u7l5jr?=
 =?us-ascii?Q?DCi1ePBzCBzhDHafnQ66miTtORVQ9vGTmDgsb8FVamo5/SoKRVY5WMD4vkUW?=
 =?us-ascii?Q?PD/eO+Bph9KKlfUGpl0dTJ/F/BzhiVsMfflTt5yOxzO3gyxwwCQEXyrzqv3c?=
 =?us-ascii?Q?PfsxUAHRknYksO5dRUDxflsfhZUmUXzbysqqpGIyJzKH9YCXfh0KKiRKPx2w?=
 =?us-ascii?Q?qAnHE7qOo6pdmK+hfK8YgekpmYeLw77u2fQRdbdqr8MvV1EBIzRTfWKIcLwr?=
 =?us-ascii?Q?lg1s3V5ua2oePKPS+UjIeVnRkEiU/uDfClByOdnC6JpXaqzGjhiBRxgvL5BT?=
 =?us-ascii?Q?B5IQCMCYks190zWJT90Z369ogDCLqv+UICwQQ5ytYooxNW78sW2/cMMZhGVF?=
 =?us-ascii?Q?tPnFdtOqINI5gaWJKrMG8PTaAhwiVQFu1Vy+NSK7+kcgmHTfbdke0R+u+C+L?=
 =?us-ascii?Q?ImWfl2HS86BBCqtBOVdISDgBwc9Dfl/2rJmLMdwe0/2yoEoqh2uOsBliDbVv?=
 =?us-ascii?Q?ts4g9qO3CHN7WWs9KyLGkay9dXG3evWVlVErGFADeNiR1kM1mKVS7WoH+fpR?=
 =?us-ascii?Q?D4UMC+z5k7GvuhBKJLT1kww3mWUX28sh7/WJNNfmeDvljHoOJLcZRLItTXQk?=
 =?us-ascii?Q?7eupwFEMlXeywXX7PV3VTOWHM7KaWWYwft2x9/XMc5Z0QjiQqLClBIwrWDhZ?=
 =?us-ascii?Q?L9RD2BJfPkOQsn7hsWILd3psoxmZjU0h0zMqxwyuCKhaCf/j8pQJ+loS6lNT?=
 =?us-ascii?Q?qLIFvrpTp4EHJiMEDNVX7lM98EPD+LICIOca0ghJ4SspyoNYnYzqY6Mk+7qL?=
 =?us-ascii?Q?tcE+AHh1K/hqL9XzkI19bEkZwFiakPd44z/B4MApCvLH8SR0Itkm4ORc9Hqo?=
 =?us-ascii?Q?l7mU1YJfmSVlKK9d6onwmSOj?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d8dc18-1ade-4950-be61-08d930a0f375
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 08:30:08.8858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgQcKsMhqC8Am+MwM+fejYzH7NqYT6aoC8rr1wN12b3x1tXVtCkwofnnDZgVrOyufsCh0Z3tX+w2Jv/nZG1v9lT3nP6+7g5Ty4iYAbmHT/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1298
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: a5aee17deb88 ("documentation: networking: devlink: add prestera switched driver Documentation")

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V2:
 1) add missing 'net-next' tag in the patch subject.
---
 Documentation/networking/devlink/devlink-trap.rst | 1 +
 Documentation/networking/devlink/index.rst        | 1 +
 Documentation/networking/devlink/prestera.rst     | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 935b6397e8cf..ef8928c355df 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -497,6 +497,7 @@ drivers:
 
   * :doc:`netdevsim`
   * :doc:`mlxsw`
+  * :doc:`prestera`
 
 .. _Generic-Packet-Trap-Groups:
 
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 8428a1220723..b3b9e0692088 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -46,3 +46,4 @@ parameters, info versions, and other features it supports.
    qed
    ti-cpsw-switch
    am65-nuss-cpsw-switch
+   prestera
diff --git a/Documentation/networking/devlink/prestera.rst b/Documentation/networking/devlink/prestera.rst
index e8b52ffd4707..49409d1d3081 100644
--- a/Documentation/networking/devlink/prestera.rst
+++ b/Documentation/networking/devlink/prestera.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=====================
+========================
 prestera devlink support
-=====================
+========================
 
 This document describes the devlink features implemented by the ``prestera``
 device driver.
-- 
2.17.1

