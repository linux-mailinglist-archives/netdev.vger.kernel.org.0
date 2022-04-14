Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05075005A8
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 07:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbiDNFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 01:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbiDNFuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 01:50:15 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B3524BBAA;
        Wed, 13 Apr 2022 22:47:48 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Thu, 14 Apr 2022 13:47:39
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.3.190]
Date:   Thu, 14 Apr 2022 13:47:39 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Duoming Zhou" <duoming@zju.edu.cn>
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V2 2/3] drivers: nfc: nfcmrvl: fix double free bug in
 nfc_fw_download_done()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <538873335b034d7d97a08d2343e898cfa924918a.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
 <538873335b034d7d97a08d2343e898cfa924918a.1649913521.git.duoming@zju.edu.cn>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2c2717d.10593.180269cebc8.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: by_KCgB3FMR7tVdiwEG7AQ--.18820W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUSElNG3GUX+gATsU
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWUCw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gdGhlcmUsCgpTb3JyeSwgdGhlIGFjdHVhbCBjYXNlIGRvZXMgbm90IG1hdGNoIHRoZSBk
ZXNjcmlwdGlvbi4gVGhlIG5ldGxpbmsgb3BlcmF0aW9ucyBtYXkgaGFzIG5vdGhpbmcgdG8gZG8g
d2l0aCB0aGUgZG91YmxlIGZyZWUgYW5kIHdlIHdpbGwgZHluYW1pY2FsbHkgY2hlY2sgdGhpcyBh
Z2Fpbi4KClNvcnJ5IGFnYWluIGZvciB0aGUgZmFsc2UgdGFnIGFuZCB0aGUgZmFsc2UgYWxhcm0u
IFQuVAoKUmVnYXJkcwpMaW4gTWE=
