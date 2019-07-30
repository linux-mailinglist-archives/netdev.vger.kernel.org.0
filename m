Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEF17AE6F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfG3Qxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:53:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfG3Qxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:53:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 700DE1264E7CA;
        Tue, 30 Jul 2019 09:53:45 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:53:44 -0700 (PDT)
Message-Id: <20190730.095344.401137621326119500.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     andrew@lunn.ch, robh+dt@kernel.org, leoyang.li@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/4] enetc: Add mdio bus driver for the
 PCIe MDIO endpoint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730.094436.855806617449032791.davem@davemloft.net>
References: <1564479919-18835-1-git-send-email-claudiu.manoil@nxp.com>
        <20190730.094436.855806617449032791.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 09:53:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAzMCBK
dWwgMjAxOSAwOTo0NDozNiAtMDcwMCAoUERUKQ0KDQo+IEZyb206IENsYXVkaXUgTWFub2lsIDxj
bGF1ZGl1Lm1hbm9pbEBueHAuY29tPg0KPiBEYXRlOiBUdWUsIDMwIEp1bCAyMDE5IDEyOjQ1OjE1
ICswMzAwDQo+IA0KPj4gRmlyc3QgcGF0Y2ggZml4ZXMgYSBzcGFyc2UgaXNzdWUgYW5kIGNsZWFu
cyB1cCBhY2Nlc3NvcnMgdG8gYXZvaWQNCj4+IGNhc3RpbmcgdG8gX19pb21lbS4NCj4+IFNlY29u
ZCBwYXRjaCBqdXN0IHJlZ2lzdGVycyB0aGUgUENJZSBlbmRwb2ludCBkZXZpY2UgY29udGFpbmlu
Zw0KPj4gdGhlIE1ESU8gcmVnaXN0ZXJzIGFzIGEgc3RhbmRhbG9uZSBNRElPIGJ1cyBkcml2ZXIs
IHRvIGFsbG93DQo+PiBhbiBhbHRlcm5hdGl2ZSB3YXkgdG8gY29udHJvbCB0aGUgTURJTyBidXMu
ICBUaGUgc2FtZSBjb2RlIHVzZWQNCj4+IGJ5IHRoZSBFTkVUQyBwb3J0cyAoZXRoIGNvbnRyb2xs
ZXJzKSB0byBtYW5hZ2UgTURJTyB2aWEgbG9jYWwNCj4+IHJlZ2lzdGVycyBhcHBsaWVzIGFuZCBp
cyByZXVzZWQuDQo+PiANCj4+IEJpbmRpbmdzIGFyZSBwcm92aWRlZCBmb3IgdGhlIG5ldyBNRElP
IG5vZGUsIHNpbWlsYXJseSB0byBFTkVUQw0KPj4gcG9ydCBub2RlcyBiaW5kaW5ncy4NCj4+IA0K
Pj4gTGFzdCBwYXRjaCBlbmFibGVzIHRoZSBFTkVUQyBwb3J0IDEgYW5kIGl0cyBSR01JSSBQSFkg
b24gdGhlDQo+PiBMUzEwMjhBIFFEUyBib2FyZCwgd2hlcmUgdGhlIE1ESU8gbXV4aW5nIGNvbmZp
Z3VyYXRpb24gcmVsaWVzDQo+PiBvbiB0aGUgTURJTyBzdXBwb3J0IHByb3ZpZGVkIGluIHRoZSBm
aXJzdCBwYXRjaC4NCj4gIC4uLg0KPiANCj4gU2VyaWVzIGFwcGxpZWQsIHRoYW5rIHlvdS4NCg0K
QWN0dWFsbHkgdGhpcyBkb2Vzbid0IGNvbXBpbGUsIEkgaGFkIHRvIHJldmVydDoNCg0KSW4gZmls
ZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVkZS9saW51eC9waHkuaDoyMCwNCiAgICAgICAgICAgICAg
ICAgZnJvbSAuL2luY2x1ZGUvbGludXgvb2ZfbWRpby5oOjExLA0KICAgICAgICAgICAgICAgICBm
cm9tIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19tZGlvLmM6NToN
CmRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19tZGlvLmM6Mjg0OjI2
OiBlcnJvcjogoWVuZXRjX21kaW9faWRfdGFibGWiIHVuZGVjbGFyZWQgaGVyZSAobm90IGluIGEg
ZnVuY3Rpb24pOyBkaWQgeW91IG1lYW4goWVuZXRjX3BjaV9tZGlvX2lkX3RhYmxloj8NCiBNT0RV
TEVfREVWSUNFX1RBQkxFKHBjaSwgZW5ldGNfbWRpb19pZF90YWJsZSk7DQogICAgICAgICAgICAg
ICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn4NCi4vaW5jbHVkZS9saW51eC9tb2R1bGUu
aDoyMzA6MTU6IG5vdGU6IGluIGRlZmluaXRpb24gb2YgbWFjcm8goU1PRFVMRV9ERVZJQ0VfVEFC
TEWiDQogZXh0ZXJuIHR5cGVvZihuYW1lKSBfX21vZF8jI3R5cGUjI19fIyNuYW1lIyNfZGV2aWNl
X3RhYmxlICBcDQogICAgICAgICAgICAgICBefn5+DQouL2luY2x1ZGUvbGludXgvbW9kdWxlLmg6
MjMwOjIxOiBlcnJvcjogoV9fbW9kX3BjaV9fZW5ldGNfbWRpb19pZF90YWJsZV9kZXZpY2VfdGFi
bGWiIGFsaWFzZWQgdG8gdW5kZWZpbmVkIHN5bWJvbCChZW5ldGNfbWRpb19pZF90YWJsZaINCiBl
eHRlcm4gdHlwZW9mKG5hbWUpIF9fbW9kXyMjdHlwZSMjX18jI25hbWUjI19kZXZpY2VfdGFibGUg
IFwNCiAgICAgICAgICAgICAgICAgICAgIF5+fn5+fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJl
ZXNjYWxlL2VuZXRjL2VuZXRjX21kaW8uYzoyODQ6MTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1h
Y3JvIKFNT0RVTEVfREVWSUNFX1RBQkxFog0KIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBlbmV0
Y19tZGlvX2lkX3RhYmxlKTsNCiBefn5+fn5+fn5+fn5+fn5+fn5+DQo=
