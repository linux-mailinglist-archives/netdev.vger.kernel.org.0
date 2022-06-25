Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C31755A803
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiFYIK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 04:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiFYIK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 04:10:27 -0400
Received: from jari.cn (unknown [218.92.28.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E33FE35DC6;
        Sat, 25 Jun 2022 01:10:22 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Sat, 25 Jun
 2022 16:04:51 +0800 (GMT+08:00)
X-Originating-IP: [125.70.163.206]
Date:   Sat, 25 Jun 2022 16:04:51 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "XueBing Chen" <chenxuebing@jari.cn>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jdmason@kudzu.us
Subject: [PATCH] ethernet: s2io: drop unexpected word 'a' in comments
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <72752b59.c83.18199e46869.Coremail.chenxuebing@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwA3QW+jwbZicjREAA--.777W
X-CM-SenderInfo: hfkh05pxhex0nj6mt2flof0/1tbiAQAACmFEYxstBQAEs6
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
ZCB0byBiZSBkcm9wcGVkCgpmaWxlIC0gZHJpdmVycy9uZXQvZXRoZXJuZXQvbmV0ZXJpb24vczJp
by5jCmxpbmUgLSAzODIwCgovKiBUZXN0IGludGVycnVwdCBwYXRoIGJ5IGZvcmNpbmcgYSBhIHNv
ZnR3YXJlIElSUSAqLwoKdG8KCi8qIFRlc3QgaW50ZXJydXB0IHBhdGggYnkgZm9yY2luZyBhIHNv
ZnR3YXJlIElSUSAqLwoKU2lnbmVkLW9mZi1ieTogWHVlQmluZyBDaGVuIDxjaGVueHVlYmluZ0Bq
YXJpLmNuPgotLS0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3MyaW8uYyB8IDIgKy0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3MyaW8uYyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L25ldGVyaW9uL3MyaW8uYwppbmRleCA2ZGQ0NTFhZGMzMzEuLjFiNzUyOTRmZTMxNSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbmV0ZXJpb24vczJpby5jCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3MyaW8uYwpAQCAtMzgxNyw3ICszODE3LDcgQEAg
c3RhdGljIGlycXJldHVybl90IHMyaW9fdGVzdF9pbnRyKGludCBpcnEsIHZvaWQgKmRldl9pZCkK
IAlyZXR1cm4gSVJRX0hBTkRMRUQ7CiB9CiAKLS8qIFRlc3QgaW50ZXJydXB0IHBhdGggYnkgZm9y
Y2luZyBhIGEgc29mdHdhcmUgSVJRICovCisvKiBUZXN0IGludGVycnVwdCBwYXRoIGJ5IGZvcmNp
bmcgYSBzb2Z0d2FyZSBJUlEgKi8KIHN0YXRpYyBpbnQgczJpb190ZXN0X21zaShzdHJ1Y3QgczJp
b19uaWMgKnNwKQogewogCXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gc3AtPnBkZXY7Ci0tIAoyLjE3
LjEK
