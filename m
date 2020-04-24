Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14071B76DE
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgDXNWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:22:50 -0400
Received: from mail-eopbgr1410110.outbound.protection.outlook.com ([40.107.141.110]:31456
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726872AbgDXNWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:22:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsSmP+UEydSAbB/lz7qRuOenj9JcX9i0QkZ+ELcenc70FuIaOVY+snmfCYzINHTvcyexoSdeUOp+7BGE+H6CD1vP+Ui94k96RzIHszZfpEcoBRTRuPHiiToU4kTCAizbgSKYZgyEeo23NN/AVbeHwdxRZ5etXj1lNqpCrX57jYjLNGnB2QpRVwZTUG1dsd0b4A0x9Dbl4BIcNb3X7gWYlN0dssXZaRBOizrI9r5qicbhmJsLzhb8exZNFGuUShtj3tUIvbiniTgbequVDcSdlbyQAsBX7AxMNNjxAK9KvJ9EtrSXX/Cv2UrlZJqJUUmYpx34F6z7kJq1m58jfHIHmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uLlzLiN8yi7CScHuYWI8qOTghBOyIPgyy5Ex2cOm2k=;
 b=dO0m7yL/AHrt9q0jqe9bhuo8udAEGs9eZ1c2heJySUvw/15Q9HsWHfTJPOjqRP6TQ4HVdwwappLOzyOVbbWfbS7fUgf+4A7Cfqgl9p1JjoAxeqUlERCex3BRgukbML8z5q40A8dVTMKINkXmIUObS7kUEhWfzxp4XtHGoL+rzLC1eqaBCb3Ifr9iGWo6kv592L0SNvw8UGGTIVWLci52LWT46jgZe0EaY848X5+ngFt0mOvI9hJgx+b214aO+u+We5ojsS38KzdllvHHWJ8GhulXYILL7cKXospCKI1URcIBOHxpTxFdsolU2ynOWQSL/xTFZgI8RGe3UODBnNnXRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uLlzLiN8yi7CScHuYWI8qOTghBOyIPgyy5Ex2cOm2k=;
 b=cxxk591O2bdCR/xYqZIPvnnyk5vCThR1gAAQFjpyC6ONinOdTxd2BSwQu8hpnhBY1hs3uQL7Pe4PdIHVQXa5bUXmfGJrePxjA+Ca2AUICrPBPjsxVaJ0X9auw0trODsRGuyoVXnZaU8mW6TahsK30J+aaUThSbmEVHwa/Eq4Fbc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com (20.179.186.82) by
 TYAPR01MB2784.jpnprd01.prod.outlook.com (20.177.102.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Fri, 24 Apr 2020 13:22:45 +0000
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::5079:4b36:6c93:3a5b]) by TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::5079:4b36:6c93:3a5b%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 13:22:45 +0000
Date:   Fri, 24 Apr 2020 09:22:34 -0400
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     richardcochran@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] ptp: clockmatrix: remove unnecessary
 comparison
Message-ID: <20200424132233.GA18127@renesas.com>
References: <1587732746-98057-1-git-send-email-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1587732746-98057-1-git-send-email-yangyingliang@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: BYAPR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:a03:100::26) To TYAPR01MB4735.jpnprd01.prod.outlook.com
 (2603:1096:404:12b::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from renesas.com (173.195.53.163) by BYAPR08CA0013.namprd08.prod.outlook.com (2603:10b6:a03:100::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 13:22:43 +0000
X-Originating-IP: [173.195.53.163]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b10ff67-008d-4924-8c47-08d7e852930c
X-MS-TrafficTypeDiagnostic: TYAPR01MB2784:
X-Microsoft-Antispam-PRVS: <TYAPR01MB2784E6A125D52DE9BDCA427DD2D00@TYAPR01MB2784.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4735.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(39860400002)(136003)(366004)(396003)(376002)(16526019)(4744005)(2616005)(81156014)(52116002)(26005)(1076003)(956004)(7696005)(316002)(86362001)(5660300002)(66946007)(8676002)(6666004)(55016002)(36756003)(4326008)(8886007)(478600001)(2906002)(66476007)(66556008)(186003)(8936002)(6916009)(33656002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SqxbuvjorV8nqcnMZPS+rZvry7uHKuBZ2+OId2H8sRnZEqr/Na1rO3B130pbPag5phUHk0xaCA5+ZEirYX4fqpKP3OfHPf9DmDLrgv5VqpWIfeMM3bqOnWgr32Wj1z4HOALEKh3YfQe/uneIcHDqgvHV/XexLH752sm/7B7CemkfTFaEFxfNF0VxM89gWXbUY3+uUyqPG0ARNGie3UO/PzLlBX9WJexjhQ7Wqb6pbsFGJujRMa7vSZdcGgN7r+SlP6bVMZs/Bpr/1MzxkDbhADoN3iWrRB390GWbnvEaDulBVoNJjhxTvFCO54pIyVQUehGJPtXpbri7sldaYTngrluEBDpTe1i4vnP9feRrWad5FZeCg3qmTJMHOzOYjgqYhy/exH8WXOupWqivuEWYFFNWws1umV7B1JapWvDEUBbqhaX0pZvtEZGqgPS9jVWM
X-MS-Exchange-AntiSpam-MessageData: ePf020sB+x459Va/FfI119tzBKB9XHX8RBGoD66b4ffWCuBW6DnC8JcxDsyYZwUuZ4ggi9o3K0B9Puh1fatMfpxT4F8gEJFrud1CrZcT14xlL5ef9VRPfHX/Yu/qtMYSIms6g0gLK13MSX4F+NPEMg==
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b10ff67-008d-4924-8c47-08d7e852930c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 13:22:44.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UScd7w0AQ3zC007Qwbz/iEPlhw1aaV4t7cUxYjHb/RQq5kcerkciJayGIL5nBI6LTgbDCcO1l3Al4nuvZPVuXSknkdDtvyORd89Nd6MlKec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2784
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Reported-by: Hulk Robot <hulkci@huawei.com>
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>---
> drivers/ptp/ptp_clockmatrix.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
>index 032e112..56aee4f 100644
>--- a/drivers/ptp/ptp_clockmatrix.c
>+++ b/drivers/ptp/ptp_clockmatrix.c
>@@ -780,7 +780,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
> 
> 			/* Page size 128, last 4 bytes of page skipped */
> 			if (((loaddr > 0x7b) && (loaddr <= 0x7f))
>-			     || ((loaddr > 0xfb) && (loaddr <= 0xff)))
>+			     || loaddr > 0xfb)
> 				continue;
> 
> 			err = idtcm_write(idtcm, regaddr, 0, &val, sizeof(val));

Thank-you for the fix.

Reviewed-by: Vincent Cheng  <vincent.cheng.xh@renesas.com>

