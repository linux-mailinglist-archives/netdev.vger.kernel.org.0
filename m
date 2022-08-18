Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28595987C0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343503AbiHRPrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245479AbiHRPrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:47:19 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BDE4BA177;
        Thu, 18 Aug 2022 08:47:16 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 18 Aug 2022 23:46:39
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.71.149]
Date:   Thu, 18 Aug 2022 23:46:39 +0800 (GMT+08:00)
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
Subject: Re: [PATCH v7 1/2] devcoredump: remove the useless gfp_t parameter
 in dev_coredumpv and dev_coredumpm
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <Yv5TefZcrUPY1Qjc@kroah.com>
References: <cover.1660739276.git.duoming@zju.edu.cn>
 <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
 <YvzicURy8t2JdQke@kroah.com>
 <176e7de7.8a223.182ac1fbc47.Coremail.duoming@zju.edu.cn>
 <Yv5TefZcrUPY1Qjc@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <5108e03b.8c156.182b1a2973f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgAXq93fXv5iIk46Aw--.19845W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgsGAVZdtbFbYQAAs7
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

SGVsbG8sCgpPbiBUaHUsIDE4IEF1ZyAyMDIyIDE2OjU4OjAxICswMjAwIEdyZWcgS0ggd3JvdGU6
Cgo+IE9uIFdlZCwgQXVnIDE3LCAyMDIyIGF0IDEwOjA1OjM3UE0gKzA4MDAsIGR1b21pbmdAemp1
LmVkdS5jbiB3cm90ZToKPiA+IEhlbGxvLAo+ID4gCj4gPiBPbiBXZWQsIDE3IEF1ZyAyMDIyIDE0
OjQzOjI5ICswMjAwIEdyZWcgS0ggd3JvdGU6Cj4gPiAKPiA+ID4gT24gV2VkLCBBdWcgMTcsIDIw
MjIgYXQgMDg6Mzk6MTJQTSArMDgwMCwgRHVvbWluZyBaaG91IHdyb3RlOgo+ID4gPiA+IFRoZSBk
ZXZfY29yZWR1bXB2KCkgYW5kIGRldl9jb3JlZHVtcG0oKSBjb3VsZCBub3QgYmUgdXNlZCBpbiBh
dG9taWMKPiA+ID4gPiBjb250ZXh0LCBiZWNhdXNlIHRoZXkgY2FsbCBrdmFzcHJpbnRmX2NvbnN0
KCkgYW5kIGtzdHJkdXAoKSB3aXRoCj4gPiA+ID4gR0ZQX0tFUk5FTCBwYXJhbWV0ZXIuIFRoZSBw
cm9jZXNzIGlzIHNob3duIGJlbG93Ogo+ID4gPiA+IAo+ID4gPiA+IGRldl9jb3JlZHVtcHYoLi4s
IGdmcF90IGdmcCkKPiA+ID4gPiAgIGRldl9jb3JlZHVtcG0oLi4sIGdmcF90IGdmcCkKPiA+ID4g
PiAgICAgZGV2X3NldF9uYW1lCj4gPiA+ID4gICAgICAga29iamVjdF9zZXRfbmFtZV92YXJncwo+
ID4gPiA+ICAgICAgICAga3Zhc3ByaW50Zl9jb25zdChHRlBfS0VSTkVMLCAuLi4pOyAvL21heSBz
bGVlcAo+ID4gPiA+ICAgICAgICAgICBrc3RyZHVwKHMsIEdGUF9LRVJORUwpOyAvL21heSBzbGVl
cAo+ID4gPiA+IAo+ID4gPiA+IFRoaXMgcGF0Y2ggcmVtb3ZlcyBnZnBfdCBwYXJhbWV0ZXIgb2Yg
ZGV2X2NvcmVkdW1wdigpIGFuZCBkZXZfY29yZWR1bXBtKCkKPiA+ID4gPiBhbmQgY2hhbmdlcyB0
aGUgZ2ZwX3QgcGFyYW1ldGVyIG9mIGt6YWxsb2MoKSBpbiBkZXZfY29yZWR1bXBtKCkgdG8KPiA+
ID4gPiBHRlBfS0VSTkVMIGluIG9yZGVyIHRvIHNob3cgdGhleSBjb3VsZCBub3QgYmUgdXNlZCBp
biBhdG9taWMgY29udGV4dC4KPiA+ID4gPiAKPiA+ID4gPiBGaXhlczogODMzYzk1NDU2YTcwICgi
ZGV2aWNlIGNvcmVkdW1wOiBhZGQgbmV3IGRldmljZSBjb3JlZHVtcCBjbGFzcyIpCj4gPiA+ID4g
UmV2aWV3ZWQtYnk6IEJyaWFuIE5vcnJpcyA8YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnPgo+ID4g
PiA+IFJldmlld2VkLWJ5OiBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0
Pgo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNu
Pgo+ID4gPiA+IC0tLQo+ID4gPiA+IENoYW5nZXMgaW4gdjc6Cj4gPiA+ID4gICAtIFJlbW92ZSBn
ZnBfdCBmbGFnIGluIGFtZGdwdSBkZXZpY2UuCj4gPiA+IAo+ID4gPiBBZ2FpbiwgdGhpcyBjcmVh
dGVzIGEgImZsYWcgZGF5IiB3aGVyZSB3ZSBoYXZlIHRvIGJlIHN1cmUgd2UgaGl0IGFsbAo+ID4g
PiB1c2VycyBvZiB0aGlzIGFwaSBhdCB0aGUgZXhhY3Qgc2FtZSB0aW1lLiAgVGhpcyB3aWxsIHBy
ZXZlbnQgYW55IG5ldwo+ID4gPiBkcml2ZXIgdGhhdCBjb21lcyBpbnRvIGEgbWFpbnRhaW5lciB0
cmVlIGR1cmluZyB0aGUgbmV4dCAzIG1vbnRocyBmcm9tCj4gPiA+IGV2ZXIgYmVpbmcgYWJsZSB0
byB1c2UgdGhpcyBhcGkgd2l0aG91dCBjYXVpbmcgYnVpbGQgYnJlYWthZ2VzIGluIHRoZQo+ID4g
PiBsaW51eC1uZXh0IHRyZWUuCj4gPiA+IAo+ID4gPiBQbGVhc2UgZXZvbHZlIHRoaXMgYXBpIHRv
IHdvcmsgcHJvcGVybHkgZm9yIGV2ZXJ5b25lIGF0IHRoZSBzYW1lIHRpbWUsCj4gPiA+IGxpa2Ug
d2FzIHByZXZpb3VzbHkgYXNrZWQgZm9yIHNvIHRoYXQgd2UgY2FuIHRha2UgdGhpcyBjaGFuZ2Uu
ICBJdCB3aWxsCj4gPiA+IHRha2UgMiByZWxlYXNlcywgYnV0IHRoYXQncyBmaW5lLgo+ID4gCj4g
PiBUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHksIEkgd2lsbCBldm9sdmUgdGhpcyBhcGkgdG8gd29y
ayBwcm9wZXJseSBmb3IgZXZlcnlvbmUuCj4gPiBJZiB0aGVyZSBhcmUgbm90IGFueSBuZXcgZHJp
dmVycyB0aGF0IHVzZSB0aGlzIGFwaSBkdXJpbmcgdGhlIG5leHQgMyBtb250aHMsIAo+ID4gSSB3
aWxsIHNlbmQgdGhpcyBwYXRjaCBhZ2Fpbi4gT3RoZXJ3aXNlLCBJIHdpbGwgd2FpdCB1bnRpbCB0
aGVyZSBhcmUgbm90IG5ldwo+ID4gdXNlcnMgYW55bW9yZS4KPiAKPiBObywgdGhhdCBpcyBub3Qg
bmVjZXNzYXJ5LiAgRG8gdGhlIHdvcmsgbm93IHNvIHRoYXQgdGhlcmUgaXMgbm8gZmxhZyBkYXkK
PiBhbmQgeW91IGRvbid0IGhhdmUgdG8gd29ycnkgYWJvdXQgbmV3IHVzZXJzLCBpdCB3aWxsIGFs
bCAianVzdCB3b3JrIi4KCkRvIHlvdSBtZWFuIHdlIHNob3VsZCByZXBsYWNlIGRldl9zZXRfbmFt
ZSgpIGluIGRldl9jb3JlZHVtcG0oKSB0byBzb21lIG90aGVyCmZ1bmN0aW9ucyB0aGF0IGNvdWxk
IHdvcmsgYm90aCBpbiBpbnRlcnJ1cHQgY29udGV4dCBhbmQgcHJvY2VzcyBjb250ZXh0PwoKQmVz
dCByZWdhcmRzLApEdW9taW5nIFpob3UK
