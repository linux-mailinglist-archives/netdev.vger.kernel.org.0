Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB23A17CC7F
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgCGGg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:36:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCGGg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:36:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40F66155292A1;
        Fri,  6 Mar 2020 22:36:26 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:36:25 -0800 (PST)
Message-Id: <20200306.223625.760484008125865765.davem@davemloft.net>
To:     jwiesner@suse.com
Cc:     netdev@vger.kernel.org, maheshb@google.com,
        Andreas.Taschner@suse.com, mkubecek@suse.cz
Subject: Re: [PATCH net] ipvlan: do not add hardware address of master to
 its unicast filter list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305193101.GA16264@incl>
References: <20200305193101.GA16264@incl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:36:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlyaSBXaWVzbmVyIDxqd2llc25lckBzdXNlLmNvbT4NCkRhdGU6IFRodSwgNSBNYXIg
MjAyMCAyMDozMTowMSArMDEwMA0KDQo+IFRoZXJlIGlzIGEgcHJvYmxlbSB3aGVuIGlwdmxhbiBz
bGF2ZXMgYXJlIGNyZWF0ZWQgb24gYSBtYXN0ZXIgZGV2aWNlIHRoYXQNCj4gaXMgYSB2bXhuZXQz
IGRldmljZSAoaXB2bGFuIGluIFZNd2FyZSBndWVzdHMpLiBUaGUgdm14bmV0MyBkcml2ZXIgZG9l
cyBub3QNCj4gc3VwcG9ydCB1bmljYXN0IGFkZHJlc3MgZmlsdGVyaW5nLiBXaGVuIGFuIGlwdmxh
biBkZXZpY2UgaXMgYnJvdWdodCB1cCBpbg0KPiBpcHZsYW5fb3BlbigpLCB0aGUgaXB2bGFuIGRy
aXZlciBjYWxscyBkZXZfdWNfYWRkKCkgdG8gYWRkIHRoZSBoYXJkd2FyZQ0KPiBhZGRyZXNzIG9m
IHRoZSB2bXhuZXQzIG1hc3RlciBkZXZpY2UgdG8gdGhlIHVuaWNhc3QgYWRkcmVzcyBsaXN0IG9m
IHRoZQ0KPiBtYXN0ZXIgZGV2aWNlLCBwaHlfZGV2LT51Yy4gVGhpcyBpbmV2aXRhYmx5IGxlYWRz
IHRvIHRoZSB2bXhuZXQzIG1hc3Rlcg0KPiBkZXZpY2UgYmVpbmcgZm9yY2VkIGludG8gcHJvbWlz
Y3VvdXMgbW9kZSBieSBfX2Rldl9zZXRfcnhfbW9kZSgpLg0KPiANCj4gUHJvbWlzY3VvdXMgbW9k
ZSBpcyBzd2l0Y2hlZCBvbiB0aGUgbWFzdGVyIGRlc3BpdGUgdGhlIGZhY3QgdGhhdCB0aGVyZSBp
cw0KPiBzdGlsbCBvbmx5IG9uZSBoYXJkd2FyZSBhZGRyZXNzIHRoYXQgdGhlIG1hc3RlciBkZXZp
Y2Ugc2hvdWxkIHVzZSBmb3INCj4gZmlsdGVyaW5nIGluIG9yZGVyIGZvciB0aGUgaXB2bGFuIGRl
dmljZSB0byBiZSBhYmxlIHRvIHJlY2VpdmUgcGFja2V0cy4NCj4gVGhlIGNvbW1lbnQgYWJvdmUg
c3RydWN0IG5ldF9kZXZpY2UgZGVzY3JpYmVzIHRoZSB1Y19wcm9taXNjIG1lbWJlciBhcyBhDQo+
ICJjb3VudGVyLCB0aGF0IGluZGljYXRlcywgdGhhdCBwcm9taXNjdW91cyBtb2RlIGhhcyBiZWVu
IGVuYWJsZWQgZHVlIHRvDQo+IHRoZSBuZWVkIHRvIGxpc3RlbiB0byBhZGRpdGlvbmFsIHVuaWNh
c3QgYWRkcmVzc2VzIGluIGEgZGV2aWNlIHRoYXQgZG9lcw0KPiBub3QgaW1wbGVtZW50IG5kb19z
ZXRfcnhfbW9kZSgpIi4gTW9yZW92ZXIsIHRoZSBkZXNpZ24gb2YgaXB2bGFuDQo+IGd1YXJhbnRl
ZXMgdGhhdCBvbmx5IHRoZSBoYXJkd2FyZSBhZGRyZXNzIG9mIGEgbWFzdGVyIGRldmljZSwNCj4g
cGh5X2Rldi0+ZGV2X2FkZHIsIHdpbGwgYmUgdXNlZCB0byB0cmFuc21pdCBhbmQgcmVjZWl2ZSBh
bGwgcGFja2V0cyBmcm9tDQo+IGl0cyBpcHZsYW4gc2xhdmVzLiBUaHVzLCB0aGUgdW5pY2FzdCBh
ZGRyZXNzIGxpc3Qgb2YgdGhlIG1hc3RlciBkZXZpY2UNCj4gc2hvdWxkIG5vdCBiZSBtb2RpZmll
ZCBieSBpcHZsYW5fb3BlbigpIGFuZCBpcHZsYW5fc3RvcCgpIGluIG9yZGVyIHRvIG1ha2UNCj4g
aXB2bGFuIGEgd29ya2FibGUgb3B0aW9uIG9uIG1hc3RlcnMgdGhhdCBkbyBub3Qgc3VwcG9ydCB1
bmljYXN0IGFkZHJlc3MNCj4gZmlsdGVyaW5nLg0KPiANCj4gRml4ZXM6IDJhZDdiZjM2Mzg0MTEg
KCJpcHZsYW46IEluaXRpYWwgY2hlY2staW4gb2YgdGhlIElQVkxBTiBkcml2ZXIiKQ0KPiBSZXBv
cnRlZC1ieTogUGVyIFN1bmRzdHJvbSA8cGVyLnN1bmRzdHJvbUByZWRxdWJlLnNlPg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBKaXJpIFdpZXNuZXIgPGp3aWVzbmVyQHN1c2UuY29tPg0KDQpQbGVhc2UgZml4
IHRoaXMgd2FybmluZyBhbmQgcmVzdWJtaXQsIHRoYW5rIHlvdToNCg0KICBDQyBbTV0gIGRyaXZl
cnMvbmV0L2lwdmxhbi9pcHZsYW5fbWFpbi5vDQpkcml2ZXJzL25ldC9pcHZsYW4vaXB2bGFuX21h
aW4uYzogSW4gZnVuY3Rpb24goWlwdmxhbl9vcGVuojoNCmRyaXZlcnMvbmV0L2lwdmxhbi9pcHZs
YW5fbWFpbi5jOjE2NzoyMTogd2FybmluZzogdW51c2VkIHZhcmlhYmxlIKFwaHlfZGV2oiBbLVd1
bnVzZWQtdmFyaWFibGVdDQogIDE2NyB8ICBzdHJ1Y3QgbmV0X2RldmljZSAqcGh5X2RldiA9IGlw
dmxhbi0+cGh5X2RldjsNCiAgICAgIHwgICAgICAgICAgICAgICAgICAgICBefn5+fn5+DQo=
