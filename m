Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EB9ED81F
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 04:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfKDDoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 22:44:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfKDDoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 22:44:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8193315043D46;
        Sun,  3 Nov 2019 19:44:09 -0800 (PST)
Date:   Sun, 03 Nov 2019 19:44:09 -0800 (PST)
Message-Id: <20191103.194409.422094551811274424.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH v2 net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191103.192601.443764119268490765.davem@davemloft.net>
References: <20191101220756.2626-1-andrew@lunn.ch>
        <20191103.192601.443764119268490765.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 19:44:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogU3VuLCAwMyBO
b3YgMjAxOSAxOToyNjowMSAtMDgwMCAoUFNUKQ0KDQo+IEFwcGxpZWQsIHRoYW5rcyBBbmRyZXcu
DQoNCkkgdHJpZWQgdG8gZml4IHNvbWUgb2YgdGhlIGFsbG1vZGNvbmZpZyBidWlsZCBmYWxsb3V0
IGJ1dCBpdCBqdXN0IGtlcHQNCnBpbGluZyB1cC4gIENhbiB5b3UgZml4IHRoaXMgYW5kIHJlc3Vi
bWl0PyAgVGhhbmtzLg0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBh
YTItbWFjLmM6IEluIGZ1bmN0aW9uIKFkcGFhMl9tYWNfZ2V0X2lmX21vZGWiOg0KZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLW1hYy5jOjQ5OjEyOiBlcnJvcjogdG9v
IGZldyBhcmd1bWVudHMgdG8gZnVuY3Rpb24goW9mX2dldF9waHlfbW9kZaINCiAgaWZfbW9kZSA9
IG9mX2dldF9waHlfbW9kZShub2RlKTsNCiAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fg0KZHJp
dmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtc3RpLmM6IEluIGZ1bmN0aW9u
IKFzdGlfZHdtYWNfcGFyc2VfZGF0YaI6DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9kd21hYy1zdGkuYzoyNzQ6MTY6IHdhcm5pbmc6IHRvbyBtYW55IGFyZ3VtZW50cyBmb3Ig
Zm9ybWF0IFstV2Zvcm1hdC1leHRyYS1hcmdzXQ0KICAgZGV2X2VycihkZXYsICJDYW4ndCBnZXQg
cGh5LW1vZGVcbiIsIGVycik7DQogICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+
fg0KSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVkZS9saW51eC9wbGF0Zm9ybV9kZXZpY2Uu
aDoxMywNCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvc3RtbWFjLmg6MTUs
DQogICAgICAgICAgICAgICAgIGZyb20gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1t
YWMvZHdtYWMtc3VueGkuYzoxMDoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFj
L2R3bWFjLXN1bnhpLmM6IEluIGZ1bmN0aW9uIKFzdW43aV9nbWFjX3Byb2JlojoNCmRyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLXN1bnhpLmM6MTIzOjE2OiB3YXJuaW5n
OiB0b28gbWFueSBhcmd1bWVudHMgZm9yIGZvcm1hdCBbLVdmb3JtYXQtZXh0cmEtYXJnc10NCiAg
IGRldl9lcnIoZGV2LCAiQ2FuJ3QgZ2V0IHBoeS1tb2RlXG4iLCByZXQpOw0KICAgICAgICAgICAg
ICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCi4vaW5jbHVkZS9saW51eC9kZXZpY2UuaDoxNjU4
OjIyOiBub3RlOiBpbiBkZWZpbml0aW9uIG9mIG1hY3JvIKFkZXZfZm10og0KICNkZWZpbmUgZGV2
X2ZtdChmbXQpIGZtdA0KICAgICAgICAgICAgICAgICAgICAgIF5+fg0KZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWMtc3VueGkuYzoxMjM6Mzogbm90ZTogaW4gZXhwYW5z
aW9uIG9mIG1hY3JvIKFkZXZfZXJyog0KICAgZGV2X2VycihkZXYsICJDYW4ndCBnZXQgcGh5LW1v
ZGVcbiIsIHJldCk7DQogICBefn5+fn5+DQo=
