Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A44B19C345
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbgDBNys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:54:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgDBNyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:54:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07B9F128A0375;
        Thu,  2 Apr 2020 06:54:46 -0700 (PDT)
Date:   Thu, 02 Apr 2020 06:54:46 -0700 (PDT)
Message-Id: <20200402.065446.2295152097236024797.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] crypto: chtls - Fix build error without IPV6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402014323.36492-1-yuehaibing@huawei.com>
References: <20200402014323.36492-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 06:54:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KRGF0ZTogVGh1LCAyIEFw
ciAyMDIwIDA5OjQzOjIzICswODAwDQoNCj4gSWYgSVBWNiBpcyBub3Qgc2V0LCBidWlsZCBmYWls
czoNCj4gDQo+IGRyaXZlcnMvY3J5cHRvL2NoZWxzaW8vY2hjcl9rdGxzLmM6IEluIGZ1bmN0aW9u
IKFjaGNyX2t0bHNfYWN0X29wZW5fcmVxNqI6DQo+IC4vaW5jbHVkZS9uZXQvc29jay5oOjM4MDoz
NzogZXJyb3I6IKFzdHJ1Y3Qgc29ja19jb21tb26iIGhhcyBubyBtZW1iZXIgbmFtZWQgoXNrY192
Nl9yY3Zfc2FkZHKiOyBkaWQgeW91IG1lYW4goXNrY19yY3Zfc2FkZHKiPw0KPiAgI2RlZmluZSBz
a192Nl9yY3Zfc2FkZHIgX19za19jb21tb24uc2tjX3Y2X3Jjdl9zYWRkcg0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXg0KPiBkcml2ZXJzL2NyeXB0by9jaGVsc2lvL2No
Y3Jfa3Rscy5jOjI1ODozNzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIKFza192Nl9yY3Zf
c2FkZHKiDQo+ICAgY3BsLT5sb2NhbF9pcF9oaSA9ICooX19iZTY0ICopJnNrLT5za192Nl9yY3Zf
c2FkZHIuaW42X3UudTZfYWRkcjhbMF07DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBefn5+fn5+fn5+fn5+fn4NCj4gDQo+IEFkZCBJUFY2IGRlcGVuZGVuY3kgdG8gZml4
IHRoaXMuDQo+IA0KPiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+
DQo+IEZpeGVzOiA2MjM3MGE0ZjM0NmQgKCJjeGdiNC9jaGNyOiBBZGQgaXB2NiBzdXBwb3J0IGFu
ZCBzdGF0aXN0aWNzIikNCj4gU2lnbmVkLW9mZi1ieTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0Bo
dWF3ZWkuY29tPg0KDQpUaGlzIGlzIGEgaGFyZCBoYW1tZXIsIGFuZCBJIHRoaW5rIHByb3BlciBD
UFAgdGVzdGluZyBzaG91bGQgYmUgYWRkZWQgdG8gdGhlDQpkcml2ZXIgY29kZSBpbnN0ZWFkLg0K
