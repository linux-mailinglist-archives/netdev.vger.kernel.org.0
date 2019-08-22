Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D1D99A9F
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388935AbfHVROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 13:14:38 -0400
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:17688 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391125AbfHVROf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 13:14:35 -0400
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MGtSkM005894;
        Thu, 22 Aug 2019 13:14:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dellteam.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=pSPlsJFML3BPeq/21ZQFMi902QsechRDqUNGAYwS7Pk=;
 b=UANCy6whT4s4Jys4elafzzxHviWk+sVcvbDUgD6Q7+DoN7nIZDBiwdGfcxKNX5U8bbPo
 oZHKNhw8eGY7Fy5TCfRqr0FxNQX9HmG6z0JajwqrAQ29YKk6XTsfhJoo15HXyewipla6
 c4DtKeaZOJMlm0maJW6s7WmlZxiF8GcxN9lWjx3sCx+3og5bHISjHSdfKkAiCa4GUvqp
 oiKHxB8CvYGnwVa4x9QF8wB7GStXZc8PawmCH6ORxiwDcdg+Kxj0jzBeU6sS71l/rTdo
 z2bwp0f7IP0SnOwukcUYEbSV+v26o+9kTKRqYtfFkx06JIBe3yUoXzJklUNgNHxNqxOq Bg== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0a-00154904.pphosted.com with ESMTP id 2uhubq1bh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 13:14:34 -0400
Received: from pps.filterd (m0134318.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MGwPIG097699;
        Thu, 22 Aug 2019 13:14:33 -0400
Received: from ausxippc101.us.dell.com (ausxippc101.us.dell.com [143.166.85.207])
        by mx0a-00154901.pphosted.com with ESMTP id 2uec7ej842-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 13:14:32 -0400
X-LoopCount0: from 10.166.132.132
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.60,346,1549951200"; 
   d="scan'208";a="1288603742"
From:   <Charles.Hyde@dellteam.com>
To:     <oneukum@suse.com>, <gregkh@linuxfoundation.org>
CC:     <Mario.Limonciello@dell.com>, <nic_swsd@realtek.com>,
        <linux-acpi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: RE: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Topic: [RFC 1/4] Add usb_get_address and usb_set_address support
Thread-Index: AQHVV6TlN6JhPmp8+EufEIlfFi8+LKcE8QcAgAFHO1CAAO3FgIAANWIw
Date:   Thu, 22 Aug 2019 17:14:30 +0000
Message-ID: <8014f932039c4e01bd513148f20ca0e4@AUSX13MPS303.AMER.DELL.COM>
References: <1566339522507.45056@Dellteam.com>
        ,<20190820222602.GC8120@kroah.com> <1566430506442.20925@Dellteam.com>
 <1566461295.8347.19.camel@suse.com>
In-Reply-To: <1566461295.8347.19.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Charles_Hyde@Dellteam.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2019-08-22T17:14:29.2453990Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.143.242.75]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=725 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220156
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=822 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+IDxzbmlwcGVkPg0KPiA+ID4NCj4gPiA+IFRoaXMgaXMgYSBWRVJZIGNkYy1uZXQtc3BlY2lm
aWMgZnVuY3Rpb24uICBJdCBpcyBub3QgYSAiZ2VuZXJpYyIgVVNCDQo+ID4gPiBmdW5jdGlvbiBh
dCBhbGwuICBXaHkgZG9lcyBpdCBiZWxvbmcgaW4gdGhlIFVTQiBjb3JlPyAgU2hvdWxkbid0IGl0
DQo+ID4gPiBsaXZlIGluIHRoZSBjb2RlIHRoYXQgaGFuZGxlcyB0aGUgb3RoZXIgY2RjLW5ldC1z
cGVjaWZpYyBsb2dpYz8NCj4gPiA+DQo+ID4gPiB0aGFua3MsDQo+ID4gPg0KPiA+ID4gZ3JlZyBr
LWgNCj4gPg0KPiA+DQo+ID4gVGhhbmsgeW91IGZvciB0aGlzIGZlZWRiYWNrLCBHcmVnLiAgSSB3
YXMgbm90IHN1cmUgYWJvdXQgYWRkaW5nIHRoaXMgdG8NCj4gbWVzc2FnZS5jLCBiZWNhdXNlIG9m
IHRoZSBVU0JfQ0RDX0dFVF9ORVRfQUREUkVTUy4gIEkgaGFkIGZvdW5kDQo+IHJlZmVyZW5jZXMg
dG8gU0VUX0FERFJFU1MgaW4gdGhlIFVTQiBwcm90b2NvbCBhdA0KPiBodHRwczovL3dpa2kub3Nk
ZXYub3JnL1VuaXZlcnNhbF9TZXJpYWxfQnVzI1VTQl9Qcm90b2NvbC4gIElmIG9uZSB3YW50ZWQg
YQ0KPiBnZW5lcmljIFVTQiBmdW5jdGlvbiBmb3IgU0VUX0FERFJFU1MsIHRvIGJlIHVzZWQgZm9y
IGJvdGggc2VuZGluZyBhIE1BQw0KPiBhZGRyZXNzIGFuZCByZWNlaXZpbmcgb25lLCBob3cgd291
bGQgeW91IHN1Z2dlc3QgdGhpcyBiZSBpbXBsZW1lbnRlZD8gIFRoaXMNCj4gaXMgYSBsZWdpdCBx
dWVzdGlvbiBiZWNhdXNlIEkgYW0gY3VyaW91cy4NCj4gDQo+IFlvdXIgaW1wbGVtZW50YXRpb24g
d2FzLCBleGNlcHQgZm9yIG1pc3NpbmcgZXJyb3IgaGFuZGxpbmcsIHVzYWJsZS4NCj4gVGhlIHBy
b2JsZW0gaXMgd2hlcmUgeW91IHB1dCBpdC4gQ0RDIG1lc3NhZ2VzIGV4aXN0IG9ubHkgZm9yIENE
QyBkZXZpY2VzLiBOb3cNCj4gaXQgaXMgdHJ1ZSB0aGF0IHRoZXJlIGlzIG5vIGdlbmVyaWMgQ0RD
IGRyaXZlci4NCj4gQ3JlYXRpbmcgYSBtb2R1bGUganVzdCBmb3IgdGhhdCB3b3VsZCBjb3N0IG1v
cmUgbWVtb3J5IHRoYW4gaXQgc2F2ZXMgaW4gbW9zdA0KPiBjYXNlcy4NCj4gQnV0IE1BQ3MgYXJl
IGNvbmZpbmVkIHRvIG5ldHdvcmsgZGV2aWNlcy4gSGVuY2UgdGhlIGZ1bmN0aW9uYWxpdHkgY2Fu
IGJlIHB1dA0KPiBpbnRvIHVzYm5ldC4gSXQgc2hvdWxkIG5vdCBiZSBwdXQgaW50byBhbnkgaW5k
aXZpZHVhbCBkcml2ZXIsIHNvIHRoYXQgZXZlcnkNCj4gbmV0d29yayBkcml2ZXIgY2FuIHVzZSBp
dCB3aXRob3V0IGR1cGxpY2F0aW9uLg0KPiANCj4gPiBZb3VyIGZlZWRiYWNrIGxlZCB0byBtb3Zp
bmcgdGhlIGZ1bmN0aW9uYWxpdHkgaW50byBjZGNfbmNtLmMgZm9yIHRvZGF5J3MNCj4gdGVzdGlu
ZywgYW5kIHJlbW92aW5nIGFsbCBjaGFuZ2VzIGZyb20gbWVzc2FnZXMuYywgdXNiLmgsIHVzYm5l
dC5jLCBhbmQNCj4gdXNibmV0LmguICBUaGlzIG1heSBiZSB3aGVyZSBJIGVuZCB1cCBsb25nIHRl
cm0sIGJ1dCBJIHdvdWxkIGxpa2UgdG8gbGVhcm4gaWYNCj4gdGhlcmUgaXMgYSBwb3NzaWJsZSBz
b2x1dGlvbiB0aGF0IGNvdWxkIGxpdmUgaW4gbWVzc2FnZS5jIGFuZCBiZSBjYWxsYWJsZSBmcm9t
DQo+IG90aGVyIFVTQi10by1FdGhlcm5ldCBhd2FyZSBkcml2ZXJzLg0KPiANCj4gQWxsIHRob3Nl
IGRyaXZlcnMgdXNlIHVzYm5ldC4gSGVuY2UgdGhlcmUgaXQgc2hvdWxkIGJlLg0KPiANCj4gCVJl
Z2FyZHMNCj4gCQlPbGl2ZXINCg0KDQpTb21lIG9mIHRoZSBkcml2ZXJzIGluIGRyaXZlcnMvbmV0
L3VzYi8gZG8gY2FsbCBmdW5jdGlvbnMgaW4gZHJpdmVycy9uZXQvdXNiL3VzYm5ldCwgYnV0IG5v
dCBhbGwuICBBcyBHcmVnIHBvaW50ZWQgb3V0LCB0aGUgVVNCIGNoYW5nZSBJIGRldmVsb3BlZCBp
cyBjZGMgc3BlY2lmaWMsIHNvIHB1dHRpbmcgaXQgaW50byB1c2JuZXQgd291bGQgcmFpc2UgdGhl
IHNhbWUgY29uY2VybnMgR3JlZyBtZW50aW9uZWQuICBMZWF2aW5nIG15IG5ld2VzdCBpbXBsZW1l
bnRhdGlvbiBpbiBjZGNfbmNtLmMgd2lsbCBiZSBtb3N0IGFwcHJvcHJpYXRlLCBhcyBpdCBhbHNv
IGZpdHMgd2l0aCB3aGF0IG90aGVyIGRyaXZlcnMgaW4gdGhpcyBmb2xkZXIgaGF2ZSBkb25lLiAg
TXkgb3JpZ2luYWwgY29kZSB3YXMgcmF0aGVyIHNob3J0IHNpZ2h0ZWQsIGF0IGJlc3QuDQoNCkNo
YXJsZXMNCg==
