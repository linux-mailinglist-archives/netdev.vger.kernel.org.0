Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101EE570E9C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiGLAId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiGLAIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:08:30 -0400
Received: from azure-sdnproxy-1.icoremail.net (azure-sdnproxy.icoremail.net [52.187.6.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A8A583F32B;
        Mon, 11 Jul 2022 17:08:26 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Tue, 12 Jul 2022 08:08:12
 +0800 (GMT+08:00)
X-Originating-IP: [218.12.17.87]
Date:   Tue, 12 Jul 2022 08:08:12 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220711104949.3de90fc5@kernel.org>
References: <56319300.38660.181e861b71b.Coremail.duoming@zju.edu.cn>
 <20220711104949.3de90fc5@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <43096493.3daca.181efbc1f66.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgCHz1ttu8xiA3RGAA--.6928W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgcIAVZdtan97gAPsH
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

SGVsbG8sCgpPbiBNb24sIDExIEp1bCAyMDIyIDEwOjQ5OjQ5IC0wNzAwIEpha3ViIEtpY2luc2tp
IHdyb3RlOgoKPiBVbnJlbGF0ZWQgdG8gdGhpcyBwYXJ0aWN1bGFyIHBhdGNoLCBidXQgaXQgc2Vl
bXMgbGlrZSB5b3UncmUgd29ya2luZwo+IGEgbG90IG9uIEFGX1JPU0UsIHdvdWxkIHlvdSBjb25z
aWRlciBhZGRpbmcgYSBnb29kIHNldCBvZiBzZWxmdGVzdHMgCj4gZm9yIGl0PyAgSXQnZCBiZSBl
YXNpZXIgdG8geW91IHRvIHZhbGlkYXRlIHRoZSBjaGFuZ2VzIGFuZCBtdWNoIGVhc2llcgo+IGZv
ciB1cyB0byB0cnVzdCB0aGUgZml4ZXMgc2VlaW5nIGhvdyB0aGV5IHdlcmUgdmFsaWRhdGVkLgoK
VGhhbmsgeW91IGZvciB5b3VyIHJlcGx5LCBJIHdpbGwgdHJ5IHRvIHByb3ZpZGUgYSBzZXQgb2Yg
c2VsZnRlc3RzLgoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3U=
