Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5A35D075
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245078AbhDLSgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:36:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37222 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbhDLSgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 14:36:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CIYgBg007638;
        Mon, 12 Apr 2021 18:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uQ0lOCAEySGhnk30Su2rDPrRd1Cbz80JRqp/+SZv2IY=;
 b=VPloUGyIDeI05CDFhqgEycTbgtw4Z1aonAMXte/mCOEvL4Uwj/AIMtqZtaWY5XXntHK2
 dv9DBb+n8NArM0lv4x74jjDu79Hg+kyJazm/MthFkI4WpFk0bqEQux/+JmqWSkld17Xp
 xIdV0PFty62/wrz1V0l3oqvrkv4RR4vVOJv1okPR0tRvVZrYdrKfE04k/Ywg2VO7/NgQ
 PzNeTF/4E9D7hcTDz34C3bdoAoTUWaEKalEbrl2CLn6m5kreIOADs3IwWVw5Vlj7TCbI
 fwHXg7mCDXhVFtqoqA9Rei1TCxMGzbWWlKEi2z+I8UqSzSJd0SuvxyzVs8YNOtHd/IGm uQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymcp99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 18:35:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CIGJKr012115;
        Mon, 12 Apr 2021 18:35:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 37unxvs4sn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 18:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRuAAbpPWJXt/GsANt6elmfRo1FLwC0lYhQhMOM7GqWfHzJzGjSUdMsuvqY1VjRxXqvOV+nwK+RWc+8d6QXZbLH8ThoCKxo4pvwEcHv+K/HZIbf0jBtv7elzLIHjNc4X+/D2kviVvuiwVxtH4fzWzarVzryUSJpszVaYrjN/n66zzUNkHGv/ThZ/9wk1dmpWeSwBP1g776Xv3t2RrQRKfunN4909ae2bhmnW3Vfmrpc/I6FVcmimxXi9rfvKPc4bCmQDnT6Rz1E5TaZsGLHzHd1rM8n7xRAs1Dlq8HZnuNKt2r70L1osZQ5eRnXKkz0PZTcPG5UAX3wb32tMRWj/SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQ0lOCAEySGhnk30Su2rDPrRd1Cbz80JRqp/+SZv2IY=;
 b=B0ZGGZyyElmzo1dWGLhpdQfBgX2r4zlzVkTHBbeZ1nS6H9iBd/nek8I/a8UfEftj8XhXMDo1FYcspj+Pd4YfcIuYjdA9TtqHYfBeQuYtyW8iBz8xUFaQXuP2CJzb2aXTupXqF5z6ATfaSzTlGvla7GAP8NHXAJUTkFXKsFFxUwWdfKNCaRZNFYcBSPm8NpQHXklTfWMR/dJKx5lgme+f0Q3TilzGCn4TKCk+dS7uVp+4As5Ruq48vvKVgRNOf6REU2CsYgHwv9zNICro4sB6P7VBTp1axhF0yeaN8nKioVsGh/V65L1fQK7HFzdtGe/ZbIkXe5GzbUm17mhdpVKttQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQ0lOCAEySGhnk30Su2rDPrRd1Cbz80JRqp/+SZv2IY=;
 b=npySF1fzlE/WzetMbYBSVh+/zSi+papz+hUfBC7sUAMWusdXLplfPOOBP+78w01V2AaYCoiaB5r/cTK91Fn5o2ZWcfs0TeQLJwvvHEqnv1LTIw6hvrNlFDjRhnkm6+dT+GrlnGjz4YgLLojlQpfb97gBlPd+d3VvLhd9235LU1g=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1832.namprd10.prod.outlook.com (2603:10b6:903:123::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Mon, 12 Apr
 2021 18:35:35 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.4020.022; Mon, 12 Apr
 2021 18:35:35 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Topic: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Index: AQHXJl3kxGIldyYid0mmsgwi6FkGPKqegoeAgAFv6wCACVprAIAH+6eA
Date:   Mon, 12 Apr 2021 18:35:35 +0000
Message-ID: <FA3BF16F-893A-4990-BAA4-E8DC595A814B@oracle.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <BYAPR10MB3270D41D73EA9D9D4FCAF118937C9@BYAPR10MB3270.namprd10.prod.outlook.com>
 <20210401175106.GA1627431@nvidia.com>
 <75DFACE2-CBA6-4486-B22F-EFE6D8D51173@oracle.com>
In-Reply-To: <75DFACE2-CBA6-4486-B22F-EFE6D8D51173@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6102b19b-7dd1-4204-f48c-08d8fde1c34b
x-ms-traffictypediagnostic: CY4PR10MB1832:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB1832694E1A96C002BBFAF264FD709@CY4PR10MB1832.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIhJ6d3JLXc1bBAhEvhatapLNFSyLKpr3G4k/u7TGlVrORqNDG4Iz/t10fjs4TRVaM5OFQzyG5iXTk2aswI8VELfVQB4hLu5Lh8sRWNZ8KJKbxCMJfveM+fqnxST16QVf46/KDR7a1Ut2lNkbS2Alr7M4iaArWskHPd1L0NiSb2lJt5laJaNmJnKEhs/oBV8DPwlIwmbmxgQFtEMVl41R4ld93/JpkBhF2/kGthZ5NFytDp+h2xqvohZaaupXfGzY9a1Gd6M2Ir+OpkaZmjqfYuLfROCfxAC+wGG1qWqxmvjaGSqNmqsqMANLH12sBSrEuH/PRd4t71xcER+aUjFxuT5zcj9EaRR+Spf2ZiskbgufLXqUBw2a6/cdp+WQWl9pZBYiFvFDKW9ZI07HPZBpQUzeL2I6dJKJPiCoRpLQDPFcfCXk/GrOVY6A8EEodrq0V/N5iHbYxOkYnXYDa0OZyz2fILVfdhY2Umxzz9+iXo9ZmcHaErxLvq/Zwz8v8tHryVAN/jdN9B1m9nMD4iCfggYiREvFF22jPjYtN7JWUHnUjNyFt52opOnE0sqE2oVnCYKlepU9oc0PODaT3Rkmj8dOnpHRbhD0I/uU4seCjmLvve98MqAbQiDZksN+ms3sB/Dr2RrSNAvM/WcfEQX9P4RGJ6wBoeLytyI75sc8AI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(38100700002)(33656002)(44832011)(2616005)(36756003)(8936002)(76116006)(91956017)(6506007)(66446008)(64756008)(66476007)(66946007)(6512007)(53546011)(478600001)(66556008)(5660300002)(71200400001)(110136005)(26005)(2906002)(186003)(66574015)(54906003)(316002)(4744005)(86362001)(4326008)(6486002)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b092QWt3dExFVVE1TWx3OVM2OTQzNlNSUG5FUzZ0aWRGMFRSbnJXOHJJSjYv?=
 =?utf-8?B?MDdWVWtBTGEvK0IyVHM0S2RaMm5FTXVCa0NITndKbXR6Q2c1VG9aOW02Uk9k?=
 =?utf-8?B?UFNqT0ZhYWkrTzlWdHdPeVFNMlJWeGR5cDZGSk53aFkyZVFza09tQ1N1UUd2?=
 =?utf-8?B?cDR5TGxKVTBsSzVXbFJXcU1kbkgzWTVwdXBsci9zR0x3bTh2U2V6WCtpaG1K?=
 =?utf-8?B?a2JVYWhrY0poT1ZCazVRRnpUK1JkVEVRUm9HZDNTakFocEEyR1dxek5RcmZ4?=
 =?utf-8?B?bnhIem80dm5nT1BienJCOHRhMU5RRmd5aExxTmpYZ2dlT2x3SFJrMjYvYlFQ?=
 =?utf-8?B?OWhKL2I5V2NEWmNOeWp1SkxZdUZlRUZRTGtSUnVNYXZoQzJIaStRY2RFS2tI?=
 =?utf-8?B?TURYV0hmeWlRNStnS3ZNdldWVGxkWm5SQVdXUjdyR3oxVnZwbStoQ00wODJC?=
 =?utf-8?B?UTViMHlRSjdsOUM5T1p5UmFGT3NORmRlSGR4ZXFNSStNU2hPTHlsTnNtSGFL?=
 =?utf-8?B?bk5XSVZ0U0pXbHhwVmFMRGMxbDFUZXprR2hxSEpLdDcvaGdZdUQvZDhRS204?=
 =?utf-8?B?cjdHS2J2UURYbHlqWm9XNEpnb1BFQzRNTTRFQ2Q3V1R5aDRXQXRRMkVNckY4?=
 =?utf-8?B?Y3h4MDlPc08vZkU1T1VEbzJYVVVoeUVaaU4xL2hOcGdDMjFOaFNGS3NBamhR?=
 =?utf-8?B?L05TMG5pVTdLcTBzQmZGbTROaGdyV25CeXdoL2hEU0JEa0NIUHBiQTJYd21j?=
 =?utf-8?B?WUdvdHJZWDdpTjAwVjdyNUpnS3JGMy9Uc2pHa2tDa0pBRVo3STV1a3h0ZkNa?=
 =?utf-8?B?VE9Mc05IeUlzRzJKZWRNOU9hZyt6ZndGYTV0Vk9mMXB6dW01REJyanVybjhx?=
 =?utf-8?B?S0lTakFhUSt5enl3QjltVnhvbGVPbFBlcmdQUnZWcmtsYm12ZTJRd3pDd3l5?=
 =?utf-8?B?ZjRrczFobnl3RS9JZ0M4bkk3eDhSRytROWJlZlJyaFZSTzcxZUEvbTczKzBw?=
 =?utf-8?B?V3hyVFJyMlVEcFV3WXdFOUQ3cTZIaTYxM01Pbzc4SlZUU3JHd3hYcEF1dUxs?=
 =?utf-8?B?N09ZZTZkZGlzWHFZSW9RVlRJdUw0eGQ3bmxwUjR6TUVBQ2poNXJIbzN1Rkhz?=
 =?utf-8?B?Y3d6TTQrMG5sOUdNVUZFQmpudVZlTTNkS3g5aDNNTWs2NEpXcWowZ293KzVJ?=
 =?utf-8?B?VXE2RTZPZUt5RTVkenhvaFhqSmJjUjRqUHVqYk5mdDF3RU91azBBbm1wVUJC?=
 =?utf-8?B?NzFraE9ubTFaRzhKRFNScnZxUFNUcU9VZHFhSWlVQlNmSGI0L3BYSFRvWjFU?=
 =?utf-8?B?cEh2ZVdmZlA0cmd4dGJ4MlBjQnNBRGxRMEdKZlJwVkh3YTU2K2U0UXBkZ3dm?=
 =?utf-8?B?YllZSmRGd3JNS3BvOU9PeHJVNWU5WmJ2TnA0S3kyYXBoSllBdWNYdTVMSFJF?=
 =?utf-8?B?NU9sQ01sZUk3bnJZRXlpR0ZJaTNlV0tHT0lmQzdlMnA3OFlYWmNwUGJPeU4w?=
 =?utf-8?B?SVJDb1N6dnkxQ2h4THkwTXNkdDFOS2V3N00weHR3TDZJcitSeUhjQWFGdDdz?=
 =?utf-8?B?SXczcnZVREhHNngxZ0N3em55dXdObEZBcDdrSG5ZY3o4Q3E1RHh4Mk1oL0Z5?=
 =?utf-8?B?VjhVdk84QkttMy9TYWtTSXJ3K1hSMlZVSjVXVG1FUDVXZUZXM0w0RkZxTXF4?=
 =?utf-8?B?TDhKcm1TSlBzaXpPa2p3cVpLdXJVZE8zYjg2UVl1a1hMYkN1YmxYUnkwUVI1?=
 =?utf-8?B?azJMQTBlVzdNWnpkalNMVzIyK3llSEZ0UVE5UUtERy9GMlFDT3M4ZDNuWXp5?=
 =?utf-8?B?Y000cUtSbGptRFZsRFpkQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B01D4B718271BE4DA9BF4D85D9AB698A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6102b19b-7dd1-4204-f48c-08d8fde1c34b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 18:35:35.8149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4DgyCXnGZGCcDy6uo4dcgjhZ/JCcqGOeqG0/i0KbEno4362B+sfxlcDwGG0N2FJfl+i0sL5OFBRsoEbAFgiWCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1832
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120117
X-Proofpoint-GUID: -HFWtu6ZJdXVdtNCAvRIiWXU1M2sDERY
X-Proofpoint-ORIG-GUID: -HFWtu6ZJdXVdtNCAvRIiWXU1M2sDERY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNyBBcHIgMjAyMSwgYXQgMTg6NDEsIEhhYWtvbiBCdWdnZSA8aGFha29uLmJ1Z2dl
QG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IA0KPj4gT24gMSBBcHIgMjAyMSwgYXQgMTk6
NTEsIEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+IHdyb3RlOg0KPj4gDQo+PiBPbiBX
ZWQsIE1hciAzMSwgMjAyMSBhdCAwNzo1NDoxN1BNICswMDAwLCBTYW50b3NoIFNoaWxpbWthciB3
cm90ZToNCj4+PiBbLi4uXQ0KPj4+IA0KPj4+IFRoYW5rcyBIYWFrb24uIFBhdGNoc2V0IGxvb2tz
IGZpbmUgYnkgbWUuDQo+Pj4gQWNrZWQtYnk6IFNhbnRvc2ggU2hpbGlta2FyIDxzYW50b3NoLnNo
aWxpbWthckBvcmFjbGUuY29tPg0KPj4gDQo+PiBKYWt1Yi9EYXZlIGFyZSB5b3UgT0sgaWYgSSB0
YWtlIHRoaXMgUkRTIHBhdGNoIHJkbWEgdG8gcmRtYSdzIHRyZWU/DQo+IA0KPiBMZXQgbWUga25v
dyBpZiB0aGlzIGlzIGxpbmdlcmluZyBkdWUgdG8gTGVvbidzIGNvbW1lbnQgYWJvdXQgdXNpbmcg
V0FSTl9PTigpIGluc3RlYWQgb2YgZXJyb3IgcmV0dXJucy4NCg0KQSBnZW50bGUgcGluZy4NCg0K
SMOla29uDQoNCg==
