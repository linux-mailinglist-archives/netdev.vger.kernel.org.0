Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5895CE78DF
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfJ1TBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:01:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfJ1TBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:01:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D90C13EA7015;
        Mon, 28 Oct 2019 12:01:14 -0700 (PDT)
Date:   Mon, 28 Oct 2019 12:01:13 -0700 (PDT)
Message-Id: <20191028.120113.302853319604481823.davem@davemloft.net>
To:     sheetal.tigadoli@broadcom.com
Cc:     zajec5@gmail.com, gregkh@linuxfoundation.org,
        michal.simek@xilinx.com, rajan.vaja@xilinx.com,
        scott.branden@broadcom.com, ray.jui@broadcom.com,
        vikram.prakash@broadcom.com, jens.wiklander@linaro.org,
        michael.chan@broadcom.com, vikas.gupta@broadcom.com,
        vasundhara-v.volam@broadcom.com, linux-kernel@vger.kernel.org,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH V3 0/3] Add OP-TEE based bnxt f/w manager
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028.114915.4026077453899574.davem@davemloft.net>
References: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
        <20191028.114915.4026077453899574.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 12:01:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogTW9uLCAyOCBP
Y3QgMjAxOSAxMTo0OToxNSAtMDcwMCAoUERUKQ0KDQo+IEZyb206IFNoZWV0YWwgVGlnYWRvbGkg
PHNoZWV0YWwudGlnYWRvbGlAYnJvYWRjb20uY29tPg0KPiBEYXRlOiBUaHUsIDI0IE9jdCAyMDE5
IDExOjAyOjM4ICswNTMwDQo+IA0KPj4gVGhpcyBwYXRjaCBzZXJpZXMgYWRkcyBzdXBwb3J0IGZv
ciBURUUgYmFzZWQgQk5YVCBmaXJtd2FyZQ0KPj4gbWFuYWdlbWVudCBtb2R1bGUgYW5kIHRoZSBk
cml2ZXIgY2hhbmdlcyB0byBpbnZva2UgT1AtVEVFDQo+PiBBUElzIHRvIGZhc3Rib290IGZpcm13
YXJlIGFuZCB0byBjb2xsZWN0IGNyYXNoIGR1bXAuDQo+PiANCj4+IGNoYW5nZXMgZnJvbSB2MjoN
Cj4+ICAtIGFkZHJlc3MgcmV2aWV3IGNvbW1lbnRzIGZyb20gSmFrdWINCj4gDQo+IFNlcmllcyBh
cHBsaWVkIHRvIG5ldC1uZXh0Lg0KPiANCj4gUGxlYXNlIHByb3Blcmx5IGFubm90YXRlIHlvdXIg
U3ViamVjdCBsaW5lcyBpbiB0aGUgZnV0dXJlIHRvIGluZGljYXRlDQo+IHRoZSBleGFjdCBHSVQg
dHJlZSB5b3VyIHBhdGNoZXMgYXJlIHRhcmdldHRpbmcsIGFsYSAiW1BBVENIIG5ldC1uZXh0IC4u
Ll0iDQoNCkFjdHVhbGx5LCByZXZlcnRlZCwgdGhpcyBkb2Vzbid0IGV2ZW4gY29tcGlsZToNCg0K
ZHJpdmVycy9maXJtd2FyZS9icm9hZGNvbS90ZWVfYm54dF9mdy5jOiBJbiBmdW5jdGlvbiChcHJl
cGFyZV9hcmdzojoNCmRyaXZlcnMvZmlybXdhcmUvYnJvYWRjb20vdGVlX2JueHRfZncuYzoxNDoy
NDogZXJyb3I6IKFTWl80TaIgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24p
DQogI2RlZmluZSBNQVhfU0hNX01FTV9TWiBTWl80TQ0KICAgICAgICAgICAgICAgICAgICAgICAg
Xn5+fn4NCmRyaXZlcnMvZmlybXdhcmUvYnJvYWRjb20vdGVlX2JueHRfZncuYzo4MToyODogbm90
ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIKFNQVhfU0hNX01FTV9TWqINCiAgIHBhcmFtWzBdLnUu
bWVtcmVmLnNpemUgPSBNQVhfU0hNX01FTV9TWjsNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBefn5+fn5+fn5+fn5+fg0KZHJpdmVycy9maXJtd2FyZS9icm9hZGNvbS90ZWVfYm54dF9mdy5j
OjE0OjI0OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcyByZXBvcnRlZCBvbmx5
IG9uY2UgZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KICNkZWZpbmUgTUFYX1NITV9N
RU1fU1ogU1pfNE0NCiAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+DQpkcml2ZXJzL2Zpcm13
YXJlL2Jyb2FkY29tL3RlZV9ibnh0X2Z3LmM6ODE6Mjg6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBt
YWNybyChTUFYX1NITV9NRU1fU1qiDQogICBwYXJhbVswXS51Lm1lbXJlZi5zaXplID0gTUFYX1NI
TV9NRU1fU1o7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn4NCmRy
aXZlcnMvZmlybXdhcmUvYnJvYWRjb20vdGVlX2JueHRfZncuYzogSW4gZnVuY3Rpb24goXRlZV9i
bnh0X2Z3X3Byb2JlojoNCmRyaXZlcnMvZmlybXdhcmUvYnJvYWRjb20vdGVlX2JueHRfZncuYzox
NDoyNDogZXJyb3I6IKFTWl80TaIgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rp
b24pDQogI2RlZmluZSBNQVhfU0hNX01FTV9TWiBTWl80TQ0KICAgICAgICAgICAgICAgICAgICAg
ICAgXn5+fn4NCmRyaXZlcnMvZmlybXdhcmUvYnJvYWRjb20vdGVlX2JueHRfZncuYzoyMTQ6NDQ6
IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyChTUFYX1NITV9NRU1fU1qiDQogIGZ3X3NobV9w
b29sID0gdGVlX3NobV9hbGxvYyhwdnRfZGF0YS5jdHgsIE1BWF9TSE1fTUVNX1NaLA0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fg0K
