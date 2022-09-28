Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304A75EDDA7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiI1N1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbiI1N1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:27:49 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77CCAA1D13;
        Wed, 28 Sep 2022 06:27:47 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Wed, 28 Sep 2022 21:27:40
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.100.195]
Date:   Wed, 28 Sep 2022 21:27:40 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de
Subject: Re: [PATCH V3] mISDN: fix use-after-free bugs in l1oip timer
 handlers
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220927172618.58f238d6@kernel.org>
References: <20220924021842.71754-1-duoming@zju.edu.cn>
 <20220927172618.58f238d6@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <51008dca.fbc35.1838448187b.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgCXnP3NSzRjlKusBg--.20265W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggHAVZdtbsZ2wBAsL
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUdWUsIDI3IFNlcCAyMDIyIDE3OjI2OjE4IC0wNzAwIEpha3ViIEtpY2luc2tp
IHdyb3RlOgoKPiBPbiBTYXQsIDI0IFNlcCAyMDIyIDEwOjE4OjQyICswODAwIER1b21pbmcgWmhv
dSB3cm90ZToKPiA+ICsJZGVsX3RpbWVyX3N5bmMoJmhjLT5rZWVwX3RsKTsKPiA+ICsJZGVsX3Rp
bWVyX3N5bmMoJmhjLT50aW1lb3V0X3RsKTsKPiA+ICsJY2FuY2VsX3dvcmtfc3luYygmaGMtPndv
cmtxKTsKPiA+ICsJZGVsX3RpbWVyX3N5bmMoJmhjLT5rZWVwX3RsKTsKPiA+ICAJY2FuY2VsX3dv
cmtfc3luYygmaGMtPndvcmtxKTsKPiAKPiBXaHkgbm90IGFkZCBhIGJpdCB3aGljaCB3aWxsIGlu
ZGljYXRlIHRoYXQgdGhlIGRldmljZSBpcyBzaHV0dGluZyAKPiBkb3duIGFuZCBjaGVjayBpdCBp
biBwbGFjZXMgd2hpY2ggc2NoZWR1bGUgdGhlIHRpbWVyPwo+IEkgdGhpbmsgdGhhdCdzIG11Y2gg
ZWFzaWVyIHRvIHJlYXNvbiBhYm91dCBhbmQgd2Ugd29uJ3QgbmVlZCB0byBkbyAKPiB0aGlzIHJl
cCBjYW5jZWwgcHJvY2VkdXJlLgoKVGhhbmsgeW91IGZvciB5b3VyIHRpbWUgYW5kIHN1Z2dlc3Rp
b25zIQoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3UK
