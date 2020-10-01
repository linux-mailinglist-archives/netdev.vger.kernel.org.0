Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0415527F6DB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgJAApR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbgJAApQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 20:45:16 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29589C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 17:45:16 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 3330D891B0;
        Thu,  1 Oct 2020 13:45:11 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1601513111;
        bh=iZ8HPVnj/moYn/uJv53VsTW+fU1qq6Fk6V1w/adwaWE=;
        h=From:To:CC:Subject:Date;
        b=t4VmVVUVHw2jO9bqQCA4lmf01qpp/N1GJqGGYWCRcxkIOqxz4V6ApfJul+9wVXjwr
         jMx4M3HlzJ0QXNGxqckcQQb/gFffZ8re6tidLIizxHihARXs+h2MpQLtp6OjRZir+f
         ixUnltw7ykGRQaa5J+YdwOHR0T/Yt44uD/pqvyS46uztzc3lL68iiupcbGJJ1ahAS0
         S3LHqG4cP76/sPM0YDtsLHwHxrykZThB6C6SIaYCp0+OflrAaEtl2j91GEkF/mTAIN
         7QecnSq117Z+G9UcwKPctZQKbu5O+Ah44tgmXowLau7x+R3lDom23TA86dhfYmN5+W
         VRFYyhjE7Ckng==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f7526980001>; Thu, 01 Oct 2020 13:45:12 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 1 Oct 2020 13:45:10 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 1 Oct 2020 13:45:10 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: dsa: mv88e6xxx: serdes link without phy
Thread-Topic: mv88e6xxx: serdes link without phy
Thread-Index: AQHWl4wd1x9X1OqsB0SXADYVDL5/gA==
Date:   Thu, 1 Oct 2020 00:45:10 +0000
Message-ID: <72e8e25a-db0d-275f-e80e-0b74bf112832@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA29561A31041F41A7D05F9FC397E302@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCldlIGhhdmUgYSBjaGFzc2lzIHBsYXRmb3JtIHRoYXQgKGFiKXVzZXMgYW4gRXRoZXJu
ZXQgYmFja3BsYW5lIA0KY29uc2lzdGluZyBvZiBNVjg4RTYwOTcgb24gdGhlIGxpbmUgY2FyZHMg
Y29ubmVjdGluZyB0byBhIE1WOThEWDE2MCBvbiANCnRoZSBjaGFzc2lzIGNvbnRyb2xsZXIocyku
DQoNCkknbSBhdHRlbXB0aW5nIHRvIHVwZGF0ZSB0aGUgbGluZSBjYXJkcyB0byBhIG1vZGVybiBr
ZXJuZWwgdHJ5aW5nIHRvIGRvIA0KYXdheSB3aXRoIGEgbG90IG9mIGN1c3RvbSBoYWNrZXJ5IGZy
b20gb3VyIG9sZGVyIGtlcm5lbC4gT25lIHByb2JsZW0gSSdtIA0KaGF2aW5nIGlzIHRoYXQgSSBj
YW4ndCBmaW5kIGEgd2F5IG9mIHRlbGxpbmcgdGhlIERTQS9NVjg4RTYwOTcgZHJpdmVyIA0KYWJv
dXQgdGhlIHBvcnRzIGZhY2luZyB0aGUgYmFja3BsYW5lLg0KDQpDdXJyZW50bHkgSSBoYXZlIHRo
ZSBmb2xsb3dpbmcgaW4gbXkgZHRzDQoNCiDCoMKgwqDCoMKgwqDCoCBzd2l0Y2hAMCB7DQogwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbXBhdGlibGUgPSAibWFydmVsbCxtdjg4ZTYw
ODUiOw0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAjYWRkcmVzcy1jZWxscyA9wqAg
PDE+Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAjc2l6ZS1jZWxscyA9IDwwPjsN
CiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZHNhLG1lbWJlciA9IDwwIDA+Ow0KDQog
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZyA9IDwweDE+Ow0KDQogwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBvcnRzIHsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICNhZGRyZXNzLWNlbGxzID3CoCA8MT47DQogwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAjc2l6ZS1jZWxscyA9IDwwPjsN
Cg0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcG9ydEA4
IHsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZWcgPSA8OD47DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGFiZWwgPSAiaW50ZXJuYWw4IjsNCiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBwaHktbW9kZSA9ICJyZ21paS1pZCI7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZml4ZWQtbGluayB7DQogwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNwZWVkID0gPDEwMDA+Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmdWxs
LWR1cGxleDsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB9Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgfTsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHBvcnRAOSB7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVnID0gPDk+Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxhYmVsID0gImludGVy
bmFsOSI7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcGh5LW1vZGUgPSAicmdtaWktaWQiOw0KIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZpeGVkLWxpbmsg
ew0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzcGVlZCA9IDwxMDAwPjsNCiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZnVsbC1kdXBsZXg7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfTsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH07DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBwb3J0QDEwIHsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWcgPSA8MTA+Ow0KIMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGxhYmVsID0gImNwdSI7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXRoZXJuZXQgPSA8JmV0aDBwb3J0PjsNCiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBw
aHktbW9kZSA9ICJyZ21paS1pZCI7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZml4ZWQtbGluayB7DQogwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHNwZWVkID0gPDEwMDA+Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmdWxsLWR1
cGxleDsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB9Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfTsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfTsNCiDCoMKgwqDC
oMKgwqDCoCB9Ow0KDQpUaGUgcHJvYmxlbSBpcyB0aGF0IGJ5IGRlY2xhcmluZyBwb3J0cyA4ICYg
OSBhcyBmaXhlZCBsaW5rIHRoZSBkcml2ZXIgDQpzZXRzIHRoZSBGb3JjZWRMaW5rIGluIHRoZSBQ
Q1MgY29udHJvbCByZWdpc3Rlci4gV2hpY2ggbW9zdGx5IHdvcmtzLiANCkV4Y2VwdCBpZiBJIGFk
ZCBhIGNoYXNzaXMgY29udHJvbGxlciB3aGlsZSB0aGUgc3lzdGVtIGlzIHJ1bm5pbmcgKG9yIG9u
ZSANCmlzIHJlYm9vdGVkKSB0aGVuIHRoZSBuZXdseSBhZGRlZCBjb250cm9sbGVyIGRvZXNuJ3Qg
c2VlIGEgbGluayBvbiB0aGUgDQpzZXJkZXMuIElmIEkgaGFjayB0aGUgY29kZSB0byBjbGVhciB0
aGUgRm9yY2VkTGluayBiaXQgdGhlbiB0aGUgDQpjb250cm9sbGVyIHdpbGwgY29ycmVjdGx5IHNl
ZSB0aGUgbGluayBzdGF0ZS4NCg0KSSB0aGluayBJIG5lZWQgYSB3YXkgb2YgdGVsbGluZyB0aGUg
ZHJpdmVyIHRoYXQgaXQgaXMgZGlyZWN0bHkgd2lyZWQgDQooaS5lLiB0aGVyZSBpcyBubyBQSFkp
IGJ1dCB0aGF0IGl0IHNob3VsZCBub3QgZm9yY2UgdGhlIGxpbmsgc3RhdGUuIEknbSANCm5vdCBz
dXJlIHRoYXQgZml4ZWQtbGluayBpcyBuZWNlc3NhcmlseSB0aGUgcmlnaHQgdG9vbCBmb3IgdGhl
IGpvYiBidXQgDQp3aXRob3V0IGl0IHRoZSBkcml2ZXIgY29tcGxhaW5zIGFib3V0IGhhdmluZyBu
byBQSFkgb24gcG9ydHMgOCBhbmQgOS4NCg0KQW55IHRob3VnaHRzIG9uIGhvdyBJIGNhbiBjb252
ZXkgbXkgaGFyZHdhcmUgc2V0dXAgdG8gdGhlIGRyaXZlcj8NCg0KVGhhbmtzLA0KQ2hyaXMNCg==
