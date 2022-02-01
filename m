Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96A64A5749
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 07:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiBAGeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 01:34:36 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:5170 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234377AbiBAGe3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 01:34:29 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2022 01:34:27 EST
Received: by ajax-webmail-mail-app3 (Coremail) ; Tue, 1 Feb 2022 14:26:23
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.67.66]
Date:   Tue, 1 Feb 2022 14:26:23 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <22021233@zju.edu.cn>
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 2/2] ax25: add refcount in ax25_dev to avoid UAF
 bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220131173729.GN1951@kadam>
References: <cover.1643343397.git.duoming@zju.edu.cn>
 <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
 <20220131173729.GN1951@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <70763230.8debd.17eb3f680eb.Coremail.22021233@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgCHODyP0vhhKmSDDA--.6799W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEIAVZdtYB1zAABsM
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciB0aW1lIGFuZCBwb2ludGluZyBvdXQgcHJvYmxl
bXMgaW4gbXkgcGF0Y2guCgpUaGUgZGVjcmVtZW50IG9mIGF4MjVfYmluZCgpIGlzIGluIGF4MjVf
a2lsbF9ieV9kZXZpY2UoKS4gSWYgd2UgZG9uJ3QKY2FsbCBheDI1X2JpbmQoKSBiZWZvcmUgYXgy
NV9raWxsX2J5X2RldmljZSgpLCB0aGUgYXgyNV9saXN0IHdpbGwgYmUKZW1wdHkgYW5kIGF4MjVf
ZGV2X3B1dCgpIGluIGF4MjVfa2lsbF9ieV9kZXZpY2UoKSB3aWxsIG5vdCBleGVjdXRlLgoKPiBA
QCAtOTEsNiArOTEsNyBAQCBzdGF0aWMgdm9pZCBheDI1X2tpbGxfYnlfZGV2aWNlKHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYpCj4gIAkJCXNwaW5fdW5sb2NrX2JoKCZheDI1X2xpc3RfbG9jayk7Cj4g
IAkJCWxvY2tfc29jayhzayk7Cj4gIAkJCXMtPmF4MjVfZGV2ID0gTlVMTDsKPiArCQkJYXgyNV9k
ZXZfcHV0KGF4MjVfZGV2KTsKPiAgCQkJcmVsZWFzZV9zb2NrKHNrKTsKPiAgCQkJYXgyNV9kaXNj
b25uZWN0KHMsIEVORVRVTlJFQUNIKTsKPiAgCQkJc3Bpbl9sb2NrX2JoKCZheDI1X2xpc3RfbG9j
ayk7CgpJIHdpbGwgc2VuZCB0aGUgaW1wcm92ZWQgcGF0Y2ggYXMgc29vbiBhcyBwb3NzaWJsZS4K
CgpCZXN0IHdpc2hlcywKRHVvbWluZyBaaG91Cg==
