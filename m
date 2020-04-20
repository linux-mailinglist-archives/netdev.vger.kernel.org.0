Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028E81B000B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgDTCzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:55:46 -0400
Received: from smtp37.cstnet.cn ([159.226.251.37]:32846 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbgDTCzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:55:45 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Apr 2020 22:55:45 EDT
Received: by ajax-webmail-APP-12 (Coremail) ; Mon, 20 Apr 2020 10:48:26
 +0800 (GMT+08:00)
X-Originating-IP: [36.157.253.18]
Date:   Mon, 20 Apr 2020 10:48:26 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5piT5p6X?= <yilin@iie.ac.cn>
To:     vishal@chelsio.com
Cc:     "csong@cs.ucr.edu" <csong@cs.ucr.edu>,
        "yiqiuping@gmail.com" <yiqiuping@gmail.com>,
        "zhiyunq@cs.ucr.edu" <zhiyunq@cs.ucr.edu>,
        "jian liu" <liujian6@iie.ac.cn>, netdev@vger.kernel.org
Subject: =?UTF-8?Q?drivers=EF=BC=9A_target=EF=BC=9A_iscsi:_cxgbit:_is_there_?=
 =?UTF-8?Q?exist_a_memleak_in_cxgbit=5Fcreate=5Fserver4=3F?=
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190723(4416cd1d)
 Copyright (c) 2002-2020 www.mailtech.cn cnic.cn-demo
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <5b93ede1.2832e.171957ca60f.Coremail.yilin@iie.ac.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: tgCowAD3_x96DZ1ecDEDAA--.26949W
X-CM-SenderInfo: p1lox0o6llvhldfou0/1tbiCwQMAFz4jOBFeAAAs2
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c3RhdGljIGludApjeGdiaXRfY3JlYXRlX3NlcnZlcjQoc3RydWN0IGN4Z2JpdF9kZXZpY2UgKmNk
ZXYsIHVuc2lnbmVkIGludCBzdGlkLAoJCSAgICAgIHN0cnVjdCBjeGdiaXRfbnAgKmNucCkKewoJ
c3RydWN0IHNvY2thZGRyX2luICpzaW4gPSAoc3RydWN0IHNvY2thZGRyX2luICopCgkJCQkgICAm
YW1wO2NucC0mZ3Q7Y29tLmxvY2FsX2FkZHI7CglpbnQgcmV0OwoKCXByX2RlYnVnKCIlczogZGV2
ID0gJXM7IHN0aWQgPSAldTsgc2luX3BvcnQgPSAldVxuIiwKCQkgX19mdW5jX18sIGNkZXYtJmd0
O2xsZGkucG9ydHNbMF0tJmd0O25hbWUsIHN0aWQsIHNpbi0mZ3Q7c2luX3BvcnQpOwoKCWN4Z2Jp
dF9nZXRfY25wKGNucCk7ICAKCWN4Z2JpdF9pbml0X3dyX3dhaXQoJmFtcDtjbnAtJmd0O2NvbS53
cl93YWl0KTsKCglyZXQgPSBjeGdiNF9jcmVhdGVfc2VydmVyKGNkZXYtJmd0O2xsZGkucG9ydHNb
MF0sCgkJCQkgIHN0aWQsIHNpbi0mZ3Q7c2luX2FkZHIuc19hZGRyLAoJCQkJICBzaW4tJmd0O3Np
bl9wb3J0LCAwLAoJCQkJICBjZGV2LSZndDtsbGRpLnJ4cV9pZHNbMF0pOwoJaWYgKCFyZXQpCgkJ
cmV0ID0gY3hnYml0X3dhaXRfZm9yX3JlcGx5KGNkZXYsCgkJCQkJICAgICZhbXA7Y25wLSZndDtj
b20ud3Jfd2FpdCwKCQkJCQkgICAgMCwgMTAsIF9fZnVuY19fKTsKCWVsc2UgaWYgKHJldCAmZ3Q7
IDApCgkJcmV0ID0gbmV0X3htaXRfZXJybm8ocmV0KTsKCWVsc2UKCQljeGdiaXRfcHV0X2NucChj
bnApOwoKCWlmIChyZXQpCgkJcHJfZXJyKCJjcmVhdGUgc2VydmVyIGZhaWxlZCBlcnIgJWQgc3Rp
ZCAlZCBsYWRkciAlcEk0IGxwb3J0ICVkXG4iLAoJCSAgICAgICByZXQsIHN0aWQsICZhbXA7c2lu
LSZndDtzaW5fYWRkciwgbnRvaHMoc2luLSZndDtzaW5fcG9ydCkpOwoJcmV0dXJuIHJldDsKfQp3
aGF0IGlmIGN4Z2I0X2NyZWF0ZV9zZXJ2ZXIgcmV0dXJuIGEgJmd0OzAgdmFsdWUsIHRoZSBjbnAg
cmVmZXJlbmNlIHdvdWxkbid0IGJlIHJlbGVhc2VkLiBPciwgd2hlbiBjeGdiNF9jcmVhdGVfc2Vy
dmVyICByZXR1cm4gJmd0OzAgdmFsdWUsIGNucCBoYXMgYmVlbiByZWxlYXNlZCBzb21ld2hlcmUu

