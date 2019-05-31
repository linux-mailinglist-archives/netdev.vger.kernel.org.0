Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39C13144F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfEaR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:57:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfEaR5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:57:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E47514FC6F63;
        Fri, 31 May 2019 10:57:24 -0700 (PDT)
Date:   Fri, 31 May 2019 10:57:21 -0700 (PDT)
Message-Id: <20190531.105721.740773292135946256.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, robh+dt@kernel.org,
        willemb@google.com
Subject: Re: [PATCH V4 net-next 0/6] Peer to Peer One-Step time stamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531055132.7qrjuqgtw6qw4mgh@localhost>
References: <20190530.115507.1344606945620280103.davem@davemloft.net>
        <20190530.125833.1049383711116106790.davem@davemloft.net>
        <20190531055132.7qrjuqgtw6qw4mgh@localhost>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 10:57:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmljaGFyZCBDb2NocmFuIDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+DQpEYXRlOiBU
aHUsIDMwIE1heSAyMDE5IDIyOjUxOjMyIC0wNzAwDQoNCj4gQW55aG93LCBJIHJlYmFzZWQgdjUg
b2YgbXkgc2VyaWVzIHRvIGxhdGVzdCBuZXQtbmV4dCwgYW5kIEknbSBnZXR0aW5nDQo+IGEgbG90
IG9mIHRoZXNlOg0KPiANCj4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIG5ldC9pcHY2L2FmX2luZXQ2
LmM6NDU6MDoNCj4gLi9pbmNsdWRlL2xpbnV4L25ldGZpbHRlcl9pcHY2Lmg6IEluIGZ1bmN0aW9u
IKFuZl9pcHY2X2JyX2RlZnJhZ6I6DQo+IC4vaW5jbHVkZS9saW51eC9uZXRmaWx0ZXJfaXB2Ni5o
OjExMDo5OiBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24goW5mX2N0X2Zy
YWc2X2dhdGhlcqI7IGRpZCB5b3UgbWVhbiChbmZfY3RfYXR0YWNooj8gWy1XZXJyb3I9aW1wbGlj
aXQtZnVuY3Rpb24tZGVjbGFyYXRpb25dDQo+ICAgcmV0dXJuIG5mX2N0X2ZyYWc2X2dhdGhlcihu
ZXQsIHNrYiwgdXNlcik7DQo+ICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fg0KPiAgICAgICAg
ICBuZl9jdF9hdHRhY2gNCg0KVGhpcyBzaG91bGQgYmUgZml4ZWQgbm93Lg0K
