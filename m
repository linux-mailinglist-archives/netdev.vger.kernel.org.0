Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671BC550F1F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 05:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbiFTD6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 23:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiFTD6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 23:58:17 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2892614C;
        Sun, 19 Jun 2022 20:58:10 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Mon, 20 Jun 2022 11:57:52
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.65.49]
Date:   Mon, 20 Jun 2022 11:57:52 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        rafael@kernel.org
Subject: Re: [PATCH v6 0/2] Remove useless param of devcoredump functions
 and fix bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YqNGB5VitXvBWzzp@kroah.com>
References: <cover.1654569290.git.duoming@zju.edu.cn>
 <YqNGB5VitXvBWzzp@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4c993f12.7b2b2.1817f427cf7.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgA3GeJA8K9ilXkzAg--.258W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkHAVZdtaS5igABsl
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

SGVsbG8gbWFpbnRhaW5lcnMsCgpUaGlzIHBhdGNoIHNldCBoYXMgYmVlbiByZXZpZXdlZCBieSBK
b2hhbm5lcyBCZXJnIGFuZCBCcmlhbiBOb3JyaXMsCmJ1dCBpdCBoYXMgbm90IGJlZW4gYWNjZXB0
ZWQgeWV0LiBEbyBJIG5lZWQgdG8gZG8gYW55IGV4dHJhIHdvcms/CgpUaGFuayB5b3UgZm9yIHlv
dXIgdGltZSEKCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91
