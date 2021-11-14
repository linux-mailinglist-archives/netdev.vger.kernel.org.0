Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A8744F812
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 14:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhKNN1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 08:27:30 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:5768 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236073AbhKNN1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 08:27:24 -0500
Received: by ajax-webmail-mail-app3 (Coremail) ; Sun, 14 Nov 2021 21:24:12
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.20.230]
Date:   Sun, 14 Nov 2021 21:24:12 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     syzbot <syzbot+b6cb97f812986fb71e8f@syzkaller.appspotmail.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in sixpack_close
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <000000000000c23f1405d0bf86d6@google.com>
References: <000000000000c23f1405d0bf86d6@google.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2cbb6ca9.18d301.17d1e9ea1d8.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgBXV2z9DZFhOWgbCA--.18531W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUCElNG3ElR6gAqsH
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWUCw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I3N5eiBmaXg6IGhhbXJhZGlvOiByZW1vdmUgbmVlZHNfZnJlZV9uZXRkZXYgdG8gYXZvaWQgVUFG
CgpsaW5rOiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9u
ZXRkZXYvbmV0LmdpdC9jb21taXQvP2lkPTgxYjFkNTQ4ZDAwYgoKQmVzdCBSZWdhcmRzCkxpbg==

