Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF60D211613
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgGAWdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgGAWdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:33:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041EFC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 15:33:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C3EF149C9E2B;
        Wed,  1 Jul 2020 15:33:22 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:33:21 -0700 (PDT)
Message-Id: <20200701.153321.436005855074448230.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     kuba@kernel.org, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 12/15] sfc_ef100: add EF100 to NIC-revision
 enumeration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <44dabf26-0d49-c577-5991-20d76fb4ccb6@solarflare.com>
References: <20200701121131.56e456c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200701.124422.999920966272100417.davem@davemloft.net>
        <44dabf26-0d49-c577-5991-20d76fb4ccb6@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:33:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWR3YXJkIENyZWUgPGVjcmVlQHNvbGFyZmxhcmUuY29tPg0KRGF0ZTogV2VkLCAxIEp1
bCAyMDIwIDIzOjIzOjQwICswMTAwDQoNCj4gT24gMDEvMDcvMjAyMCAyMDo0NCwgRGF2aWQgTWls
bGVyIHdyb3RlOg0KPj4gT3IgaXMgdGhpcyBjb2RlIHVzZWQgYXMgYSBsaWJyYXJ5IGJ5IHR3byAi
ZHJpdmVycyI/DQo+IFllcywgaXQgaXM7IHRoZXJlIHdpbGwgYmUgYSBzZWNvbmQgbW9kdWxlICdz
ZmNfZWYxMDAua28nd2hpY2ggdGhpcw0KPiDCoGZpbGUgd2lsbCBiZSBsaW5rZWQgaW50byBhbmQg
d2hpY2ggd2lsbCBzZXQgZWZ4LT50eXBlIHRvIG9uZSB3aXRoDQo+IMKgYW4gRUYxMDAgcmV2aXNp
b24uDQo+IA0KPiBBbHRob3VnaCB0YmggSSBoYXZlIGJlZW4gd29uZGVyaW5nIGFib3V0IGFub3Ro
ZXIgYXBwcm9hY2ggdG8NCj4gwqBldGh0b29sX2dldF9kcnZpbmZvOiB3ZSBjb3VsZCBoYXZlIGEg
Y29uc3QgY2hhciBbXSBpbiBlYWNoIGRyaXZlcidzDQo+IMKgbm9uLWNvbW1vbiBwYXJ0cywgaG9s
ZGluZyBLQlVJTERfTU9ETkFNRSwgd2hpY2ggZXRodG9vbF9jb21tb24uYw0KPiDCoGNvdWxkIGp1
c3QgcmVmZXJlbmNlLCByYXRoZXIgdGhhbiBsb29raW5nIGF0IGVmeC0+dHlwZS0+cmV2aXNpb24N
Cj4gwqBhbmQgcmVseWluZyBvbiB0aGUgcmVzdCBvZiB0aGUgZHJpdmVyIHRvIHNldCBpdCB1cCBy
aWdodC4NCj4gU2luY2UgaXQgbG9va3MgbGlrZSBJJ2xsIG5lZWQgdG8gcmVzcGluIHRoaXMgc2Vy
aWVzIGFueXdheSwgSSdsbCB0cnkNCj4gwqB0aGF0IGFuZCBzZWUgaWYgaXQgd29ya3Mg4oCUIGl0
IHNlZW1zIGNsZWFuZXIgdG8gbWUuDQoNCkl0IHNlZW1zIGNsZWFuZXIgdG8gbWUgdG9vLg0K
