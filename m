Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24356E88A1
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 05:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjDTDY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 23:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDTDYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 23:24:54 -0400
Received: from m13131.mail.163.com (m13131.mail.163.com [220.181.13.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03C4840CF;
        Wed, 19 Apr 2023 20:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=hE7fiZj3s4txMs2vS8mzctsLg98BwRhMA64GtdDveFM=; b=N
        Otw+RzfKKaHELQECPJUnHwYaRXoc5+BTAQ5D1ce9hhSuZ5ebzX5Tlzq0TgaQm1ah
        K/iqw/xIf3pejr2ZCKp4NRqEdlXzqwUKeAZuCVJZU38x+B1ap5QOyNqiFNR1E69+
        qSzdnq24eVX4sWstxu8TkEPb7cN/Sc62n/jgGYZaT4=
Received: from slark_xiao$163.com ( [112.97.49.85] ) by
 ajax-webmail-wmsvr131 (Coremail) ; Thu, 20 Apr 2023 11:23:31 +0800 (CST)
X-Originating-IP: [112.97.49.85]
Date:   Thu, 20 Apr 2023 11:23:31 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:Re: [net-next v2] wwan: core: add print for wwan port
 attach/disconnect
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
In-Reply-To: <20230419183905.5d290242@kernel.org>
References: <20230417094617.2927393-1-slark_xiao@163.com>
 <20230419183905.5d290242@kernel.org>
X-NTES-SC: AL_QuyTA/Wdvkgq5yifbekXnkoShO85W8a1s/0m3INTOZ00hyv80AINQ19FPknE9vyPDRuDkDixQihV8cNKRpFVY6Mw0szE5fE0YJTKSLFMTp49
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <336b60ba.ff1.1879cb04aa9.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: g8GowAAnL2czsEBkfAIFAA--.26535W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDQhXZFaEN4sxyAABsg
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKQXQgMjAyMy0wNC0yMCAwOTozOTowNSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToKPk9uIE1vbiwgMTcgQXByIDIwMjMgMTc6NDY6MTcgKzA4MDAgU2xhcmsgWGlh
byB3cm90ZToKPj4gUmVmZXIgdG8gVVNCIHNlcmlhbCBkZXZpY2Ugb3IgbmV0IGRldmljZSwgdGhl
cmUgaXMgYSBub3RpY2UgdG8KPj4gbGV0IGVuZCB1c2VyIGtub3cgdGhlIHN0YXR1cyBvZiBkZXZp
Y2UsIGxpa2UgYXR0YWNoZWQgb3IKPj4gZGlzY29ubmVjdGVkLiBBZGQgYXR0YWNoL2Rpc2Nvbm5l
Y3QgcHJpbnQgZm9yIHd3YW4gZGV2aWNlIGFzCj4+IHdlbGwuCj4+IAo+PiBTaWduZWQtb2ZmLWJ5
OiBTbGFyayBYaWFvIDxzbGFya194aWFvQDE2My5jb20+Cj4KPlBhdGNoIG5ldmVyIG1hZGUgaXQg
dG8gdGhlIGxpc3Q6Cj4KPmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMzA0MTcwOTQ2MTcu
MjkyNzM5My0xLXNsYXJrX3hpYW9AMTYzLmNvbS8KPgo+OiggQ291bGQgeW91IHJlc2VuZD8KU2Vu
ZCBhZ2Fpbi4gUHJldmlvdXMgZW1haWwgc2VudCB0byBuZXRkZXYgYW5kIGxpbmsta2VybmVsIGZh
aWxlZCB3aXRoIHVua25vd24gcmVhc29uLg==
