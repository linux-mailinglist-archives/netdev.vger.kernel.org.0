Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71340522CE8
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242678AbiEKHMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240092AbiEKHMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:12:18 -0400
Received: from m1522.mail.126.com (m1522.mail.126.com [220.181.15.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAD8A35DE0;
        Wed, 11 May 2022 00:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=Y8zV7
        PXORuA9nN9QPcuaH/lRC0O+rCPtTltbZG+YlqA=; b=BCpc8HuV6usJKMz0mN4Pl
        54/AeMXrkp9f98AxOuFAHEt2dPTeYUdfrQyn0L2ivzDRSN/bocdVO2d2n/ffKQIJ
        4mOqn/tZGjdBtVXRtEikwerDaUUPQS8BGGsLDXApAvKdiWxsqvf45HMFEpoXmSzG
        mCFL3zoycXdNRQdvqwqVA0=
Received: from zhaojunkui2008$126.com ( [58.213.83.157] ) by
 ajax-webmail-wmsvr22 (Coremail) ; Wed, 11 May 2022 15:11:34 +0800 (CST)
X-Originating-IP: [58.213.83.157]
Date:   Wed, 11 May 2022 15:11:34 +0800 (CST)
From:   z <zhaojunkui2008@126.com>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc:     "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        "Vincent Mailhol" <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bernard@vivo.com
Subject: Re:Re: [PATCH] usb/peak_usb: cleanup code
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220511064450.phisxc7ztcc3qkpj@pengutronix.de>
References: <20220511063850.649012-1-zhaojunkui2008@126.com>
 <20220511064450.phisxc7ztcc3qkpj@pengutronix.de>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4986975d.3de3.180b1f57189.Coremail.zhaojunkui2008@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: FsqowABHVmKnYXtinUMpAA--.1492W
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiYAP9qlpEHUayngACsf
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjItMDUtMTEgMTQ6NDQ6NTAsICJNYXJjIEtsZWluZS1CdWRkZSIgPG1rbEBwZW5ndXRy
b25peC5kZT4gd3JvdGU6Cj5PbiAxMC4wNS4yMDIyIDIzOjM4OjM4LCBCZXJuYXJkIFpoYW8gd3Jv
dGU6Cj4+IFRoZSB2YXJpYWJsZSBmaSBhbmQgYmkgb25seSB1c2VkIGluIGJyYW5jaCBpZiAoIWRl
di0+cHJldl9zaWJsaW5ncykKPj4gLCBmaSAmIGJpIG5vdCBrbWFsbG9jIGluIGVsc2UgYnJhbmNo
LCBzbyBtb3ZlIGtmcmVlIGludG8gYnJhbmNoCj4+IGlmICghZGV2LT5wcmV2X3NpYmxpbmdzKSx0
aGlzIGNoYW5nZSBpcyB0byBjbGVhbnVwIHRoZSBjb2RlIGEgYml0Lgo+Cj5QbGVhc2UgbW92ZSB0
aGUgdmFyaWFibGUgZGVjbGFyYXRpb24gaW50byB0aGF0IHNjb3BlLCB0b28uIEFkanVzdCB0aGUK
PmVycm9yIGhhbmRsaW5nIGFjY29yZGluZ2x5LgoKSGkgTWFyYzoKCkkgYW0gbm90IHN1cmUgaWYg
dGhlcmUgaXMgc29tZSBnYXAuCklmIHdlIG1vdmUgdGhlIHZhcmlhYmxlIGRlY2xhcmF0aW9uIGlu
dG8gdGhhdCBzY29wZSwgdGhlbiBlYWNoIGVycm9yIGJyYW5jaCBoYXMgdG8gZG8gdGhlIGtmcmVl
IGpvYiwgbGlrZToKaWYgKGVycikgewoJCQlkZXZfZXJyKGRldi0+bmV0ZGV2LT5kZXYucGFyZW50
LAoJCQkJInVuYWJsZSB0byByZWFkICVzIGZpcm13YXJlIGluZm8gKGVyciAlZClcbiIsCgkJCQlw
Y2FuX3VzYl9wcm8ubmFtZSwgZXJyKTsKCSAgICAgICAgICAgICAgICBrZnJlZShiaSk7CgkgICAg
ICAgICAgICAgICAga2ZyZWUoZmkpOwoJICAgICAgICAgICAgICAgIGtmcmVlKHVzYl9pZik7CgoJ
ICAgICAgICAgICAgICAgcmV0dXJuIGVycjsKCQl9CkkgYW0gbm90IHN1cmUgaWYgdGhpcyBsb29r
cyBhIGxpdHRsZSBsZXNzIGNsZWFyPwpUaGFua3MhCgpCUi8vQmVybmFyZAo+Cj5yZWdhcmRzLAo+
TWFyYwo+Cj4tLSAKPlBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVp
bmUtQnVkZGUgICAgICAgICAgIHwKPkVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwg
aHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwKPlZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVuZCAg
ICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwKPkFtdHNnZXJpY2h0IEhpbGRl
c2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwK
