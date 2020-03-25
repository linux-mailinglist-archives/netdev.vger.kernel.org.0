Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A0192405
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgCYJ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:28:35 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:26178
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726154AbgCYJ2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 05:28:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpsLz2oIi6/H5g/Ty67XfSXgtDCLJGxoGVyxaRUG0+Ig15Gb0UoCiaM9U0nMv07DuDqTRfnTtja2yNwtPcSRbtjr2h3xmNhsAxO5WseyfgqBWj5EyRUXyADlPHQa2ldHkI+frjxSBIu5eC9CSaojfAet/5WdV9iTb7BuE2B4EkXrmDE0sHRkFCSqzWA0OZ59zCDC8IcY1bwcDE+RV/Ojn+B2tph+AUpaWz+6XjVared1ZugrSzIj8jB+ZKLW5/CNtJZXdcf1nKD/+4pSR2DGuZ+AP0L7B5JD6uImj19jKxMzodrBMoQoU6yPkKJH9mKVdV8UG38aPp+SM+Ip/fEk4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYshHAvOR6RNTfKizZm+ATE1+hXdX8uWo78z6k2wDcE=;
 b=MtTPfKsWrjrcu5rtLGzYWa7lLu281bVFRVSUGjYLGtuK709FHSfGozHv3dP9U0DiuOnvqi4R8H4sXeKzTd0fOsvHkP9hsLE0XCzPdTit1W3DQ/qom3b1mqjINsWrZz7vWKeNlf0XQut9ABVtFObxbe4VHTwZL8Dskym23d+dUBGroUEWubxiM/HkRMs8HOYxesy66E0PDYBQqfGUn38KQcubRcNwffX/zaPnCY+VbeYIkqinbCHj6QFXR12gkk/kP6/cQmvQeMO/b0Y8oyRW2tbRgbnU/dPT3nWfBmOEEJSbnk8k18f4QLQDmrxMDvCcFP/TkQNTZ5BfWxfAvEisiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYshHAvOR6RNTfKizZm+ATE1+hXdX8uWo78z6k2wDcE=;
 b=NGJm80lLZsRkGGVdmfawA2nRhoqcbAYNEPYqataLpavG2peF+Rrk4NHtoQWWgsLbW+FgrxWzuPX+9N+E2WCny6pJsqwnk5Wwm5PR0oHhnptyehE8Xqa2AJZ2eZcMNYvc0SszGrxVdMuXP105BGxk/qp3tQ7XEL3fwVu5G2T6Xog=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (10.186.174.71) by
 AM0PR05MB5921.eurprd05.prod.outlook.com (20.178.117.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Wed, 25 Mar 2020 09:28:31 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::6923:aafd:c994:bfa5%7]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 09:28:31 +0000
Date:   Wed, 25 Mar 2020 11:28:28 +0200
From:   Ido Schimmel <idosch@mellanox.com>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [PATCH iproute2-next] bash-completion: devlink: add
 bash-completion function
Message-ID: <20200325092828.GA1332739@splinter>
References: <20200325092534.32451-1-danieller@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325092534.32451-1-danieller@mellanox.com>
X-ClientProxiedBy: AM0PR02CA0026.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::39) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (79.180.94.225) by AM0PR02CA0026.eurprd02.prod.outlook.com (2603:10a6:208:3e::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Wed, 25 Mar 2020 09:28:30 +0000
X-Originating-IP: [79.180.94.225]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b25070dd-801d-4fb9-9fb0-08d7d09ee1e1
X-MS-TrafficTypeDiagnostic: AM0PR05MB5921:|AM0PR05MB5921:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB592119965C8F80DC6AF19E37BFCE0@AM0PR05MB5921.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(9686003)(107886003)(6486002)(52116002)(6496006)(186003)(6862004)(26005)(16526019)(86362001)(478600001)(956004)(4326008)(33716001)(1076003)(8676002)(6636002)(316002)(66946007)(8936002)(81156014)(5660300002)(81166006)(66556008)(66476007)(2906002)(33656002)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5921;H:AM0PR05MB6754.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEv48jehMW9FpWDKPUZHark32uCpde7b9IGYmuuDzjKsa8yOZzUYM9ot4IEyEN4JbeRrei2sg6/r3525WkNlNyrXGtVHvuHJJNpf87A9baELByXrISuzzNI2Nl4z2e7hEFpPM6sBb8XB9hMTsSRAMkxE1xCTkMq9rMeMcenx/WgkBOJJrlUoSNgHbW9EVUMB1S9StzExlYzLw9DbOGHyPzSV3lFHsB5iACC8XSNzmKo66GclKLH4ikeW4axI2SQyuOG3mHbYVO90U1vt5kTjQPKmUeePEIfB4JO31TAWohQuvlMSrdcXTQwDp7qLYtyQJ8EnK+i6ysO5gXTg//9nOyfNKpJIzug1xYUVLrL5sJzHMfJ0lkRtzVa+2tuPTLiatxDUEi8nZht0Gdn7vYh9pkl7OtKEyrNtXI2AdQGFypm2jVE4WgFEfQLcNcG96ivg
X-MS-Exchange-AntiSpam-MessageData: U46t1QIJR9N1ao6xYoqbWf7VcoViqcI8AjSY4pmHJ2MwNjpKya6Bjy/2Ht6FWe3fIT7MvdteabRyZmSBignGGN9aOQDpYSw9hV4iUR4L/mKJMACSv/1OYQC/sl2UScreESxUvMQ1AQPzRmrD5chcnA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25070dd-801d-4fb9-9fb0-08d7d09ee1e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 09:28:31.0549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyIAJ2fD5tVGdNORE/hZsn5V3MDJxjVOA5QvfiP/9mgmvOJvR3q1PQ2mhzPc6hO4SG1o+zXbjpxinpM2UigwNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5921
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:25:34AM +0200, Danielle Ratson wrote:
> Add function for command completion for devlink in bash, and update Makefile
> to install it under /usr/share/bash-completion/completions/.
> 
> Signed-off-by: Danielle Ratson <danieller@mellanox.com>

Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks!
