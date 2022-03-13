Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9684D726F
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 05:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiCME2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 23:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiCME2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 23:28:09 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1F86115961;
        Sat, 12 Mar 2022 20:27:00 -0800 (PST)
Received: by ajax-webmail-mail-app3 (Coremail) ; Sun, 13 Mar 2022 12:26:45
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.69.222]
Date:   Sun, 13 Mar 2022 12:26:45 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jreuter@yaina.de, kuba@kernel.org,
        davem@davemloft.net, ralf@linux-mips.org
Subject: Re: Re: [PATCH V3] ax25: Fix refcount leaks caused by ax25_cb_del()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220311105344.GI3293@kadam>
References: <20220311014624.51117-1-duoming@zju.edu.cn>
 <20220311105344.GI3293@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4364e68e.77f.17f81875881.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgC3L2uFci1ieYUFAA--.450W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEIAVZdtYpS1wABs6
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
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

SGVsbG8sCgpPbiBGcmksIE1hciAxMSwgMjAyMiBEYW4gQ2FycGVuIHdyb3RlOgoKPiBCdXQgZXZl
biBoZXJlLCBteSBpbnN0aW5jdCBpcyB0aGF0IGlmIHRoZSByZWZjb3VudGluZyBpcyB3ZXJlIGRv
bmUgaW4KPiB0aGUgY29ycmVjdCBwbGFjZSB3ZSB3b3VsZCBub3QgbmVlZCBhbnkgYWRkaXRpb25h
bCB2YXJpYWJsZXMuICBJcyB0aGVyZQo+IG5vIHNpbXBsZXIgc29sdXRpb24/CgpJIHNlbnQgIltQ
QVRDSCBuZXQgVjIgMS8yXSBheDI1OiBGaXggcmVmY291bnQgbGVha3MgY2F1c2VkIGJ5IGF4MjVf
Y2JfZGVsKCkiCm9uIE9uIEZyaSwgTWFyIDExLCAyMDIyLiBDb3VsZCB0aGlzIHBhdGNoIHNvbHZl
IHlvdXIgcXVlc3Rpb24/CgpCZXN0IHdpc2hlcywKRHVvbWluZyBaaG91CgoK
