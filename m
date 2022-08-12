Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7A590C9E
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 09:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiHLHgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 03:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbiHLHga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 03:36:30 -0400
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 12 Aug 2022 00:36:27 PDT
Received: from m1391.mail.163.com (m1391.mail.163.com [220.181.13.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3D2D98A78
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=vKUQp
        BmZZIzUT78niF5BwpbswGEey/GojeqexK2WiCE=; b=e9Aj6PtI0LjUPuV8roRzE
        8c6TLK53EiOAYDrTMUYA8fIs/zTVjl2ZzKXRkgl79K0SHzXi75LrqO4ZXfZrc95j
        e13qGBxZ46mN6AxKz0QdlhOkM+teoiufAR78uOpuHmnnSOsX5eVXYog6gA6MT1ES
        Pi2sPtaeSnpVMPrP2rZ6ro=
Received: from 15720603159$163.com ( [119.3.119.21] ) by
 ajax-webmail-wmsvr91 (Coremail) ; Fri, 12 Aug 2022 15:21:15 +0800 (CST)
X-Originating-IP: [119.3.119.21]
Date:   Fri, 12 Aug 2022 15:21:15 +0800 (CST)
From:   jiangheng <15720603159@163.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2] genl: modify the command output message of genl -h
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <1c6b71b1.62fc.18290edbaff.Coremail.15720603159@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: W8GowAD3_39r__VibHmbAA--.57316W
X-CM-SenderInfo: jprvljyqwqjievzbjqqrwthudrp/xtbCqQBbhV0DgnOYYgAAsi
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_05,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSBmNDcwOWEzMjQ4NzA4MjIwNjZiNDQ5YmFiODk5ODBkYmE4YzhhZjc5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBqaW5hZyA8amluYWcxMjEzOEBnbWFpbC5jb20+CkRhdGU6IFRo
dSwgMTQgT2N0IDIwMjEgMTU6MTM6MDMgKzA4MDAKU3ViamVjdDogW1BBVENIXSBnZW5sOiBtb2Rp
ZnkgdGhlIGNvbW1hbmQgb3V0cHV0IG9mIGdlbmwgLWgKCmFmdGVyIHRoZSBtb2RpZmljYXRpb24s
IHRoZSBjb21tYW5kIG91dHB1dCBpcyB0aGUgc2FtZSBhcyB0aGF0IG9mIG1hbiA4IGdlbmwgYW5k
IG1vcmUgcmVhZGFibGUuCi0tLQogZ2VubC9nZW5sLmMgfCA4ICsrKysrLS0tCiAxIGZpbGUgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2dlbmwv
Z2VubC5jIGIvZ2VubC9nZW5sLmMKaW5kZXggNjU1N2U2YmMuLjk3N2U5ZGI3IDEwMDY0NAotLS0g
YS9nZW5sL2dlbmwuYworKysgYi9nZW5sL2dlbmwuYwpAQCAtOTksOSArOTksMTEgQEAgc3RhdGlj
IHZvaWQgdXNhZ2Uodm9pZCkgX19hdHRyaWJ1dGVfXygobm9yZXR1cm4pKTsKIHN0YXRpYyB2b2lk
IHVzYWdlKHZvaWQpCiB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsCi0gICAgICAgICAgICAgICAi
VXNhZ2U6IGdlbmwgWyBPUFRJT05TIF0gT0JKRUNUIFtoZWxwXSB9XG4iCi0gICAgICAgICAgICAg
ICAid2hlcmUgIE9CSkVDVCA6PSB7IGN0cmwgZXRjIH1cbiIKLSAgICAgICAgICAgICAgICIgICAg
ICAgT1BUSU9OUyA6PSB7IC1zW3RhdGlzdGljc10gfCAtZFtldGFpbHNdIHwgLXJbYXddIHwgLVZb
ZXJzaW9uXSB8IC1oW2VscF0gfVxuIik7CisgICAgICAgICAgICAgICAiVXNhZ2U6IGdlbmwgWyBP
UFRJT05TIF0gT0JKRUNUIFtoZWxwXVxuIgorICAgICAgICAgICAgICAgIndoZXJlICBPQkpFQ1Qg
Oj0geyBjdHJsIENUUkxfT1BUUyB9XG4iCisgICAgICAgICAgICAgICAiICAgICAgIE9QVElPTlMg
Oj0geyAtc1t0YXRpc3RpY3NdIHwgLWRbZXRhaWxzXSB8IC1yW2F3XSB8IC1WW2Vyc2lvbl0gfCAt
aFtlbHBdIH1cbiIKKyAgICAgICAgICAgICAgICIgICAgICAgQ1RSTF9PUFRTIDo9IHsgaGVscCB8
IGxpc3QgfCBtb25pdG9yIHwgZ2V0IFBBUk1TIH1cbiIKKyAgICAgICAgICAgICAgICIgICAgICAg
UEFSTVMgOj0geyBuYW1lIE5BTUUgfCBpZCBJRCB9XG4iKTsKICAgICAgICBleGl0KC0xKTsKIH0K
Ci0tCjIuMjMuMAo=
