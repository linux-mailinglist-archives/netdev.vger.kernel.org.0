Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE9852A168
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 14:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbiEQMYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 08:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243673AbiEQMYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 08:24:42 -0400
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C45B647047;
        Tue, 17 May 2022 05:24:38 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 17 May 2022 20:24:35
 +0800 (GMT+08:00)
X-Originating-IP: [124.236.130.193]
Date:   Tue, 17 May 2022 20:24:35 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] NFC: hci: fix sleep in atomic context bugs in
 nfc_hci_hcp_message_tx
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <171c13bb-9fc9-0807-e872-6859dfa2603d@linaro.org>
References: <20220516021028.54063-1-duoming@zju.edu.cn>
 <d5fdfe27-a6de-3030-ce51-9f4f45d552f3@linaro.org>
 <6aba1413.196eb.180cc609bf1.Coremail.duoming@zju.edu.cn>
 <ea2af2f9-002a-5681-4293-a05718ce9dcd@linaro.org>
 <fc6a78c.196ab.180d1a98cc9.Coremail.duoming@zju.edu.cn>
 <171c13bb-9fc9-0807-e872-6859dfa2603d@linaro.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <147574ae.199bb.180d1fa2bba.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDXQCADlINiGyFbAA--.8584W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgcNAVZdtZvEjQAAsl
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

SGVsbG8sCgpPbiBUdWUsIDE3IE1heSAyMDIyIDEzOjM5OjQ0ICswMjAwIHdyb3RlOgoKPiBZb3Ug
c2VudCB2MiBvbmUgbWludXRlIGJlZm9yZSByZXBseWluZyBoZXJlLi4uIHRoYXQncyBub3QgaG93
IGRpc2N1c3Npb24KPiB3b3JrLiBQbGVhc2UgZG8gbm90IHNlbnQgbmV4dCB2ZXJzaW9uIGJlZm9y
ZSByZWFjaGluZyBzb21lIGNvbnNlbnN1cy4KCkkgYW0gc29ycnkuIEJlZm9yZSByZWFjaGluZyBz
b21lIGNvbnNlbnN1cywgSSB3aWxsIG5vdCBzZW5kIG5leHQgdmVyc2lvbiBpbiB0aGUgZnV0dXJl
LgpUaGFua3MgZm9yIHlvdXIgZ3VpZGFuY2UuCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQo=

