Return-Path: <netdev+bounces-4824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 320E670E93E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0FF21C20A57
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA3E17734;
	Tue, 23 May 2023 22:50:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB9E4A3B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:50:46 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B826D83;
	Tue, 23 May 2023 15:50:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NM4S5R001400;
	Tue, 23 May 2023 22:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=T7+CToGvGVojwZ4R3pcERZbuL46bEmAc6w9mLGSWjEg=;
 b=HoauqfMLN1RNWmhNp+nEIqmommo1HlzEpeQN1dUSWGZL80vb+erncbY7jwSAjT43fbHf
 s5GocnvOrqkNZu/w03xzRWnYUzddu8fBE8LUenMOsl+PfVQ6DfT2BGG0FX2JfDjYEaEL
 h55cDpX9wPT1iRQ2tN16UaINtozFmBaQ9dQHaOvQMvVPpvEX8fxaUL8up079Dt3Xd+Rp
 yrhHc18ukyrMiYGIhuc3CUdT+TjCj4eaBIdr6pBwiuyj/8zJzpAyL6xPmCJzyFJ5FI7U
 fYd16tev/WHwOR1tljg2QOtGEvw+lxp89PRaYVf9K0L46EZXEGTTk2WdCg6g5Wb3lC3d 4A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp426d78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 22:50:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34NLTZW3029086;
	Tue, 23 May 2023 22:50:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2bfq6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 22:50:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFNNc5oL66XDlJgED3oI/pyltUotU0DS1I65wqkRdxw+bV9IanXq/7ifPHuemLlc8tLH79XAFxkMvF9bJMSM/0dW5xk348/EMbwS1NuZ3ewD9ehyXW6l0KLZq9EpT4Bj7dCIM+N2e8xYfZy+YWrbePaKH7vD7V0JFIx1kvP9vJnXJ5LXADmyYaG4BHv87dmrqFarctNGwTHIiHYJsWqU8VAS6Bo1W+2mMEQIcyjNRrnItddVyFWOYPu6jDNz0oGh+73nR1KIzNt5sFY2K3GGQkbkydb1uHyBM/ZBLSUg5IliG7mfYv0+ckEUvpLWeiOe26uA1V7EsR10hVeNTBgcJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7+CToGvGVojwZ4R3pcERZbuL46bEmAc6w9mLGSWjEg=;
 b=QR7WlEbdiQtZRVA0luTCnaA9K1wK/mRCiECCC8LxVbsrzhgGfcuW+q4uPgzPAQ6kp5ZJjtNlYsQkF09PV0PnTPAyUneoyV67xKrFp5Mq+WUbfSChxRIb0SyoG02NEGWW8cqJjUaQ/+SxZcDZOjrZCij96A+h5c3RgVfneWQGhArfU1RicHTHYpH2mU9xLmwZtYNRt59SHE6YzkRdOxg3ec6vWjnmKoySEloJG4IG59vTDCsugWTbMBQqkhwFD/bE6yXhao+pMBnFXgtUyNxJsd3rVz3PobjHRVdZp/TX9EoJwKP2xADtJRU8YZmmHPgCad1EFUwrspE5jWq/w5nABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7+CToGvGVojwZ4R3pcERZbuL46bEmAc6w9mLGSWjEg=;
 b=LCXtVeuEVv6N5VxvUfK9GCF2P+rdZFUlHspTh0QJiVHoc6LBJbGcDwK2MMZr3+wPZycJEhWme1NshRjP6VIsJzU0voLiJ2iGLczWEQshCZLb6xumOCTgTyGw35L4PQnAKEUYi+1+EdAaLryJCqyJkiGfcZSJjksRHec9n5KgrCg=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Tue, 23 May
 2023 22:50:37 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 22:50:36 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Tom Talpey <tom@talpey.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Chuck Lever <cel@kernel.org>,
        Netdev
	<netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard
 Metzler <BMT@zurich.ibm.com>
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Topic: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Index: AQHZf2hilDPMQchDT02kRjpEKJKB+69MGTWAgBw+lwCAAAdZAIAAM/gA
Date: Tue, 23 May 2023 22:50:36 +0000
Message-ID: <157EE22D-4A74-4C2B-B704-FAEE371B265C@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca> <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
 <95eebf9d-3889-e639-68af-e01d7cfbf77f@talpey.com>
In-Reply-To: <95eebf9d-3889-e639-68af-e01d7cfbf77f@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SN7PR10MB6308:EE_
x-ms-office365-filtering-correlation-id: cede8221-462b-4a41-1de4-08db5be01fdc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 b+UVGp45Q1azoSIymw67iqt4jky0q7ehkK8YomaVnIoNiBzGPV1NT4UcMmBkdS+xQeP/lUz7j/HNZ+n3tuotguWf9k5b8FT8eqAv6aeJ7Bm2y5z7FvECsjXNcFuvpsoWTJYshjKcMP63YwFmcKy/rTPsOa+61SLMOGyEpr8EgLavNdHrLbtOprlUnHYABrnfvT55mujdEBQbwwhIc2SIeoGye6PYQ/UQpHq3im977ThxQML5XJupTMNCO9ad5wetaUOUuDoFHEy+ARJ9SL55Aex36q3LCFpo4ZHWtOiK8pspxZWp9piAc1v/JCTmZqGWYExhN2n3BXfGQo435a7WnyR1iw3HIEqM1NxgPjq67DWso7gUOWVBdzg0L/1yM8DAW41smvFpcvurMtn1mGH4oRrN6Y4NIKCNwmsgkCO7jgT7PSVmPVj4M55GZpji+cN/wNL2UiBnIJb1FxlEisjUjWykeNRnZzqh2RLWknsVwPIvP5eNqC8+xH/pDSEw1ibIR92iQLFNtZQzCFWjzgPq/JcZDImVz3dUq1XdrHiDuMmYdJ2Pl0DSPky8Ox4MKuX8FgH1SuciDuymlnUJRhq7FgpZfc7EqFAXYzI3irsTwWbiwpbBcZflyqZSAqM6PoU8ZmQ4PKZT/qlaTfvs6Iz5QA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199021)(54906003)(86362001)(6486002)(41300700001)(478600001)(316002)(71200400001)(91956017)(76116006)(6916009)(66556008)(64756008)(66446008)(66476007)(4326008)(66946007)(5660300002)(38070700005)(8676002)(8936002)(38100700002)(26005)(122000001)(53546011)(6512007)(186003)(33656002)(2906002)(6506007)(2616005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Q5xi8DDmxcyjxlPYo0dhNuz6dY5hVnsCE5Dk3rT8eBxXH0hLCGpEN8DSDoy3?=
 =?us-ascii?Q?/j8CH8y0tuVPoSl3GwKZZfcSgt9rjoSTzGbrCMxWTsRW/DZ2xP0THog70cPg?=
 =?us-ascii?Q?i4ORqtD2eXWm4o+eF3Wem1JHKGvHB80qfJ9Ps+WRuuf9Fip11cgExl0eYP12?=
 =?us-ascii?Q?3IEtEb2Nw4MYp93LfGM4dfWWqpE0Vs0NzXXetvTxhBQc9v1g/CuNtgfPI1e1?=
 =?us-ascii?Q?GngF4n16XDqjPwfwqInbFvXVgep6zj3xJXudtUdwobMcivWHiQHKhnAtynp5?=
 =?us-ascii?Q?lR/X9M7ZcrDzshsk74hB2Ng3XPDWHDaxPDMmAM8h1+m9Uwq7DQft5kZOhjqg?=
 =?us-ascii?Q?Zexy0svjXGrLTgLJt14CaD/RQF/x2DqsMw/djbcRotw4QpR8tMe748IhBxap?=
 =?us-ascii?Q?ZknNNdxv0HKU8AZZn3c7qtRCxRRUweAVCVKDCCzvtNU3anl6ADAFvtFBxbBd?=
 =?us-ascii?Q?XGrukiSqByveX4nJ3JUMUT7CziWnaWCd1+AdGHAXvB6bzozJZZqwIZ6gJI6d?=
 =?us-ascii?Q?5TzT+SsJPVPJBHI8cWHGWyg74BF05jwB2fU2AbMnIauyGVCv6ARKdtPjQnn7?=
 =?us-ascii?Q?6gIzRvwKMtIR+sqbxB+D4jU2jfKfnc+NZERUrUQAv/1FC6n9oq2mt5xHkt0E?=
 =?us-ascii?Q?W2CCUPJ7AmSCKKzL5V8S1O2euvlMRIhx9hKN86A7F/EhzqBdc6plJCgkRbBB?=
 =?us-ascii?Q?+zTpaiggfqaN+PnyTPa0UQ8/y2/SBbGhBKMd49vTTtPNvzw9XA9Xqakmp3nf?=
 =?us-ascii?Q?Q+aijjgugAphU2Zs50mhsXXlVt7WNVf3Z4KmRfGB9nZ7u0QsAyIIfy0RjJL2?=
 =?us-ascii?Q?FWlOa3p+NRnSfTxLU7vwfACCczQOSg7IgWCHdgwXcIS9YiFoMN0lZKeO189+?=
 =?us-ascii?Q?gYIoatoMFewkDr3CdGGf6wVF+oP5COznq6RqUepLPQgbV+qkdfsoSDcku9DQ?=
 =?us-ascii?Q?/WLAD2YFAQbYemB1Yk76Pwp7rE7aF1aWTVI3y3i4flHmnDEqb6SIT1YRxAAM?=
 =?us-ascii?Q?H7/oCi751DCaznUD2lLAQN+ypZ9XE0f7dN1yfsG3VmnJ5CtV8RLEvagEHgZ9?=
 =?us-ascii?Q?R3cS3yv1H4k82XsPla7EXDWi+rvAuoxWakCUtX8EKAK5NVGEiZJIikvWXv5J?=
 =?us-ascii?Q?nntnXdXfr1g5eXGFNuKbaMBFk9216Kq0KFQK42CRKYbyfqCXYH0s8W2iZgdU?=
 =?us-ascii?Q?/ymeRzW6wAYta7l7W7K1teQLET1ku1snwn0zauraQXzm/L3paZh9PEGqvjUO?=
 =?us-ascii?Q?yLHipfuDowEG5M5N+JJ5V1bCiYt4efDKItZ2JKOrYc2HLueJLe6tnXFpfgtN?=
 =?us-ascii?Q?VqQQvg1oZqY2h9Wbf2vX3KSahesHdZFzsRwzqoc3gGXVvLnLbpqFttVL175k?=
 =?us-ascii?Q?4lfCFOLOQAMconB2VfCNuqbtiqka+NILzlFiCMa6qMSXo7XFjPH3V+iDhZef?=
 =?us-ascii?Q?aF7YtS+ZaTEqqYzUWcz8qCzR2ODciyjkfOlFBzbgrthRUKxFOTYcp/me1bby?=
 =?us-ascii?Q?jrxMfX0Tg2dlIp9OESYFR+uiYmfuf4llwOg/80ScZ2RJxgIXqJNsdjhyEL0V?=
 =?us-ascii?Q?dfo8dVyq5ByDZpOU/CP8z/q8fpBjIy2pmdn2NRJvtiluK9rgtKvPrAXP5pqB?=
 =?us-ascii?Q?iQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4035B175323B7F41AAA00C3E7D768976@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GnWsAlnm6NHV3zHttQGLjCWomJl9ex5S1ISEhUn/0SD5k+Yfy8dh/ei317XrbeU7g3GdTXwzJeK0SfMODajs+1bkuN2lRWsiSaXHPYq0H7QBKk944YfAXTH6o/tb38ArW8NnSwCpokQ9nrTq5yLvJenQA5b8GDnYsAsAJIdo5cyPKowWBw64DakPq+lIe7mOdYozQQzgKmnAQMEmQbP2oDMPUZirTz5mzzegbjfH5TUzJgcndRAI0rVscA0XhV6WZuIVh3EXJnHv585lrbJNof6cD0ObNuSgjdNDD3T+E9S5yTV0C7DktXvBSlH7JhjO6KWO7FpeyQM0sZqTyZzUXherx9qwBqK6P7kRN9X2ISjhzLqJeDKGi1cxIUhvUt9RT2o0kx/ZBENRhfhAmTT+ROgcL5Z8igOpgSOHdJMvDYniiTwaVFKyrxHcLHo8itZRnzLyP+9Ct/DnXvO7OVQKiuROP8bjReOXkPtmdpCEFUK3ArzS+kvSWihSbPaarDJX32Nvc3upmwVcXY9XuD0i3Dqup+fZUldY36HBa8h6CHUzVXWx9IwYFwpyv09+IQov3XfCO0mKCTsRpJRfx+nkeyBlfR66rcWEEaqbQ3WJpISQ7wnlhKO2jc4nj1rItWaHq/xJVp7NmHEH9IKzcW0WKKYEcYIhibGsSJpNoIRRRarw7b9nguDc6VFFdbxP623L6GLpsjRLK1bdzhUcttyhD1s6QI0fWXdY0UMiyWylmnWe6ynbILRBnCHGkykF0mRD0GHc4Ao0IfwiT2uW9Owi+ekVbaYGvqipNRhYardesjkSqpov+1WU49xI4DjZX+ta9EOjILuXh8A94Tc8l2m4n6cLF+11zR6Kq6X4/p9nbZl4JU3iJQeeGMFGa/qNJNLd
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cede8221-462b-4a41-1de4-08db5be01fdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 22:50:36.8051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M7EQUQBsoZQHAuLT5TL/uc+UXgXcd3NB8EF8bvh2tUszGIao1i3vDflmXUq+O9RuDwaM7GQzWeSXp3Se5EvhjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_14,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230183
X-Proofpoint-ORIG-GUID: MXKjXQyU97CW9cjrR1kGine1qSfqpLl0
X-Proofpoint-GUID: MXKjXQyU97CW9cjrR1kGine1qSfqpLl0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 23, 2023, at 3:44 PM, Tom Talpey <tom@talpey.com> wrote:
>=20
> On 5/23/2023 3:18 PM, Chuck Lever III wrote:
>>> On May 5, 2023, at 3:58 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>>=20
>>> On Fri, May 05, 2023 at 11:43:11AM -0400, Chuck Lever wrote:
>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>=20
>>>> In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
>>>> addresses. siw_device_create() would fall back to copying the
>>>> device's name in those cases, because an all-zero MAC address breaks
>>>> the RDMA core IP-to-device lookup mechanism.
>>>=20
>>> Why not just make up a dummy address in SIW? It shouldn't need to leak
>>> out of it.. It is just some artifact of how the iWarp stuff has been
>>> designed
>> So that approach is already being done in siw_device_create(),
>> even though it is broken (the device name hasn't been initialized
>> when the phony MAC is created, so it is all zeroes). I've fixed
>> that and it still doesn't help.
>> siw cannot modify the underlying net_device to add a made-up
>> MAC address.
>> The core address resolution code wants to find an L2 address
>> for the egress device. The underlying ib_device, where a made-up
>> GID might be stored, is not involved with address resolution
>> AFAICT.
>> tun devices have no L2 address. Neither do loopback devices,
>> but address resolution makes an exception for LOOPBACK devices
>> by redirecting to a local physical Ethernet device.
>> Redirecting tun traffic to the local Ethernet device seems
>> dodgy at best.
>> I wasn't sure that an L2 address was required for siw before,
>> but now I'm pretty confident that it is required by our
>> implementation.
>=20
> Does rxe work over tunnels?

(It's not tunnels per se, it's devices that don't have
L2 addresses... and tun happens to be one instance of
that class).

My (brief) reading of the source code is that the use of
devices that do not have L2 addresses is prohibited for
rxe.


> Seems like it would have the same issue.

Agreed, if rxe did not prohibit them, it would have the same
issue.

To be clear: siw itself and the family of iWARP protocols
shouldn't have any problem at all with such devices. The
issue seems to be with the Linux implementation of address
resolution.


> int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name)
> {
> ...
>        addrconf_addr_eui48((unsigned char *)&dev->node_guid,
>                            rxe->ndev->dev_addr);
>=20
> static struct siw_device *siw_device_create(struct net_device *netdev)
> {
> ...
>        addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
>                                    netdev->dev_addr);
>=20
> Tom.


--
Chuck Lever



