Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA16F55A801
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 10:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiFYIN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 04:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiFYINz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 04:13:55 -0400
Received: from jari.cn (unknown [218.92.28.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03CFD10FD1;
        Sat, 25 Jun 2022 01:13:53 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Sat, 25 Jun
 2022 16:08:28 +0800 (GMT+08:00)
X-Originating-IP: [125.70.163.206]
Date:   Sat, 25 Jun 2022 16:08:28 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "XueBing Chen" <chenxuebing@jari.cn>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:  [PATCH] gve: drop unexpected word 'a' in comments
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <762564ba.c84.18199e7b56b.Coremail.chenxuebing@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwAHEW98wrZieDREAA--.797W
X-CM-SenderInfo: hfkh05pxhex0nj6mt2flof0/1tbiAQAICmFEYxsvNQACsG
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=2.2 required=5.0 tests=BAYES_00,RCVD_IN_PBL,RDNS_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_PERMERROR,T_SPF_PERMERROR,XPRIO
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CnRoZXJlIGlzIGFuIHVuZXhwZWN0ZWQgd29yZCAnYScgaW4gdGhlIGNvbW1lbnRzIHRoYXQgbmVl
ZCB0byBiZSBkcm9wcGVkCgpTaWduZWQtb2ZmLWJ5OiBYdWVCaW5nIENoZW4gPGNoZW54dWViaW5n
QGphcmkuY24+Ci0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvZ29vZ2xlL2d2ZS9ndmVfdHhfZHFv
LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9nb29nbGUvZ3ZlL2d2ZV90eF9kcW8u
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2dvb2dsZS9ndmUvZ3ZlX3R4X2Rxby5jCmluZGV4IGVj
Mzk0ZDk5MTY2OC4uZjdiYTYxNjE5NWYzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9nb29nbGUvZ3ZlL2d2ZV90eF9kcW8uYworKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9nb29n
bGUvZ3ZlL2d2ZV90eF9kcW8uYwpAQCAtNzk1LDcgKzc5NSw3IEBAIHN0YXRpYyB2b2lkIGd2ZV9o
YW5kbGVfcGFja2V0X2NvbXBsZXRpb24oc3RydWN0IGd2ZV9wcml2ICpwcml2LAogCQkJICAgICBH
VkVfUEFDS0VUX1NUQVRFX1BFTkRJTkdfUkVJTkpFQ1RfQ09NUEwpKSB7CiAJCQkvKiBObyBvdXRz
dGFuZGluZyBtaXNzIGNvbXBsZXRpb24gYnV0IHBhY2tldCBhbGxvY2F0ZWQKIAkJCSAqIGltcGxp
ZXMgcGFja2V0IHJlY2VpdmVzIGEgcmUtaW5qZWN0aW9uIGNvbXBsZXRpb24KLQkJCSAqIHdpdGhv
dXQgYSBhIHByaW9yIG1pc3MgY29tcGxldGlvbi4gUmV0dXJuIHdpdGhvdXQKKwkJCSAqIHdpdGhv
dXQgYSBwcmlvciBtaXNzIGNvbXBsZXRpb24uIFJldHVybiB3aXRob3V0CiAJCQkgKiBjb21wbGV0
aW5nIHRoZSBwYWNrZXQuCiAJCQkgKi8KIAkJCW5ldF9lcnJfcmF0ZWxpbWl0ZWQoIiVzOiBSZS1p
bmplY3Rpb24gY29tcGxldGlvbiByZWNlaXZlZCB3aXRob3V0IGNvcnJlc3BvbmRpbmcgbWlzcyBj
b21wbGV0aW9uOiAlZFxuIiwKLS0gCjIuMTcuMQo=
