Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47596515E
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfGKFUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:20:30 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:9250 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbfGKFUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 01:20:30 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6B5GKBa013525;
        Wed, 10 Jul 2019 22:20:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=VjdBTZ+pm3LJOfmGqZQ6VSqQUEhUe0JAC0EtDGvBLk8=;
 b=XMQpHene/pJjpIn7gmDHcFTbKf3LCt0H2Tg35W10/kr2Pu8JWzn7C+l2CKWfuWPdbz5L
 tiC8TEUgh7Nbm0jPqjKdeLqwvJyxg3oIH6S5RxQklRMdyeIZ3pNFP4WinQnndNWxi6WM
 dTyop61nM/Jag5frc76DYrtD/4VdHexv6ByWNqjR3QxbtwJnmhmP5S9wxd3jrBH51T7+
 OQ3veLN1ogYVHb13ePJQXnJ3uFdYp/P38MITp9tPHqlvSBBkz5jZ6ZEn6pcbSwhK2U1J
 H7o6Zsq4m/u0olmGI4rX7l3WtWCZO0hmkn4mIlrjui0GpkiYYnWoFY6pGUNXT7uha6Zq gQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2058.outbound.protection.outlook.com [104.47.36.58])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2tnq0m1j9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 22:20:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjdBTZ+pm3LJOfmGqZQ6VSqQUEhUe0JAC0EtDGvBLk8=;
 b=FT1RREKwCbrkmi67dyoUTcgeWTzgzrOdsSlMcycoFkZqxZLtWiNSYGr1GdIXkxbpUBJ+Mz7IAnt9M2ERQOYY9LVjhRN1gkAoIrRtV/L+N4NY75JhQRSO3zb2Dk8Qkkspd6bAnEGe/kUzHdyb8ZxZjUlRw4Yozwd+CVKZjz+4+5U=
Received: from CO2PR07MB2469.namprd07.prod.outlook.com (10.166.94.21) by
 CO2PR07MB2661.namprd07.prod.outlook.com (10.166.93.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 05:20:11 +0000
Received: from CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::8d1b:292f:5f51:f6d]) by CO2PR07MB2469.namprd07.prod.outlook.com
 ([fe80::8d1b:292f:5f51:f6d%6]) with mapi id 15.20.2073.008; Thu, 11 Jul 2019
 05:20:11 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     David Miller <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Arthur Marris <arthurm@cadence.com>,
        Steven Ho <stevenh@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: RE: [PATCH v6 0/5] net: macb: cover letter
Thread-Topic: [PATCH v6 0/5] net: macb: cover letter
Thread-Index: AQHVNyz5FQb5Z+JcbkKLGishkgcgwabEMWWAgACwiGA=
Date:   Thu, 11 Jul 2019 05:20:10 +0000
Message-ID: <CO2PR07MB24694D0E645213B92F9F6465C1F30@CO2PR07MB2469.namprd07.prod.outlook.com>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
 <20190710.114707.1137811182536299673.davem@davemloft.net>
In-Reply-To: <20190710.114707.1137811182536299673.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy04YWM1MTVlMC1hMzliLTExZTktODUwMC0wNGQzYjAyNzc0NGFcYW1lLXRlc3RcOGFjNTE1ZTItYTM5Yi0xMWU5LTg1MDAtMDRkM2IwMjc3NDRhYm9keS50eHQiIHN6PSIxNDIiIHQ9IjEzMjA3Mjk2MDA2NTE0NDYyMyIgaD0iWWVwNzVLM3g0MitTdllqbS9WTkNSL3ZwY0JvPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: 
x-originating-ip: [14.143.9.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f39dcda-490d-48ac-9087-08d705bf7247
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CO2PR07MB2661;
x-ms-traffictypediagnostic: CO2PR07MB2661:
x-microsoft-antispam-prvs: <CO2PR07MB26611B4491ABC6178DDB26DCC1F30@CO2PR07MB2661.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(36092001)(199004)(189003)(76176011)(8936002)(7736002)(305945005)(6246003)(86362001)(99286004)(81156014)(558084003)(7696005)(107886003)(81166006)(9686003)(478600001)(53936002)(102836004)(6506007)(6916009)(68736007)(6436002)(74316002)(76116006)(6116002)(55236004)(8676002)(26005)(78486014)(71190400001)(186003)(71200400001)(66446008)(4270600006)(33656002)(5660300002)(476003)(229853002)(25786009)(316002)(66946007)(446003)(11346002)(486006)(66556008)(54906003)(256004)(64756008)(55016002)(66476007)(19618925003)(2906002)(14454004)(3846002)(52536014)(66066001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB2661;H:CO2PR07MB2469.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cadence.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: atYZetPOjlfevibQgLodOI9wGbgnDuR2tp+HzcpINHNb+wE9xXKull4anRcBCskq3gbZvAUiiczA5TRanJyilFrsLMrFM53RHgBHiAP1iLE74DfmyGtUGSaFPX289vzsUxkGkixGMLowmibueeMvWXdNTGvtEdbsBm9nah6sP8s4jUvkpCcbxBMV2vAe+1wov9aYQojJRkmJVu+x2nMSDVIiXjyZAxBnGqjrkiR+Tdt5Y4at4Bytn+b3SXnzp7+F2iP/h4EpTer+42Ky7DqMxvdn8ifjcEw8AEDfUM3Tyxv+ullU4SXeoBZcZlECg/kgJaVKpgeLjomnT2eOP/qRhymZDWrPG+wdYInPLu509/8KsHdWE7FipycLzjYLgRJf8YovpiVaZ5Z9rXR+W0JnWUC+x26ib9p8yxjsuzfQ03E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f39dcda-490d-48ac-9087-08d705bf7247
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 05:20:10.8170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pthombar@global.cadence.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR07MB2661
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=667 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Ok, I will resubmit it.

Regards,
Parshuram Thombare
