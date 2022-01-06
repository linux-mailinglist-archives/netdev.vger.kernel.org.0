Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB34865AB
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbiAFN70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:59:26 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:44357
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239519AbiAFN7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:59:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjIH42C/7T/VH0q2tV2NyfdsmHDVKc5Fugg5Tt9WPkWSmw18kRfob/wBFHUL50yEYBs69W5O3/Dvw82/lh+IpwjayzmajDurGuCJNwKEUql75xJ3j2QL59FcFJ2SgeIzPsruuH3KJChp8D3+RLTw/FQK2uT/76XQEntbDEjN45kt/Ko1QOV8duJozpH03hMYMeIKPGM3WBwFdYLOvFoMbP7COOM3JFZ9SQzW12aRA/gO7s/sJtYcDNLFEMr4bEFSdNMVpEQWeOU6o10dqmEKIpc0i28fEQemo43cf/vTciE/ODXr/Gdt5nv4jX+Vt1ALB674uUYR7YlDWcJKCcxVlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/WSTZTV6qgN5VKBW0oneuy+8uleToav6x9TC2cY5p8=;
 b=oBWbjLlhUTsNPO1roxw1FAISMEbHSTvxBP3gSFbJLnmNIKPf2pxhWheBeB2wWOjSkAsUb6cP3yfYWXWyzDPLRiMqSWnrh0ahoaKgeBHleQdjzTMyS1vsHQVLJ9Q42enjPmPtT7edmOxYnl1OSh55wC3NIvkXB5If6YwBC5Nw9STebB2kw9/tSWDH0VHYHjT+SkGP7ZHtHnPKmwUD4uadyOZ9XD9gxqOvo2yPH/WeEvJOoBHwPdovCx+jQje523SRCDyvcLS3Wi2ZM9frNdg05bo9DAy5OE33DUqdQyPSbRrrXDv8alIBra6nrVU/GIBOxMJvVmMS11I0uO4gUe+K7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/WSTZTV6qgN5VKBW0oneuy+8uleToav6x9TC2cY5p8=;
 b=ZdCVJMhzAKm4rY1XqgZOgHHsm/zkvktsGwkH+Z5RFpvAitPr6iVJTPCQbACzKKFY4QkwzBccv39LTuICXlWaPNCa5KUifUwU0AU9tGlwMr+vbz5HpK7sf5uhlMRqaqN5H7aWDHD1dE7UIHS08bX6oZ4lDYYies4u8Zdx8uSBei0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AS4PR04MB9267.eurprd04.prod.outlook.com (2603:10a6:20b:4e2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 13:59:23 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::b5b4:c0ab:e6a:9ed9%3]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 13:59:23 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, robert-ionut.alexa@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: small cleanup
Date:   Thu,  6 Jan 2022 15:59:02 +0200
Message-Id: <20220106135905.81923-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d636c86-4c95-418a-73a0-08d9d11cbe7d
X-MS-TrafficTypeDiagnostic: AS4PR04MB9267:EE_
X-Microsoft-Antispam-PRVS: <AS4PR04MB9267C367FB84FDE89A2A0DA4E04C9@AS4PR04MB9267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5EdofDtUVpuMY15CJ1JWRx5Z0U19x0oosBmLAE7IKs6rAgLFNkLYO8PMMQbERliv0H/EorzvFOgXQPIGAbK3M9e+YwiGIMh0xQ44cdYHfb+M/+SXoteKaM+YWGKB9DOO3lu3KZbTXLxTegNpSZHXECRp60idd19KPuEQXwlfhLYv2i3717/P1EG0gBfdlhbF4G1DmBgIebmKKWNwxJkYwFvjONvIlNsHWfMOrR7vSlq/ejBl0oNRevZn0hDoqJUtXYtE6K4seGLSubYbB86SJaWIyBTca1g860Z5xQx1Yf1e+AultF02hBNIcaHLKV9XMKqRBJeDRAhTQrjfTeFzGf6WE9r6gA+eErpvgHdZFZCcf3IUQw5xcCLfSzYa0dXZl4nvB5hcJPOl7GNnKe9f8RcMKS+UdqCQ6rLapv5gtMVhGlszr12dMVe0kmOAMFBfbrhbCOuOYt2UXnAfmibCix8MI1ohzxHt/SDUdhEdTp/DQIoxHXN94mQHFiu/076KmdpkT75fxoq/PW5vjLHtDPjB47b6K0Q+rytp2XXhle+U6Aok32+y/a/xI/R+ZDKfNYg4EFsyPJHqoQmc3gxJz+3Bf3ogMimWq5wIfX2aRXUvvQFAqkA0RvCQ+exn32MYKF+vjY6vh99o9BHrk9Zx43ywfBhygcH+UzM+N7wFXrjg/V1MnHIbXrtOoKwwc1bUN+iMr+WIdBjbpCef7mHgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6512007)(66556008)(6486002)(66946007)(66476007)(6666004)(2616005)(4326008)(44832011)(186003)(508600001)(26005)(38350700002)(38100700002)(83380400001)(52116002)(316002)(36756003)(8676002)(2906002)(8936002)(86362001)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6rNOcTHTiTtjA0cJtL+6H6wFoo5qFzLFR1/VTbbgJz/wXM8G5TvrQ5xbV0mD?=
 =?us-ascii?Q?DSbO+aKlhBzpv1zQBVerO+pT8YDOmKkng0ndUlCz8itMg41PL9N7rblGPHfO?=
 =?us-ascii?Q?vh7DcTE83e1O8HrlSD2EV6cymw86jppqYqeU07k5YSXtJ6BRaPkno0vPR7aE?=
 =?us-ascii?Q?Bx8DrH12JOowUHfBn5HwSH2cR2vY2pGRJtpefmZUryhkeq04zPqKvPhuTvPR?=
 =?us-ascii?Q?KwuyAkgsM6IQlTSjFUAqWxSQDfGSzxCEpUZZbpEBDe0jwQgbSrEvGgbUZ5Md?=
 =?us-ascii?Q?VvYwNPyk6f/mg/rwm6UasG1nWxmoc45Q8FX+TiNf1BDRyek0fF92Td3v2rhP?=
 =?us-ascii?Q?kD2WHBubzUeiEyFCi7vg1t53XdQ9c5Y10zINH5ukALYodCUflr01AK1TeLp2?=
 =?us-ascii?Q?w/JSxmkI+KB+aIylgusH2kTgbuvd3t99nUzCoUdVHxPWHNyqmVzPmnP9UTCy?=
 =?us-ascii?Q?3JZPFEJsbe+n8JHbbaOE9lYl0OISHBKTNF6XxEhwDYH+zsXowo97lVuGruai?=
 =?us-ascii?Q?cnLoKi+npjE1j1Q1YBdJaEQ5Fe/EkuNTGVr3ly8wFDkqVk5f+GXH8PKkF30P?=
 =?us-ascii?Q?JMTeABgZ7H9r0Uoc8zcbOIES7YZX5C8/7/geTZcUbvp5hKOVuuYcLSu/P0pH?=
 =?us-ascii?Q?JiQZVtUDgmMo8mY7Fe8NpIsxHARZu8nee7LiMB3m7vaXqiRLQKBfrlMQXF/L?=
 =?us-ascii?Q?/vLIgv2beEMslxmLv4TQLBJpg6lh0XweXzb7xx/2EPzPe7HCIiSALAoXe2h9?=
 =?us-ascii?Q?8EeZhFMglsu7x0MortMGjOcsEs7iQlB+KUYghFISjhRzw9CQbkB5sLB1hAff?=
 =?us-ascii?Q?38L1Nj/3zpnhbF88CWVAtH8fe0ULo9EdLGGfAZpJ3MZfnfCSRSzID93QN1D6?=
 =?us-ascii?Q?WOxvkOsk2eNI4NMZEDiCkbRsrRuzXo5NObNwEuWHy6ogbwkOXXYFuYTJxxkJ?=
 =?us-ascii?Q?eb3aslwcCh/pjcbZm0EneWlhB8HmN9PYuDGJF3NKFLWd6rutgVE+IlwIDN+/?=
 =?us-ascii?Q?GhBkc9uw34dtWmA1OH7Bw+GGU0SA3y/fafxCiO2NS4moijnxZF/Rtd+UsRK/?=
 =?us-ascii?Q?z9zGTVIoFn0s/3SWOlxzln8IAnQ7/wcNSRX3yk+hHrWZ99gJ8tXej99Ypcco?=
 =?us-ascii?Q?MKVwdMG3mUO5uWuEVhit0TKIY80nhZe7nuW1W2CsF63nzwAMhLviY017V0KU?=
 =?us-ascii?Q?0QkVFLtJonPaHhBDkWRSs71HkZ+PIl8LD2I0opvb7hjvR+7hGJhraErV3b9W?=
 =?us-ascii?Q?7KhARjotG9AEc9yJrjMS9MPY+KdkMOFuHt7yNKQTHpTBPIjWmXiHFSYHdAH1?=
 =?us-ascii?Q?2xI+XbjLvAGDdFOoniArLhIRGAhWiZWjpwju/H5Fn06OSI8/N0puEnyo47zC?=
 =?us-ascii?Q?RZRAvrwTatxF6n/RVEmB/UE1u5u0ymmEXpx1abR8vh8r+EaILCPa3VHilt8I?=
 =?us-ascii?Q?1khyu38iz1oj6BWs1RQav0yQJ4xtq2X6VqHDuljubM3YjDg7fqp+C3TeK64V?=
 =?us-ascii?Q?rTZh3d9UUvcTc4UXzo3UjKV7/OvyDSAaOATqbJSEvg6c9TzlivyQde0qD4mX?=
 =?us-ascii?Q?Zs2LYUisTsMV17FoZOoTB2TAMs2i5RJ7aRH3gCsB4UrpuZmkunCJZ3aLHSF0?=
 =?us-ascii?Q?KAeMSgcx9fPHpFkXhHILs5k=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d636c86-4c95-418a-73a0-08d9d11cbe7d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 13:59:23.6829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivaBb95c6vfwJqsPxESvo16NlYX5l8yGdGfoXD6OQ5+zFwqBLktIg56N79JeDltEJN7qYmqLBU0mOTjmYdNNNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These 3 patches are just part of a small cleanup on the dpaa2-eth and
the dpaa2-switch drivers.

In case we are hitting a case in which the fwnode of the root dprc
device we initiate a deferred probe. On the dpaa2-switch side, if we are
on the remove path, make sure that we check for a non-NULL pointer
before accessing the port private structure.

Ioana Ciornei (2):
  dpaa2-mac: return -EPROBE_DEFER from dpaa2_mac_open in case the fwnode
    is not set
  dpaa2-switch: check if the port priv is valid

Robert-Ionut Alexa (1):
  dpaa2-mac: bail if the dpmacs fwnode is not found

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 20 +++++++++++++++++--
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  9 ++++++---
 2 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.33.1

