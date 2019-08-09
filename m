Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C95488078
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407173AbfHIQqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:46:47 -0400
Received: from de-out1.bosch-org.com ([139.15.230.186]:46164 "EHLO
        de-out1.bosch-org.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfHIQqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:46:47 -0400
Received: from si0vm1948.rbesz01.com (unknown [139.15.230.188])
        by si0vms0216.rbdmz01.com (Postfix) with ESMTPS id 464rjw4mg4z1XLG7M;
        Fri,  9 Aug 2019 18:46:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=escrypt.com;
        s=key1-intmail; t=1565369204;
        bh=VDAJlQTfIr+fUOEPOmcb1Pg28nSNC1xg7m+x39/WQTk=; l=10;
        h=From:Subject:From:Reply-To:Sender;
        b=jtT8E4o/z4YzCnw+cLodhgy+ZlpTroLDQHyRYqjkAnbO6nCB3bsWCvJJgDQwlooHN
         MnFs1H0qW5m5sh2Lnp0xo29slTisZBYhY0Fk4oaFfdd6GIqtH9MEzwpXaWPFmJLhRE
         TSt97eRvnjvuy0dBL5gPguCiT7car7MCIt1DMUdk=
Received: from fe0vm1740.rbesz01.com (unknown [10.58.172.176])
        by si0vm1948.rbesz01.com (Postfix) with ESMTPS id 464rjw30cfz1jY;
        Fri,  9 Aug 2019 18:46:44 +0200 (CEST)
X-AuditID: 0a3aad14-9afff700000020d8-7b-5d4da3743f84
Received: from si0vm1949.rbesz01.com ( [10.58.173.29])
        (using TLS with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by fe0vm1740.rbesz01.com (SMG Outbound) with SMTP id 4F.16.08408.473AD4D5; Fri,  9 Aug 2019 18:46:44 +0200 (CEST)
Received: from FE-MBX2039.de.bosch.com (fe-mbx2039.de.bosch.com [10.3.231.49])
        by si0vm1949.rbesz01.com (Postfix) with ESMTPS id 464rjw0nVdz6Cjw2w;
        Fri,  9 Aug 2019 18:46:44 +0200 (CEST)
Received: from FE-MBX2038.de.bosch.com (10.3.231.48) by
 FE-MBX2039.de.bosch.com (10.3.231.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 9 Aug 2019 18:46:43 +0200
Received: from FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2]) by
 FE-MBX2038.de.bosch.com ([fe80::12c:f84b:4fd6:38c2%2]) with mapi id
 15.01.1713.008; Fri, 9 Aug 2019 18:46:43 +0200
From:   "FIXED-TERM Buecheler Konstantin (ETAS-SEC/ECT-Mu)" 
        <fixed-term.Konstantin.Buecheler@escrypt.com>
To:     Dan Murphy <dmurphy@ti.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: AW: tcan4x5x on a Raspberry Pi
Thread-Topic: tcan4x5x on a Raspberry Pi
Thread-Index: AdVF/c5mwtK0bcvDSY+DXrUhyfKmYQAKdxcAAikoH5A=
Date:   Fri, 9 Aug 2019 16:46:43 +0000
Message-ID: <ee351bd74b764759bb0258af3651bd4a@escrypt.com>
References: <845ea24f71b74b42821c7fce20bc0476@escrypt.com>
 <d1badcdb-7635-705d-35d5-448297e8fafa@ti.com>
In-Reply-To: <d1badcdb-7635-705d-35d5-448297e8fafa@ti.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.23.200.63]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA22Tb0xTVxjGOfcWPFSuvb1Q+tqJkW4Bt0SkhWnnjNmSLSqbYXHZhy1rXBkX
        Wldadm8h4idoXHSwTJawwJiwqtWFIlCqAuuASeefAiGyARsZTNSJInFMIYtspmX3tsX2w77c
        vOd5z+99znlOLiaZz7EKmyw2lrMYzOoEqUS6oy1ti+30Pn32xUCSrmb4QrzO9fhLUnfVkfoK
        uefaZDexZ8mz8S3iPenOQtZsKme5rbs+kBpnhifWlN5WHhqtCZKVqE5ZjRIx0Lnwe0MbUY2k
        mKEbCGi6MikJL/oRjLW5IosHCC7/NREvIgzdh+A750tinUCb4IvztSE8hT6OoNZ+iRAbyXQm
        VLfMJYh1Cr0ZFtxTknC9AxbnB0mxltDPQcs390JDKUEf9o5FDA7Che+7Q3sSBf3Ew7shHdFp
        4HZfD+kkrQTP3cfx4TvQ4OwN60Ar4P4fwYi+CRZ+9Aq+WNj/PHR4t4bRdKirubUmbCuHwa/u
        SGpRamPM1MYo0RhDNMYQDiRxIUURm11eotmem53FFbD84WxN1ofWEg8Kv1FKD3riK/IhAiMf
        ehETagXldOzTM+sKrIUVRgNvPMCVmVleraIupun0TPJTmS8rKDHxvMlq8SHApDqFGscCRxUa
        Kg6znDWM+dAzWKJWUsU4/32GLjbY2I9YtpTlVrsvY6wGimsSQDnHFrOHikxm22pbnUahuLg4
        JjW2E2tL4EQfysFJgnfrSdGbLzWU8KbiCL4+jDOrahQdQvm49n7TKRIPXGkWvpebzpwiGYnF
        amFVSqpGnEWLlLHM8vQ0qg1UjjdPzyhiGtGJ82gSYaROpt5xv6lnkoQfIXoOoLrF6OQRMQpp
        nQJDn8PQbOfgSd80gvreIILe1uW14G93yWBy/poM5oJjMrjxyx0ZuBc7aDjmfEjD8oRDDq6v
        p+UwN2pXQOfQqBI6AnNKOFl1GsDff3YDNAQnNsLUjfp0WLG3pMNYVU86/FDvzYD2xakMOFc5
        kAVLA0MaqLv1iRY+7W3XwvLNLi10rpzJgZXxn7bB+T6PDoINXbp5IWNCyJhb2CtmbDPY/ifj
        iBq9nKoS7db89tou/+5O7yXH9U3c1WBZQiD31892amdn9z7yVL5+wBHoa5adjVs/OzSy7kjr
        NtLu73l2hPlZvjb/kZ8//saxvMA/m/9sftdu7jK/WjVz8Hbi/rePEn9XLAU+Hnkwnndvhiov
        utnfot6+v346bcu3BT0ZXnZQVf4vf+LI0cXMYGaeWsIbDZoXSI43/Ad7mG/6oQQAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEtvbnN0YW50aW4NCg0KPj4gT24gNy8yOS8xOSA2OjE5IEFNLCBGSVhFRC1URVJNIEJ1ZWNo
ZWxlciBLb25zdGFudGluIChFVEFTLVNFQy9FQ1QtTXUpIHdyb3RlOg0KPj4gSGkgYWxsLA0KPj4N
Cj4+IEkgYW0gY3VycmVudGx5IHdvcmtpbmcgb24gYSBwcm9qZWN0IHdoZXJlIEkgYW0gdHJ5aW5n
IHRvIHVzZSB0aGUgdGNhbjQ1NTAgY2hpcCB3aXRoIGEgUmFzcGJlcnJ5IFBJIDNCLg0KPj4gSSBh
bSBzdHJ1Z2dsaW5nIHRvIGNyZWF0ZSBhIHdvcmtpbmcgZGV2aWNlIHRyZWUgb3ZlcmxheSBmaWxl
IGZvciB0aGUgUmFzcGJlcnJ5IFBpLg0KPj4gSGFzIGFueW9uZSBoZXJlIHRyaWVkIHRoaXMgYWxy
ZWFkeT8gSSB3b3VsZCBhcHByZWNpYXRlIGFueSBoZWxwLg0KDQo+IEFyZSB5b3UgdXNpbmcgdGhl
IGRyaXZlciBmcm9tIG5ldC1uZXh0Pw0KDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldC1uZXh0LmdpdC90cmVlL2RyaXZlcnMvbmV0L2Nh
bi9tX2Nhbg0KDQpZZXMsIEkgYW0gdXNpbmcgdGhlIGRyaXZlciBmcm9tIG5ldC1uZXh0LiANCg0K
DQo+IERUIGRvY3VtZW50YXRpb24gaGVyZQ0KDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldC1uZXh0LmdpdC90cmVlL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2FuL3RjYW40eDV4LnR4dA0KDQpJIHNhdyB0aGlz
IGRvY3VtZW50YXRpb24gYnV0IGl0IGRpZG7igJl0IGhlbHAgbXVjaCAoQXMgSSBzYWlkLCBJIGRv
buKAmXQgaGF2ZSBtdWNoIGV4cGVyaWVuY2Ugd2l0aCBkZXZpY2UgdHJlZXMpIC4gTXkgZHRzIGZp
bGUgY3VycmVudGx5IGxvb2tzIGxpa2UgdGhpczogIA0KDQovZHRzLXYxLzsNCi9wbHVnaW4vOw0K
DQovIHsNCiAgICBjb21wYXRpYmxlID0gImJyY20sYmNtMjgzNSIsICJicmNtLGJjbTI4MzYiLCAi
YnJjbSxiY20yNzA4IiwgImJyY20sYmNtMjcwOSI7DQogICAgZnJhZ21lbnRAMCB7DQogICAgICAg
IHRhcmdldCA9IDwmc3BpMD47DQoJX19vdmVybGF5X18gew0KICAgICAgICAgICAgc3RhdHVzID0g
Im9rYXkiOw0KCSAgICBzcGlkZXZAMHsNCgkgICAgICAgIHN0YXR1cyA9ICJkaXNhYmxlZCI7DQoJ
ICAgIH07DQoJfTsNCiAgICB9Ow0KDQogICAgZnJhZ21lbnRAMiB7DQogICAgICAgIGNvbXBhdGli
bGUgPSAiYm9zY2gsIG1fY2FuIjsNCgl0YXJnZXQgPSA8JnNwaTA+Ow0KCV9fb3ZlcmxheV9fIHsN
CgkgICAgdGNhbjR4NXg6IHRjYW40eDV4QDAgew0KCSAgICAgICAgICAgICBjb21wYXRpYmxlID0g
InRpLHRjYW40eDV4IjsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgcmVnID0gPDA+Ow0KCQkj
YWRkcmVzcy1jZWxscyA9IDwxPjsNCiAgICAgICAgICAgICAgICAgICAgICAgICAjc2l6ZS1jZWxs
cyA9IDwxPjsNCgkJc3BpLW1heC1mcmVxdWVuY3kgPSA8MTAwMDAwMDA+Ow0KICAgICAgICAgICAg
ICAgICAgICAgICAgIGJvc2NoLG1yYW0tY2ZnID0gPDB4MCAwIDAgMzIgMCAwIDEgMT47DQoJCWRh
dGEtcmVhZHktZ3Bpb3MgPSA8JmdwaW8gMjMgMD47DQoJCWRldmljZS13YWtlLWdwaW9zID0gPCZn
cGlvIDI0IDE+Ow0KCQkJCQ0KCSAgICB9OwkJDQoJfTsNCiAgICB9Ow0KfTsNCg0KDQpDaGVja2lu
ZyBkbWVzZyBJIGFsd2F5cyBzZWUgdGhlc2UgZXJyb3JzOg0KWyAgICA1LjQwOTA1MV0gdGNhbjR4
NXggc3BpMC4wOiBubyBjbG9jayBmb3VuZA0KWyAgICA1LjQwOTA2NF0gdGNhbjR4NXggc3BpMC4w
OiBubyBDQU4gY2xvY2sgc291cmNlIGRlZmluZWQNClsgICAgNS40MDkxMjVdIHRjYW40eDV4IHNw
aTAuMDogZGF0YS1yZWFkeSBncGlvIG5vdCBkZWZpbmVkDQpbICAgIDUuNDA5MTM1XSB0Y2FuNHg1
eCBzcGkwLjA6IFByb2JlIGZhaWxlZCwgZXJyPS0yMg0KDQpJIGFscmVhZHkgZml4ZWQgdGhlIGNs
b2NrIGlzc3VlIG9uY2UgYnkgZG9pbmcgc29tZXRoaW5nIGxpa2UgdGhpczoNCmNsb2NrcyA9IDwm
Y2FuMF9vc2M+LA0KICAgICAgICAgICAgICA8JmNhbjBfb3NjPjsNCmNsb2NrLW5hbWVzID0gImhj
bGsiLCAiY2NsayI7DQpCdXQgdGhhdCBkaWRu4oCZdCBmaXggdGhlICIgZGF0YS1yZWFkeSBncGlv
IG5vdCBkZWZpbmVkIiBlcnJvci4NCg0KDQo+IEkgZGlkIHRoZSBkZXZlbG9wbWVudCBvbiBhIEJl
YWdsZUJvbmUgQmxhY2suDQoNCj4gRGFuDQoNCj4gVGhhbmtzLA0KPiBLb25zdGFudGluDQo+DQo=
