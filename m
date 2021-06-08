Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C9339F6A0
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhFHMcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:32:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18732 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232541AbhFHMb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:31:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158CHVRL003217;
        Tue, 8 Jun 2021 12:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7si13qFprgOWEsEVT0lQvjmPrXvaBzyXOiWntxwxpwc=;
 b=kcCzilCzwM9qRErDiXkvbwFgRHAlRBWXWRQHhU8uU1/mjGXook62eZsBLn+SKvo7QDZH
 rWiPSHHQ2yveXBtHqNdX22vBOHNbNX+2M57kWwwQ1ObAKHiMjvMxdM3R83lahO61mHBZ
 cwewcKlomhlemB7JjizzbGJZKKBgTW4wmgEGLhVZwMAAZKc+eEX/qQlhhZOGvawaoMbQ
 9HRnP9gIBuRLZDYqOkrdzndDZA1+y1i3KbWyFvP+pgPIRpHwvOnlTCuucGy1bwe+fGka
 XsfcbFim1SfddbYqIOxThjqQQr12cDYHw7DBTU3VK9M7rMd8bdT7u9wmFRjkQw43YCbF ug== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3916ehrnwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 12:29:59 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 158CHeYQ011465;
        Tue, 8 Jun 2021 12:29:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3020.oracle.com with ESMTP id 3922wrvvwk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 12:29:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhsbPHhROEi+VSKYu/WCilwStLOPR33NLsOCiRw1+p8SAVMFeGMWApKVtQoIeulZLLszBhRIZTLPU6KzTLpOIKMWNoyMYlnTu4mWass4s09nSwzbn/sB82w+LnpdfkAx93ut5dWQEOvJcS9yDMsLcVo7LuB6UIysCk3DiDB/UfXTdXRmW9iZTDAs/feyu4MA0vcylJ5+rXG7m1KHsIzDFnSh17+kAyaE8khuFq19YvN1TBVn5925m4cOaOawJXXNi2YXdYybOl1a1Wt+EmjH2c6HByUOLxyW3bHOVsap/ccaZ2kpzEaizo4ezGXXLC/41k57CVG7wTmbYVjP5B8Axw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7si13qFprgOWEsEVT0lQvjmPrXvaBzyXOiWntxwxpwc=;
 b=B4qBi3Xy+7KfEeYaKIgfYA+8GeFN4D0IqXVLw3lIh/Y1ia2mJm5A5lxy/87NIPlxpmIrc2b/8kbVdxRSRZBIfstXVMiJ5PdUeXPPzV2Dca1TKc7rKSwzbysdBjjsEXTcsXNztuhh+/bgSFOo+s2lKUUxvPiCkWFfPQfJbtswKcguXuiZbNEdarqnOz4peJmjT9O/UkbZ6TVULBsSA+9SFWYvjVcP1J7aRBXqk1zfdWFZABq6qJhquowfZWOLGBLeyBcb0JrkL4wNC146SjsuhCmjELvrEtrFqJ0AZZpHCWX6rRROEzTP53TpONK0b67lnhimDdtk5jRPfIQm4K7nFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7si13qFprgOWEsEVT0lQvjmPrXvaBzyXOiWntxwxpwc=;
 b=0Ld9kQ8wY0cYnFu4WhhflawVrodLu/9zTjEwmtW2xcrro74uMtSundAsoeIqCM6JnR2evLDbXNCjkSddo8moG6D+fid4IYWKNxLEx4mHdJZCCJntIGrrgx/96vMaZC93LiY8g8BQEu44TUw0nH8Kkf8+gVjzgO0rH0Y61xaO/JE=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1670.namprd10.prod.outlook.com (2603:10b6:910:e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 12:29:56 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::2cda:5611:238a:17a3]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::2cda:5611:238a:17a3%8]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 12:29:56 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com" 
        <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] net: rds: fix memory leak in rds_recvmsg
Thread-Topic: [PATCH v2] net: rds: fix memory leak in rds_recvmsg
Thread-Index: AQHXXD1wSnylDteql0CRegCjQqdhuasKC30A
Date:   Tue, 8 Jun 2021 12:29:56 +0000
Message-ID: <3DEDB1BE-C48D-4B64-AB4B-B9C6D9505FC4@oracle.com>
References: <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
 <20210608080641.16543-1-paskripkin@gmail.com>
In-Reply-To: <20210608080641.16543-1-paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 999c71bc-2b8e-40cd-d12f-08d92a791fe0
x-ms-traffictypediagnostic: CY4PR10MB1670:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB167047138B3875743C0BACB8FD379@CY4PR10MB1670.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W2jxIDcc+iqqCTfoazQVedUx1Az8qkAJvY9Ab4P0tfkW3jW7CbsJSiiEmk7eXE4uqL1v7CV5qNx53X9Vy2UMl0gnfrvEhM1ilgS6XD7ubkxGpH97kxqF2S6l0RywWIaQIus2xqMYYBPU3c1DcYC1gNNsvcSLqh3febV2Ud95JNl8xKlf26wFwFcypqCBg6HNnbihYnr7NSEfchGvTUA1tl+InM4Wwwp8J+1/NtQVEylYxJc90DhyX7PZEbNks10lwWt+FIRWD4PjiU27a1cVvcJcCkNKXtNgwKOAtcgslXEHPHCmFIWoi/ZOs8AdKOGtNCHCqt78BfoNr++EgBMQM/8bbeSWmg8VLlZ2X/wjSf1KGE573pN3SKk2qgyY/bSlYWaJkYZzujHQ5nojaa6shTpok5TcCduwZTA0nSg6fBUdD68qZY45DYjyAEMwBWo12+65Ie4j4lnSd+XG1+j/zBRot77yrykBvmRQ46d6N/7Ebq9l+765rSlOlx4i7RWZq1IA9B5acLQ/0g/X9d8TYLnhlVJqqRwEwNAJvuetjtg6faiS5XBP/Ul64CxPGo29NecIe+fRetVVVE9Wcyt9548bdmtaFTSuZ1UrtqooEy9uBNU6XSCFeaQlOyyKI/gJSt0OMkJdq7ugz1lcsRxXwx0PXybOSTjLXhVazg9Jbf4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(83380400001)(76116006)(91956017)(478600001)(66574015)(33656002)(71200400001)(64756008)(66946007)(6506007)(122000001)(6916009)(36756003)(8676002)(186003)(86362001)(316002)(38100700002)(2906002)(5660300002)(6486002)(26005)(44832011)(2616005)(6512007)(54906003)(66556008)(4326008)(66446008)(66476007)(53546011)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzlPRHVCdy9SWFZxTk1tc1NrKzdSOURmdkY0Z0JYNllCbUNiN25KV3VhNEFa?=
 =?utf-8?B?MmVwY0k2NU5kUk00S3NjbjlOWTBkWTJIRjV5dEV4UUhHVFd4Z3Brc04xQkRK?=
 =?utf-8?B?VmVuSHh2cnZyTVZjNEVMczhYVEZySVRTdEs0T2dvdDgvemFlcVVVc1p0NzBo?=
 =?utf-8?B?NWNuL1F6MFpBeXVRcmNpd1hZQzJxWWxZNGZra3lyRWRRbnJrd29BcWJ5QWhW?=
 =?utf-8?B?SFVYR2lpOTFhQmxvZnlGbjQyUXd5aVlUeEROUGUxL3F6NFBhQUZXaUxpcTRu?=
 =?utf-8?B?QW1wMzhCRWVmTnR4UitKR05xeW1haWdEaWNUZWlNRHdUSGMrSDczQkJiemxk?=
 =?utf-8?B?UnFHZEF0MDJqMWN5clBqcDV5TTJPVnJ0NHdNbFFFbmVkcmpsTW1NTURVMUNT?=
 =?utf-8?B?eW5PUnBpUmhjZEh4ZUFMMlNOcW9iWk8vWjlIRWxEUzJqUzd2OGpBTkpRaWNF?=
 =?utf-8?B?Wjl3eFZqdDNRZUdQa3hGUW9qMDMvK3JRaDVBVjRPT1BVbUxLU2trRmVERzFl?=
 =?utf-8?B?Y1FxbHdadTZSL0RtbnN0WWtPWHNPWk1DZ1piVjZuVGRtMytVSkZHMG96cnND?=
 =?utf-8?B?ZFhKVXh2eDVjV1A3Sm5vZnVLT1lpcVQ3b0VWQUFwZTZBdnhTcFpyWTF3bTZ0?=
 =?utf-8?B?cWVKVDhZNmtyR0Z3SGQrWkNWNGwyZkZweUlKUGVDZVRWeXRmcGxXTFAvL0FV?=
 =?utf-8?B?aUIxd3grWDk0Uks5YmF4TnhOUXZId0Q0bFVzQjl4YlFsZkNMZG8xSVY0Lzls?=
 =?utf-8?B?SW96bEliWFNEaktkNmwwNE9mWWw1Wkdzeko4ZTdhVHFGV01RRnVDaXZJTWtr?=
 =?utf-8?B?SVd1SjVNRTJINE4rcnFjeWlPUXh1bVVDZkQxVkEwMEJhOUtoZDc1VmJZSCsv?=
 =?utf-8?B?K044SC8wOVZ6ZE02WkY5bjd4WUN6WXd2NkpyTEtQdjRxYklyOWE2ak9yZ1BU?=
 =?utf-8?B?MzRyeWFaQTVwbllwT1BoMENhaUtKRUw3SlpFMlBpaVpWMXF3Wnh3SXFWMUN2?=
 =?utf-8?B?bllKYXRndGFXVklDRFNiR0pUamxiYjluY1B0QkptSU83T2EwZU84Zi9FUTRs?=
 =?utf-8?B?K2M5WWNBUFBnUm51SDRNakJVREpKYWRES25sZVBSV05TSGVNbHl2YjNzcVVI?=
 =?utf-8?B?NFlwbDJNWjBROFFUbjJTQ0h4UG9UMld0ckEwcy9BcGZzSTVwSkMvQVBNK29k?=
 =?utf-8?B?RlpzSGVCZUUvUlYvTnQvV0RFcW42ZlM3VU1kY2pLandDV0huNG4yTHRIaFlB?=
 =?utf-8?B?dS9vWXBPa3pvcTBtTFNVbWRZdHZHN3Y1eGZaQkZtRFIrc0tTazdlNkVLR0FF?=
 =?utf-8?B?YWdmR2lTNkFrVG4vdFVnbHNzUkF2bmt5WU5LejJVZFcvbjFsYnlBaEpTMkRh?=
 =?utf-8?B?bGcwb3hzc0hRVjNSWmVtYTE3NVdVTk1PNW9BY3lSOFNpNm9EZVo4Y0dtMHpJ?=
 =?utf-8?B?TVE1RDJGK2hjTHVCVWVYclNyUi94dEpYS25hWlhDSWMwVUlSeTB0eFNZVGo0?=
 =?utf-8?B?bmJBTDFXT2pBcXZiQVpmako2K3VtV3dZVDdJTGdLUUdTUUd1cVZrZCtDMHhB?=
 =?utf-8?B?ek9abjBQWjliZTdqa1o2ZGJKa2k0SGwxOXliQ0tjWFBuQjBPSFoveDhwSHFs?=
 =?utf-8?B?WiswVmhrWnlIVElEaU1ORWlnSmo3dElVN09JbVI3TkJaNlYxZWJjRUVzUVB6?=
 =?utf-8?B?dDlUbUhKSU1ZeVliOHQxdkNrRi9UcXQ1dHM1NVNDKzB3NGxWUDB6TEVPVUpo?=
 =?utf-8?B?VFlVdXZEZ0o3YW1WUTB1NlpqbFQ4V0wvZGJCQkFDS24wcloxRFR1YWJpcXU3?=
 =?utf-8?B?WUxVSmZKcndJVzVRWWdZdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87618CE209B631419C5392F2458318D8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999c71bc-2b8e-40cd-d12f-08d92a791fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 12:29:56.2323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fXn6cG1Z7foYZs6n/tCKUAKBQDfZLL5w2+OG0ExG4DRMFmjpWlooT6T5ifa3FdY4rEIaWUM1XPrPCSOB4zeHFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1670
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080082
X-Proofpoint-GUID: dLcLCJExI9SxCq5beSKcVqc3ibz5f6Ig
X-Proofpoint-ORIG-GUID: dLcLCJExI9SxCq5beSKcVqc3ibz5f6Ig
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gOCBKdW4gMjAyMSwgYXQgMTA6MDYsIFBhdmVsIFNrcmlwa2luIDxwYXNrcmlwa2lu
QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBTeXpib3QgcmVwb3J0ZWQgbWVtb3J5IGxlYWsgaW4g
cmRzLiBUaGUgcHJvYmxlbQ0KPiB3YXMgaW4gdW5wdXR0ZWQgcmVmY291bnQgaW4gY2FzZSBvZiBl
cnJvci4NCj4gDQo+IGludCByZHNfcmVjdm1zZyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3Qg
bXNnaGRyICptc2csIHNpemVfdCBzaXplLA0KPiAJCWludCBtc2dfZmxhZ3MpDQo+IHsNCj4gLi4u
DQo+IA0KPiAJaWYgKCFyZHNfbmV4dF9pbmNvbWluZyhycywgJmluYykpIHsNCj4gCQkuLi4NCj4g
CX0NCj4gDQo+IEFmdGVyIHRoaXMgImlmIiBpbmMgcmVmY291bnQgaW5jcmVtZW50ZWQgYW5kDQo+
IA0KPiAJaWYgKHJkc19jbXNnX3JlY3YoaW5jLCBtc2csIHJzKSkgew0KPiAJCXJldCA9IC1FRkFV
TFQ7DQo+IAkJZ290byBvdXQ7DQo+IAl9DQo+IC4uLg0KPiBvdXQ6DQo+IAlyZXR1cm4gcmV0Ow0K
PiB9DQo+IA0KPiBpbiBjYXNlIG9mIHJkc19jbXNnX3JlY3YoKSBmYWlsIHRoZSByZWZjb3VudCB3
b24ndCBiZQ0KPiBkZWNyZW1lbnRlZC4gQW5kIGl0J3MgZWFzeSB0byBzZWUgZnJvbSBmdHJhY2Ug
bG9nLCB0aGF0DQo+IHJkc19pbmNfYWRkcmVmKCkgZG9uJ3QgaGF2ZSByZHNfaW5jX3B1dCgpIHBh
aXIgaW4NCj4gcmRzX3JlY3Ztc2coKSBhZnRlciByZHNfY21zZ19yZWN2KCkNCj4gDQo+IDEpICAg
ICAgICAgICAgICAgfCAgcmRzX3JlY3Ztc2coKSB7DQo+IDEpICAgMy43MjEgdXMgICAgfCAgICBy
ZHNfaW5jX2FkZHJlZigpOw0KPiAxKSAgIDMuODUzIHVzICAgIHwgICAgcmRzX21lc3NhZ2VfaW5j
X2NvcHlfdG9fdXNlcigpOw0KPiAxKSArIDEwLjM5NSB1cyAgIHwgICAgcmRzX2Ntc2dfcmVjdigp
Ow0KPiAxKSArIDM0LjI2MCB1cyAgIHwgIH0NCj4gDQo+IEZpeGVzOiBiZGJlNmZiYzZhMmYgKCJS
RFM6IHJlY3YuYyIpDQo+IFJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IHN5emJvdCs1MTM0Y2RmMDIx
YzRlZDVhYWE1ZkBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IFNpZ25lZC1vZmYtYnk6IFBh
dmVsIFNrcmlwa2luIDxwYXNrcmlwa2luQGdtYWlsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEjDpWtv
biBCdWdnZSA8aGFha29uLmJ1Z2dlQG9yYWNsZS5jb20+DQoNCg0KVGhhbmtzIGZvciBmaXhpbmcg
dGhpcywgSMOla29uDQoNCj4gLS0tDQo+IA0KPiBDaGFuZ2VzIGluIHYyOg0KPiAJQ2hhbmdlZCBn
b3RvIHRvIGJyZWFrLg0KPiANCj4gLS0tDQo+IG5ldC9yZHMvcmVjdi5jIHwgMiArLQ0KPiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9uZXQvcmRzL3JlY3YuYyBiL25ldC9yZHMvcmVjdi5jDQo+IGluZGV4IDRkYjEwOWZiNmVj
Mi4uNWI0MjZkYzM2MzRkIDEwMDY0NA0KPiAtLS0gYS9uZXQvcmRzL3JlY3YuYw0KPiArKysgYi9u
ZXQvcmRzL3JlY3YuYw0KPiBAQCAtNzE0LDcgKzcxNCw3IEBAIGludCByZHNfcmVjdm1zZyhzdHJ1
Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csIHNpemVfdCBzaXplLA0KPiANCj4g
CQlpZiAocmRzX2Ntc2dfcmVjdihpbmMsIG1zZywgcnMpKSB7DQo+IAkJCXJldCA9IC1FRkFVTFQ7
DQo+IC0JCQlnb3RvIG91dDsNCj4gKwkJCWJyZWFrOw0KPiAJCX0NCj4gCQlyZHNfcmVjdm1zZ196
Y29va2llKHJzLCBtc2cpOw0KPiANCj4gLS0gDQo+IDIuMzEuMQ0KPiANCg0K
