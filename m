Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E356F9BDF8
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 15:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfHXN0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 09:26:32 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:12738 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727590AbfHXN0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 09:26:32 -0400
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7O9I1UG024304;
        Sat, 24 Aug 2019 09:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=vyenab3a8UQH7rT3KMO+iOomzSuZqcYP73PMmCmSPIE=;
 b=J/iMqm/N0WJdTi5TgBlmGq6ZdfHFNbHYMHYcJd72g8PoQYJgU3HOUlPxe3A8v5snxtSt
 96trZn40na8DwsT2aP4Fm7yoGBPf+JfUEO8WnqpJezV5Jw5BsNdM5vN8rgHSMMVetO+j
 g15uj9G5oH6X5T786heYcDaywpVaKPikI7+qYqD/5O+/u3BYMa8YBPKQgBXHxWzSBVZt
 aXpehYtfcEgJxqYXTqON2eijl/FTQW7RkRLYjC390BdJXo4Bvr79TJJKmJf6TkbQOw4C
 ZGKVMUZ7dHiuVA3jIzBuYWJlU6Pr9IvIX1effbkoyoaNr3a1ddQ1W/vgdtFagTBuFJRT WA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 2uk2fx8e5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 24 Aug 2019 09:26:30 -0400
Received: from pps.filterd (m0133268.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7ODQR8a093409;
        Sat, 24 Aug 2019 09:26:30 -0400
Received: from ausxippc106.us.dell.com (AUSXIPPC106.us.dell.com [143.166.85.156])
        by mx0a-00154901.pphosted.com with ESMTP id 2uk2d0j2jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 09:26:29 -0400
X-LoopCount0: from 10.166.135.96
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,349,1549951200"; 
   d="scan'208";a="451775981"
From:   <Mario.Limonciello@dell.com>
To:     <bjorn@mork.no>, <Charles.Hyde@dellteam.com>
CC:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <oliver@neukum.org>,
        <netdev@vger.kernel.org>, <nic_swsd@realtek.com>
Subject: RE: [RFC 4/4] net: cdc_ncm: Add ACPI MAC address pass through
 functionality
Thread-Topic: [RFC 4/4] net: cdc_ncm: Add ACPI MAC address pass through
 functionality
Thread-Index: AQHVV6XcyyL7dINtZEiggXCPIGXHZ6cKIlGegAAtFPA=
Date:   Sat, 24 Aug 2019 13:26:27 +0000
Message-ID: <76ae76bf1fd44fb3bd42eb43907e3ce8@AUSX13MPC101.AMER.DELL.COM>
References: <ec7435e0529243a99f6949ee9efbede5@AUSX13MPS303.AMER.DELL.COM>
 <877e722691.fsf@miraculix.mork.no>
In-Reply-To: <877e722691.fsf@miraculix.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [143.166.24.60]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-24_08:2019-08-23,2019-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 mlxlogscore=660 suspectscore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908240149
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 impostorscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=755 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908240102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCasO4cm4gTW9yayA8Ympvcm5A
bW9yay5ubz4NCj4gU2VudDogU2F0dXJkYXksIEF1Z3VzdCAyNCwgMjAxOSA1OjQ0IEFNDQo+IFRv
OiBIeWRlLCBDaGFybGVzIC0gRGVsbCBUZWFtDQo+IENjOiBsaW51eC11c2JAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9yZzsNCj4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlv
bi5vcmc7IExpbW9uY2llbGxvLCBNYXJpbzsgb2xpdmVyQG5ldWt1bS5vcmc7DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IG5pY19zd3NkQHJlYWx0ZWsuY29tDQo+IFN1YmplY3Q6IFJlOiBbUkZD
IDQvNF0gbmV0OiBjZGNfbmNtOiBBZGQgQUNQSSBNQUMgYWRkcmVzcyBwYXNzIHRocm91Z2gNCj4g
ZnVuY3Rpb25hbGl0eQ0KPiANCj4gDQo+IFtFWFRFUk5BTCBFTUFJTF0NCj4gDQo+IDxDaGFybGVz
Lkh5ZGVAZGVsbHRlYW0uY29tPiB3cml0ZXM6DQo+IA0KPiA+IEBAIC05MzAsMTEgKzkzMSwxOCBA
QCBpbnQgY2RjX25jbV9iaW5kX2NvbW1vbihzdHJ1Y3QgdXNibmV0ICpkZXYsDQo+IHN0cnVjdCB1
c2JfaW50ZXJmYWNlICppbnRmLCB1OCBkYXRhXw0KPiA+ICAJdXNiX3NldF9pbnRmZGF0YShjdHgt
PmNvbnRyb2wsIGRldik7DQo+ID4NCj4gPiAgCWlmIChjdHgtPmV0aGVyX2Rlc2MpIHsNCj4gPiAr
CQlzdHJ1Y3Qgc29ja2FkZHIgc2E7DQo+ID4gKw0KPiA+ICAJCXRlbXAgPSB1c2JuZXRfZ2V0X2V0
aGVybmV0X2FkZHIoZGV2LCBjdHgtPmV0aGVyX2Rlc2MtDQo+ID5pTUFDQWRkcmVzcyk7DQo+ID4g
IAkJaWYgKHRlbXApIHsNCj4gPiAgCQkJZGV2X2RiZygmaW50Zi0+ZGV2LCAiZmFpbGVkIHRvIGdl
dCBtYWMgYWRkcmVzc1xuIik7DQo+ID4gIAkJCWdvdG8gZXJyb3IyOw0KPiA+ICAJCX0NCj4gPiAr
CQlpZiAoZ2V0X2FjcGlfbWFjX3Bhc3N0aHJ1KCZpbnRmLT5kZXYsICZzYSkgPT0gMCkgew0KPiA+
ICsJCQltZW1jcHkoZGV2LT5uZXQtPmRldl9hZGRyLCBzYS5zYV9kYXRhLCBFVEhfQUxFTik7DQo+
ID4gKwkJCWlmICh1c2JuZXRfc2V0X2V0aGVybmV0X2FkZHIoZGV2KSA8IDApDQo+ID4gKwkJCQl1
c2JuZXRfZ2V0X2V0aGVybmV0X2FkZHIoZGV2LCBjdHgtDQo+ID5ldGhlcl9kZXNjLT5pTUFDQWRk
cmVzcyk7DQo+ID4gKwkJfQ0KPiA+ICAJCWRldl9pbmZvKCZpbnRmLT5kZXYsICJNQUMtQWRkcmVz
czogJXBNXG4iLCBkZXYtPm5ldC0NCj4gPmRldl9hZGRyKTsNCj4gPiAgCX0NCj4gDQo+IFNvIHlv
dSB3YW50IHRvIHJ1biBhIERlbGwgc3BlY2lmaWMgQUNQSSBtZXRob2QgZXZlcnkgdGltZSBhbnlv
bmUgcGx1Z3Mgc29tZQ0KPiBOQ00gY2xhc3MgZGV2aWNlIGludG8gYSBob3N0IHN1cHBvcmluZyBB
Q1BJPyAgVGhhdCdzIGdvaW5nIHRvIGFubm95IHRoZSBoZWxsIG91dA0KPiBvZiA5OS45OTk3JSBv
ZiB0aGUgeDg2LCBpYTY0IGFuZCBhcm02NCB1c2VycyBvZiB0aGlzIGRyaXZlci4NCj4gDQo+IENh
bGwgQUNQSSBvbmNlIHdoZW4gdGhlIGRyaXZlciBsb2FkcywgYW5kIG9ubHkgaWYgcnVubmluZyBv
biBhbiBhY3R1YWwgRGVsbA0KPiBzeXN0ZW0gd2hlcmUgdGhpcyBtZXRob2QgaXMgc3VwcG9ydGVk
LiAgVGhlcmUgbXVzdCBiZSBzb21lIEFDUEkgZGV2aWNlIElEIHlvdQ0KPiBjYW4gbWF0Y2ggb24g
dG8ga25vdyBpZiB0aGlzIG1ldGhvZCBpcyBzdXBwb3J0ZWQgb3Igbm90Pw0KPiANCj4gDQo+IEJq
w7hybg0KDQpJIGhhdmUgdG8gYWdyZWUgLSB0aGlzIGlzIG1pc3NpbmcgYW4gaWRlbnRpZnlpbmcg
ZmFjdG9yIG9mIHRoZSBENjAwMC4gIEl0IHNob3VsZG4ndCBiZQ0KcnVubmluZyBvbiAianVzdCBh
bnkiIGNkY19uY20gZGV2aWNlLg0KDQpUaGUgY29kZSB0aGF0IGlzIGluIGdldF9hY3BpX21hY19w
YXNzdGhyb3VnaCBjaGVja3MgZm9yIGEgcHJvcGVybHkgYnVpbHQgQUNQSSBtZXRob2QNCnRob3Vn
aC4NCg==
