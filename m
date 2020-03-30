Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453241973AE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgC3FKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:10:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgC3FKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:10:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D1DF15C66A9E;
        Sun, 29 Mar 2020 22:10:40 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:10:39 -0700 (PDT)
Message-Id: <20200329.221039.801988103648289657.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, tanhuazhong@huawei.com
Subject: Re: [PATCH net-next] mlx4: fix "initializer element not constant"
 compiler error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327210835.2576135-1-jacob.e.keller@intel.com>
References: <20200327210835.2576135-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:10:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQpEYXRlOiBGcmks
IDI3IE1hciAyMDIwIDE0OjA4OjM1IC0wNzAwDQoNCj4gQSByZWNlbnQgY29tbWl0IGU4OTM3Njgx
Nzk3YyAoImRldmxpbms6IHByZXBhcmUgdG8gc3VwcG9ydCByZWdpb24NCj4gb3BlcmF0aW9ucyIp
IHVzZWQgdGhlIHJlZ2lvbl9jcl9zcGFjZV9zdHIgYW5kIHJlZ2lvbl9md19oZWFsdGhfc3RyDQo+
IHZhcmlhYmxlcyBhcyBpbml0aWFsaXplcnMgZm9yIHRoZSBkZXZsaW5rX3JlZ2lvbl9vcHMgc3Ry
dWN0dXJlcy4NCj4gDQo+IFRoaXMgY2FuIHJlc3VsdCBpbiBjb21waWxlciBlcnJvcnM6DQo+IGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94Ly9tbHg0L2NyZHVtcC5jOjQ1OjEwOiBlcnJvcjog
aW5pdGlhbGl6ZXINCj4gZWxlbWVudCBpcyBub3QgY29uc3RhbnQNCj4gICAgLm5hbWUgPSByZWdp
b25fY3Jfc3BhY2Vfc3RyLA0KPiAgICAgICAgICAgIF4NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvL21seDQvY3JkdW1wLmM6NDU6MTA6IG5vdGU6IChuZWFyDQo+IGluaXRpYWxpemF0
aW9uIGZvciChcmVnaW9uX2NyX3NwYWNlX29wcy5uYW1loikNCj4gZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvL21seDQvY3JkdW1wLmM6NTA6MTA6IGVycm9yOiBpbml0aWFsaXplcg0KPiBl
bGVtZW50IGlzIG5vdCBjb25zdGFudA0KPiAgICAubmFtZSA9IHJlZ2lvbl9md19oZWFsdGhfc3Ry
LA0KPiANCj4gVGhlIHZhcmlhYmxlcyB3ZXJlIG1hZGUgdG8gYmUgImNvbnN0IGNoYXIgKiBjb25z
dCIsIGluZGljYXRpbmcgdGhhdCBib3RoDQo+IHRoZSBwb2ludGVyIGFuZCBkYXRhIHdlcmUgY29u
c3RhbnQuIFRoaXMgd2FzIGVub3VnaCB0byByZXNvbHZlIHRoaXMgb24NCj4gcmVjZW50IEdDQyAo
Z2NjIChHQ0MpIDkuMi4xIDIwMTkwODI3IChSZWQgSGF0IDkuMi4xLTEpIGZvciB0aGlzIGF1dGhv
cikuDQo+IA0KPiBVbmZvcnR1bmF0ZWx5IHRoaXMgaXMgbm90IGVub3VnaCBmb3Igb2xkZXIgY29t
cGlsZXJzIHRvIHJlYWxpemUgdGhhdCB0aGUNCj4gdmFyaWFibGUgY2FuIGJlIHRyZWF0ZWQgYXMg
YSBjb25zdGFudCBleHByZXNzaW9uLg0KPiANCj4gRml4IHRoaXMgYnkgaW50cm9kdWNpbmcgbWFj
cm9zIGZvciB0aGUgc3RyaW5nIGFuZCB1c2UgdGhvc2UgaW5zdGVhZCBvZg0KPiB0aGUgdmFyaWFi
bGUgbmFtZSBpbiB0aGUgcmVnaW9uIG9wcyBzdHJ1Y3R1cmVzLg0KPiANCj4gUmVwb3J0ZWQtYnk6
IHRhbmh1YXpob25nIDx0YW5odWF6aG9uZ0BodWF3ZWkuY29tPg0KPiBGaXhlczogZTg5Mzc2ODE3
OTdjICgiZGV2bGluazogcHJlcGFyZSB0byBzdXBwb3J0IHJlZ2lvbiBvcGVyYXRpb25zIikNCj4g
U2lnbmVkLW9mZi1ieTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQoN
CkFwcGxpZWQuDQo=
