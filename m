Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2F55005AA
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 07:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbiDNFxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 01:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiDNFxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 01:53:02 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7F5427B2A;
        Wed, 13 Apr 2022 22:50:36 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 14 Apr 2022 13:50:28
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.0.92]
Date:   Thu, 14 Apr 2022 13:50:28 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Duoming Zhou" <duoming@zju.edu.cn>
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V3 1/3] drivers: nfc: nfcmrvl: fix double free bugs
 caused by fw_dnld_over()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <1d34425a0ea8a553a66dcf4f22ca55cc920dbb42.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
 <1d34425a0ea8a553a66dcf4f22ca55cc920dbb42.1649913521.git.duoming@zju.edu.cn>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <f198a12.102db.180269f7d00.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgBXX6cktldig6s1AQ--.43533W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUSElNG3GUX+gAUsT
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
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

SGVsbG8gdGhlcmUsCgpTb3JyeSBoZXJlIGJ1dCBhY3R1YWxseSBJIGRpZG4ndCAicmV2aWV3IiB0
aGlzIHBhdGNoIGJ1dCBvbmx5IG9mZmVyIHNvbWUgc3VnZ2VzdGlvbnMuCkl0IHNlZW1zIHRoYXQg
dGhlIGN1cnJlbnQgdmVyc2lvbiBvZiBwYXRjaCBtYWlubHkgZm9jdXMgb24gc29sdmluZyB0aGUg
ZGF0YSByYWNlLiBIb3dldmVyLCBJJ2QgcHJlZmVyIHRvIG1ha2Ugc3VyZSB0aGlzIGZ1bmN0aW9u
Cgo+IHN0YXRpYyB2b2lkIGZ3X2RubGRfb3ZlcihzdHJ1Y3QgbmZjbXJ2bF9wcml2YXRlICpwcml2
LCB1MzIgZXJyb3IpCgpuZXZlciBiZSBhYmxlIHRvIGJlIGNhbGxlZCBtb3JlIHRoYW4gb25jZS4g
TWF5YmUgYWRkIHNvbWUgYWRkaXRpb25hbCBmbGFnIHdpdGggbG9jayBpcyBtb3JlIGFwcHJvcHJp
YXRlLgoKUmVnYXJkcwpMaW4=
