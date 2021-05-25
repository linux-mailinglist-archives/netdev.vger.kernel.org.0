Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A2F3905CE
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhEYPtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 11:49:00 -0400
Received: from mail-dm3nam07on2105.outbound.protection.outlook.com ([40.107.95.105]:4074
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230013AbhEYPtA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 11:49:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOfFEz/Tb8lrqNHVs6WCBTF+0yLxeAgomQx3OcSKqkCZ/8qNqU8mDamQGMSfSAWu73NwKJkoMoJZtsUeW8cBcc4+AYjXVfKGcILRuSisUrsetO3/DKhbNVbgHDLqYSQK+9QtAsMNTky7gJnex2EMKHgkPT21wKJlOwS/g/vanBhUVb0bFxge/iOsjd17lr2OzXzd9nysqU5o/+oGfMenVoYIhHbXd1Zbi/nrm6/6nYCQKYlXaZmqe2E0x9MPXPjCVfaOKAZiQiq4veKQ6Qcd0BO4re+c2cCiUx/N7Qc5ON5dC0Bv9vyfCFOP+pSgkJ4iE/8fN2jVziaiPX05fuxWRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwrdfMk6OT6TeYSoyjG0vVBbpDl9jLjlV9RQnAa3tGU=;
 b=OfuQHVHW8mGEq+8lZtr+kcECETyKbYpbQGI9rYsCBbNFVnfXq6oKDl9Fy1u34GeQ8hFqeQKCEHcz2cnAsHqbJ7mLepYgepbOgydJIlNcRzIj2LuoY8MMqqZr8Pd0ypaLNyDF75CYPByu/Cb56BryhCJlEySL0TJCI21sDyJMG3WQ5RKcuu6U3lQIkGY8P2joijpxal+nkaRd+oP5wET4c3E7znJVgg3WYaeS1xFoKgncxOnxHckRRr5FHKungMwmjtst94CZAzYP3+Z5w5BeUw0BhJfLP1OaUsbcIbMIrRWBNObaK8CMHawsbHuHOw279Qrcu70FucMqMggGkVpDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwrdfMk6OT6TeYSoyjG0vVBbpDl9jLjlV9RQnAa3tGU=;
 b=YOmcXQMyzPtiUXGus/enbV9cui/A+Hn0IAzGOhfTFPRtCO4ERoz3IDSJwt6Fe8ZHSFb4YS+mRxgaoYoozDDHsMN+lDb90eMHmrEcvrYpLEgavsTJFDn8dldg1+xM/d0AnoVdX+LHcNirSzmpVnHT6z+7FD1eOsmYO6SkVy7Jw+o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4874.namprd13.prod.outlook.com (2603:10b6:510:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12; Tue, 25 May
 2021 15:47:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 15:47:27 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Simon Horman <simon.horman@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: [PATCH net-next] nfp: update maintainer and mailing list addresses
Date:   Tue, 25 May 2021 17:47:04 +0200
Message-Id: <20210525154704.2363-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a]
X-ClientProxiedBy: AM3PR05CA0151.eurprd05.prod.outlook.com
 (2603:10a6:207:3::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a) by AM3PR05CA0151.eurprd05.prod.outlook.com (2603:10a6:207:3::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 25 May 2021 15:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf6af0e4-acf6-43b1-5cbf-08d91f94659b
X-MS-TrafficTypeDiagnostic: PH0PR13MB4874:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4874CB4B59F098A69F8BEC05E8259@PH0PR13MB4874.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbHbYk4BVWBLFWd5iMDZpvyLxT+cD0S8rM7v3UWL+m4szzm4HpevrRkhG7b5sIlaE+BfYd5TT8p9EzPG4FE2YBdZHDPqoWce9L4lFE2LXEFKvDvqDhlddEJfkLpsbccJhUnPSNaQ0mogHN1vcU7iidl3k0OSC+hbRL8jq6O+J0E3FzmSr7EgET4qVKV+U3QTOQD9GLZNnc2gm0BDSQftIZmFYlfcHEXkSybj1OXihKT0ngvweOcC1cXn9+1uicm1D7qCrW9b1ULpqL46ZQ+8X1QsWRAuGpkIi3aXJR4V76gUiXHQJRG5lJZuP2+tNFExJYe3GHjwfqWfvKcwG0bsWb70CHItnDGgSZ4uEus5X3+DcF7J2exNEqfj7JXBftyAqFZazk54wI64efybFFA0qstvgQ0oMoVWCuhnax0jJctSI1ZIfGIDMnX5wdZKR2lk+fHtMMA7xiC7yUUJUGQL6gcZsOGvp8n+Oj+fLSLuxBbqonbRpbFWlzfcMH9DtzJxQTAikhKDT28SPaX0p5XZ+MKL5/mhImbtrIiqyJeytAlgjALmxSOe8wpypTx+RnP8zc5Tupgu2/w+U0zXHlZDRdmAi9DKFIQdDepxGvNIEWMnjqG3qWAjZcSDAYKp0CfPcrvL4XFgui4pG1QAFBXLeaTYiiSCHqVObrCHMM+Uv3CYb1mGZRLsXo52GUSsBPyU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(346002)(136003)(376002)(366004)(316002)(54906003)(66556008)(6666004)(1076003)(478600001)(86362001)(110136005)(66946007)(66476007)(6486002)(52116002)(4326008)(36756003)(4744005)(2616005)(44832011)(107886003)(38100700002)(6506007)(5660300002)(8936002)(16526019)(8676002)(83380400001)(6512007)(2906002)(186003)(130980200001)(223123001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wvRpN2MKZaKOSmpsaNncGDpxV3fw6lCL3tVQSK9kANVhV921LNlgOg3URQ9N?=
 =?us-ascii?Q?YMKh6gqAAJ/Ys57hK5xyzjib1Uhi9f7n7su0zK4PDFll+rQY3g8emonh9RI1?=
 =?us-ascii?Q?faUcR2GEovm2QTBm0GyqAY4up3EfcpIbQFuKbBxhENcILjKtb6MIPnUvkGHZ?=
 =?us-ascii?Q?vtC1FLb9U1Bnzo68IbdM/0y2M1tKkiwBHx4+3JwlN09Ld/baY9youRy1yy/w?=
 =?us-ascii?Q?HtU5lkfn77CH+b7Dz+dEcGySbhI7VbVAMjwKiQUUoEN4hEiwmkjc/PN/AcXH?=
 =?us-ascii?Q?rJkuCdljK5EQdBmc7kbiaQ31CawaP6gLGcLUUP2PqQ3NZPOd/bnzba7d9v9+?=
 =?us-ascii?Q?EOO44fFy9kiniQlcksWwBJzB5pTK/F3nZbsshu0QGCiDMt5iuFCtizkVm2sZ?=
 =?us-ascii?Q?inqcD74YiMoo/M1oeAFO3T5/9VQ07IaDc3kWc+E/YzDbDCo5oQYqAxDfaLqK?=
 =?us-ascii?Q?yECP/Lse0QHIqmP73zrM4VphwqfCETV6dgkmaf3/Mg+EnTp8AT0ifTNSbfRY?=
 =?us-ascii?Q?plRZ3zswcW52/bEdIr9koMNu7NxWSt/+ZkYXtJsbOqal1r/t53y0BjCpVqMt?=
 =?us-ascii?Q?z4IU44sPHh2x2KZQJ2+9lwPCReSpdBQTi0AbpTY+fdyYk4IaKeAK8M/RRQ2t?=
 =?us-ascii?Q?yQa7STxYbX2uVQwuL9+Jnwn3mO2yY82uRM4Bhfl8vuVqN3q9P1mPpt+ke37Z?=
 =?us-ascii?Q?uaDDvmFXqNhUoYO8qZ2XTRdKzzY2O/qu0dHJAJ+URPTojTAyBuoPb80SmONT?=
 =?us-ascii?Q?1qBLUQL71yze2E4Zau/QgQvfqgznk4Os3IcZwxiSljdPiB9T39mY6jKgF3uS?=
 =?us-ascii?Q?8YmJCvOAWjiPbVYBaAtJjpTkMzONPASuvpMZa3MpOEkwI3RXK8UqY98jMJBa?=
 =?us-ascii?Q?OriI1yRpYqA45ifEYwZ084NplsdGL5ufhb1KUsepfXkYfjmhdUnd3791DttT?=
 =?us-ascii?Q?BzNw88CV5315czUj4iFy4Fr8c59Dq3rhrcbvOK1l/iUu7mwmkD811Dtmsi/e?=
 =?us-ascii?Q?0X2ZfNcTSOJZgaif9MQ5ZgPOAtVt9v9rX40/lVIApM5M+MHCOyc9ZxCc8kUk?=
 =?us-ascii?Q?joXKVfhfG7jS7Fz2343XbKBt+liCHbKTL4YXpovUuGY6tMwncwhxid++Ajmf?=
 =?us-ascii?Q?2HfRtVyadaQm/KdVPEvoGMDI8tfLiWHGtap6YD0DNfNG1MR4j9MpvYVwCeJW?=
 =?us-ascii?Q?AIjDr3YJhMsb2WnPeq73zm/5A6g9zeTNlQbJiyA1tNJZeculp8MvOu9BT7tq?=
 =?us-ascii?Q?lKEryQsZXxapBLvE2lS+hAWSsB36Fs5UApbIELSjuDxEDdki1nbgwwHd/+FB?=
 =?us-ascii?Q?0dM5zLWoncGapoJbfysum9/0FfKWdb1vX8uneyUaPBRw85AhXwve+Q1hl8NR?=
 =?us-ascii?Q?bdBiozLlXd/xV8tyvgw9rj5xVc2R?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6af0e4-acf6-43b1-5cbf-08d91f94659b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 15:47:27.2436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSSzBZ1qflOQSqa3IAzzLvQzBI8IR0f/mckEyL1xRNEwrK0xVZrXNyieVg9EG8tonvC9ZcsYaHp2mz+9vah94aBHm2rFgDOC1pW0hBInPWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4874
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of Netronome's activities and people have moved over to Corigine,
including NFP driver maintenance and myself.

Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b9f329249a5a..fd31ecf7da13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12686,9 +12686,9 @@ F:	drivers/rtc/rtc-ntxec.c
 F:	include/linux/mfd/ntxec.h
 
 NETRONOME ETHERNET DRIVERS
-M:	Simon Horman <simon.horman@netronome.com>
+M:	Simon Horman <simon.horman@corigine.com>
 R:	Jakub Kicinski <kuba@kernel.org>
-L:	oss-drivers@netronome.com
+L:	oss-drivers@corigine.com
 S:	Maintained
 F:	drivers/net/ethernet/netronome/
 
-- 
2.20.1

