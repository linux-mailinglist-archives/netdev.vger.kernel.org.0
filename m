Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538204B7133
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241060AbiBOP7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:59:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiBOP7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:59:13 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF78BD2FA;
        Tue, 15 Feb 2022 07:59:02 -0800 (PST)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jym2l4Dzjz67y81;
        Tue, 15 Feb 2022 23:58:07 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 16:58:59 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Tue, 15 Feb 2022 16:58:59 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Shuah Khan <skhan@linuxfoundation.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/6] ima: Fix documentation-related warnings in
 ima_main.c
Thread-Topic: [PATCH v2 1/6] ima: Fix documentation-related warnings in
 ima_main.c
Thread-Index: AQHYImlgLEbYFhksa0WFiw7rM/aqE6yUsLSAgAATzSA=
Date:   Tue, 15 Feb 2022 15:58:59 +0000
Message-ID: <34975820d40c4c839ea16e0f3debcd48@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <20220215124042.186506-2-roberto.sassu@huawei.com>
 <759a70de-a06b-592c-de4a-f7c74fbe4619@linuxfoundation.org>
In-Reply-To: <759a70de-a06b-592c-de4a-f7c74fbe4619@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBTaHVhaCBLaGFuIFttYWlsdG86c2toYW5AbGludXhmb3VuZGF0aW9uLm9yZ10NCj4g
U2VudDogVHVlc2RheSwgRmVicnVhcnkgMTUsIDIwMjIgNDo0NiBQTQ0KPiBPbiAyLzE1LzIyIDU6
NDAgQU0sIFJvYmVydG8gU2Fzc3Ugd3JvdGU6DQo+ID4gRml4IHNvbWUgd2FybmluZ3MgaW4gaW1h
X21haW4uYywgZGlzcGxheWVkIHdpdGggVz1uIG1ha2UgYXJndW1lbnQuDQo+ID4NCj4gDQo+IFRo
YW5rIHlvdSBmb3IgZml4aW5nIHRoZXNlLiBEb2MgYnVpbGRzIGFyZSBmdWxsIG9mIHRoZW0gYW5k
IGZldyBsZXNzDQo+IGlzIHdlbGNvbWUuDQo+IA0KPiBBZGRpbmcgdGhlIHdhcm5zIG9yIHN1bW1h
cnkgb2YgdGhlbSB0byBjaGFuZ2UgbG9nIHdpbGwgYmUgZ29vZC4NCg0KSGkgU2h1YWgNCg0Kb2ss
IEkgd2lsbCBhZGQgYSBicmllZiBkZXNjcmlwdGlvbiBvZiB3aGF0IEkgZml4ZWQgaW4gdGhlIG5l
eHQgdmVyc2lvbg0Kb2YgdGhlIHBhdGNoIHNldC4NCg0KVGhhbmtzDQoNClJvYmVydG8NCg0KSFVB
V0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMNCk1hbmFnaW5nIERp
cmVjdG9yOiBMaSBQZW5nLCBaaG9uZyBSb25naHVhDQoNCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2Jl
cnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gICBzZWN1
cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9tYWluLmMgfCAxMSArKysrKystLS0tLQ0KPiA+ICAgMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9tYWluLmMNCj4gYi9zZWN1cml0
eS9pbnRlZ3JpdHkvaW1hL2ltYV9tYWluLmMNCj4gPiBpbmRleCA4YzZlNDUxNGQ0OTQuLjk0NmJh
OGExMmVhYiAxMDA2NDQNCj4gPiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9tYWlu
LmMNCj4gPiArKysgYi9zZWN1cml0eS9pbnRlZ3JpdHkvaW1hL2ltYV9tYWluLmMNCj4gPiBAQCAt
NDE4LDYgKzQxOCw3IEBAIGludCBpbWFfZmlsZV9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCB1bnNp
Z25lZCBsb25nIHByb3QpDQo+ID4NCj4gPiAgIC8qKg0KPiA+ICAgICogaW1hX2ZpbGVfbXByb3Rl
Y3QgLSBiYXNlZCBvbiBwb2xpY3ksIGxpbWl0IG1wcm90ZWN0IGNoYW5nZQ0KPiA+ICsgKiBAdm1h
OiB2bV9hcmVhX3N0cnVjdCBwcm90ZWN0aW9uIGlzIHNldCB0bw0KPiA+ICAgICogQHByb3Q6IGNv
bnRhaW5zIHRoZSBwcm90ZWN0aW9uIHRoYXQgd2lsbCBiZSBhcHBsaWVkIGJ5IHRoZSBrZXJuZWwu
DQo+ID4gICAgKg0KPiANCj4gDQo+IFJldmlld2VkLWJ5OiBTaHVhaCBLaGFuIDxza2hhbkBsaW51
eGZvdW5kYXRpb24ub3JnPg0KPiANCj4gdGhhbmtzLA0KPiAtLSBTaHVhaA0K
