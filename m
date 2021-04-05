Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCBA3544ED
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbhDEQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:13:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56268 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhDEQNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:13:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135G4mCe015870;
        Mon, 5 Apr 2021 16:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6ZCYi5x9KyI+B5MFkxxmvJs++RpIGe6OPo+HqVFSflc=;
 b=F/AjF6kWnaGrv6yqkXxU0WqDa7rRaMm+0jBrtLM3nfClpPHzFuUmfo0aY9JzCgDInZzV
 APs6pjUg7BJxn6+NY5r2Ztzdp1IT8R2Ne2Gp9pxjbo+M9abKvDZ7cIfFUTiIm4MVW0/5
 3FK5bJBfYgvWh0CVODSxNdcAbBy0ep10wiPrkqx7Q6osDQuH6YBgkhJtt9VACFoYnqym
 6wPH5rxFbI2/GaKsjXAXb2re54E/lngiSojeO/2/T8PUFqEXZgewa4+eFkXNy466Eb5w
 UOCbAjdlRbOI9oKPUC2aSboQPG2VoU5y99ZlxV3EH+zmGvShTFkxj5I4ZxMvu+D6fJLN rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37q3f2ajs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 16:12:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135G5C7W014139;
        Mon, 5 Apr 2021 16:12:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 37q2pweern-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 16:12:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1yKsBWvGYk6brkmzGLz3/jWkfC67M/wrTR4J/DS4q+GoyV5ojE0Ds1vgNRkLQITTqrFfLfe4I46WwNYuxNm4oEO3LJRrerOSrLNFx0JqWqzFNAf4/nCDTBLQzsAIy4sWsnZgt/cIqWaVEpAzSrBthE4FI9WG7ke2nyhIMNTETOLm7crVMxRRVZAX0J5Fpx9OStG4VbXCklg1Oisf/MDmQ5gWDWmvaByrGdCiYDu4Tjr1mvpT7earjuKTsn13kjaNMDTKVVeo5GqoMYUQ2ZDZklczWffV2je21eiYXs0n0mCBs+hWnetlUy6lO7kYYCEx9KyaJ1ubUKlKE9DE6AgIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZCYi5x9KyI+B5MFkxxmvJs++RpIGe6OPo+HqVFSflc=;
 b=C8UGrpNfpGUGdnTZ3bqRxcWVCB77jeHOuUuopsOfBOhOw9QxQ5G99DIF2VgJ3zrqCkY8moK4Ua2qfpE1DHnhMKneHmVYrIPuQthfzR6YG6OTKbHP8FUPgvUtZyOSyYmk36owF6hkdonLi9TcuRMKWMCj5mXeV9QPRWGwwHpDhtJfT1WBjjk7HE6fDauKyq72DtRXa62TU7lgFV2djUnjrcu8WM6yBTFV4qJlUQBPJvn9/0D5yy01azfO9seuBLGhWlPdb84Dgj8TzOseKC+jKw5+GhX5BVfM1R8U5KjqM2X5oaOBWw8VHAr3VBGYwoBbSHFhyUYL4+Wb5QyfN1TGpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZCYi5x9KyI+B5MFkxxmvJs++RpIGe6OPo+HqVFSflc=;
 b=XI7HuC9TmBYtVfSeeZTMzI81t/CsLhKcaEaU2X+fQmjx3luGhUIjkIQep/BlgOMNLp6cEkT60/xRVmOSQrSfdaK0Z5IPeGWwX3sANvaTQL4+WYeFWCfSUYiGku/1d4S6ztAOMECPngv42ABKowfQ7z0hVYoOR0ZmeHzS7/ACCBs=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BY5PR10MB4131.namprd10.prod.outlook.com (2603:10b6:a03:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 16:12:40 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782%5]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:12:40 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 8/8] net/rds: Move to client_supported callback
Thread-Topic: [PATCH rdma-next 8/8] net/rds: Move to client_supported callback
Thread-Index: AQHXKjaAkoIiwnRJCkenCOATPT/M0A==
Date:   Mon, 5 Apr 2021 16:12:39 +0000
Message-ID: <937B9EBE-BE34-43E9-BEDE-D7540545CAE6@oracle.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-9-leon@kernel.org>
In-Reply-To: <20210405055000.215792-9-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [138.3.200.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0801a28e-f794-437f-4b22-08d8f84da2d4
x-ms-traffictypediagnostic: BY5PR10MB4131:
x-microsoft-antispam-prvs: <BY5PR10MB4131CE69AEB053992219510F93779@BY5PR10MB4131.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hCxkIYPWBFb6+B5TFY2wtLyQ7YXb3uG1Sw9T53oSocMHFxWwuAeUj+D22Iu01nbf/zhmVO//qIcsQr92xbgmGubMifb1Bqy7cJm04/lSsXJ+VAMXg5r22EvBMCMYe9YyQMBXCiAaZHMEUEd5gmi4X9eFyAX4cwaTmb/pzXPxk7R2haO2OkCOC3q+XeCb2VvAVHV3LVwuCxwVMKRHvrpKtKimFK7KKA4lLUIRu/0brgkV2toEOnjFQc5jVhuKcpeAnYLzI4ujc4dXri725Hvmto0lh1qA68QeYedleFZ3ZstmhlMOxa2bBX7sQOI8gFobhu7OYR0AEYmpJgK/VoBZr7h0Q93srU1QuoMMrOVYKYaCifzFXXf4ut03WS/Ukhzux4YP8mbBGC5bTy5sYOhjro8fz3WqDp55UzFC4lOsPtcVYHsrd6mZ/WrVGNQQCMPqhjy4++LJPYLOWEoZRBZYzBG66rDPqe99Yr4jNayyb9sEqNdw7uTP/SFGsifOzg8Lvv+jChnjHIeOPQao7viQDLmGKpVvx+tTNWygIjD9aeLgGbJIDY2Gb3RTb7lp7hYGqo0mmtg1BnHbMjo0qUaZ5V51gUtx2O7FnDbMZ2stldVD0lAHJKksuyIN3eNHDQhtD+KzL+q4ITOmZCXsy6TVfjelLXzpZAIInMFpEbcaAHOWNNwG1LZmMR2R1GwlbORq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(478600001)(5660300002)(53546011)(316002)(36756003)(66946007)(6506007)(2906002)(4326008)(64756008)(2616005)(4744005)(7416002)(8936002)(54906003)(66476007)(26005)(66556008)(44832011)(91956017)(76116006)(8676002)(38100700001)(6916009)(71200400001)(6486002)(66446008)(6512007)(86362001)(186003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QTJ0TFdOcXVSai8yQkpPUW1Ca3JnNnpTK2ZpUlc1M2c2NStiTDRoU3BWRWsz?=
 =?utf-8?B?ZHI0Vm53Yk5Uc0kxZHBwYnhGdlFZcHhRSGlVRUtnbUxybzdPMGhMNlJjZk85?=
 =?utf-8?B?L1NJZnpMd0NXbkI2OEp1Und2elZGQkN2RGJUS2xoNG5YOUFuclNtemJJY1VU?=
 =?utf-8?B?cExYZm5oUGE0NU1rWmdrZzNVUVk4bmh6YllTMllGWGc5WU5sQ05HS0pLeHhm?=
 =?utf-8?B?aUZKMXQxeDVBeFZoWmx3dVQwbXE2T3lmS1RTWDQvNUF5cCs1cTYyNldrZm84?=
 =?utf-8?B?RllXcmcyQWprSmFsaHV2SlBIcE9DWDJPejBHM256OVEvWEFpNFc2NFFVK3Bm?=
 =?utf-8?B?Wmc4UFZ3dGI5Q3lERTdOSkVrZHVoK0xscEdsU0lqVjRBejJRdlFlVGJKWVpO?=
 =?utf-8?B?dmJEUzkzeHNQOHdtaVc5QlNiQTlsSWFmMmU0LzJvS3hjZVMwOFpFa2RiYmNC?=
 =?utf-8?B?Tk5sYUpWOUlYeWJYNXl1eFpnNm1NY2NEZHBKUjdzSTJueGhDWDVlV2xabVVk?=
 =?utf-8?B?RHRGMjJQS29HREhiRXh3TXBza1Z1NzhKYm5oNjV6SE1JNzlSSjVwZWpyd3FG?=
 =?utf-8?B?aDlzZWFtQ0N5aTRaVE02eEFQV2ZHTFVEMHJHUkM1Qm5KbHZSWGh2dnRabXc4?=
 =?utf-8?B?OVYvYncwWUJVUU1aQklCdEFqVXdEZ1dvbFY0dzBiWFBhT1B0SjNlL3R5MEVQ?=
 =?utf-8?B?RkJ4WXN4Y1pSNGw0VkxacXNmNklhK3ZVWTJrbkt3RkFIZXplTFI5NjRrcTBk?=
 =?utf-8?B?M1FQdkYwdGQrSExTaGFEbFJDWnpJUmVsV1J6eHNDdXRKZEpzcHVVVWl6N1Yz?=
 =?utf-8?B?NUdSV3E1WEV6MWZaREs3Z25QKzEzS0hwUXliMWpGRDRMWG9mczJrcS9rZTJ5?=
 =?utf-8?B?YytSMG5KYlRlV2ZsUGJFdWY4MGZQa1ZaZ1N1bEV6SllFalhKMDB5V2tuVFZa?=
 =?utf-8?B?aFRtdExINmsrWkJLaGlLR1JONFZpM0l6b1pWb1hlUU1NaWsvTGFnMG1iWTVh?=
 =?utf-8?B?T2pyUGtzOVF5MHpERVU2U1EzeW5NUDR5Mmg2eHdjdEV5R1pvN0JPekxoYi9t?=
 =?utf-8?B?SmZGWHJnVDZIWE1BQkc2RisxSmNkUVNrRm1QemhpUUh5OEJDMEQ4bm9UNm45?=
 =?utf-8?B?eWpiMk1vY3ExZmhDbGNILzFHOEN0REsvVTVROG5xbXNnb1FvZlJGRUhjTFNF?=
 =?utf-8?B?UG5QQWZPS28vakJXQ0tmUnNIZ3JZUEM1UjlHeWJkTlVIK0ZRRTRlM3FXQWJ0?=
 =?utf-8?B?Skp2eFViQXFTV0pNcGNJN3ZOZ2cra2toYkVrSVp3NEdZNy9aQXUrOHZRYWR2?=
 =?utf-8?B?NEhhTnU2S2RyQkY1ejEvWU5ORmNWZFlCT2c5R1pqSWtMRHRBUGoxRDV6OEht?=
 =?utf-8?B?L1BBWUVmWlNRcU9xbkVaZGtoem9EZzhZak1jcnNjTklPanJla3AwMkh0MG1t?=
 =?utf-8?B?Y1habmlwTS9RbUdLdWdzZ1A0N3FIMjNBS2hlSXRraHN5dHBwV0drUUtOeUlv?=
 =?utf-8?B?RzN5d0w1NDJldEFJRXdQZlRuQ2ZZQzRmeEhPQzNYZk9YRGl1akxNbG1XMmpW?=
 =?utf-8?B?MHl3NFdVTTlnUmRQcWYwUW5Pc1lqRmpYMEdhVHU2VVowVGFIRC9ETVZNYlNv?=
 =?utf-8?B?N2NWQzEwLzkzRmZ0d0ZNbmFWajEya1JmTXVHT1F0SEdTc0NFZ0hocGxtVWNJ?=
 =?utf-8?B?UWZ4bmlnN1hoZDRSeHBhalNVTURFck9Ma0VpWWR4L2xIeTgrVGpjSXVoRzFa?=
 =?utf-8?Q?IFZEZjkWlpqYjOBx+sP3dsMfRC9J6F8X/mqUsCa?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE581DAAD2346443986870F4ED561A69@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0801a28e-f794-437f-4b22-08d8f84da2d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 16:12:39.9368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mcuUE/fILOjIAzjozeh3/OUbfYnIUk5XfRN4D4j9ZPxtmEfN5oul2rqtVcO35/eSvHjinUbh0d1T7CFjyAvm6ielEOpuzNIVij4OI0VnRDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4131
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050108
X-Proofpoint-GUID: P-h79oXBYOwLRXzFr_oJHrIQfua0nIE_
X-Proofpoint-ORIG-GUID: P-h79oXBYOwLRXzFr_oJHrIQfua0nIE_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104050108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gQXByIDQsIDIwMjEsIGF0IDEwOjUwIFBNLCBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVs
Lm9yZz4gd3JvdGU6DQo+IA0KPiBGcm9tOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+
DQo+IA0KPiBVc2UgbmV3bHkgaW50cm9kdWNlZCBjbGllbnRfc3VwcG9ydGVkKCkgY2FsbGJhY2sg
dG8gYXZvaWQgY2xpZW50DQo+IGFkZGl0aW9uYWwgaWYgdGhlIFJETUEgZGV2aWNlIGlzIG5vdCBv
ZiBJQiB0eXBlIG9yIGlmIGl0IGRvZXNuJ3QNCj4gc3VwcG9ydCBkZXZpY2UgbWVtb3J5IGV4dGVu
c2lvbnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG52aWRpYS5jb20+
DQo+IC0tLQ0KPiBuZXQvcmRzL2liLmMgfCAyMCArKysrKysrKysrKysr4oCU4oCU4oCUDQoNCkxv
b2tzIGZpbmUgYnkgbWUuDQoNCkFja2VkLWJ5OiBTYW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5z
aGlsaW1rYXJAb3JhY2xlLmNvbT4NCg0KDQo=
