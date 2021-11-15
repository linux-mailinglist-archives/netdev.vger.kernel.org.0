Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945C84507B3
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbhKOPBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:01:06 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:29718 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232119AbhKOPAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 10:00:30 -0500
Received: by ajax-webmail-mail-app4 (Coremail) ; Mon, 15 Nov 2021 22:57:26
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.20.230]
Date:   Mon, 15 Nov 2021 22:57:26 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, jirislaby@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: CHANGELOG: [PATCH v1] NFC: reorganize the functions in nci_request
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <20211115145600.8320-1-linma@zju.edu.cn>
References: <20211115145600.8320-1-linma@zju.edu.cn>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <60e40977.194e9f.17d241a5ad5.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgCX3a1XdZJhNnYQBQ--.12618W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwQKElNG3ErBXAAGsH
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgdGhlcmUsCgpDb21wYXJlZCB0byB0aGUgdmVyc2lvbi0wIHBhdGNoLCB0aGlzIHBhdGNoIGFk
ZCBmaXhlcyB0YWcgaW4gdGhlIHBhdGNoIGZpbGUKCisgRml4ZXM6IDZhMjk2OGFhZjUwYyAoIk5G
QzogYmFzaWMgTkNJIHByb3RvY29sIGltcGxlbWVudGF0aW9uIikKCgpCZXN0IHJlZ2FyZHMKTGlu

