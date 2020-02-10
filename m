Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9C1585A2
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 23:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBJWhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 17:37:35 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:36383 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgBJWhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 17:37:35 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 5D993886BF
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 11:37:31 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1581374251;
        bh=Wqr8g/8se7mcoCvGHoeg+ET7QbbIGC6QCoyU+kTZk78=;
        h=From:To:Subject:Date;
        b=kugXIhGBqVB1iuqAT3IWUSiHinnXMeqYfK36UoT1zw17UJcpLL9wVc2qt6LnePufn
         uKlyx8ylRN4REN0mINUA0JsKMnCc8lAiKbHZXQdmqflx4+lPOyiiOyeCBULmpA4jiW
         oxMsoXa7Fn2yG51mHJsES6Wey6T6csKiSdpUmTFBQ5WNuguW48Kdi+OLCgiTTo13CU
         QtGi/+HfUGqbcBTVDPMnJ8Gi+UmsrUC8N+E49pDp0nKQBSIJGnj1wfwCMnakpBLNgs
         3HiDnx0rInJ29WVfXcTHtwhA4KSYV5ZRq/KgHAULH76cT2T4wVqyQ9pNY+YmfF2SzR
         iOrhm3mFCpixw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e41db2b0003>; Tue, 11 Feb 2020 11:37:31 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Feb 2020 11:37:31 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1473.005; Tue, 11 Feb 2020 11:37:31 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "libc-help@sourceware.org" <libc-help@sourceware.org>
Subject: redefinition of 'struct iphdr' - netinet/ip.h vs linux/ip.h
Thread-Topic: redefinition of 'struct iphdr' - netinet/ip.h vs linux/ip.h
Thread-Index: AQHV4GKtP+FedlXX+E+CqRZvUkiSRA==
Date:   Mon, 10 Feb 2020 22:37:30 +0000
Message-ID: <06d85c1ec9537fba479f9d02e938feeb7f623662.camel@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:7107:d7a8:1069:3b0e]
Content-Type: text/plain; charset="utf-8"
Content-ID: <176BAF982227A3459980BA1EBB33DFAB@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkkgaGF2ZSBhbiBhcHBsaWNhdGlvbiB0aGF0IHdhbnRzIHRvIGluY2x1ZGUgYm90aCBu
ZXRpbmV0L2lwLmggYW5kDQpsaW51eC9pZl90dW5uZWwuaC4NCg0KQXMgb2Yga2VybmVsIGhlYWRl
cnMgdmVyc2lvbnMgbmV3ZXIgdGhhbiB2NC44IHRoZSBhcHBsaWNhdGlvbiBmYWlscyB0bw0KY29t
cGlsZSB3aXRoIHRoZSBmb2xsb3dpbmcgZXJyb3INCg0KICBtYWtlWzFdOiBFbnRlcmluZyBkaXJl
Y3RvcnkgJ2NvbXBpbGUtdGVzdCcNCiAgICBDQyAgICAgICBjb21waWxlLXRlc3Qubw0KICBJbiBm
aWxlIGluY2x1ZGVkIGZyb20gL3Vzci9pbmNsdWRlL2xpbnV4L2lmX3R1bm5lbC5oOjcsDQogICAg
ICAgICAgICAgICAgICAgZnJvbSBjb21waWxlLXRlc3QuYzozOg0KICAvdXNyL2luY2x1ZGUvbGlu
dXgvaXAuaDo4Njo4OiBlcnJvcjogcmVkZWZpbml0aW9uIG9mICdzdHJ1Y3QgaXBoZHInDQogICBz
dHJ1Y3QgaXBoZHIgew0KICAgICAgICBefn5+fg0KICBJbiBmaWxlIGluY2x1ZGVkIGZyb20gY29t
cGlsZS10ZXN0LmM6MjoNCiAgL3Vzci9pbmNsdWRlL25ldGluZXQvaXAuaDo0NDo4OiBub3RlOiBv
cmlnaW5hbGx5IGRlZmluZWQgaGVyZQ0KICAgc3RydWN0IGlwaGRyDQogICAgICAgICAgXn5+fn4N
CiAgbWFrZVsxXTogKioqIFtNYWtlZmlsZTozODU6IGNvbXBpbGUtdGVzdC5vXSBFcnJvciAxDQoN
Ckxvb2tpbmcgYXQgdGhlIGxpbnV4IGNvbW1pdCBjb21taXQgMWZlOGUwZjA3NGM3DQooImluY2x1
ZGUvdWFwaS9saW51eC9pZl90dW5uZWwuaDogaW5jbHVkZSBsaW51eC9pZi5oLCBsaW51eC9pcC5o
IGFuZA0KbGludXgvaW42LmgiKSBJIGNhbiBzZWUgdGhhdCB0aGUgYXBwbGljYXRpb24gd2FzIHBy
b2JhYmx5IHdvcmtpbmcgYnkNCmx1Y2suDQoNCkRvaW5nIGEgYml0IG9mIHNlYXJjaGluZyBJIGNh
biBzZWUgdmFyaW91cyBmaXhlcyB3aXRoIHJlbW92aW5nIG9uZSBvZg0KdGhlIG9mZmVuZGluZyBo
ZWFkZXIgZmlsZXMgYnV0IHRoaXMgY2F1c2VzIG1vcmUgcHJvYmxlbXMgZm9yIHRoZQ0KYXBwbGlj
YXRpb24gaW4gcXVlc3Rpb24uDQoNCklzIHRoZXJlIGEgd2F5IG9mIG1ha2luZyBuZXRpbmV0L2lw
LmggYW5kIGxpbnV4L2lmX3R1bm5lbC5oIGNvLWV4aXN0Pw0KDQpUaGFua3MsDQpDaHJpcyBQYWNr
aGFtDQo=
