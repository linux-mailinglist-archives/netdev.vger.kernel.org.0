Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E981D4222
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgEOAeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727123AbgEOAeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:34:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92314C061A0C;
        Thu, 14 May 2020 17:34:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1109414CDC3ED;
        Thu, 14 May 2020 17:34:02 -0700 (PDT)
Date:   Thu, 14 May 2020 17:34:01 -0700 (PDT)
Message-Id: <20200514.173401.2124867853360450667.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     grygorii.strashko@ti.com, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH net-next 0/2] am65-cpsw: add taprio/EST offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513132615.16299-1-m-karicheri2@ti.com>
References: <20200513132615.16299-1-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:34:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTXVyYWxpIEthcmljaGVyaSA8bS1rYXJpY2hlcmkyQHRpLmNvbT4NCkRhdGU6IFdlZCwg
MTMgTWF5IDIwMjAgMDk6MjY6MTMgLTA0MDANCg0KPiBBTTY1IENQU1cgaC93IHN1cHBvcnRzIEVu
aGFuY2VkIFNjaGVkdWxlZCBUcmFmZmljIChFU1Qg4oCTIGRlZmluZWQNCj4gaW4gUDgwMi4xUWJ2
L0QyLjIgdGhhdCBsYXRlciBnb3QgaW5jbHVkZWQgaW4gSUVFRSA4MDIuMVEtMjAxOCkNCj4gY29u
ZmlndXJhdGlvbi4gRVNUIGFsbG93cyBleHByZXNzIHF1ZXVlIHRyYWZmaWMgdG8gYmUgc2NoZWR1
bGVkDQo+IChwbGFjZWQpIG9uIHRoZSB3aXJlIGF0IHNwZWNpZmljIHJlcGVhdGFibGUgdGltZSBp
bnRlcnZhbHMuIEluDQo+IExpbnV4IGtlcm5lbCwgRVNUIGNvbmZpZ3VyYXRpb24gaXMgZG9uZSB0
aHJvdWdoIHRjIGNvbW1hbmQgYW5kDQo+IHRoZSB0YXByaW8gc2NoZWR1bGVyIGluIHRoZSBuZXQg
Y29yZSBpbXBsZW1lbnRzIGEgc29mdHdhcmUgb25seQ0KPiBzY2hlZHVsZXIgKFNDSF9UQVBSSU8p
LiBJZiB0aGUgTklDIGlzIGNhcGFibGUgb2YgRVNUIGNvbmZpZ3VyYXRpb24sDQo+IHVzZXIgaW5k
aWNhdGUgImZsYWcgMiIgaW4gdGhlIGNvbW1hbmQgd2hpY2ggaXMgdGhlbiBwYXJzZWQgYnkNCj4g
dGFwcmlvIHNjaGVkdWxlciBpbiBuZXQgY29yZSBhbmQgaW5kaWNhdGUgdGhhdCB0aGUgY29tbWFu
ZCBpcyB0bw0KPiBiZSBvZmZsb2FkZWQgdG8gaC93LiB0YXByaW8gdGhlbiBvZmZsb2FkcyB0aGUg
Y29tbWFuZCB0byB0aGUNCj4gZHJpdmVyIGJ5IGNhbGxpbmcgbmRvX3NldHVwX3RjKCkgbmRvIG9w
cy4gVGhpcyBwYXRjaCBpbXBsZW1lbnRzDQo+IG5kb19zZXR1cF90YygpIGFzIHdlbGwgYXMgb3Ro
ZXIgY2hhbmdlcyByZXF1aXJlZCB0byBvZmZsb2FkIEVTVA0KPiBjb25maWd1cmF0aW9uIHRvIENQ
U1cgaC93DQo+IA0KPiBGb3IgbW9yZSBkZXRhaWxzIHBsZWFzZSByZWZlciBwYXRjaCAyLzIuDQog
Li4uDQoNClNlcmllcyBhcHBsaWVkLCB0aGFuayB5b3UuDQo=
