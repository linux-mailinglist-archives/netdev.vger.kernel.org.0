Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85956EE412
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjDYOit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbjDYOiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:38:13 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1ACC9022
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 07:37:53 -0700 (PDT)
Received: from u201911841$hust.edu.cn ( [10.12.176.104] ) by
 ajax-webmail-app1 (Coremail) ; Tue, 25 Apr 2023 22:37:47 +0800 (GMT+08:00)
X-Originating-IP: [10.12.176.104]
Date:   Tue, 25 Apr 2023 22:37:47 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?6ZKf5YuH?= <u201911841@hust.edu.cn>
To:     "jakub kicinski" <kuba@kernel.org>
Cc:     ktestrobot@126.com, wangjikai@hust.edu.cn,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] wifi: mt7601u: delete dead code checking debugfs
 returns
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220802(cbd923c5)
 Copyright (c) 2002-2023 www.mailtech.cn hust
In-Reply-To: <20230425070703.0686a593@kernel.org>
References: <64474195.013A79.00008@m126.mail.126.com>
 <20230425070703.0686a593@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <46846d87.43beb.187b8d963cf.Coremail.u201911841@hust.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: FgEQrADn7LS75Udk82noAw--.29815W
X-CM-SenderInfo: zxsqimqrrykio6kx23oohg3hdfq/1tbiAQsMBl7Em5RTzwAAsJ
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW5Jw
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

Ck9uIDIwMjMtMDQtMjUgMjI6MDc6MDMsIEpha3ViIEtpY2luc2tpIHdyb3RlOgo+IE9uIFR1ZSwg
MjUgQXByIDIwMjMgMTE6MTU6MDQgKzA4MDAgKENTVCkga3Rlc3Ryb2JvdEAxMjYuY29tIHdyb3Rl
Ogo+ID4gSGksIFdhbmcgSmlrYWkKPiA+IFRoaXMgZW1haWwgaXMgYXV0b21hdGljYWxseSByZXBs
aWVkIGJ5IEtUZXN0Um9ib3QoQmV0YSkuIFBsZWFzZSBkbyBub3QgcmVwbHkgdG8gdGhpcyBlbWFp
bC4KPiA+IElmIHlvdSBoYXZlIGFueSBxdWVzdGlvbnMgb3Igc3VnZ2VzdGlvbnMgYWJvdXQgS1Rl
c3RSb2JvdCwgcGxlYXNlIGNvbnRhY3QgWmhvbmdZb25nIDxVMjAxOTExODQxQGh1c3QuZWR1LmNu
Pgo+IAo+IFdoYXQgaXMgdGhpcz8gUGxlYXNlIGRvbid0IHNwYW0gcGVvcGxlIHdpdGggc29tZSBy
YW5kb20gYm90IG91dHB1dC4KCldlIGFyZSBzb3JyeSBhYm91dCB0aGlzIHNpdHVhdGlvbi4gT3Vy
IHJvYm90IGRldmVsb3BtZW50IGludHJvZHVjZWQgYSAKbG9naWMgZXJyb3IgaW4gY2hlY2tpbmcg
cGF0Y2hlcywgaS5lLiwgaXQgZG9lcyBub3QgY2hlY2sgaWYgdGhpcyBwYXRjaCAKaXMgc2VudCBv
dXQgdG8gTEtNTC4KClBsZWFzZSBpZ25vcmUgdGhpcyByb2JvdCBtZXNzYWdlLiBSZWFsbHkgc29y
cnkgYWJvdXQgdGhpcyBhbGFybS4KClpob25nWW9uZw==
