Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B30522EB4
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241947AbiEKIsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243938AbiEKIsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:48:11 -0400
Received: from m1522.mail.126.com (m1522.mail.126.com [220.181.15.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27C74166440;
        Wed, 11 May 2022 01:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=VZ+03
        3rjL5WXbFMVjEGjHKVe/trY65VZ5/Yvfg3b3Sc=; b=HoGhgh4SdNTfJk8WFgS0E
        tMWY/Iz74e0uNnGiWuJYxhToAsS0QYZ1b5OYVpAP8UU+XrDcKUlTMDXoS97nO3uP
        0MRDS/qlHnAiWuQ1AX1eaRDsXNW8EIAeDRiG6X3NMBoTsuqGA56ShbT+CtVNjxPI
        qo1AbvKUTLN4om3fBU4LvQ=
Received: from zhaojunkui2008$126.com ( [112.80.34.205] ) by
 ajax-webmail-wmsvr22 (Coremail) ; Wed, 11 May 2022 16:46:37 +0800 (CST)
X-Originating-IP: [112.80.34.205]
Date:   Wed, 11 May 2022 16:46:37 +0800 (CST)
From:   z <zhaojunkui2008@126.com>
To:     "Vincent MAILHOL" <mailhol.vincent@wanadoo.fr>
Cc:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bernard@vivo.com
Subject: Re:Re: Re: [PATCH] usb/peak_usb: cleanup code
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <CAMZ6RqKHs4gdcNjVONfOTsHh6ZFEt0qpbEaKqDM7c1Cbc1OLdQ@mail.gmail.com>
References: <20220511063850.649012-1-zhaojunkui2008@126.com>
 <20220511064450.phisxc7ztcc3qkpj@pengutronix.de>
 <4986975d.3de3.180b1f57189.Coremail.zhaojunkui2008@126.com>
 <CAMZ6RqKHs4gdcNjVONfOTsHh6ZFEt0qpbEaKqDM7c1Cbc1OLdQ@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1c7b223e.51b2.180b24c78b6.Coremail.zhaojunkui2008@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: FsqowABHVmLud3ti92ApAA--.2017W
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiLRn9qlpD93ryPwACs4
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkF0IDIwMjItMDUtMTEgMTY6Mjg6MjYsICJWaW5jZW50IE1BSUxIT0wiIDxtYWlsaG9sLnZpbmNl
bnRAd2FuYWRvby5mcj4gd3JvdGU6Cj5PbiBXZWQuIDExIE1heSAyMDIyIGF0IDE2OjExLCB6IDx6
aGFvanVua3VpMjAwOEAxMjYuY29tPiB3cm90ZToKPj4gQXQgMjAyMi0wNS0xMSAxNDo0NDo1MCwg
Ik1hcmMgS2xlaW5lLUJ1ZGRlIiA8bWtsQHBlbmd1dHJvbml4LmRlPiB3cm90ZToKPj4gPk9uIDEw
LjA1LjIwMjIgMjM6Mzg6MzgsIEJlcm5hcmQgWmhhbyB3cm90ZToKPj4gPj4gVGhlIHZhcmlhYmxl
IGZpIGFuZCBiaSBvbmx5IHVzZWQgaW4gYnJhbmNoIGlmICghZGV2LT5wcmV2X3NpYmxpbmdzKQo+
PiA+PiAsIGZpICYgYmkgbm90IGttYWxsb2MgaW4gZWxzZSBicmFuY2gsIHNvIG1vdmUga2ZyZWUg
aW50byBicmFuY2gKPj4gPj4gaWYgKCFkZXYtPnByZXZfc2libGluZ3MpLHRoaXMgY2hhbmdlIGlz
IHRvIGNsZWFudXAgdGhlIGNvZGUgYSBiaXQuCj4+ID4KPj4gPlBsZWFzZSBtb3ZlIHRoZSB2YXJp
YWJsZSBkZWNsYXJhdGlvbiBpbnRvIHRoYXQgc2NvcGUsIHRvby4gQWRqdXN0IHRoZQo+PiA+ZXJy
b3IgaGFuZGxpbmcgYWNjb3JkaW5nbHkuCj4+Cj4+IEhpIE1hcmM6Cj4+Cj4+IEkgYW0gbm90IHN1
cmUgaWYgdGhlcmUgaXMgc29tZSBnYXAuCj4+IElmIHdlIG1vdmUgdGhlIHZhcmlhYmxlIGRlY2xh
cmF0aW9uIGludG8gdGhhdCBzY29wZSwgdGhlbiBlYWNoIGVycm9yIGJyYW5jaCBoYXMgdG8gZG8g
dGhlIGtmcmVlIGpvYiwgbGlrZToKPj4gaWYgKGVycikgewo+PiAgICAgICAgICAgICAgICAgICAg
ICAgICBkZXZfZXJyKGRldi0+bmV0ZGV2LT5kZXYucGFyZW50LAo+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICJ1bmFibGUgdG8gcmVhZCAlcyBmaXJtd2FyZSBpbmZvIChlcnIgJWQp
XG4iLAo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBjYW5fdXNiX3Byby5uYW1l
LCBlcnIpOwo+PiAgICAgICAgICAgICAgICAgICAgICAgICBrZnJlZShiaSk7Cj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgIGtmcmVlKGZpKTsKPj4gICAgICAgICAgICAgICAgICAgICAgICAga2Zy
ZWUodXNiX2lmKTsKPj4KPj4gICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gZXJyOwo+PiAg
ICAgICAgICAgICAgICAgfQo+PiBJIGFtIG5vdCBzdXJlIGlmIHRoaXMgbG9va3MgYSBsaXR0bGUg
bGVzcyBjbGVhcj8KPj4gVGhhbmtzIQo+Cj5BIGNsZWFuZXIgd2F5IHdvdWxkIGJlIHRvIG1vdmUg
YWxsIHRoZSBjb250ZW50IG9mIHRoZSBpZgo+KCFkZXYtPnByZXZfc2libGluZ3MpIHRvIGEgbmV3
IGZ1bmN0aW9uLgoKSGkgVmluY2VudCBNYWlsaG9sOgoKR290IGl0LgpUaGlzIHNlZW1zIHRvIGJl
IGEgZ29vZCBpZGVhLCBpIHdvdWxkIHJlc3VibWl0IG9uZSBwYXRjaCBWMi4KVGhhbmtzIQoKQlIv
L0Jlcm5hcmQKPgo+WW91cnMgc2luY2VyZWx5LAo+VmluY2VudCBNYWlsaG9sCg==
