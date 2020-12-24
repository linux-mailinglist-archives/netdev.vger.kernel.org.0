Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37FD2E25E7
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 11:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgLXKRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 05:17:40 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:50774 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbgLXKRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 05:17:40 -0500
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 24 Dec 2020 18:16:22
 +0800 (GMT+08:00)
X-Originating-IP: [210.32.144.176]
Date:   Thu, 24 Dec 2020 18:16:22 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     kjlu@umn.edu, "Christian Benvenuti" <benve@cisco.com>,
        "Govindarajulu Varadarajan" <_govind@gmx.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] enic: Remove redundant free in enic_set_ringparam
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <20201223123747.6f506068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201223123833.14733-1-dinghao.liu@zju.edu.cn>
 <20201223123747.6f506068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <53493c26.15.176943fe01d.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBH3jl2auRfCgMAAA--.1W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgsEBlZdtRrfowABsS
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIDIzIERlYyAyMDIwIDIwOjM4OjMzICswODAwIERpbmdoYW8gTGl1IHdyb3RlOgo+
ID4gVGhlIGVycm9yIGhhbmRsaW5nIHBhdGhzIGluIGVuaWNfYWxsb2Nfdm5pY19yZXNvdXJjZXMo
KQo+ID4gaGF2ZSBjYWxsZWQgZW5pY19mcmVlX3ZuaWNfcmVzb3VyY2VzKCkgYmVmb3JlIHJldHVy
bmluZy4KPiA+IFNvIHdlIG1heSBub3QgbmVlZCB0byBjYWxsIGl0IGFnYWluIG9uIGZhaWx1cmUg
YXQgY2FsbGVyCj4gPiBzaWRlLgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBEaW5naGFvIExpdSA8
ZGluZ2hhby5saXVAemp1LmVkdS5jbj4KPiAKPiBCdXQgaXQncyBoYXJtbGVzcywgcmlnaHQ/IFNv
IHRoZSBwYXRjaCBpcyBqdXN0IGEgY2xlYW51cCBub3QgYSBmaXg/Cj4gCgpJIHRoaW5rIGl0J3Mg
aGFybWxlc3MuIFNpbmNlIHRoZXJlIGlzIGEgY2hlY2sgZXZlcnkgdGltZSBiZWZvcmUgZnJlZWlu
ZywKY2FsbGluZyBlbmljX2ZyZWVfdm5pY19yZXNvdXJjZXMoKSB0d2ljZSBoYXMgbm8gc2VjdXJp
dHkgaXNzdWUuCgo+IEluIHRoYXQgY2FzZSwgY291bGQgeW91IHBsZWFzZSByZXBvc3QgaW4gdHdv
IHdlZWtzPyBXZSdyZSBjdXJyZW50bHkgCj4gaW4gdGhlIG1lcmdlIHdpbmRvdyBwZXJpb2QsIHdl
J3JlIG9ubHkgYWNjZXB0aW5nIGZpeGVzIHRvIHRoZQo+IG5ldHdvcmtpbmcgdHJlZXMuCj4gCj4g
VGhhbmtzIQoK
