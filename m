Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9E812AA16
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 04:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLZDuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 22:50:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLZDuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 22:50:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5017A1541355A;
        Wed, 25 Dec 2019 19:50:01 -0800 (PST)
Date:   Wed, 25 Dec 2019 19:50:00 -0800 (PST)
Message-Id: <20191225.195000.1150683636639114235.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] netfilter: add indr block setup in
 nf_flow_table_offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
        <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 19:50:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogd2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCkRhdGU6IFRodSwgMjYgRGVjIDIwMTkgMDk6
NDY6NTEgKzA4MDANCg0KPiDlnKggMjAxOS8xMi8yNSAxNzo0OCwgd2VueHVAdWNsb3VkLmNuIOWG
memBkzoNCj4+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+Pg0KPj4gVGhpcyBwYXRj
aCBwcm92aWRlIHR1bm5lbCBvZmZsb2FkIGluIG5mX2Zsb3dfdGFibGVfb2ZmbG9hZCBiYXNlZCBv
bg0KPj4gcm91dGUgbHd0dW5uZWwuIA0KPj4gVGhlIGZpcnN0IHBhdGNoIGFkZCBUQ19TRVRQX0ZU
IHR5cGUgaW4gZmxvd19pbmRyX2Jsb2NrX2NhbGwuDQo+PiBUaGUgbmV4dCB0d28gcGF0Y2hlcyBh
ZGQgc3VwcG9ydCBpbmRyIGNhbGxiYWNrIHNldHVwIGluIGZsb3d0YWJsZSBvZmZsb2FkLg0KPj4g
VGhlIGxhc3QgdHdvIHBhdGNoZXMgYWRkIHR1bm5lbCBtYXRjaCBhbmQgYWN0aW9uIG9mZmxvYWQu
DQo+IA0KPiBIacKgIERhdmlkLA0KPiANCj4gVGhpcyBzZXJpZXMgbW9kaWZ5IHRoZSBuZXQvY29y
ZS9mbG93X29mZmxvYWQuYyBhbmQgbmV0L3NjaGVkL2Nsc19hcGkuYyBmaWxlcy4NCj4gDQo+IFRo
aXMgc2VyaWVzIG1heWJlIGJlIHN1aXQgZm9yIG5ldC1uZXh0IHRyZWUgYnV0IG5vdCBuZi1uZXh0
IHRyZWU/DQoNCkl0J3MgZmluZSBmb3IgbmYtbmV4dCwgd2UnbGwganVzdCByZXNvbHZlIGFueSBj
b25mbGljdHMgdGhhdCBzaG93IHVwLg0K
