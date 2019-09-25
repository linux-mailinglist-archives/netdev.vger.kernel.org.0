Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96323BDD4E
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404917AbfIYLmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:42:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404639AbfIYLmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:42:02 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3227F154EC893;
        Wed, 25 Sep 2019 04:42:01 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:41:59 +0200 (CEST)
Message-Id: <20190925.134159.1914660952439794832.davem@davemloft.net>
To:     julietk@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, tlfalcon@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 0/2] net/ibmvnic: serialization fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
References: <20190920201123.18913-1-julietk@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:42:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSnVsaWV0IEtpbSA8anVsaWV0a0BsaW51eC52bmV0LmlibS5jb20+DQpEYXRlOiBGcmks
IDIwIFNlcCAyMDE5IDE2OjExOjIxIC0wNDAwDQoNCj4gVGhpcyBzZXJpZXMgaW5jbHVkZXMgdHdv
IGZpeGVzLiBUaGUgZmlyc3QgaW1wcm92ZXMgcmVzZXQgY29kZSB0byBhbGxvdyANCj4gbGlua3dh
dGNoX2V2ZW50IHRvIHByb2NlZWQgZHVyaW5nIHJlc2V0LiBUaGUgc2Vjb25kIGVuc3VyZXMgdGhh
dCBubyBtb3JlDQo+IHRoYW4gb25lIHRocmVhZCBydW5zIGluIHJlc2V0IGF0IGEgdGltZS4gDQo+
IA0KPiB2MjoNCj4gLSBTZXBhcmF0ZSBjaGFuZ2UgcGFyYW0gcmVzZXQgZnJvbSBkb19yZXNldCgp
DQo+IC0gUmV0dXJuIElCTVZOSUNfT1BFTl9GQUlMRUQgaWYgX19pYm12bmljX29wZW4gZmFpbHMN
Cj4gLSBSZW1vdmUgc2V0dGluZyB3YWl0X2Zvcl9yZXNldCB0byBmYWxzZSBmcm9tIF9faWJtdm5p
Y19yZXNldCgpLCB0aGlzDQo+ICAgaXMgZG9uZSBpbiB3YWl0X2Zvcl9yZXNldCgpDQo+IC0gTW92
ZSB0aGUgY2hlY2sgZm9yIGZvcmNlX3Jlc2V0X3JlY292ZXJ5IGZyb20gcGF0Y2ggMSB0byBwYXRj
aCAyDQo+IA0KPiB2MzoNCj4gLSBSZXN0b3JlIHJlc2V0onMgc3VjY2Vzc2Z1bCByZXR1cm4gaW4g
b3BlbiBmYWlsdXJlIGNhc2UNCj4gDQo+IHY0Og0KPiAtIENoYW5nZSByZXNldHRpbmcgZmxhZyBh
Y2Nlc3MgdG8gYXRvbWljDQoNClNlcmllcyBhcHBsaWVkLCB0aGFuayB5b3UuDQo=
