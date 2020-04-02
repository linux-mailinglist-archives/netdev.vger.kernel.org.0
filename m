Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D5619C34A
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbgDBNzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:55:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46968 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBNze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:55:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B670128A037D;
        Thu,  2 Apr 2020 06:55:34 -0700 (PDT)
Date:   Thu, 02 Apr 2020 06:55:33 -0700 (PDT)
Message-Id: <20200402.065533.99559000408191080.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] crypto/chcr: Add missing include file
 <linux/highmem.h>
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200402023258.33336-1-yuehaibing@huawei.com>
References: <20200402023258.33336-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 06:55:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KRGF0ZTogVGh1LCAyIEFw
ciAyMDIwIDEwOjMyOjU4ICswODAwDQoNCj4gZHJpdmVycy9jcnlwdG8vY2hlbHNpby9jaGNyX2t0
bHMuYzogSW4gZnVuY3Rpb24goWNoY3Jfc2hvcnRfcmVjb3JkX2hhbmRsZXKiOg0KPiBkcml2ZXJz
L2NyeXB0by9jaGVsc2lvL2NoY3Jfa3Rscy5jOjE3NzA6MTI6IGVycm9yOiBpbXBsaWNpdCBkZWNs
YXJhdGlvbiBvZiBmdW5jdGlvbiCha21hcF9hdG9taWOiOw0KPiAgZGlkIHlvdSBtZWFuIKFpbl9h
dG9taWOiPyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0NCj4gICAgIHZh
ZGRyID0ga21hcF9hdG9taWMoc2tiX2ZyYWdfcGFnZShmKSk7DQo+ICAgICAgICAgICAgIF5+fn5+
fn5+fn5+DQo+IA0KPiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+
DQo+IEZpeGVzOiBkYzA1ZjNkZjhmYWMgKCJjaGNyOiBIYW5kbGUgZmlyc3Qgb3IgbWlkZGxlIHBh
cnQgb2YgcmVjb3JkIikNCj4gU2lnbmVkLW9mZi1ieTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0Bo
dWF3ZWkuY29tPg0KDQpBcHBsaWVkLg0K
