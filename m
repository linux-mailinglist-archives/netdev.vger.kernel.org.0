Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71404112D56
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfLDOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 09:18:22 -0500
Received: from mail-eopbgr20114.outbound.protection.outlook.com ([40.107.2.114]:30234
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727828AbfLDOSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 09:18:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3nbyDj6++zY6W04UVnuak8mJEjY2gCRAQK4mrbiTU86P0v3ba71jHHUklFCNKwWV2j6BIsdc0XFZvtROuYfy65jHvlhFOHqxoE4/czUvgikMQuhae30WSBS8TEdpDCM4z8sR7q0jixWgbUvS/Tv9ifS7MqqpxrMGuUZFQwm8wvncFq8ORJFg1PQHZqJLBAgyvuRIttDvU25rA3ZUajIW/IC9cvXDqg2QpmTHLRawYNM9bOjiDhVjc74MyKNzqTF8Pw6uyiEI9R45h9ArkCwk/bC7UyZz+wWU5Gsn9O0Xyoserx+8ideRD8sQj9Xit6aLM3kIljpztrOVrfc0sOBKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aI+lvP5JGs/8DmkrBQBnMtTjE+hZUI65WXmHFt7TCg=;
 b=cYXLtgCTJ7cxAiPPd66lal+IkHHqjJPDJxvuC0Tdgnn/G++phrYxiA0+GUpOtvPCoIZ3Gtr/XkPsMvhOs/4IaKitGGdx1HAM7Rrpyc8vOdH8ClQ8C31wOLbO7mV/EH2ilUcmIv/6uBhtq4xnOtrpwZAy4yur/KUv7MLQOTB3b7CGoZRnzYY1cE8wfnPH3KvTIx/TS1joG6A/BLKYmykiIWSiGCL5Fpk1GVwRvLNSpOIMFJ0c8ojU9aiSrZ6DZTy/QEe2VwGcc0EdoKVK6hhEcIvta7akMOHzqvoBK74TlkATn1pDhajyhCQ9+ruRPYlteSXWYpdDPN5I5gefrzxbXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aI+lvP5JGs/8DmkrBQBnMtTjE+hZUI65WXmHFt7TCg=;
 b=feAkek+mfnrWL4J7uJkzPApfw7HRDAkXS+T5N0oIfrBbdmEOQXm46kNFTqWIcApSH6O9B7rRqFyUqWzz9Wal0rqHg73kLsbPwBuYh5nZid2ADSHxRv3EqQ8Hc6kf8+R5G05eQgYAOanApbSUrqSmMUTFT/D66pkTOiDbeXjhxrw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB4831.eurprd07.prod.outlook.com (20.178.8.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.4; Wed, 4 Dec 2019 14:18:16 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::1512:231a:ef92:4af0]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::1512:231a:ef92:4af0%5]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 14:18:16 +0000
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Subject: net: dsa: mv88e6xxx: error parsing ethernet node from dts
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     rasmus.villemoes@prevas.dk, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
Message-ID: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
Date:   Wed, 4 Dec 2019 15:18:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:205:1::16) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [IPv6:2a02:1811:b219:a500:baca:3aff:fed1:9b] (2a02:1811:b219:a500:baca:3aff:fed1:9b) by AM4PR07CA0003.eurprd07.prod.outlook.com (2603:10a6:205:1::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.4 via Frontend Transport; Wed, 4 Dec 2019 14:18:16 +0000
X-Originating-IP: [2a02:1811:b219:a500:baca:3aff:fed1:9b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5560206c-fb64-4a83-fe06-08d778c4ce25
X-MS-TrafficTypeDiagnostic: VI1PR07MB4831:
X-Microsoft-Antispam-PRVS: <VI1PR07MB4831C835CD4323BBE619AB28FF5D0@VI1PR07MB4831.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39850400004)(346002)(366004)(136003)(376002)(199004)(189003)(14444005)(5024004)(5640700003)(316002)(58126008)(31696002)(54906003)(66946007)(5660300002)(6486002)(66556008)(66476007)(86362001)(305945005)(7736002)(6436002)(6116002)(186003)(4326008)(50466002)(81156014)(1730700003)(81166006)(2616005)(25786009)(16526019)(31686004)(52116002)(2351001)(2870700001)(478600001)(36756003)(6916009)(8676002)(2906002)(66574012)(2501003)(23746002)(65956001)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4831;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0DSxauhuO0eMR061Dz4IUimEr89ixVgZe9OeY6i1zzPfwiS+TIuFvWyceMA4D+3AxWaitUXteydKobOOlaVT0ZM7kL8yYbG6+kYTCjtngS9RswpC5WyyA0tS9dDTL9roG6OnXEnBgvHmmqOcAjMmPW/WYQ7gj+k6ddScg64eud1gyvmzG6QwglkJVZ11I85s6IM3bO6I4bFu9MmzG47A43GMTe5BseTygLzY/0+dK+y3jcNeUCZG2fzOqhcdRoAFjw8z6yG+eio+rY/Xp/b3COkPatQ7z0uODnZ6/8p6Ta22nT6gqg/mNBbgJmegYyvAE25H9hlQ3DMtHuuWBJOOajpGPVNCbjuOpDbG4ZHkgLkZWhXI1waQYISv4fXCENH87/oxMwWw4akYyuCgEJIhIq7Rq3rWGH0Iw39mzLYunB+0F462PvuCdOrhuVUPvLC
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5560206c-fb64-4a83-fe06-08d778c4ce25
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 14:18:16.5762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9kABdZ3PWi+izO6MUdmZObwYnB3x7NnGUYuTCekQW2grhjxcUrda7Ahx0GKHdb65rD8yAOTSx92UKOYAZ9B/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4831
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I extended the drivers/net/dsa/mv88e6xxx to add a new switch to the 6250 family, the 6071, see below. I will properly submit a patch once the driver is up and running.
I branched mainline on 4d856f72c10e Linux 5.3.

The problem is that I do not succeed to get the network interfaces specified in DTS. Here the interesting part from my dts, copied from vf610-zii-ssmb-spu3.dts, also imx6qdl-zii-rdu2.dtsi is almost the same. My dts includes imx6ul.dtsi.

&fec1 {
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_enet1>;
    phy-mode = "rmii";
    status = "okay";

    fixed-link {
        speed = <100>;
        full-duplex;
    };

    mdio {
        #address-cells = <1>;
        #size-cells = <0>;
        status = "okay";

        switch: switch@0 {
            compatible = "marvell,mv88e6250";
            reg = <0>;
            reset-gpios = <&gpio4 17 GPIO_ACTIVE_LOW>;

            ports {
                #address-cells = <1>;
                #size-cells = <0>;

                port@0 {
                    reg = <0>;
                    label = "eth0";
                };

                port@1 {
                    reg = <1>;
                    label = "x1";
                };

                port@2 {
                    reg = <2>;
                    label = "x2";
                };

                port@5 {
                    reg = <5>;
                    label = "cpu";
                    ethernet = <&fec1>;  //<-- here error

                    fixed-link {
                        speed = <100>;
                        full-duplex;
                    };
                };
            };
        };
    };
};

Here parts of dmesg (no error reported):

[    1.992342] libphy: Fixed MDIO Bus: probed
[    2.009532] pps pps0: new PPS source ptp0
[    2.014387] libphy: fec_enet_mii_bus: probed
[    2.017159] mv88e6085 2188000.ethernet-1:00: switch 0x710 detected: Marvell 88E6071, revision 5
[    2.125616] libphy: mv88e6xxx SMI: probed
[    2.134450] fec 2188000.ethernet eth0: registered PHC device 0
...
[   11.366359] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
[   11.366722] fec 2188000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off

When I enable debugging in the source code, I see that mv88e6xxx_probe() fails, because *'of_find_net_device_by_node(ethernet);'* fails. But why?, &fec1 does exist, although I find it strange to specify &fec1 inside &fec1 itself. But according to documentation and other examples, that is the way it is done.

Here some more details:

- The detect, and register read/write is OK: with #define _DEBUG I see a lot of successful register read/write (to global and phy registers).

- When I do not add the first fixed-link in DTS, the kernel hangs, or oopses, or runs but with warnings (..._sendmsg, probably trying to send dhcp requests)

- mv88e6xxx_probe() gives the error above because mv88e6xxx_register_switch(chip) fails, with 'goto_mdio'.

-------------------------------------------------------------------------------
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h

index 8d5a6cd6fb19..9c0b84fb69b0 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -100,6 +100,9 @@
 /* Offset 0x03: Switch Identifier Register */
 #define MV88E6XXX_PORT_SWITCH_ID               0x03
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_MASK     0xfff0
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6020     0x0200
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6070     0x0700
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6071     0x0710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6085     0x04a0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6095     0x0950
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6097     0x0990
@@ -117,6 +120,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6190     0x1900
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6191     0x1910
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6185     0x1a70
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6220     0x2200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6240     0x2400
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6250     0x2500
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6290     0x2900

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 4646e46d47f2..207b777da98e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -41,6 +41,7 @@ enum mv88e6xxx_frame_mode {
 
 /* List of supported models */
 enum mv88e6xxx_model {
+       MV88E6071,
        MV88E6085,
        MV88E6095,
        MV88E6097,
@@ -77,7 +78,7 @@ enum mv88e6xxx_family {
        MV88E6XXX_FAMILY_6097,  /* 6046 6085 6096 6097 */
        MV88E6XXX_FAMILY_6165,  /* 6123 6161 6165 */
        MV88E6XXX_FAMILY_6185,  /* 6108 6121 6122 6131 6152 6155 6182 6185 */
-       MV88E6XXX_FAMILY_6250,  /* 6250 */
+       MV88E6XXX_FAMILY_6250,  /* 6020 6070 6071 6220 6250 */
        MV88E6XXX_FAMILY_6320,  /* 6320 6321 */
        MV88E6XXX_FAMILY_6341,  /* 6141 6341 */
        MV88E6XXX_FAMILY_6351,  /* 6171 6175 6350 6351 */

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0a97eb73a37..c697ebd6e336 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3881,13 +3881,34 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 };
 
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
+       [MV88E6071] = {
+               .prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6071,
+               .family = MV88E6XXX_FAMILY_6250,
+               .name = "Marvell 88E6071",
+               .num_databases = 64,
+               .num_ports = 7,
+               .num_internal_phys = 5,
+               .max_vid = 4095,
+               .port_base_addr = 0x08,
+               .phy_base_addr = 0x00,
+               .global1_addr = 0x0f,
+               .global2_addr = 0x07,
+               .age_time_coeff = 15000,
+               .g1_irqs = 9,
+               .g2_irqs = 10,
+               .atu_move_port_mask = 0xf,
+               .dual_chip = true,
+               .tag_protocol = DSA_TAG_PROTO_DSA,
+               .ops = &mv88e6250_ops,
+       },
+
        [MV88E6085] = {
                .prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6085,
                .family = MV88E6XXX_FAMILY_6097,
                .name = "Marvell 88E6085",
-               .num_databases = 4096,
+               .num_databases = 64,
                .num_ports = 10,
-               .num_internal_phys = 5,
+               .num_internal_phys = 8,
                .max_vid = 4095,
                .port_base_addr = 0x10,
                .phy_base_addr = 0x0,
@@ -3909,7 +3930,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
                .name = "Marvell 88E6095/88E6095F",
                .num_databases = 256,
                .num_ports = 11,
-               .num_internal_phys = 0,
+               .num_internal_phys = 8,
                .max_vid = 4095,
                .port_base_addr = 0x10,
                .phy_base_addr = 0x0,

-- 

Kind Regards,

Jürgen Lambrecht
R&D Associate

