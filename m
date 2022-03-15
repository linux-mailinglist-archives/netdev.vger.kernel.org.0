Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508754D9DA6
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349232AbiCOOfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349180AbiCOOfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:35:11 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65EE227FED;
        Tue, 15 Mar 2022 07:33:57 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 15 Mar 2022 22:33:44
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.64.209]
Date:   Tue, 15 Mar 2022 22:33:44 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de, thomas@osterried.de
Subject: Re: Re: Re: [PATCH net V4 1/2] ax25: Fix refcount leaks caused by
 ax25_cb_del()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220315141905.GB1841@kadam>
References: <20220315015403.79201-1-duoming@zju.edu.cn>
 <20220315102657.GX3315@kadam>
 <15e4111b.5339.17f8deb1f24.Coremail.duoming@zju.edu.cn>
 <20220315141905.GB1841@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3c2e97d4.5434.17f8dffc573.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBnLrDIozBiK_UWAA--.2953W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgcKAVZdtYsBQgABs5
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

SGVsbG8sCgpPbiBUdWUsIDE1IE1hciAyMDIyIDE3OjE5OjA1ICswMzAwLCBEYW4gQ2FycGVudGVy
IHdyb3RlOgoKPiBTbyB0aGUgdjMgcGF0Y2ggd2FzIGJ1Z2d5PwpJIHRoaW5rIHYzIGlzIG5vdCBh
IGdvb2QgcGF0Y2ggdGhhdCBjb3VsZCBiZSBhcHBsaWVkIGluIHRoZSByZWFsIHdvcmxkLgoKPiBX
aHkgd2FzIHRoaXMgbm90IGV4cGxhaW5lZCB1bmRlciB0aGUgLS0tIGN1dCBvZmYgbGluZT8KCkkg
d2lsbCBhZGQgZXhwbGFuYXRpb24gdW5kZXIgdGhlIC0tLSBjdXQgb2ZmIGxpbmUgaW4gW1BBVENI
IG5ldCBWNSAxLzJdCmFuZCBzZW5kIGl0IHRvIHlvdSBhcyBzb29uIGFzIHBvc3NpYmxlLgoKQmVz
dCB3aXNoZXMsCkR1b21pbmcgWmhvdQ==
