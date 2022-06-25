Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7113A55A83C
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 11:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiFYJAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 05:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiFYJAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 05:00:01 -0400
Received: from jari.cn (unknown [218.92.28.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABDE72CE1A;
        Sat, 25 Jun 2022 02:00:00 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Sat, 25 Jun
 2022 16:54:33 +0800 (GMT+08:00)
X-Originating-IP: [125.70.163.206]
Date:   Sat, 25 Jun 2022 16:54:33 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "XueBing Chen" <chenxuebing@jari.cn>
To:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sky2: drop unexpected word 'a' in comments
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1c4ec5e8.c87.1819a11e892.Coremail.chenxuebing@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwD3AG9JzbZi5jVEAA--.828W
X-CM-SenderInfo: hfkh05pxhex0nj6mt2flof0/1tbiAQAICmFEYxsvOAABsI
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
ZCB0byBiZSBkcm9wcGVkCgpmaWxlIC0gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9za3ky
LmMKbGluZSAtIDQ3MTQKCi8qIFRlc3QgaW50ZXJydXB0IHBhdGggYnkgZm9yY2luZyBhIGEgc29m
dHdhcmUgSVJRICovCgp0bwoKLyogVGVzdCBpbnRlcnJ1cHQgcGF0aCBieSBmb3JjaW5nIGEgc29m
dHdhcmUgSVJRICovCgpTaWduZWQtb2ZmLWJ5OiBYdWVCaW5nIENoZW4gPGNoZW54dWViaW5nQGph
cmkuY24+Ci0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9za3kyLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21hcnZlbGwvc2t5Mi5jCmluZGV4IGExZTkwN2M4NTIxNy4uOWYxYTdlYzA0OTFhIDEwMDY0
NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIuYworKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tYXJ2ZWxsL3NreTIuYwpAQCAtNDcxMSw3ICs0NzExLDcgQEAgc3RhdGlj
IGlycXJldHVybl90IHNreTJfdGVzdF9pbnRyKGludCBpcnEsIHZvaWQgKmRldl9pZCkKIAlyZXR1
cm4gSVJRX0hBTkRMRUQ7CiB9CiAKLS8qIFRlc3QgaW50ZXJydXB0IHBhdGggYnkgZm9yY2luZyBh
IGEgc29mdHdhcmUgSVJRICovCisvKiBUZXN0IGludGVycnVwdCBwYXRoIGJ5IGZvcmNpbmcgYSBz
b2Z0d2FyZSBJUlEgKi8KIHN0YXRpYyBpbnQgc2t5Ml90ZXN0X21zaShzdHJ1Y3Qgc2t5Ml9odyAq
aHcpCiB7CiAJc3RydWN0IHBjaV9kZXYgKnBkZXYgPSBody0+cGRldjsKLS0gCjIuMTcuMQo=
