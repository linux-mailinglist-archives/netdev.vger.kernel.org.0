Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3976CA0D5
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjC0KHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbjC0KHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:07:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4405F19AC;
        Mon, 27 Mar 2023 03:07:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0235621D65;
        Mon, 27 Mar 2023 10:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679911622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=piK1k/jAbCBiod6LGEuGSrG43Cv8CyaxA7eqmfoo3xM=;
        b=gnGaO5MW4QE7wKfq4mNRqkGSxnWA085RIsioe/acG10dDi75ZrNr5PW3+6VfVL9w7U/cun
        DGAeXZbTsL+1KZnKW1r1g7GmjvnXx2E0PAC6RsTQULiDDO4dMjlcVG35KmvXxm3H+MA1p7
        9iEmYt0cPc48lQUJa7m8tZoGkdcnu1Q=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A499813482;
        Mon, 27 Mar 2023 10:07:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GVV0JMVqIWQTegAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 27 Mar 2023 10:07:01 +0000
Message-ID: <f519a2d3-6662-35a2-b295-1825924affa8@suse.com>
Date:   Mon, 27 Mar 2023 12:07:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
 <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
In-Reply-To: <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------V8vgFtPUgiGKsryGpJ0SBO00"
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------V8vgFtPUgiGKsryGpJ0SBO00
Content-Type: multipart/mixed; boundary="------------o00FFekE5CAmp1fvhhvOtTxs";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 xen-devel@lists.xenproject.org, stable@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <f519a2d3-6662-35a2-b295-1825924affa8@suse.com>
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
 <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
In-Reply-To: <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>

--------------o00FFekE5CAmp1fvhhvOtTxs
Content-Type: multipart/mixed; boundary="------------GUxOV17dACoS8RXLMrtU0tHw"

--------------GUxOV17dACoS8RXLMrtU0tHw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjcuMDMuMjMgMTE6NDksIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyNy4wMy4yMDIz
IDEwOjM2LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gRml4IHhlbnZpZl9nZXRfcmVxdWVz
dHMoKSBub3QgdG8gZG8gZ3JhbnQgY29weSBvcGVyYXRpb25zIGFjcm9zcyBsb2NhbA0KPj4g
cGFnZSBib3VuZGFyaWVzLiBUaGlzIHJlcXVpcmVzIHRvIGRvdWJsZSB0aGUgbWF4aW11bSBu
dW1iZXIgb2YgY29weQ0KPj4gb3BlcmF0aW9ucyBwZXIgcXVldWUsIGFzIGVhY2ggY29weSBj
b3VsZCBub3cgYmUgc3BsaXQgaW50byAyLg0KPj4NCj4+IE1ha2Ugc3VyZSB0aGF0IHN0cnVj
dCB4ZW52aWZfdHhfY2IgZG9lc24ndCBncm93IHRvbyBsYXJnZS4NCj4+DQo+PiBDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZw0KPj4gRml4ZXM6IGFkN2Y0MDJhZTRmNCAoInhlbi9uZXRi
YWNrOiBFbnN1cmUgcHJvdG9jb2wgaGVhZGVycyBkb24ndCBmYWxsIGluIHRoZSBub24tbGlu
ZWFyIGFyZWEiKQ0KPj4gU2lnbmVkLW9mZi1ieTogSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5o
ICB8ICAyICstDQo+PiAgIGRyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYyB8IDI1
ICsrKysrKysrKysrKysrKysrKysrKysrLS0NCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyNCBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC94ZW4tbmV0YmFjay9jb21tb24uaCBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNr
L2NvbW1vbi5oDQo+PiBpbmRleCAzZGJmYzhhNjkyNGUuLjFmY2JkODNmN2ZmMiAxMDA2NDQN
Cj4+IC0tLSBhL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5oDQo+PiArKysgYi9k
cml2ZXJzL25ldC94ZW4tbmV0YmFjay9jb21tb24uaA0KPj4gQEAgLTE2Niw3ICsxNjYsNyBA
QCBzdHJ1Y3QgeGVudmlmX3F1ZXVlIHsgLyogUGVyLXF1ZXVlIGRhdGEgZm9yIHhlbnZpZiAq
Lw0KPj4gICAJc3RydWN0IHBlbmRpbmdfdHhfaW5mbyBwZW5kaW5nX3R4X2luZm9bTUFYX1BF
TkRJTkdfUkVRU107DQo+PiAgIAlncmFudF9oYW5kbGVfdCBncmFudF90eF9oYW5kbGVbTUFY
X1BFTkRJTkdfUkVRU107DQo+PiAgIA0KPj4gLQlzdHJ1Y3QgZ250dGFiX2NvcHkgdHhfY29w
eV9vcHNbTUFYX1BFTkRJTkdfUkVRU107DQo+PiArCXN0cnVjdCBnbnR0YWJfY29weSB0eF9j
b3B5X29wc1syICogTUFYX1BFTkRJTkdfUkVRU107DQo+PiAgIAlzdHJ1Y3QgZ250dGFiX21h
cF9ncmFudF9yZWYgdHhfbWFwX29wc1tNQVhfUEVORElOR19SRVFTXTsNCj4+ICAgCXN0cnVj
dCBnbnR0YWJfdW5tYXBfZ3JhbnRfcmVmIHR4X3VubWFwX29wc1tNQVhfUEVORElOR19SRVFT
XTsNCj4+ICAgCS8qIHBhc3NlZCB0byBnbnR0YWJfW3VuXW1hcF9yZWZzIHdpdGggcGFnZXMg
dW5kZXIgKHVuKW1hcHBpbmcgKi8NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC94ZW4t
bmV0YmFjay9uZXRiYWNrLmMgYi9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9uZXRiYWNrLmMN
Cj4+IGluZGV4IDFiNDI2NzZjYTE0MS4uMTExYzE3OWYxNjFiIDEwMDY0NA0KPj4gLS0tIGEv
ZHJpdmVycy9uZXQveGVuLW5ldGJhY2svbmV0YmFjay5jDQo+PiArKysgYi9kcml2ZXJzL25l
dC94ZW4tbmV0YmFjay9uZXRiYWNrLmMNCj4+IEBAIC0zMzQsNiArMzM0LDcgQEAgc3RhdGlj
IGludCB4ZW52aWZfY291bnRfcmVxdWVzdHMoc3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUs
DQo+PiAgIHN0cnVjdCB4ZW52aWZfdHhfY2Igew0KPj4gICAJdTE2IGNvcHlfcGVuZGluZ19p
ZHhbWEVOX05FVEJLX0xFR0FDWV9TTE9UU19NQVggKyAxXTsNCj4+ICAgCXU4IGNvcHlfY291
bnQ7DQo+PiArCXUzMiBzcGxpdF9tYXNrOw0KPj4gICB9Ow0KPj4gICANCj4+ICAgI2RlZmlu
ZSBYRU5WSUZfVFhfQ0Ioc2tiKSAoKHN0cnVjdCB4ZW52aWZfdHhfY2IgKikoc2tiKS0+Y2Ip
DQo+PiBAQCAtMzYxLDYgKzM2Miw4IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IHNrX2J1ZmYg
KnhlbnZpZl9hbGxvY19za2IodW5zaWduZWQgaW50IHNpemUpDQo+PiAgIAlzdHJ1Y3Qgc2tf
YnVmZiAqc2tiID0NCj4+ICAgCQlhbGxvY19za2Ioc2l6ZSArIE5FVF9TS0JfUEFEICsgTkVU
X0lQX0FMSUdOLA0KPj4gICAJCQkgIEdGUF9BVE9NSUMgfCBfX0dGUF9OT1dBUk4pOw0KPj4g
Kw0KPj4gKwlCVUlMRF9CVUdfT04oc2l6ZW9mKCpYRU5WSUZfVFhfQ0Ioc2tiKSkgPiBzaXpl
b2Yoc2tiLT5jYikpOw0KPj4gICAJaWYgKHVubGlrZWx5KHNrYiA9PSBOVUxMKSkNCj4+ICAg
CQlyZXR1cm4gTlVMTDsNCj4+ICAgDQo+PiBAQCAtMzk2LDExICszOTksMTMgQEAgc3RhdGlj
IHZvaWQgeGVudmlmX2dldF9yZXF1ZXN0cyhzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSwN
Cj4+ICAgCW5yX3Nsb3RzID0gc2hpbmZvLT5ucl9mcmFncyArIDE7DQo+PiAgIA0KPj4gICAJ
Y29weV9jb3VudChza2IpID0gMDsNCj4+ICsJWEVOVklGX1RYX0NCKHNrYiktPnNwbGl0X21h
c2sgPSAwOw0KPj4gICANCj4+ICAgCS8qIENyZWF0ZSBjb3B5IG9wcyBmb3IgZXhhY3RseSBk
YXRhX2xlbiBieXRlcyBpbnRvIHRoZSBza2IgaGVhZC4gKi8NCj4+ICAgCV9fc2tiX3B1dChz
a2IsIGRhdGFfbGVuKTsNCj4+ICAgCXdoaWxlIChkYXRhX2xlbiA+IDApIHsNCj4+ICAgCQlp
bnQgYW1vdW50ID0gZGF0YV9sZW4gPiB0eHAtPnNpemUgPyB0eHAtPnNpemUgOiBkYXRhX2xl
bjsNCj4+ICsJCWJvb2wgc3BsaXQgPSBmYWxzZTsNCj4+ICAgDQo+PiAgIAkJY29wLT5zb3Vy
Y2UudS5yZWYgPSB0eHAtPmdyZWY7DQo+PiAgIAkJY29wLT5zb3VyY2UuZG9taWQgPSBxdWV1
ZS0+dmlmLT5kb21pZDsNCj4+IEBAIC00MTMsNiArNDE4LDEzIEBAIHN0YXRpYyB2b2lkIHhl
bnZpZl9nZXRfcmVxdWVzdHMoc3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUsDQo+PiAgIAkJ
Y29wLT5kZXN0LnUuZ21mbiA9IHZpcnRfdG9fZ2ZuKHNrYi0+ZGF0YSArIHNrYl9oZWFkbGVu
KHNrYikNCj4+ICAgCQkJCSAgICAgICAgICAgICAgIC0gZGF0YV9sZW4pOw0KPj4gICANCj4+
ICsJCS8qIERvbid0IGNyb3NzIGxvY2FsIHBhZ2UgYm91bmRhcnkhICovDQo+PiArCQlpZiAo
Y29wLT5kZXN0Lm9mZnNldCArIGFtb3VudCA+IFhFTl9QQUdFX1NJWkUpIHsNCj4+ICsJCQlh
bW91bnQgPSBYRU5fUEFHRV9TSVpFIC0gY29wLT5kZXN0Lm9mZnNldDsNCj4+ICsJCQlYRU5W
SUZfVFhfQ0Ioc2tiKS0+c3BsaXRfbWFzayB8PSAxVSA8PCBjb3B5X2NvdW50KHNrYik7DQo+
IA0KPiBNYXliZSB3b3J0aHdoaWxlIHRvIGFkZCBhIEJVSUxEX0JVR19PTigpIHNvbWV3aGVy
ZSB0byBtYWtlIHN1cmUgdGhpcw0KPiBzaGlmdCB3b24ndCBncm93IHRvbyBsYXJnZSBhIHNo
aWZ0IGNvdW50LiBUaGUgbnVtYmVyIG9mIHNsb3RzIGFjY2VwdGVkDQo+IGNvdWxkIGNvbmNl
aXZhYmx5IGJlIGdyb3duIHBhc3QgWEVOX05FVEJLX0xFR0FDWV9TTE9UU19NQVggKGkuZS4N
Cj4gWEVOX05FVElGX05SX1NMT1RTX01JTikgYXQgc29tZSBwb2ludC4NCg0KVGhpcyBpcyBi
YXNpY2FsbHkgaW1wb3NzaWJsZSBkdWUgdG8gdGhlIHNpemUgcmVzdHJpY3Rpb24gb2Ygc3Ry
dWN0DQp4ZW52aWZfdHhfY2IuDQoNCj4gDQo+PiArCQkJc3BsaXQgPSB0cnVlOw0KPj4gKwkJ
fQ0KPj4gKw0KPj4gICAJCWNvcC0+bGVuID0gYW1vdW50Ow0KPj4gICAJCWNvcC0+ZmxhZ3Mg
PSBHTlRDT1BZX3NvdXJjZV9ncmVmOw0KPj4gICANCj4+IEBAIC00MjAsNyArNDMyLDggQEAg
c3RhdGljIHZvaWQgeGVudmlmX2dldF9yZXF1ZXN0cyhzdHJ1Y3QgeGVudmlmX3F1ZXVlICpx
dWV1ZSwNCj4+ICAgCQlwZW5kaW5nX2lkeCA9IHF1ZXVlLT5wZW5kaW5nX3JpbmdbaW5kZXhd
Ow0KPj4gICAJCWNhbGxiYWNrX3BhcmFtKHF1ZXVlLCBwZW5kaW5nX2lkeCkuY3R4ID0gTlVM
TDsNCj4+ICAgCQljb3B5X3BlbmRpbmdfaWR4KHNrYiwgY29weV9jb3VudChza2IpKSA9IHBl
bmRpbmdfaWR4Ow0KPj4gLQkJY29weV9jb3VudChza2IpKys7DQo+PiArCQlpZiAoIXNwbGl0
KQ0KPj4gKwkJCWNvcHlfY291bnQoc2tiKSsrOw0KPj4gICANCj4+ICAgCQljb3ArKzsNCj4+
ICAgCQlkYXRhX2xlbiAtPSBhbW91bnQ7DQo+PiBAQCAtNDQxLDcgKzQ1NCw4IEBAIHN0YXRp
YyB2b2lkIHhlbnZpZl9nZXRfcmVxdWVzdHMoc3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUs
DQo+PiAgIAkJCW5yX3Nsb3RzLS07DQo+PiAgIAkJfSBlbHNlIHsNCj4+ICAgCQkJLyogVGhl
IGNvcHkgb3AgcGFydGlhbGx5IGNvdmVyZWQgdGhlIHR4X3JlcXVlc3QuDQo+PiAtCQkJICog
VGhlIHJlbWFpbmRlciB3aWxsIGJlIG1hcHBlZC4NCj4+ICsJCQkgKiBUaGUgcmVtYWluZGVy
IHdpbGwgYmUgbWFwcGVkIG9yIGNvcGllZCBpbiB0aGUgbmV4dA0KPj4gKwkJCSAqIGl0ZXJh
dGlvbi4NCj4+ICAgCQkJICovDQo+PiAgIAkJCXR4cC0+b2Zmc2V0ICs9IGFtb3VudDsNCj4+
ICAgCQkJdHhwLT5zaXplIC09IGFtb3VudDsNCj4+IEBAIC01MzksNiArNTUzLDEzIEBAIHN0
YXRpYyBpbnQgeGVudmlmX3R4X2NoZWNrX2dvcChzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1
ZSwNCj4+ICAgCQlwZW5kaW5nX2lkeCA9IGNvcHlfcGVuZGluZ19pZHgoc2tiLCBpKTsNCj4+
ICAgDQo+PiAgIAkJbmV3ZXJyID0gKCpnb3BwX2NvcHkpLT5zdGF0dXM7DQo+PiArDQo+PiAr
CQkvKiBTcGxpdCBjb3BpZXMgbmVlZCB0byBiZSBoYW5kbGVkIHRvZ2V0aGVyLiAqLw0KPj4g
KwkJaWYgKFhFTlZJRl9UWF9DQihza2IpLT5zcGxpdF9tYXNrICYgKDFVIDw8IGkpKSB7DQo+
PiArCQkJKCpnb3BwX2NvcHkpKys7DQo+PiArCQkJaWYgKCFuZXdlcnIpDQo+PiArCQkJCW5l
d2VyciA9ICgqZ29wcF9jb3B5KS0+c3RhdHVzOw0KPj4gKwkJfQ0KPiANCj4gSXQgaXNuJ3Qg
Z3VhcmFudGVlZCB0aGF0IGEgc2xvdCBtYXkgYmUgc3BsaXQgb25seSBvbmNlLCBpcyBpdD8g
QXNzdW1pbmcgYQ0KDQpJIHRoaW5rIGl0IGlzIGd1YXJhbnRlZWQuDQoNCk5vIHNsb3QgY2Fu
IGNvdmVyIG1vcmUgdGhhbiBYRU5fUEFHRV9TSVpFIGJ5dGVzIGR1ZSB0byB0aGUgZ3JhbnRz
IGJlaW5nDQpyZXN0cmljdGVkIHRvIHRoYXQgc2l6ZS4gVGhlcmUgaXMgbm8gd2F5IGhvdyBz
dWNoIGEgZGF0YSBwYWNrZXQgY291bGQgY3Jvc3MNCjIgcGFnZSBib3VuZGFyaWVzLg0KDQpJ
biB0aGUgZW5kIHRoZSBwcm9ibGVtIGlzbid0IHRoZSBjb3BpZXMgZm9yIHRoZSBsaW5lYXIg
YXJlYSBub3QgY3Jvc3NpbmcNCm11bHRpcGxlIHBhZ2UgYm91bmRhcmllcywgYnV0IHRoZSBj
b3BpZXMgZm9yIGEgc2luZ2xlIHJlcXVlc3Qgc2xvdCBub3QNCmRvaW5nIHNvLiBBbmQgdGhp
cyBjYW4ndCBoYXBwZW4gSU1PLg0KDQo+IG5lYXItNjRrIHBhY2tldCB3aXRoIGFsbCB0aW55
IG5vbi1wcmltYXJ5IHNsb3RzLCB0aGF0J2xsIGNhdXNlIHRob3NlIHRpbnkNCj4gc2xvdHMg
dG8gYWxsIGJlIG1hcHBlZCwgYnV0IGR1ZSB0bw0KPiANCj4gCQlpZiAocmV0ID49IFhFTl9O
RVRCS19MRUdBQ1lfU0xPVFNfTUFYIC0gMSAmJiBkYXRhX2xlbiA8IHR4cmVxLnNpemUpDQo+
IAkJCWRhdGFfbGVuID0gdHhyZXEuc2l6ZTsNCj4gDQo+IHdpbGwsIGFmYWljdCwgY2F1c2Ug
YSBsb3Qgb2YgY29weWluZyBmb3IgdGhlIHByaW1hcnkgc2xvdC4gVGhlcmVmb3JlIEkNCj4g
dGhpbmsgeW91IG5lZWQgYSBsb29wIGhlcmUsIG5vdCBqdXN0IGFuIGlmKCkuIFBsdXMgdHhf
Y29weV9vcHNbXSdlcw0KPiBkaW1lbnNpb24gYWxzbyBsb29rcyB0byBuZWVkIGZ1cnRoZXIg
Z3Jvd2luZyB0byBhY2NvbW1vZGF0ZSB0aGlzLiBPcg0KPiBtYXliZSBub3QgLSBhdCBsZWFz
dCB0aGUgZXh0cmVtZSBleGFtcGxlIGdpdmVuIHdvdWxkIHN0aWxsIGJlIGZpbmU7IG1vcmUN
Cj4gZ2VuZXJhbGx5IHBhY2tldHMgYmVpbmcgbGltaXRlZCB0byBiZWxvdyA2NGsgbWVhbnMg
MioxNiBzbG90cyB3b3VsZA0KPiBzdWZmaWNlIGF0IG9uZSBlbmQgb2YgdGhlIHNjYWxlLCB3
aGlsZSAyKk1BWF9QRU5ESU5HX1JFUVMgd291bGQgYXQgdGhlDQo+IG90aGVyIGVuZCAoYWxs
IHRpbnksIGluY2x1ZGluZyB0aGUgcHJpbWFyeSBzbG90KS4gV2hhdCBJIGhhdmVuJ3QgZnVs
bHkNCj4gY29udmluY2VkIG15c2VsZiBvZiBpcyB3aGV0aGVyIHRoZXJlIG1pZ2h0IGJlIGNh
c2VzIGluIHRoZSBtaWRkbGUgd2hpY2gNCj4gYXJlIHlldCB3b3JzZS4NCg0KU2VlIGFib3Zl
IHJlYXNvbmluZy4gSSB0aGluayBpdCBpcyBva2F5LCBidXQgbWF5YmUgSSdtIG1pc3Npbmcg
c29tZXRoaW5nLg0KDQoNCkp1ZXJnZW4NCg0K
--------------GUxOV17dACoS8RXLMrtU0tHw
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------GUxOV17dACoS8RXLMrtU0tHw--

--------------o00FFekE5CAmp1fvhhvOtTxs--

--------------V8vgFtPUgiGKsryGpJ0SBO00
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmQhasUFAwAAAAAACgkQsN6d1ii/Ey99
xQf/f3JuJ797H2HtIX7674GCN0MEsAljPo5o4H1KN7Wb/g6oxoKd8BZDxVP9eXfTOYU4vq2+l5D/
ei2POupEzkGw0NkbLeJhId30X8CzSkwEJWfOSbAO8BaS9Qpl9vJen656/9c+o7aqxMNtMqtKoT8K
CoUVfh3Jb6lSdLcRgrsZx1ohhEG9Qcik4MHCCl4o2Jt6OMfaWA5wlhkgLrK6/MtVJIv8++ghkdMQ
p9j6q8ecPtzYdgc3u9Bw7eb3ZMEuCPe7E6VZLFZYDkRzZMkg6oFkPsOewXOL0wywwv4+xygxwYBT
etuV7tRfPj0KIVJyW0dd/jNMsE5SVyuruvVazCC/Sw==
=qeZG
-----END PGP SIGNATURE-----

--------------V8vgFtPUgiGKsryGpJ0SBO00--
