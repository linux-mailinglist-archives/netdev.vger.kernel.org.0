Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF11C07E9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgD3U2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3U2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:28:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F96BC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:28:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95EB8128AE846;
        Thu, 30 Apr 2020 13:28:20 -0700 (PDT)
Date:   Thu, 30 Apr 2020 13:28:19 -0700 (PDT)
Message-Id: <20200430.132819.1445821468387589728.davem@davemloft.net>
To:     julietk@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        tlfalcon@linux.vnet.ibm.com
Subject: Re: [PATCH net] ibmvnic: Skip fatal error reset after passive init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430182211.24211-1-julietk@linux.vnet.ibm.com>
References: <20200430182211.24211-1-julietk@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 13:28:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSnVsaWV0IEtpbSA8anVsaWV0a0BsaW51eC52bmV0LmlibS5jb20+DQpEYXRlOiBUaHUs
IDMwIEFwciAyMDIwIDEzOjIyOjExIC0wNTAwDQoNCj4gRHVyaW5nIE1UVSBjaGFuZ2UsIHRoZSBm
b2xsb3dpbmcgZXZlbnRzIG1heSBoYXBwZW4uDQo+IENsaWVudC1kcml2ZW4gQ1JRIGluaXRpYWxp
emF0aW9uIGZhaWxzIGR1ZSB0byBwYXJ0bmVyonMgQ1JRIGNsb3NlZCwNCj4gY2F1c2luZyBjbGll
bnQgdG8gZW5xdWV1ZSBhIHJlc2V0IHRhc2sgZm9yIEZBVEFMX0VSUk9SLiBUaGVuIHBhc3NpdmUN
Cj4gKHNlcnZlci1kcml2ZW4pIENSUSBpbml0aWFsaXphdGlvbiBzdWNjZWVkcywgY2F1c2luZyBj
bGllbnQgdG8NCj4gcmVsZWFzZSBDUlEgYW5kIGVucXVldWUgYSByZXNldCB0YXNrIGZvciBmYWls
b3Zlci4gSWYgdGhlIHBhc3NpdmUNCj4gQ1JRIGluaXRpYWxpemF0aW9uIG9jY3VycyBiZWZvcmUg
dGhlIEZBVEFMIHJlc2V0IHRhc2sgaXMgcHJvY2Vzc2VkLA0KPiB0aGUgRkFUQUwgZXJyb3IgcmVz
ZXQgdGFzayB3b3VsZCB0cnkgdG8gYWNjZXNzIGEgQ1JRIG1lc3NhZ2UgcXVldWUNCj4gdGhhdCB3
YXMgZnJlZWQsIGNhdXNpbmcgYW4gb29wcy4gVGhlIHByb2JsZW0gbWF5IGJlIG1vc3QgbGlrZWx5
IHRvDQo+IG9jY3VyIGR1cmluZyBETFBBUiBhZGQgdk5JQyB3aXRoIGEgbm9uLWRlZmF1bHQgTVRV
LCBiZWNhdXNlIHRoZSBETFBBUg0KPiBwcm9jZXNzIHdpbGwgYXV0b21hdGljYWxseSBpc3N1ZSBh
IGNoYW5nZSBNVFUgcmVxdWVzdC4NCj4gDQo+IEZpeCB0aGlzIGJ5IG5vdCBwcm9jZXNzaW5nIGZh
dGFsIGVycm9yIHJlc2V0IGlmIENSUSBpcyBwYXNzaXZlbHkNCj4gaW5pdGlhbGl6ZWQgYWZ0ZXIg
Y2xpZW50LWRyaXZlbiBDUlEgaW5pdGlhbGl6YXRpb24gZmFpbHMuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBKdWxpZXQgS2ltIDxqdWxpZXRrQGxpbnV4LnZuZXQuaWJtLmNvbT4NCg0KQXBwbGllZCwg
dGhhbmtzLg0K
