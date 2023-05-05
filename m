Return-Path: <netdev+bounces-627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0976F89F6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 22:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B66D1C2199F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E53C8FC;
	Fri,  5 May 2023 20:03:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FEDC2E4
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 20:03:14 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A24116;
	Fri,  5 May 2023 13:03:12 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345Hh6MM027907;
	Fri, 5 May 2023 20:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=agjYTTbNPx27k6OKHcFoTweyOIXCRVfma2xwMv8ePoo=;
 b=ABuBtX2dRpch1iwAzmZXcM7ivxCe3j++rQ6hbYdVJZyn+0u9fSiqvokYUT7cDvUCMejv
 U4d1Sfc1wClgBhvK5IQrn1Zm5jiubaAMFjl8M52vb83fPv7NEHhgHf0iSG0IjQHaTxgX
 KcYe+tScyWXowCiniEOJhZ8t1TG0NI7n8K1tc5hfutchS2HTCI1JQfpIEvYL88taLJxE
 I0IOZEPxE7t9dr2wkz8pm5U55dPQF2ZmoAzUbpkKS8c4U4l3wvdJtqcBuLKGk5w/GotE
 Nc3JsaL/upC9Bb79elvywxydW3URzvt05K1PSTmPlqboWB5yv6PhH8AQHzxtKJ5YVhlo 3g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8t5fwpem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 May 2023 20:03:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 345JxNYt040470;
	Fri, 5 May 2023 20:03:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spabpaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 May 2023 20:03:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARvHrv+lMXpnQW35MBW84nskiYhL2ge7DQ9QK0zy9+iwpcTXb6vhH/bDPX/HObBD6DU5Fh/8ucK1dWqHe1/Og1xfqHuYiSFA4/zHZVqSuDr+y8QSfQwjKn9b3jv80Gx4hzSiXhrwveCKqRERHk3EVLREQdwDp6vuHMHfygjf97X4qd6XmPfRVfXDpUP3Ixn6DI2kXi7JzWVV9Sb09kO4fNk5M2Q4TMhAl36gqEdwvnZnM6lr260QBmXpainqbik6rRHbbAap5rPL7SsTb+6jIZJw5T9Vzr2OAsrslHc7gQg4iBpC4FUB5Zt3bFuhTN5Gn/B5jgNl/QbOeqrcwdxHrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agjYTTbNPx27k6OKHcFoTweyOIXCRVfma2xwMv8ePoo=;
 b=YNSqC6+yFC7FFqJL/2F5vzTL9YKI98evYU74LuAZQkzEXxjZx0l80thUmGdnrYEhyhCEvV7ZoStnKNkgzs6rfEyvB9kvWiiTDkSNZoqH5DzvAjJV3blrgNyehEfE2sVp6pb29oUnBukM7hkSLOgE6sVmKl6hpiPRcnrALga9druY4EjlmKkjNOLmSHfsGIeAb1OMFRRKQVXZ+eS9I+ek0bruqjTOrbomJ6nyNiaB2uRsd0GBaFv4egQZsoSlJHsNlELLHCQPmknLmkQRU9EBGoDxSIYctpNJp+HhC3TJrLslNdDvIEDKdl9uFTrl+l9MiJ1OM950lBruH3CewFk8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agjYTTbNPx27k6OKHcFoTweyOIXCRVfma2xwMv8ePoo=;
 b=LZUkNMfpIfjKsa15Cgr4X2/nMN9hJn8KeJjNDoYUATit22u40Kze1KBf4iMD+ep23oi9WD5J4TmggNp2sQzzCDm0Zny9pda+zvGZ/GQLm+fC1lBdEHdURKasjlOz5aOz6VzCKcPxLwWqDgduqKv+s8iBD5cPtbxl48ce5gXdsI4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB7020.namprd10.prod.outlook.com (2603:10b6:8:14b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 20:03:01 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 20:03:01 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Chuck Lever <cel@kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard
 Metzler <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Topic: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Index: AQHZf2hilDPMQchDT02kRjpEKJKB+69MGTWAgAABHoA=
Date: Fri, 5 May 2023 20:03:01 +0000
Message-ID: <3A1AE752-3229-4E7A-B9C8-6E2A134CAA14@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca>
In-Reply-To: <ZFVf+wzF6Px8nlVR@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB7020:EE_
x-ms-office365-filtering-correlation-id: 0265a476-0770-473a-a387-08db4da3bb22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 xWOSM9hQdcRGS+Go/1F4HI0gSHrJq75iKpZ+LXxIiRFjyr3+nzYZG0vO9ENgxFneCTvUwYOOwss4QKOb7FLaW2vPcWzbIi9IploQzY5HOMfuolJPmkHAv8EBqyEpaTAOwAW5r460bbdczvi/fV1P/bb3mtmCtKd2GD+RQX57BNkp5SUnDQzTJRQ8YQQgOQb2EY5T65XHroaMo/0DHSBIrX2aBxq06KbaGtZYRlpobqSE2eWXvODM8jn29I7AV/H7i5KoSSvnxFtS6n9A08exRxACqejdHXIZ92+T1teAddJ4VvdJP/ZAJDcLWFuRYBJbAULlVyskxT6OdExZyChhHeIMoE/qKs1nh9CkecCACBWc0vi4qbXVS89CP08kdousjDdgfwFqA2Hz7Xi9bWupraXnoQirfxrZRNaibkHfxC+8pbecmKArrMpQacMb9MJjDGrCMzGMpe89NaOpRBPDDgXqS3MWcX/Ow7FqzrFa41dkO0c5tOWqwgvlR5PuXEv/5lHoASQC7djqsDxK2fM6hNI7VhoxwTqvj386SU01Puz9b7z7tVbQ3KNJ0rbXS3gP3Q9zpxtWaN7bvbx4van4WQ6g2dvZJGKl7LSLcZEjsmRHDy9P8NOt+fv7rgkftfB9ipyiXG96FtwBVf0AbNP0hQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199021)(6916009)(76116006)(66946007)(66556008)(66446008)(66476007)(64756008)(71200400001)(6486002)(4326008)(91956017)(316002)(54906003)(86362001)(33656002)(478600001)(36756003)(53546011)(6512007)(6506007)(26005)(2616005)(8936002)(8676002)(5660300002)(41300700001)(2906002)(4744005)(38100700002)(38070700005)(186003)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?y2FtNYwv19Jo0BNdTyox9EXk7rZh064pGGAmKtNUTCsRSB5sC/NpqxOq2NkH?=
 =?us-ascii?Q?8ih+ghXmtIsSeTrG/g5F5LLhPQn5KXloG2f2UnQFWbmLrP+wPG9JOo0x7Tg6?=
 =?us-ascii?Q?4PLfkQbFM23uBy8dL2I9l0lWbxkZCv5pZn0McOomZDen+FS9s7AZlvEEUrfR?=
 =?us-ascii?Q?IoowdR7bw/ClzdICd+u3gwo+6kRR2DiOu+tXFF6vAWW+tQNbY7TL3iVqo9wL?=
 =?us-ascii?Q?BHC9fuBw5mU3tSmQzQwnLaTXcn6no3aqlXD2IS86n2Uj1UQ1yuEWVdHUxbjP?=
 =?us-ascii?Q?Jd4HWX5IB35w1k2TwFBY7cZGIjBW29Ey9A7BVqlcMjksOgYtRnHZdpLQLc7S?=
 =?us-ascii?Q?bJZKiv9n/wE0+fDKcDCi+KONs5hGmCCYgfQ8QjVdf6abuLHEuMfg4xaGdH9E?=
 =?us-ascii?Q?q7eKFJhf6EhBTPO/RfL8+VufUVz8N0ogCzcbvjCf1K5I8zGatsgwSw3GYt20?=
 =?us-ascii?Q?s26A2CoFilO9SDQd4eCX5xBdAcKlHyGF1iy3KlRNthMaVRQH5R9BktIaSQCr?=
 =?us-ascii?Q?/E2Jaslg9tO7GDdlahIylfRv+FTWnCLsa4OvJwhbwydAuno2x4H9FmX7zLb7?=
 =?us-ascii?Q?E0xc084DZp9kES2vSL1GGmJ6/N6u5nzkY0x1dTwnZ17uzkswI1+62rwWCq//?=
 =?us-ascii?Q?T+8wVN5KWgR13UHOi8LXYw8qqUi5Tvqh0PSfiTlgTJN9Yu/3STJDJawkds+t?=
 =?us-ascii?Q?YLCV4wIIxnev5JjbuD5DQPpAcLlKhLfZDZOHMOQ9swjtMbwE85QVX5dRALY0?=
 =?us-ascii?Q?brod6GYxVVk16Bk8ubg9VxBjBi7FORpAiBQlTZN6NQbDTREdPtmhsdl9iOj7?=
 =?us-ascii?Q?doHqmZe63UhsmpXHVApmboPHSF/hR0eippm1CXl09+V3cmZsT8+2KyA4f/I8?=
 =?us-ascii?Q?h5XRUJ3aor1lrTvUp5Z7qQbPqTwEwGHiQ4QZRAveF+hisxIq8ug9pBsS6s7w?=
 =?us-ascii?Q?p2vyQpq1jcYL7QYLfW8Ttvrl7gvsJNUNAvgSg0S0akFJJ5INBcQYUVd80EcO?=
 =?us-ascii?Q?umZGThCz21DV5PIrWidl8N/BDi31Mapp/B5GDZEJE+gViXEx1YHKeYHCEwq3?=
 =?us-ascii?Q?pLZqcGXKQhJaEPfaYijonxq/JLBfcLayPV9h55ptmkhP7RpVKh+roISipvRV?=
 =?us-ascii?Q?SnAPnWu/mWPHmYqHGdbJjP5aWvlkponLbCKjpoNOCBuct5Z0PF56I/np8xcR?=
 =?us-ascii?Q?tkb02Q4HnLsdLVgqUBwuOh542LC4mDE+7HBdWxzB8SbkpjNIpLQ/Lj6K6iMT?=
 =?us-ascii?Q?kY6rv8tTBFMYLmlkubyj4w7wL3LyM5gNTfGLEPAUSGc8wIEemxlmUj8d/tOu?=
 =?us-ascii?Q?Rtmr0PznKldtqvegWj9+KFu4mf5eAwhchQvXBlMk12M34HCEdcs/ToBMyTh9?=
 =?us-ascii?Q?OBiyFkWa2xUrlFZJg77AXfFoS7kMo4C7ZLryZugvQv5A2z8jjRI33jNFu1Qt?=
 =?us-ascii?Q?V5WrUVl1rRnZaWG4KsYV0+hDnRXgwXFzuFrBaTZeNAIcmmapAOU/GHs5qcjd?=
 =?us-ascii?Q?8/A12VAa/5Uz/RuNF+mnKDnbYPUAOKJJnDbb3g4Zkd9zH6QnHaifgQG2t9Hs?=
 =?us-ascii?Q?OjAvLEhbKmJcHZ+rQotDNuID1fuAsO5RrQucg/YQKQOCkOvRrbMbAuB6lhD1?=
 =?us-ascii?Q?mA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3AB7FB128D3E244AAC27B7FD0F3199CA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	71pY905I/Y6zncVcu+yoR7H3Sok9PLuMsXb/p/nmu7Jyr9lVCppZ/e1lgDNO5dYSjgrGEhSUGYQ2bo/n7QWQPYg1VWzYxTCW9RzOhZ1UhAhiJ4gRZXUuo203gTa1sZmrBOhUD5IcTww3/qe1UyUIscrvGfo3Lhzp1m9S2/nhQonV5OhU+TIwJa+mmPW66rF96IZX+AP0jfOlzhGrd1ORIimmHu9GbOPvJlK9JwqgW2TN4vThJoSt4CT6PxkNZ5qB443ooWwLm4gOkctNqNH/a4KB6/mfyD4w2yUjCN7AJHfm7FRJz2HYYClDI+EziNmdMMQixNjXvXzLjFVqOeVWVIHIuSS+0j/hRUf8dPmnr0uTD+41NFhuaLugIn7PJ4EMIj5NIEBrn7g0lV+ebDNLPYuPricWwidUSDNe/5x1uO7ZIwfc8oC1nYzkC/iuAO1e+q/djcftGJVg8bMfb7xg0eqwhwWlqYX4+tk9S96ixasPNKWgABTxbJ9K5XJ8LLGucW/OrKxxTSn87RxW8v1Oojc/ng30Sn0o48TwmKlDM473DMjAn0a4rn3pJG7DgX6qCxB1N6oc7tmWcOjOPebFKH7ouSkj5KdllB7QzuubXKqHx+SimZjuM35uHDec4uTKtIEBluwEiB5xwUBeSAvEBetroY8x4g10WK5v3u5j57xAJxcwShSUhq6l0gwu4RTrQGvT+os04LBgYZYiWkk3RIOkbfWEdA8R1VcFVicXbRCqU9usTtjXHxBhvhstzqa/BiG3flgPdFPLHYHduHgL3F0WPbgtv6o8qTB5qWE9PLqgUcoZcVEZRfelz7fCMoBMN6TrrdN1QT3Zc4gD9fKjxszZL1Q5eY7c1O8g0CCdWIMmReGS2qZSrnYdZUebal4M
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0265a476-0770-473a-a387-08db4da3bb22
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 20:03:01.7204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OV1BqDYa+WzkIKD5Q15xWG3IFylqN1Q5GSYYTnG4SQuQOzt9A4HevKkxnXwdigAAtSj4G00wRuPpTQd/F86JCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_26,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=953
 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305050164
X-Proofpoint-GUID: utgFUI8Y533A03rFkk6NTfTOItmVpr1S
X-Proofpoint-ORIG-GUID: utgFUI8Y533A03rFkk6NTfTOItmVpr1S
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 5, 2023, at 3:58 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Fri, May 05, 2023 at 11:43:11AM -0400, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
>> addresses. siw_device_create() would fall back to copying the
>> device's name in those cases, because an all-zero MAC address breaks
>> the RDMA core IP-to-device lookup mechanism.
>=20
> Why not just make up a dummy address in SIW? It shouldn't need to leak
> out of it.. It is just some artifact of how the iWarp stuff has been
> designed

I've been trying that.

Even though the siw0 device is now registered with a non-zero GID,=20
cma_acquire_dev_by_src_ip() still comes up with a zero GID which
matches no device. Address resolution then fails.

I'm still looking into why.


--
Chuck Lever



