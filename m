Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2796459707F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbiHQOGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239856AbiHQOGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:06:23 -0400
X-Greylist: delayed 5182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Aug 2022 07:06:15 PDT
Received: from zg8tmtm4lje5ny4xodqumjaa.icoremail.net (zg8tmtm4lje5ny4xodqumjaa.icoremail.net [138.197.184.20])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 954F5CE6;
        Wed, 17 Aug 2022 07:06:14 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Wed, 17 Aug 2022 22:05:37
 +0800 (GMT+08:00)
X-Originating-IP: [106.117.76.235]
Date:   Wed, 17 Aug 2022 22:05:37 +0800 (GMT+08:00)
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
In-Reply-To: <YvzicURy8t2JdQke@kroah.com>
References: <cover.1660739276.git.duoming@zju.edu.cn>
 <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
 <YvzicURy8t2JdQke@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <176e7de7.8a223.182ac1fbc47.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgAXq92y9fxiCAIaAw--.19097W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgAFAVZdtbEncgAGsa
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBXZWQsIDE3IEF1ZyAyMDIyIDE0OjQzOjI5ICswMjAwIEdyZWcgS0ggd3JvdGU6
Cgo+IE9uIFdlZCwgQXVnIDE3LCAyMDIyIGF0IDA4OjM5OjEyUE0gKzA4MDAsIER1b21pbmcgWmhv
dSB3cm90ZToKPiA+IFRoZSBkZXZfY29yZWR1bXB2KCkgYW5kIGRldl9jb3JlZHVtcG0oKSBjb3Vs
ZCBub3QgYmUgdXNlZCBpbiBhdG9taWMKPiA+IGNvbnRleHQsIGJlY2F1c2UgdGhleSBjYWxsIGt2
YXNwcmludGZfY29uc3QoKSBhbmQga3N0cmR1cCgpIHdpdGgKPiA+IEdGUF9LRVJORUwgcGFyYW1l
dGVyLiBUaGUgcHJvY2VzcyBpcyBzaG93biBiZWxvdzoKPiA+IAo+ID4gZGV2X2NvcmVkdW1wdigu
LiwgZ2ZwX3QgZ2ZwKQo+ID4gICBkZXZfY29yZWR1bXBtKC4uLCBnZnBfdCBnZnApCj4gPiAgICAg
ZGV2X3NldF9uYW1lCj4gPiAgICAgICBrb2JqZWN0X3NldF9uYW1lX3ZhcmdzCj4gPiAgICAgICAg
IGt2YXNwcmludGZfY29uc3QoR0ZQX0tFUk5FTCwgLi4uKTsgLy9tYXkgc2xlZXAKPiA+ICAgICAg
ICAgICBrc3RyZHVwKHMsIEdGUF9LRVJORUwpOyAvL21heSBzbGVlcAo+ID4gCj4gPiBUaGlzIHBh
dGNoIHJlbW92ZXMgZ2ZwX3QgcGFyYW1ldGVyIG9mIGRldl9jb3JlZHVtcHYoKSBhbmQgZGV2X2Nv
cmVkdW1wbSgpCj4gPiBhbmQgY2hhbmdlcyB0aGUgZ2ZwX3QgcGFyYW1ldGVyIG9mIGt6YWxsb2Mo
KSBpbiBkZXZfY29yZWR1bXBtKCkgdG8KPiA+IEdGUF9LRVJORUwgaW4gb3JkZXIgdG8gc2hvdyB0
aGV5IGNvdWxkIG5vdCBiZSB1c2VkIGluIGF0b21pYyBjb250ZXh0Lgo+ID4gCj4gPiBGaXhlczog
ODMzYzk1NDU2YTcwICgiZGV2aWNlIGNvcmVkdW1wOiBhZGQgbmV3IGRldmljZSBjb3JlZHVtcCBj
bGFzcyIpCj4gPiBSZXZpZXdlZC1ieTogQnJpYW4gTm9ycmlzIDxicmlhbm5vcnJpc0BjaHJvbWl1
bS5vcmc+Cj4gPiBSZXZpZXdlZC1ieTogSm9oYW5uZXMgQmVyZyA8am9oYW5uZXNAc2lwc29sdXRp
b25zLm5ldD4KPiA+IFNpZ25lZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1
LmNuPgo+ID4gLS0tCj4gPiBDaGFuZ2VzIGluIHY3Ogo+ID4gICAtIFJlbW92ZSBnZnBfdCBmbGFn
IGluIGFtZGdwdSBkZXZpY2UuCj4gCj4gQWdhaW4sIHRoaXMgY3JlYXRlcyBhICJmbGFnIGRheSIg
d2hlcmUgd2UgaGF2ZSB0byBiZSBzdXJlIHdlIGhpdCBhbGwKPiB1c2VycyBvZiB0aGlzIGFwaSBh
dCB0aGUgZXhhY3Qgc2FtZSB0aW1lLiAgVGhpcyB3aWxsIHByZXZlbnQgYW55IG5ldwo+IGRyaXZl
ciB0aGF0IGNvbWVzIGludG8gYSBtYWludGFpbmVyIHRyZWUgZHVyaW5nIHRoZSBuZXh0IDMgbW9u
dGhzIGZyb20KPiBldmVyIGJlaW5nIGFibGUgdG8gdXNlIHRoaXMgYXBpIHdpdGhvdXQgY2F1aW5n
IGJ1aWxkIGJyZWFrYWdlcyBpbiB0aGUKPiBsaW51eC1uZXh0IHRyZWUuCj4gCj4gUGxlYXNlIGV2
b2x2ZSB0aGlzIGFwaSB0byB3b3JrIHByb3Blcmx5IGZvciBldmVyeW9uZSBhdCB0aGUgc2FtZSB0
aW1lLAo+IGxpa2Ugd2FzIHByZXZpb3VzbHkgYXNrZWQgZm9yIHNvIHRoYXQgd2UgY2FuIHRha2Ug
dGhpcyBjaGFuZ2UuICBJdCB3aWxsCj4gdGFrZSAyIHJlbGVhc2VzLCBidXQgdGhhdCdzIGZpbmUu
CgpUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHksIEkgd2lsbCBldm9sdmUgdGhpcyBhcGkgdG8gd29y
ayBwcm9wZXJseSBmb3IgZXZlcnlvbmUuCklmIHRoZXJlIGFyZSBub3QgYW55IG5ldyBkcml2ZXJz
IHRoYXQgdXNlIHRoaXMgYXBpIGR1cmluZyB0aGUgbmV4dCAzIG1vbnRocywgCkkgd2lsbCBzZW5k
IHRoaXMgcGF0Y2ggYWdhaW4uIE90aGVyd2lzZSwgSSB3aWxsIHdhaXQgdW50aWwgdGhlcmUgYXJl
IG5vdCBuZXcKdXNlcnMgYW55bW9yZS4KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91Cgo=
