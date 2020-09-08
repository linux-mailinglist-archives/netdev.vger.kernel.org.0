Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DFD262028
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbgIHUJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:09:52 -0400
Received: from mail-eopbgr00056.outbound.protection.outlook.com ([40.107.0.56]:58754
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729773AbgIHPSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:18:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0juIjn2cJqFWMg/LCWBEgD92C+2917SgVj4FPp2DlxnHKkDLL+TsFfYKJDNRl+YJHtiJMNtI8ctB2FLX2S/+rSR2xGuegW65bMIzXtaUA0geTVAZK2berwe36UemoYcrPY4l9MoJqgMN7RoAag6b/RVT7Q/9dflYj+W3wue8wcpUKAtj7y2GGsJLC9a4dN/Oq9opiu42eqwR1W1gklgFSmpXhecZby2NeZML9Xb7+oJELu6v0CXbkk6NhzM3JsZFzFZ7ROPte+JuNGI3XIvLqnCeAhEyeFCMd84g6KcmKTze0qY5AO/IGTMjYl8t8717vrsvapkXjCqTcI2p2zjeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8s0CFFPlwqqltQ9x84JqJN9AgppuA3KaOR0DFpKyI4=;
 b=IQmgvYthuUWRJHiw0hPe+wnfyLDtkjHxCviY8UHMxcOW9J6L88PMYoj8mKhVYSBJbRH5SBcIdow+vBxTMNfireytM7GO+YnH1XICsiWq26Y+bIZnxYP3eetqrRqjpNKO9ebg+8PCzE6ipstVV8WO8VG+KtQuF2w8wu/N5MCaQGnCIdpdQ+0RRWpMeElc4GpkB9oDO8TmdQMXOuzXPXHkvONOTnXZIU0HATt/qLLwVSAUw2CuspmhZbteKxBn8Z8H24jZpClze7K1IkNPOgc6M7UneqmGnXAFaanD7lNHY1vRf/QuC3TfNLoG/oZrD4gB97bkFJ9Vsh8LMKCsnxCzZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8s0CFFPlwqqltQ9x84JqJN9AgppuA3KaOR0DFpKyI4=;
 b=ChdbUr+uET7K1xVAirmF1JU13/lX9tsbeCGUl/yq/JRW5iYvQAvAw1vK5tegAdlxXpwMco2cSJTZaLF9lfxZUss7/mg6qLdbriydLTzkoG/mzt529ok6RSORywVS+rTz5iMIykxMshzqcrA+X6JpvdeT6rtuuCBC3LTn6GaZzf4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM8PR05MB7331.eurprd05.prod.outlook.com (2603:10a6:20b:1dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 14:43:12 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:12 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v2 2/6] devlink: Add comment block for missing port attributes
Date:   Tue,  8 Sep 2020 17:42:37 +0300
Message-Id: <20200908144241.21673-3-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908144241.21673-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200908144241.21673-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:6e::25) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:10 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff3bcb94-74c9-4f2d-96f9-08d85405829c
X-MS-TrafficTypeDiagnostic: AM8PR05MB7331:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM8PR05MB73318A341232DED16B112BEDD1290@AM8PR05MB7331.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zfwq7vuyxGrTAWP9jcR1loDAk+hDhT5n5XqkxonGxRLGUv0+avSwB8CtqwoaBXybHLyWBBm1YAMwiiu9q2+vdo6OM9/3ErD2/vWS2Ry8trZHFpT4u2610JB5++T/txDNFq3IU9ioJUao/YvRHtMW8f4wAUybrvJvasiPe22un8qdbgGoDSr7U7bSjIiDPTMIw/ByG1fykpT6AVyoamBOlkuWZAPTonupZ1mglH7I6JbxgipPSTHG1W/c5W/x0CLYiPQp5MSOOfoTJL7twedLiVR3qiZuWCuMZV/T9Lk4tCTNnDIN2HcvO7Q6FMrjultkF6bRiNbQ2unEK3aZWU2cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(4744005)(8676002)(5660300002)(66476007)(66946007)(66556008)(2906002)(36756003)(2616005)(956004)(54906003)(186003)(8936002)(86362001)(498600001)(16526019)(6506007)(83380400001)(26005)(6486002)(1076003)(52116002)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DScrlyBOgtqC/liliy+osvP8Ayv0Cv9LtkVUPed6nvDvv4ZUJ7WcYjGfmX2fEfT4M0+7WTJttTD9nR/X15BS0XNnHqS4unATMsYwmgWVm9cyaf2KZCVKy/Pm2cAvtaGiY1sOdgfcY3po3Naz6JRROZf6h8jK0/HzOTfaBJ9JHHRCYPxsaIao7HS//cxXqUH4vTqdq6vTjIb+JE1q6378SZ9w+t0AADWSHKI8/t7EVTanMqZ175RhyPhSbZFx0tIrNoQLdw8k4taPw3sZVcJHoU0YXydakmqLwinXogEWE/9JOp9d+V1KRpXtAsNLbBqj1+N3Hol4+sNZCkfmmgJP+Wenmf9VBMhBpohJmyNNZNPOuae4DV78R7f3ChVFeBm1Vqb/d5vaMoiRW74XtajJTbPFuH0ocoktRV63/AY9OYSMfc88jVWBp3Xu1IH/PWVr9Vu4aC/SJn6YOQo7/9Zd60TL3mmGrq8eJgT4uAPCIRwNcOL1dcnwU3qbNc/KAcB+PzNqNyVlFKEc651iW8to8LcXN9a+JXMAkeUlLG5eIPGf/lem5+gcZDITLPi40G5wdHEhi7du5qEVxabJu0DWsuZuPz68vgGqvzW9u6dAzMPcLG4assbr3CHG3K1BOurwj1FW6fB7DCFurJtffXbdxQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3bcb94-74c9-4f2d-96f9-08d85405829c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:11.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWql6RLs2TvQMFCS48cguHwD5yde/0MuJIG4WfJ3SaLZPjuo36CkOb+2s2Zj/uf8i+HkylN8RcdsCXdnwuVjBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7331
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add comment block for physical, PF and VF port attributes.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 include/net/devlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f3c8a443238..3c7ba3e1f490 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -73,6 +73,9 @@ struct devlink_port_pci_vf_attrs {
  * @splittable: indicates if the port can be split.
  * @lanes: maximum number of lanes the port supports. 0 value is not passed to netlink.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
+ * @phys: physical port attributes
+ * @pci_pf: PCI PF port attributes
+ * @pci_vf: PCI VF port attributes
  */
 struct devlink_port_attrs {
 	u8 split:1,
-- 
2.26.2

