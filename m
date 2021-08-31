Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9918E3FC0B5
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 04:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhHaCKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 22:10:37 -0400
Received: from mx20.baidu.com ([111.202.115.85]:47524 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239377AbhHaCKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 22:10:36 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id 57EB0D74965CC2F0E12B;
        Tue, 31 Aug 2021 10:09:37 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 31 Aug 2021 10:09:37 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Tue, 31 Aug 2021 10:09:37 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSB2aXJ0aW9fbmV0OiByZWR1Y2UgcmF3X3NtcF9wcm9j?=
 =?gb2312?B?ZXNzb3JfaWQoKSBjYWxsaW5nIGluIHZpcnRuZXRfeGRwX2dldF9zcQ==?=
Thread-Topic: [PATCH] virtio_net: reduce raw_smp_processor_id() calling in
 virtnet_xdp_get_sq
Thread-Index: AQHXneNzpWGI4yCMH0iM4E17NXpkuauM3hmA
Date:   Tue, 31 Aug 2021 02:09:36 +0000
Message-ID: <bbf978c3252b4f2ea13ab7ca07d53034@baidu.com>
References: <1629966095-16341-1-git-send-email-lirongqing@baidu.com>
 <20210830170837-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210830170837-mutt-send-email-mst@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.194.62]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLdPKvP7Urbz+LS0tLS0NCj4gt6K8/sjLOiBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEBy
ZWRoYXQuY29tPg0KPiC3osvNyrG85DogMjAyMcTqONTCMzHI1SA1OjEwDQo+IMrVvP7IyzogTGks
Um9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiCzrcvNOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBicGZAdmdlci5rZXJuZWwub3JnOw0KPiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51
eC1mb3VuZGF0aW9uLm9yZw0KPiDW98ziOiBSZTogW1BBVENIXSB2aXJ0aW9fbmV0OiByZWR1Y2Ug
cmF3X3NtcF9wcm9jZXNzb3JfaWQoKSBjYWxsaW5nIGluDQo+IHZpcnRuZXRfeGRwX2dldF9zcQ0K
PiANCj4gT24gVGh1LCBBdWcgMjYsIDIwMjEgYXQgMDQ6MjE6MzVQTSArMDgwMCwgTGkgUm9uZ1Fp
bmcgd3JvdGU6DQo+ID4gc21wX3Byb2Nlc3Nvcl9pZCgpL3Jhdyogd2lsbCBiZSBjYWxsZWQgb25j
ZSBlYWNoIHdoZW4gbm90IG1vcmUgcXVldWVzDQo+ID4gaW4gdmlydG5ldF94ZHBfZ2V0X3NxKCkg
d2hpY2ggaXMgY2FsbGVkIGluIG5vbi1wcmVlbXB0aWJsZSBjb250ZXh0LCBzbw0KPiA+IGl0J3Mg
c2FmZSB0byBjYWxsIHRoZSBmdW5jdGlvbg0KPiA+IHNtcF9wcm9jZXNzb3JfaWQoKSBvbmNlLg0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
Pg0KPiANCj4gY29tbWl0IGxvZyBzaG91bGQgcHJvYmFibHkgZXhwbGFpbiB3aHkgaXQncyBhIGdv
b2QgaWRlYSB0byByZXBsYWNlDQo+IHJhd19zbXBfcHJvY2Vzc29yX2lkIHdpdGggc21wX3Byb2Nl
c3Nvcl9pZCBpbiB0aGUgY2FzZSBvZiBjdXJyX3F1ZXVlX3BhaXJzDQo+IDw9IG5yX2NwdV9pZHMu
DQo+IA0KDQoNCkkgY2hhbmdlIGl0IGFzIGJlbG93LCBpcyBpdCBvaz8NCg0KICAgIHZpcnRpb19u
ZXQ6IHJlZHVjZSByYXdfc21wX3Byb2Nlc3Nvcl9pZCgpIGNhbGxpbmcgaW4gdmlydG5ldF94ZHBf
Z2V0X3NxDQoNCiAgICBzbXBfcHJvY2Vzc29yX2lkKCkgYW5kIHJhd19zbXBfcHJvY2Vzc29yX2lk
KCkgYXJlIGNhbGxlZCBvbmNlDQogICAgZWFjaCBpbiB2aXJ0bmV0X3hkcF9nZXRfc3EoKSwgd2hl
biBjdXJyX3F1ZXVlX3BhaXJzIDw9IG5yX2NwdV9pZHMsDQogICAgc2hvdWxkIGJlIG1lcmdlZA0K
DQogICAgdmlydG5ldF94ZHBfZ2V0X3NxKCkgaXMgY2FsbGVkIGluIG5vbi1wcmVlbXB0aWJsZSBj
b250ZXh0LCBzbw0KICAgIGl0J3Mgc2FmZSB0byBjYWxsIHRoZSBmdW5jdGlvbiBzbXBfcHJvY2Vz
c29yX2lkKCksIGFuZCBrZWVwDQogICAgc21wX3Byb2Nlc3Nvcl9pZCgpLCBhbmQgcmVtb3ZlIHRo
ZSBjYWxsaW5nIG9mIHJhd19zbXBfcHJvY2Vzc29yX2lkKCksDQogICAgYXZvaWQgdGhlIHdyb25n
IHVzZSB2aXJ0bmV0X3hkcF9nZXRfc3EgdG8gcHJlZW1wdGlibGUgY29udGV4dA0KICAgIGluIHRo
ZSBmdXR1cmUNCg0KLUxpDQo=
