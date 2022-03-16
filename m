Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD64DAEF9
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 12:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355377AbiCPLiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 07:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiCPLiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 07:38:25 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074E846179;
        Wed, 16 Mar 2022 04:37:09 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 592315FD04;
        Wed, 16 Mar 2022 14:37:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647430628;
        bh=41t35rlQaRnVr9L7q8rZvzPoDx37Vjwb21Z/xTvhcbg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=HwTUznHQ24WGx+uzWZjHS5elHH/UZoamUyozlYlQxhelSEhi7/mzhU+jI+xdnwB6q
         e9pG1Mg11FYjor5vaLTPmzWF0EX8MkPqiqfi7ofHbj28tsiDvoAD+tapn6+DxnlZKL
         Qpt2INc7IsLsIMy1CwdfWYC2cKdn5YjgxqWsAIk/xf6CsSB1NhROfOJMJPZrUxyJcL
         78EIcusJ+SbevReeP20OMIkc9ATusGtgale/FID9047ZaHXagk13ElrG2FelkgsGAA
         ClrzYaX1VNsL4dkR9JOoygYFkjoKgtC+I7yD9ws3/BAeSaE9lScSM8bbu0Q644+vbA
         W39yndGmNf8nQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 16 Mar 2022 14:37:08 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] af_vsock: add two new tests for SOCK_SEQPACKET
Thread-Topic: [RFC PATCH v2 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Index: AQHYOQbyso2e/I/ekky/gZ0IvB2spqzBg8cAgAAsLAA=
Date:   Wed, 16 Mar 2022 11:36:08 +0000
Message-ID: <a567ea34-82bd-841e-2a80-71340a9b1e49@sberdevices.ru>
References: <1474b149-7d4c-27b2-7e5c-ef00a718db76@sberdevices.ru>
 <20220316085854.estmt5xafafsmp73@sgarzare-redhat>
In-Reply-To: <20220316085854.estmt5xafafsmp73@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D939B6EA93B3040A20032BF454CDD8D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/16 06:31:00 #18980784
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDMuMjAyMiAxMTo1OCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBXZWQs
IE1hciAxNiwgMjAyMiBhdCAwNzoyNTowN0FNICswMDAwLCBLcmFzbm92IEFyc2VuaXkgVmxhZGlt
aXJvdmljaCB3cm90ZToNCj4+IFRoaXMgYWRkcyB0d28gdGVzdHM6IGZvciByZWNlaXZlIHRpbWVv
dXQgYW5kIHJlYWRpbmcgdG8gaW52YWxpZA0KPj4gYnVmZmVyIHByb3ZpZGVkIGJ5IHVzZXIuIEkg
Zm9yZ290IHRvIHB1dCBib3RoIHBhdGNoZXMgdG8gbWFpbg0KPj4gcGF0Y2hzZXQuDQo+Pg0KPj4g
QXJzZW5peSBLcmFzbm92KDIpOg0KPj4NCj4+IGFmX3Zzb2NrOiBTT0NLX1NFUVBBQ0tFVCByZWNl
aXZlIHRpbWVvdXQgdGVzdA0KPj4gYWZfdnNvY2s6IFNPQ0tfU0VRUEFDS0VUIGJyb2tlbiBidWZm
ZXIgdGVzdA0KPj4NCj4+IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgMjExICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4gMSBmaWxlIGNoYW5nZWQs
IDIxMSBpbnNlcnRpb25zKCspDQo+IA0KPiBJIHRoaW5rIHRoZXJlIGFyZSBvbmx5IHNtYWxsIHRo
aW5ncyB0byBmaXgsIHNvIG5leHQgc2VyaWVzIHlvdSBjYW4gcmVtb3ZlIFJGQyAocmVtZW1iZXIg
dG8gdXNlIG5ldC1uZXh0KS4NCj4gDQo+IEkgYWRkZWQgdGhlIHRlc3RzIHRvIG15IHN1aXRlIGFu
ZCBldmVyeXRoaW5nIGlzIHJ1bm5pbmcgY29ycmVjdGx5Lg0KPiANCj4gSSBhbHNvIHN1Z2dlc3Qg
eW91IHRvIHNvbHZlIHRoZXNlIGxpdHRsZSBpc3N1ZXMgdGhhdCBjaGVja3BhdGNoIGhhcyBoaWdo
bGlnaHRlZCB0byBoYXZlIHBhdGNoZXMgcmVhZHkgZm9yIHN1Ym1pc3Npb24gOi0pDQo+IA0KPiBU
aGFua3MsDQo+IFN0ZWZhbm8NCj4gDQo+ICQgLi9zY3JpcHRzL2NoZWNrcGF0Y2gucGwgLS1zdHJp
Y3QgLWfCoCBtYXN0ZXIuLkhFQUQNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IENvbW1pdCAyYTFiZmI5M2I1
MWQgKCJhZl92c29jazogU09DS19TRVFQQUNLRVQgcmVjZWl2ZSB0aW1lb3V0IHRlc3QiKQ0KPiAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gQ0hFQ0s6IFVubmVjZXNzYXJ5IHBhcmVudGhlc2VzIGFyb3VuZCAnZXJy
bm8gIT0gRUFHQUlOJw0KPiAjNzA6IEZJTEU6IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVz
dC5jOjQzNDoNCj4gK8KgwqDCoCBpZiAoKHJlYWQoZmQsICZkdW1teSwgc2l6ZW9mKGR1bW15KSkg
IT0gLTEpIHx8DQo+ICvCoMKgwqDCoMKgwqAgKGVycm5vICE9IEVBR0FJTikpIHsNCj4gDQo+IFdB
Uk5JTkc6IEZyb206L1NpZ25lZC1vZmYtYnk6IGVtYWlsIG5hbWUgbWlzbWF0Y2g6ICdGcm9tOiBL
cmFzbm92IEFyc2VuaXkgVmxhZGltaXJvdmljaCA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Picg
IT0gJ1NpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2Vz
LnJ1PicNCj4gDQo+IHRvdGFsOiAwIGVycm9ycywgMSB3YXJuaW5ncywgMSBjaGVja3MsIDk3IGxp
bmVzIGNoZWNrZWQNCj4gDQo+IE5PVEU6IEZvciBzb21lIG9mIHRoZSByZXBvcnRlZCBkZWZlY3Rz
LCBjaGVja3BhdGNoIG1heSBiZSBhYmxlIHRvDQo+IMKgwqDCoMKgwqAgbWVjaGFuaWNhbGx5IGNv
bnZlcnQgdG8gdGhlIHR5cGljYWwgc3R5bGUgdXNpbmcgLS1maXggb3IgLS1maXgtaW5wbGFjZS4N
Cj4gDQo+IENvbW1pdCAyYTFiZmI5M2I1MWQgKCJhZl92c29jazogU09DS19TRVFQQUNLRVQgcmVj
ZWl2ZSB0aW1lb3V0IHRlc3QiKSBoYXMgc3R5bGUgcHJvYmxlbXMsIHBsZWFzZSByZXZpZXcuDQo+
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0NCj4gQ29tbWl0IDkxNzZiY2FiY2RkNyAoImFmX3Zzb2NrOiBTT0NLX1NFUVBB
Q0tFVCBicm9rZW4gYnVmZmVyIHRlc3QiKQ0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IENIRUNLOiBDb21wYXJp
c29uIHRvIE5VTEwgY291bGQgYmUgd3JpdHRlbiAiIWJ1ZjEiDQo+ICM1MTogRklMRTogdG9vbHMv
dGVzdGluZy92c29jay92c29ja190ZXN0LmM6NDg2Og0KPiArwqDCoMKgIGlmIChidWYxID09IE5V
TEwpIHsNCj4gDQo+IENIRUNLOiBDb21wYXJpc29uIHRvIE5VTEwgY291bGQgYmUgd3JpdHRlbiAi
IWJ1ZjIiDQo+ICM1NzogRklMRTogdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmM6NDky
Og0KPiArwqDCoMKgIGlmIChidWYyID09IE5VTEwpIHsNCj4gDQo+IENIRUNLOiBQbGVhc2UgZG9u
J3QgdXNlIG11bHRpcGxlIGJsYW5rIGxpbmVzDQo+ICMxNTI6IEZJTEU6IHRvb2xzL3Rlc3Rpbmcv
dnNvY2svdnNvY2tfdGVzdC5jOjU4NzoNCj4gKw0KPiArDQo+IA0KPiBXQVJOSU5HOiBGcm9tOi9T
aWduZWQtb2ZmLWJ5OiBlbWFpbCBuYW1lIG1pc21hdGNoOiAnRnJvbTogS3Jhc25vdiBBcnNlbml5
IFZsYWRpbWlyb3ZpY2ggPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4nICE9ICdTaWduZWQtb2Zm
LWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2aWNlcy5ydT4nDQo+IA0KPiB0
b3RhbDogMCBlcnJvcnMsIDEgd2FybmluZ3MsIDMgY2hlY2tzLCAxNTAgbGluZXMgY2hlY2tlZA0K
PiANCj4gTk9URTogRm9yIHNvbWUgb2YgdGhlIHJlcG9ydGVkIGRlZmVjdHMsIGNoZWNrcGF0Y2gg
bWF5IGJlIGFibGUgdG8NCj4gwqDCoMKgwqDCoCBtZWNoYW5pY2FsbHkgY29udmVydCB0byB0aGUg
dHlwaWNhbCBzdHlsZSB1c2luZyAtLWZpeCBvciAtLWZpeC1pbnBsYWNlLg0KPiANCj4gQ29tbWl0
IDkxNzZiY2FiY2RkNyAoImFmX3Zzb2NrOiBTT0NLX1NFUVBBQ0tFVCBicm9rZW4gYnVmZmVyIHRl
c3QiKSBoYXMgc3R5bGUgcHJvYmxlbXMsIHBsZWFzZSByZXZpZXcuDQo+IA0KPiBOT1RFOiBJZiBh
bnkgb2YgdGhlIGVycm9ycyBhcmUgZmFsc2UgcG9zaXRpdmVzLCBwbGVhc2UgcmVwb3J0DQo+IMKg
wqDCoMKgwqAgdGhlbSB0byB0aGUgbWFpbnRhaW5lciwgc2VlIENIRUNLUEFUQ0ggaW4gTUFJTlRB
SU5FUlMuDQpBY2sNCj4gDQo+IA0KPiANCj4gDQoNCg==
