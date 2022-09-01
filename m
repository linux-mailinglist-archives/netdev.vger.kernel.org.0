Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC9A5A969F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiIAMVk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Sep 2022 08:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiIAMVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:21:36 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D550E080
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:21:34 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2046.outbound.protection.outlook.com [104.47.22.46]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-28-nZJuoN1lPhq56ocdZd-qdQ-1; Thu, 01 Sep 2022 14:21:31 +0200
X-MC-Unique: nZJuoN1lPhq56ocdZd-qdQ-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0430.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:29::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Thu, 1 Sep 2022 12:21:30 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%2]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 12:21:30 +0000
Date:   Thu, 1 Sep 2022 14:21:29 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: possible circular locking in kernfs_remove_by_name_ns/devinet_ioctl
 linux 6.0-rc3
Message-ID: <20220901122129.GA493609@francesco-nb.int.toradex.com>
X-ClientProxiedBy: MR2P264CA0029.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::17)
 To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35064b48-165b-4846-e0f0-08da8c14803a
X-MS-TrafficTypeDiagnostic: ZRAP278MB0430:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: P687fdkY4fWzmHuEZj6p1epHoEnTsyLvsHNM0Pxpg9ETnwm+3dfT4BdrzjEMSq0yWsELFPQGou+24yOzX6i5gQb/YNPROoTwHIMO69khJahitCgqh6BEeuuHF2sbgz14hVEQwWfo0KkaGZJzZZ9HmOWDDuqvo/nCM88O42ZNTAWto+6zabWRmneeyJy1f57LYJlXct/Nd6e5iWKqBrr1TC4yXTTwKS39F1RnVoY7OnvO6kLhoAA6FimhRCLwIDihhayHZBS/PurPkQ69OFfKrL7smlInTCbsHke5rAVmGUHxQMtxO4h1glYvjkQ3rJBMpyIjrPACykNM8jx9vKPQ6nzLd0SGNSWjWxAZoRkBrA+EUf4IfomKCBIlBgyjD8oi9SnoXEVbuynESTw2j2GcS5NEGGA+NwkT80CuskwmtLi8HBJCFlf/Yto9ULCmtUkAx8UNRWFmxdHZnhsHAOMMN9NUEv+/tzfu0eHX7F9skOZV98s+23LTDjMm/TkEMtpPjX/Ncx6jJjUvBmwKNxz06YwrNct+eCzrAiBD1B5STBDqSYJXoqavYW1vOMUQtvoNxsQIgg7x75/AqPCzIFs45mMnS7DEMkq+bXKFiT51OtmajSB0qb00u7QMto1smCLCxxVilzRJmCn96GEkVh5eRtB6VRtspF2pKfiHjI9yRAAduRe2+a1E5tbis44uv4mrqNJI5MFKCKhPe8SiqqnlkkvUQsN6a2N3YxeAJrNgj5hf6HSO3LoQaek6cL0qj4dwXyB6FJxGml6uUw4BARE7pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(396003)(366004)(39850400004)(66556008)(8676002)(66946007)(38350700002)(33656002)(38100700002)(86362001)(41300700001)(83380400001)(1076003)(6486002)(6506007)(6512007)(186003)(2906002)(478600001)(26005)(316002)(5660300002)(52116002)(44832011)(66476007)(8936002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MOmiNXUJMmMAEbiy16eKudI7NqIKM5QmNfp7KQ73vOEZZUE9w1NSKVWR60bk?=
 =?us-ascii?Q?mwuN/ZIGffca8Ev7NtwWuvHCJViRKbxl13pavPz9j/+o4a9mnZ+oxWvlgHCJ?=
 =?us-ascii?Q?pG0OHbLg2geo2niKJZBlnFsyzxW5HJ+Z1UafPBXyHxNi90QyrZ4icNS8iCbm?=
 =?us-ascii?Q?pgYqduakKofRPGwKVp8O5ZZn1M66AvaOcf/oX5olhS2BX4NwVw0dYPuwLfCu?=
 =?us-ascii?Q?4AdZ9H4WBz/8x9q7D23TUn/UtqdTqrg9R/uhb29m+J4S4h69h4pe2+188TDk?=
 =?us-ascii?Q?xTTz6MogSrMMQkMadLZQNN79NikvYk+9HMPvIRqiL7vz458n6VCaHdIooYup?=
 =?us-ascii?Q?n+q4JIC1ZFyoBY5EpLb5+kXgHiYDibIPeNSjiVoCstMBjrZ46VdYHwidALr7?=
 =?us-ascii?Q?YbP99SSdHHGpUUnuSNcyU/sEXEw4fPNr7G9h8IpqkqlYOx1adRLklMQhNP4w?=
 =?us-ascii?Q?dOhC0oELScfavQIP1+KuCD8wcVwGdsj6RC/sDRhS5rCxjCcU3lu7gOefTlR4?=
 =?us-ascii?Q?ZsqAN3+4ZQSmZCgtYeqSm6Q8JC24wx6pGTizKLyy3wyLDe8jMe2XgeljdqMf?=
 =?us-ascii?Q?jiqsmIomCp7P+6Co3C+FYVYh1ysvFJDZtHg79DsQyx4N0wLx2WuAtm7/oM8x?=
 =?us-ascii?Q?zFdlCiElRjcm1HFCs57EHyLiDZEN3jSDxLdsq229F8lseiSivuS44dxLVEnQ?=
 =?us-ascii?Q?HkbsC8JbeJ8gtbRtJlCKat32i1lF5FcrtI8cFfe4NEzDvyzCTfOYoud8+HvH?=
 =?us-ascii?Q?2/NO4zyHB9lBLp+84YhVo3YviUMR0CSze9xR8Jgvf79xLEuJfEMD8LtIx2Sn?=
 =?us-ascii?Q?AWZkV/td6aAiyQ4OcKDx/gNlz5Gu0hdo5J4o69yd1YClB56adRTCXPOaKSdu?=
 =?us-ascii?Q?KIOWXn34TbaCqZWvx/k7VHiwkGERl+ISFtPeRwowaa/Qaw0lRAgoNBj/4KS7?=
 =?us-ascii?Q?nCzE4x03cBnzP1T288PRp5gd2DuqUD9Yrm9hA567r2zBJFEUXpwATTd/w5CR?=
 =?us-ascii?Q?khrBh+AHsXEVhc+Tv3VnD2hPntTCZmhTn2ypdrDl+zDUbTD02mrFdNQitP0T?=
 =?us-ascii?Q?3mhg9MMIQxTTs5fKtu3LHIvW70a0Lem5TczrhH/K8dsqxXfnpXwCEjH80mkX?=
 =?us-ascii?Q?qbHPu9tnnzdk9LVEnofIbU/qnA2yvHpn9YqXPvuepMU4qZSZ46rDcgAIvzFK?=
 =?us-ascii?Q?LMGnPzRGxS/YHOF1Cwqw5tiKin6EaTwlgT4wPft02a9e8pMgu0BaWzl2oAMb?=
 =?us-ascii?Q?z/9vFwvfFfjeps1dqU/JywLitWvpcGnCjK6BWIT/6AJTy8ZN0ggzW99KngeQ?=
 =?us-ascii?Q?n2OQcQGdtXMSjo+8UlCVJhOxkei0bVxu0Y9j0n+wYIcp8QlHdMLVbkyK9o8b?=
 =?us-ascii?Q?HfIx0FiKto8sep/szz8kJc+/NmhtMRT8GzQ6HPTtKPge070M/chahCUyW7/U?=
 =?us-ascii?Q?S0rxPiiqKxZFaR1ekouvuaAqT/yXXKW1hbaLAT3WnQck1IdrVHlyImoChx4m?=
 =?us-ascii?Q?DWC/sgRUQiEk8L3ndoole867aVtU7AWcvEG7ho0PdevaIy/5Md/gPJAWMBnf?=
 =?us-ascii?Q?Nia5uy0G81e/KLqzhaHIYp7z3F0T+emi0RiIjDdz6kb7PcgFaYD1OIt18N7v?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35064b48-165b-4846-e0f0-08da8c14803a
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 12:21:30.5704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJE0fTPJtpy3zDaxmB/6BG1JC94lDFr39q7kiyokk2uS0xIMFwZQh5pGrUogsW9XSt1mPq5SMCF1QDzB83hkzzVATWEJq5v38wejCJv9Yc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0430
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,
I have this warning on linux 6.0-rc3, running on a ARM colibri-imx7.

[   21.629186] ======================================================
[   21.635418] WARNING: possible circular locking dependency detected
[   21.641646] 6.0.0-rc3 #7 Not tainted
[   21.645256] ------------------------------------------------------
[   21.651480] connmand/542 is trying to acquire lock:
[   21.656399] c2ce1d70 (kn->active#9){++++}-{0:0}, at: kernfs_remove_by_name_ns+0x50/0xa0
[   21.664516]
               but task is already holding lock:
[   21.670394] c17af6e0 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0xc8/0x870
[   21.677441]
               which lock already depends on the new lock.

[   21.685677]
               the existing dependency chain (in reverse order) is:
[   21.693230]
               -> #2 (rtnl_mutex){+.+.}-{3:3}:
[   21.698971]        __mutex_lock+0x88/0x1110
[   21.703208]        mutex_lock_killable_nested+0x1c/0x28
[   21.708487]        register_netdev+0xc/0x34
[   21.712721]        gether_register_netdev+0x38/0xb0
[   21.717654]        rndis_bind+0x22c/0x39c
[   21.721710]        usb_add_function+0x7c/0x1e4
[   21.726201]        configfs_composite_bind+0x1bc/0x370
[   21.731391]        gadget_bind_driver+0x9c/0x204
[   21.736059]        really_probe+0xd8/0x3dc
[   21.740201]        __driver_probe_device+0x94/0x200
[   21.745125]        driver_probe_device+0x2c/0xd0
[   21.749785]        __driver_attach+0xc0/0x18c
[   21.754184]        bus_for_each_dev+0x74/0xc0
[   21.758583]        bus_add_driver+0x164/0x218
[   21.762980]        driver_register+0x74/0x10c
[   21.767379]        usb_gadget_register_driver_owner+0x40/0xd4
[   21.773173]        gadget_dev_desc_UDC_store+0xbc/0xf0
[   21.778358]        configfs_write_iter+0xac/0x110
[   21.783110]        vfs_write+0x2d4/0x46c
[   21.787077]        ksys_write+0x60/0xec
[   21.790953]        ret_fast_syscall+0x0/0x1c
[   21.795265]        0xbeeb4b88
[   21.798266]
               -> #1 (udc_lock){+.+.}-{3:3}:
[   21.803824]        __mutex_lock+0x88/0x1110
[   21.808054]        mutex_lock_nested+0x1c/0x24
[   21.812540]        usb_udc_uevent+0x34/0xb0
[   21.816763]        dev_uevent+0x100/0x2dc
[   21.820812]        uevent_show+0x90/0x10c
[   21.824860]        dev_attr_show+0x18/0x48
[   21.828999]        sysfs_kf_seq_show+0x88/0x118
[   21.833573]        seq_read_iter+0x194/0x4bc
[   21.837885]        vfs_read+0x1a8/0x270
[   21.841762]        ksys_read+0x60/0xec
[   21.845550]        ret_fast_syscall+0x0/0x1c
[   21.849860]        0xbea98840
[   21.852857]
               -> #0 (kn->active#9){++++}-{0:0}:
[   21.858766]        __lock_acquire+0x1550/0x23c0
[   21.863344]        lock_acquire+0x108/0x37c
[   21.867570]        __kernfs_remove+0x294/0x368
[   21.872055]        kernfs_remove_by_name_ns+0x50/0xa0
[   21.877151]        device_del+0x178/0x454
[   21.881199]        device_unregister+0x20/0x64
[   21.885683]        wakeup_source_unregister.part.0+0x20/0x3c
[   21.891396]        device_wakeup_disable+0x48/0x58
[   21.896232]        fec_enet_open+0x2ec/0x36c
[   21.900547]        __dev_open+0xec/0x180
[   21.904512]        __dev_change_flags+0x164/0x1d4
[   21.909261]        dev_change_flags+0x14/0x44
[   21.913660]        devinet_ioctl+0x6c8/0x870
[   21.917971]        inet_ioctl+0x1c4/0x2b8
[   21.922019]        sock_ioctl+0x458/0x4fc
[   21.926072]        sys_ioctl+0xf4/0xe04
[   21.929948]        ret_fast_syscall+0x0/0x1c
[   21.934258]        0xbeeca960
[   21.937256]
               other info that might help us debug this:

[   21.945318] Chain exists of:
                 kn->active#9 --> udc_lock --> rtnl_mutex

[   21.954902]  Possible unsafe locking scenario:

[   21.960865]        CPU0                    CPU1
[   21.965430]        ----                    ----
[   21.969994]   lock(rtnl_mutex);
[   21.973174]                                lock(udc_lock);
[   21.978709]                                lock(rtnl_mutex);
[   21.984419]   lock(kn->active#9);
[   21.987779]
                *** DEADLOCK ***

[   21.993745] 1 lock held by connmand/542:
[   21.997704]  #0: c17af6e0 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0xc8/0x870
[   22.005191]
               stack backtrace:
[   22.009587] CPU: 0 PID: 542 Comm: connmand Not tainted 6.0.0-rc3 #7
[   22.015905] Hardware name: Freescale i.MX7 Dual (Device Tree)
[   22.021703]  unwind_backtrace from show_stack+0x10/0x14
[   22.026985]  show_stack from dump_stack_lvl+0x58/0x70
[   22.032088]  dump_stack_lvl from check_noncircular+0xf4/0x168
[   22.037891]  check_noncircular from check_prev_add+0xc4/0x15d8
[   22.043783]  check_prev_add from __lock_acquire+0x1550/0x23c0
[   22.049587]  __lock_acquire from lock_acquire+0x108/0x37c
[   22.055041]  lock_acquire from __kernfs_remove+0x294/0x368
[   22.060582]  __kernfs_remove from kernfs_remove_by_name_ns+0x50/0xa0
[   22.066991]  kernfs_remove_by_name_ns from device_del+0x178/0x454
[   22.073141]  device_del from device_unregister+0x20/0x64
[   22.078501]  device_unregister from wakeup_source_unregister.part.0+0x20/0x3c
[   22.085700]  wakeup_source_unregister.part.0 from device_wakeup_disable+0x48/0x58
[   22.093253]  device_wakeup_disable from fec_enet_open+0x2ec/0x36c
[   22.099408]  fec_enet_open from __dev_open+0xec/0x180
[   22.104514]  __dev_open from __dev_change_flags+0x164/0x1d4
[   22.110141]  __dev_change_flags from dev_change_flags+0x14/0x44
[   22.116117]  dev_change_flags from devinet_ioctl+0x6c8/0x870
[   22.121830]  devinet_ioctl from inet_ioctl+0x1c4/0x2b8
[   22.127017]  inet_ioctl from sock_ioctl+0x458/0x4fc
[   22.131946]  sock_ioctl from sys_ioctl+0xf4/0xe04
[   22.136701]  sys_ioctl from ret_fast_syscall+0x0/0x1c
[   22.141802] Exception stack(0xf1269fa8 to 0xf1269ff0)
[   22.146900] 9fa0:                   00000000 beeca984 00000010 00008914 beeca984 beeca978
[   22.155141] 9fc0: 00000000 beeca984 00000010 00000036 00000003 00001002 00000e94 beecab3c
[   22.163380] 9fe0: 00000036 beeca960 b6b58089 b6ad1ae6


The kernel configuration used is based on imx_v6_v7_defconfig with the
following changes:

--- original	2022-09-01 14:13:12.334642373 +0200
+++ new	2022-09-01 14:12:46.799096809 +0200
@@ -1 +1 @@
-CONFIG_KERNEL_LZO=y
+CONFIG_KERNEL_LZ4=y
@@ -18,5 +17,0 @@
-CONFIG_SOC_IMX31=y
-CONFIG_SOC_IMX35=y
-CONFIG_SOC_IMX50=y
-CONFIG_SOC_IMX51=y
-CONFIG_SOC_IMX53=y
@@ -24,3 +18,0 @@
-CONFIG_SOC_IMX6SL=y
-CONFIG_SOC_IMX6SLL=y
-CONFIG_SOC_IMX6SX=y
@@ -29,2 +20,0 @@
-CONFIG_SOC_IMX7ULP=y
-CONFIG_SOC_VF610=y
@@ -36 +25,0 @@
-CONFIG_KEXEC=y
@@ -58,0 +48 @@
+# CONFIG_SWAP is not set
@@ -67,0 +58,2 @@
+CONFIG_CAN_FLEXCAN=y
+CONFIG_CAN_MCP251X=m
@@ -71,0 +64,2 @@
+CONFIG_BT_MRVL=m
+CONFIG_BT_MRVL_SDIO=m
@@ -101 +94,0 @@
-CONFIG_MTD_NAND_VF610_NFC=y
@@ -103 +95,0 @@
-CONFIG_MTD_SPI_NOR=y
@@ -121 +112,0 @@
-CONFIG_PATA_IMX=y
@@ -138 +128,0 @@
-CONFIG_CAN_FLEXCAN=y
@@ -200,0 +191 @@
+CONFIG_SPI_MEM=y
@@ -204,5 +195 @@
-CONFIG_SPI_FSL_DSPI=y
-CONFIG_PINCTRL_IMX8MM=y
-CONFIG_PINCTRL_IMX8MN=y
-CONFIG_PINCTRL_IMX8MP=y
-CONFIG_PINCTRL_IMX8MQ=y
+CONFIG_SPI_SPIDEV=y
@@ -240,0 +228 @@
+CONFIG_REGULATOR=y
@@ -252,3 +239,0 @@
-CONFIG_RC_CORE=y
-CONFIG_RC_DEVICES=y
-CONFIG_IR_GPIO_CIR=y
@@ -269 +253,0 @@
-CONFIG_DRM_MSM=y
@@ -273,0 +258 @@
+CONFIG_DRM_SIMPLE_BRIDGE=y
@@ -391,5 +376 @@
-CONFIG_CLK_IMX8MM=y
-CONFIG_CLK_IMX8MN=y
-CONFIG_CLK_IMX8MP=y
-CONFIG_CLK_IMX8MQ=y
-CONFIG_SOC_IMX8M=y
+CONFIG_EXTCON_USB_GPIO=y
@@ -410 +390,0 @@
-CONFIG_NVMEM_VF610_OCOTP=y
@@ -417 +397 @@
-CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS=m
@@ -421 +401 @@
-CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS=m
@@ -423,0 +404 @@
+CONFIG_EXT4_FS=y
@@ -428 +409 @@
-CONFIG_FUSE_FS=y
+CONFIG_FUSE_FS=m
@@ -434,0 +416 @@
+CONFIG_NTFS3_FS=m
@@ -436 +418 @@
-CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS=m
@@ -457 +439,3 @@
-CONFIG_CMA_SIZE_MBYTES=64
+CONFIG_CMA_SIZE_MBYTES=256
+CONFIG_CMA_SIZE_PERCENTAGE=50
+CONFIG_CMA_SIZE_SEL_MIN=y
@@ -461,0 +446 @@
+CONFIG_DYNAMIC_DEBUG=y

I have not tried to bisect this yet, just probing if someone has already
some idea on this.

Francesco

