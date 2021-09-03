Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C854007AE
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 23:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350451AbhICV71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 17:59:27 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:9780 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350122AbhICV70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 17:59:26 -0400
X-Greylist: delayed 12581 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2021 17:59:26 EDT
Received: from pps.filterd (m0049287.ppops.net [127.0.0.1])
        by m0049287.ppops.net-00191d01. (8.16.0.43/8.16.0.43) with SMTP id 183IEHPB044742
        for <netdev@vger.kernel.org>; Fri, 3 Sep 2021 14:28:45 -0400
Received: from alpi155.enaf.aldc.att.com (sbcsmtp7.sbc.com [144.160.229.24])
        by m0049287.ppops.net-00191d01. with ESMTP id 3au5nymbrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 14:28:45 -0400
Received: from enaf.aldc.att.com (localhost [127.0.0.1])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id 183IShx8002434
        for <netdev@vger.kernel.org>; Fri, 3 Sep 2021 14:28:44 -0400
Received: from zlp27126.vci.att.com (zlp27126.vci.att.com [135.66.87.47])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id 183ISbua002296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Fri, 3 Sep 2021 14:28:38 -0400
Received: from zlp27126.vci.att.com (zlp27126.vci.att.com [127.0.0.1])
        by zlp27126.vci.att.com (Service) with ESMTP id CDA8E411EB0A
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 18:28:37 +0000 (GMT)
Received: from MISOUT7MSGEX2AF.ITServices.sbc.com (unknown [135.66.184.205])
        by zlp27126.vci.att.com (Service) with ESMTP id B680140006BF
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 18:28:37 +0000 (GMT)
Received: from MISOUT7MSGED1DB.ITServices.sbc.com (135.66.184.185) by
 MISOUT7MSGEX2AF.ITServices.sbc.com (135.66.184.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 3 Sep 2021 14:28:37 -0400
Received: from MISOUT7MSGETA02.tmg.ad.att.com (144.160.12.220) by
 MISOUT7MSGED1DB.ITServices.sbc.com (135.66.184.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14 via Frontend Transport; Fri, 3 Sep 2021 14:28:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgeso2.exch.att.com (144.160.12.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.14; Fri, 3 Sep 2021 14:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vc/VyslX2nF0gJ4e9YGCiDCImxA3EgP4T/M+z+cSDq20F8XihtG1gXwO6QaGikH5cMGLCVWvCzGLO4KBAXFNLvv+QtfRYLZN7W4iASlenG+119EIlHpyGgatMIxB4GALAZCk3chET2VGgv4smiWGU/i5/9xWXkcAnbS05r+dAqVhFJVcB7oNy65h+gQ8bgrF96BZpdriCao5tQomoHcb/J0uwL1clSUZU6ut0BVZmY3AyYMjWcsTyE+dlGdfaR/8Ldrc9RxLVV9VwEOOX5PsPm6gLHuDp6eJd22ZWf4GycQdtEys7RU+WSb2STQxsZWqaizAhX6GLddatwAZl38wjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=thNFd84ol9nrMHapbXko/vCKUlmxSeenKH8tWayAs0A=;
 b=d788X3x22q6NTkvRTcCuJlG2BIx7NcM1NWAtygMTvwthWU9W343gznZCEIxiTicVSYELYxdghj6Kq2w10utXnv93H23IFHhV9zJEBQ03GCr1m8mQgV+q6TPWOnuDy6Dl0U3C6wuXbBowKbJnPr3O71fV6dOlhqiDteAma3dKryubxrEkkO+mnmPBacaS5M3khEWPrNr6pJvV79uKfcWXy4070pGmXADqqVT7ku5XAe/MtnHdVT6Vh4X/OpEqCLxU5/cx545V7yitjuARrd9EDeLn9iWcODsXTmBpw82zRgPh40vXfnevpd35X/BuNuPcFWwVMbFnVuSMF6RhJfa+0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=att.com; dmarc=pass action=none header.from=att.com; dkim=pass
 header.d=att.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.onmicrosoft.com;
 s=selector2-att-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thNFd84ol9nrMHapbXko/vCKUlmxSeenKH8tWayAs0A=;
 b=ed2SCKSHIXSy1Vej2N7yY5zV3lVIhu9RMwXd2sQHVUKEeW0kc5M/3vYgCvdGHGYsbRqNVcGSkKEN5tbMT5qvzZKPtSub5iKFR2ceWRcDnsTTKt48TcEZkx1CkZ+PxNzxeRovE4kx49ukClADgoymztQVNA8ZPaB1yVa0ggf7X/g=
Received: from MW4PR02MB7233.namprd02.prod.outlook.com (2603:10b6:303:65::8)
 by MW4PR02MB7236.namprd02.prod.outlook.com (2603:10b6:303:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Fri, 3 Sep
 2021 18:28:29 +0000
Received: from MW4PR02MB7233.namprd02.prod.outlook.com
 ([fe80::7daf:71bb:75ab:420b]) by MW4PR02MB7233.namprd02.prod.outlook.com
 ([fe80::7daf:71bb:75ab:420b%8]) with mapi id 15.20.4478.023; Fri, 3 Sep 2021
 18:28:29 +0000
From:   "SCHAUS, STEVEN" <ss0855@att.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Enabling SECMARK for mark extension
Thread-Topic: Enabling SECMARK for mark extension
Thread-Index: AdebaCOCIxH5A7p+SUOd2MIgvhCC0Q==
Date:   Fri, 3 Sep 2021 18:28:29 +0000
Message-ID: <MW4PR02MB7233D1D88F365A972B4D3BF9DCCF9@MW4PR02MB7233.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=att.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2ad29de-e7b2-472c-950d-08d96f08a0de
x-ms-traffictypediagnostic: MW4PR02MB7236:
x-microsoft-antispam-prvs: <MW4PR02MB7236124E633274D559DC5BA8DCCF9@MW4PR02MB7236.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0K2RxBURfb4Q/rO668MfNBZq5+JH1orBZP3NNS+MdKoqBbedpAqNkCFej26zL/LqUvnheX4GWObkK8wVvDknHJBQiDjZM9+32kBpdrCRs9EuKhG6Tu/x276t0bCxAbchhyRZ4hzZGo42f7igsmmj6NFIuYyUb/tXlAMHXaLrtJm5ErRNOFTAosbNZbuZjHytJ9evz/48ik6ItkJegXBIq1EcmfrhfgMvu8WTCzhhqt/Jipuh7+rJYQV3PlkorD09+Ee2Ew2+gNZE/1VOS7Ob+AgRhoDcgicqwU4Xo5GiihJcrRPc+HCgA7nUk/o97MXVC+pa9vQUj3Fq34xOJt0dOfAeAH62v4DHE74DdEgO+OKGg+Bliv7K7fmvBpbvyBDitOw15Gf/He9mMBmxjmsn50GKLaYq9fZDxdscwu7Oqn+3S/uUhH3mNU3EkhUh6VpcLIEwp09vZWpRwSFkDze30Rc98kcTsmhiWEoGsQuxd+IUSeIBwK5O9FhWw6WI1jWa0/l5aMZwfNssQUIknCwrqrhGPq3h4Zv5dq0sPewM2jyfdqZEMgcULnnp4UrKcLOxwjEGroUOVtaOkhNJe7ERJKtrYxohpJf/QHVweQ60HiqT1I1hxgF1zWRz6SeBsVONJr5mt9VOIS033HJYaw9DiLnmJmjCLgNICdOtE32EOjy21cyPJMbYX1RoaCWjYIZBCI01eDS0nzpxY614IkhXiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR02MB7233.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(26005)(186003)(2906002)(8676002)(38070700005)(38100700002)(478600001)(7696005)(122000001)(82202003)(86362001)(5660300002)(6916009)(52536014)(6506007)(316002)(9686003)(8936002)(83380400001)(76116006)(33656002)(71200400001)(66556008)(66476007)(66446008)(64756008)(66946007)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oPNeamlhnkSmOPaqpJ1mCeIE+yxWGJWYq0QDpSAFVLVGoDDHf8jZpeagZ36L?=
 =?us-ascii?Q?oXDT9uy+pgSMXZsi5E6hxRY/BugHYP9Jt7wCW7Ud1dPzLC+t9HtKR3Sv+fk+?=
 =?us-ascii?Q?Q2fIcHdAAUiCNHICTUINEsMoWsOiVM8SIIanI0xBo+gKol8tTp0FSG7KZpCy?=
 =?us-ascii?Q?8PM0cDo4fpyGN2fI4zA2Ft0MM8D1Oya/spM9OLfFDZRP7x/IaQzKVxn5RGdE?=
 =?us-ascii?Q?Ysw9nYmvzUXAOW/W3qODNxGCdGJUmyAexu4KERnrp99DUt5puvdAUoM5Fihk?=
 =?us-ascii?Q?1KqOSk0Hph7TC1LoNfy1L2D1Qk/426Tc/nSMlDABRu3lxknj9X8EmO55nj3Z?=
 =?us-ascii?Q?u2JXAiAEwd+bVwNmMZFQFQZ4MCslNhc8ww/JfLVlKRYduzyf6amXU2/TmkVx?=
 =?us-ascii?Q?kdBL/3x11lMjC56zEGHT6epFxKq+rrj7MJnfBfi2DanUgtau4apBaTN0fQ9l?=
 =?us-ascii?Q?lapmNKS4EF6CCsVYZ8ocdNuzYj61TPzJR4jg++7R2BfXUXKeHpf3yWGNGFZw?=
 =?us-ascii?Q?uJJu8oxd0HdKZCBLww8UBVJJt0CPG9GEIp1cVOaNWJYJecCPL6NGRDl/g9Bi?=
 =?us-ascii?Q?OQWDoiBoTz0uvEKNkQ5nm8du5S521iriW38KIT+2FloHmS9LlIW2HNAuHnDb?=
 =?us-ascii?Q?+l8NBV0YEauRUfVPiR3P3pSh+nh8GhsWsESLAUYno6qINrOOu6AXwDqCAkd4?=
 =?us-ascii?Q?O2fZLDI8bF33bBko3Sh30NCoELiz5z20j3g5fA3jZGrDg9sOelGitaoNceb8?=
 =?us-ascii?Q?kWPymqlxKE+qnBTGWwxKSQrXHnHH3c/U6PdjSSmrx352jwHNV4iV9K0PO1iS?=
 =?us-ascii?Q?+OJVcO8WTtc3JZIvyTXMMxZqkGBKSsIl2lfWOERvgYGchp+VKyyAwl6jD+Ku?=
 =?us-ascii?Q?QX8zf1f/cKnE1oCJfE9WlONE2pgHcNq4uMhkX2UjXPbG4GbYUtgvJtRaPTh3?=
 =?us-ascii?Q?eFr+fox2XyOj5Ejr75dGP4EtIgj52c9enCGz80jR9L8dCwkLFJajJi6V1PbF?=
 =?us-ascii?Q?lZ4EJPV5O0Jlw+T6+kFHplBfNYvSZa9mdlEiH9QCpoUhhKmxW+EhfVMyuYjw?=
 =?us-ascii?Q?gUgnc79hmWuA5c28yBkzSQHVwpycLMtUhHeD5mvZ3S+Q/f7cgm7lO52pVRiX?=
 =?us-ascii?Q?8M7zjy43CO5mW1dsk55jvIUB9tRPF+KZOAKtWccoFMvbWFrJ7pFUZyRQMAJd?=
 =?us-ascii?Q?LQMeZGd3oO15fsSezwxAsEnCarrVmGt/XTQgAK6/pco5PSizelm1AcSnMgpr?=
 =?us-ascii?Q?6iNYBdJmXQN0N1bP8ucHKQsgIEe5ASocIDRPBBVF3uuMIqb/YIC2pw3y3m8L?=
 =?us-ascii?Q?57Q+3XJP17pO4XFewnGI+ALX?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR02MB7233.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ad29de-e7b2-472c-950d-08d96f08a0de
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 18:28:29.8710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e741d71c-c6b6-47b0-803c-0f3b32b07556
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkexjU2qM6J2JVcmIOeCQ5ZkdqqfkOCSRpPeeV9rXiHu+ytQL1OWWn/go/xCNnik
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7236
X-OriginatorOrg: att.com
X-TM-SNTS-SMTP: 805C3B76BFB92DF2735C0543986586282F810CDF5931E0286F383A47DC7009592
X-Proofpoint-GUID: TKPXld_2lgdICqeAA2BNJB-0-y2WWfjd
X-Proofpoint-ORIG-GUID: TKPXld_2lgdICqeAA2BNJB-0-y2WWfjd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-03_07:2021-09-03,2021-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 phishscore=0
 mlxlogscore=722 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am looking into ways of extending the use of the mark field in struct sk_=
buff because we've exhausted the 32-bit field. In particular, these bits ar=
e in some cases used by the route table to determine the output interface.

After looking at secmark and connlabel for this approach, I thought that se=
cmark would be the least intrusive approach. My reasoning is that secmark/s=
ecid is already propagated through the network stack (e.g. struct flowi) an=
d that would make it convenient to use for routing without changes to most =
of the data structures.

I am working on a patch set for my use case. At a high level:
1. Allow setting the raw secmark field via iptables instead of using an LSM=
 label
2. Allow matching on the secmark field via iptables
3. Allow routing on the secmark field via iproute

xt_SECMARK: add new mode SECMARK_MODE_RAW for directly assigning a value to=
 secmark
xt_SECMARK: allow matching on secmark with optional mask
flowi: set flowi secid based on skb->secmark
fib_rule: propagate and rule match on secid
fib_rule: define FRA_SECMARK and FRA_SECMASK for the UAPI
rtnetlink: define RTA_SECMARK for the UAPI

Is this a sane thing to do or is there a better approach? Are there securit=
y considerations I am missing with respect to LSM's?

Thank you.

-Steve
