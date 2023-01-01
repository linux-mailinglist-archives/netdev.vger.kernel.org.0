Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E655865AAF0
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjAASLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 13:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjAASLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 13:11:12 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF12CCF
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 10:11:10 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id x11so20969737qtv.13
        for <netdev@vger.kernel.org>; Sun, 01 Jan 2023 10:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-language:references:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TXbJB0KMCfIlwY0ltY89Wv0goTtmbbx9NfGatobyUv4=;
        b=Ek492CvBfqtYHe0KF4LN+FtNJXqE/l2zEABU4Qhh9tTl8bi12Qx4RysQL+g+J3w0DF
         faFkjU5U1SSlJrxqMY/vkz1XlJZS3UdJMs/dGiREhhOHDGCFR1XwTaf+MIoUhqX3Gxfh
         48NxbM8yAn7iLpdXAuBZoJkwtc9ZCIlvlyaIo0Z16XLdLV3NeVvLTI6UoXqe5BK8xGSC
         hkrqBMxQLlS3HTFyAXioL0cGfJGidy488BHIfLxgn8HVZs+VANtQ9S1bOu5WZlv5iKfz
         NGSHTVUmxE//XUEyc42wK7rQd9tpAXVSNCF9KxwOErVcPfrx29t0CxYRpnlY7n5DsHeo
         AmNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-language:references:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TXbJB0KMCfIlwY0ltY89Wv0goTtmbbx9NfGatobyUv4=;
        b=Wt8eJzTNow0nPAQOQk9xV9OwNG2JM2P9bBr02tOzjK4NeFBhs9moMtjMDHUs+mx5fm
         qHx3heWBIccAlufxV3MbMx+0E+lfVrcZxaUzsi5rg2AcXHmmO+kx4A6w2LhuEwyZxLkY
         UOLso8fM3DW4SIC7shpOClrqqjhUB0AEnhUQR+GkG4Tw/KddOwVoE8X456d2g/BL4TEN
         5GAo9sjALV/LZUV0ZZfZ/nuv8su7bVtqPjJUbLKsT7XlaIj6PyDF8BHCi3IH2s09dEM9
         BfZiaM3awOWjJOdPsldcU6ajs9KY3fOzqaabAl2UEgSU0AXfMFLegYkkrgR4GYdOvSUp
         groA==
X-Gm-Message-State: AFqh2kp4h4v3sLWW5G5n7ZGR/2hlxVnShr3g2iDuAeLDuJHhmhvVD4ML
        phuS/vZRkmY4KNhCTC+cYMc=
X-Google-Smtp-Source: AMrXdXuv87Qj4m6yUOqYvpWiweQjbiQmMZxQjS0weUc044TT2Al8E68VEKmN2tiiyZI7tX7mgNByNQ==
X-Received: by 2002:a05:622a:17c5:b0:39c:da21:6bb3 with SMTP id u5-20020a05622a17c500b0039cda216bb3mr45086958qtk.56.1672596669631;
        Sun, 01 Jan 2023 10:11:09 -0800 (PST)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id 133-20020a37088b000000b006bb2cd2f6d1sm18798670qki.127.2023.01.01.10.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 10:11:08 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------A7HSVuJRDRvEP86jN2HygWpt"
Message-ID: <a40020bd-c190-4283-1977-9e4d9627b888@gmail.com>
Date:   Sun, 1 Jan 2023 13:11:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Sean Anderson <seanga2@gmail.com>
Subject: Re: [FSL P50x0] DPAA Ethernet issue
To:     chzigotzky@xenosoft.de, Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     darren@stevens-zone.net, davem@davemloft.net, info@xenosoft.de,
        linuxppc-dev@lists.ozlabs.org, madskateman@gmail.com,
        matthew@a-eon.biz, rtd2@xtra.co.nz, sean.anderson@seco.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
References: <0bfc8f3d-cb62-25f4-2590-ff424adbe48a@xenosoft.de>
Content-Language: en-US
In-Reply-To: <0bfc8f3d-cb62-25f4-2590-ff424adbe48a@xenosoft.de>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------A7HSVuJRDRvEP86jN2HygWpt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgQ2hyaXN0aWFuLA0KDQorQ0MgbmV0ZGV2IGZvbGtzDQoNCj4gSGkgQWxsLA0KPiANCj4g
VGhlIERQQUEgRXRoZXJuZXQgZG9lc27igJl0IHdvcmsgYW55bW9yZSBvbiBvdXIgRlNMIFA1
MDIwL1A1MDQwIGJvYXJkcyBbMV0gDQo+IHNpbmNlIHRoZSBmaXJzdCB1cGRhdGVzIGFmdGVy
IHRoZSBmaW5hbCBrZXJuZWwgNi4xIFsyXS4NCj4gV2UgYmlzZWN0ZWQgeWVzdGVyZGF5IFsz
XSBhbmQgZm91bmQgdGhlIHByb2JsZW1hdGljIGNvbW1pdCBbNF0uIEkgd2FzIA0KPiBhYmxl
IHRvIHJldmVydCBpdC4gQWZ0ZXIgdGhhdCB0aGUgRFBBQSBFdGhlcm5ldCB3b3JrcyBhZ2Fp
bi4gSSBjcmVhdGVkIGEgDQo+IHBhdGNoIGZvciByZXZlcnRpbmcgdGhlIGNvbW1pdCBbNF0u
IEFmdGVyIHBhdGNoaW5nIGFuZCBjb21waWxpbmcsIHRoZSANCj4gRFBBQSBFdGhlcm5ldCBh
bHNvIHdvcmtzIGFnYWluLg0KDQpUaGFuayB5b3UgZm9yIHRlc3RpbmcgdGhpcy4gVW5mb3J0
dW5hdGVseSwgSSBoYXZlIG5vIFAtc2VyaWVzIGhhcmR3YXJlLA0Kc28gSSB3YXMgdW5hYmxl
IHRvIHRlc3QgdGhlIDEwZ2VjL2R0c2VjIHBhcnRzIG9mIHRoaXMgY29udmVyc2lvbi4gSSBo
YWQNCmhvcGVkIHRoYXQgdGhpcyB3b3VsZCBnZXQgdGVzdGVkIGJ5IHNvbWVvbmUgd2l0aCB0
aGUgaGFyZHdhcmUgKGF0IE5YUCkNCmJlZm9yZSBub3csIGJ1dCBpdCBzZWVtcyB5b3UgZ2V0
IHRvIGJlIHRoZSAibHVja3kiIGZpcnN0IHVzZXIuDQoNCkkgc2VlIHlvdSBoYXZlIGxhYmVs
ZWQgb25lIG9mIHlvdXIga2VybmVscyBhcyBzdXBwb3J0aW5nIFFFTVUuICBEbyB5b3UNCmhh
cHBlbiB0byBoYXZlIGluc3RydWN0aW9ucyBmb3IgcnVubmluZyBMaW51eCBvbiBRRU1VPw0K
DQo+IEl0IHNlZW1zLCB0aGF0IHRoZSBuZXcgZHJpdmVyIGRvZXNu4oCZdCB3b3JrIHdpdGgg
b3VyIG9uYm9hcmQgRFBBQSBuZXR3b3JrIA0KPiBpbnRlcmZhY2VzLg0KPiANCj4gQ291bGQg
eW91IHBsZWFzZSBjaGVjayB5b3VyIGNvbW1pdD8gWzRdDQoNCkNhbiB5b3UgdHJ5IHRoZSBm
b2xsb3dpbmcgcGF0Y2guIEkgdGhpbmsgbXkgbWFpbCBjbGllbnQgd2lsbCBtYW5nbGUgaXQs
DQpzbyBJIGhhdmUgYWxzbyBhdHRhY2hlZCBpdCB0byB0aGlzIGVtYWlsLg0KDQogRnJvbSAz
ODk4YzYyMTA2MDI1MjA5YjI2NTI3YWQxNTE2YjMzOWVlYmI2MmYxIE1vbiBTZXAgMTcgMDA6
MDA6MDAgMjAwMQ0KRnJvbTogU2VhbiBBbmRlcnNvbiA8c2VhbmdhMkBnbWFpbC5jb20+DQpE
YXRlOiBTdW4sIDEgSmFuIDIwMjMgMTM6MDA6MjEgLTA1MDANClN1YmplY3Q6IFtQQVRDSF0g
bmV0OiBkcGFhOiBGaXggZHRzZWMgY2hlY2sgZm9yIFBDUyBhdmFpbGFiaWxpdHkNCg0KV2Ug
d2FudCB0byBmYWlsIGlmIHRoZSBQQ1MgaXMgbm90IGF2YWlsYWJsZSwgbm90IGlmIGl0IGlz
IGF2YWlsYWJsZS4gRml4DQp0aGlzIGNvbmRpdGlvbi4NCg0KRml4ZXM6IDVkOTNjZmNmNzM2
MCAoIm5ldDogZHBhYTogQ29udmVydCB0byBwaHlsaW5rIikNClJlcG9ydGVkLWJ5OiBDaHJp
c3RpYW4gWmlnb3R6a3kgPGluZm9AeGVub3NvZnQuZGU+DQpTaWduZWQtb2ZmLWJ5OiBTZWFu
IEFuZGVyc29uIDxzZWFuZ2EyQGdtYWlsLmNvbT4NCi0tLQ0KICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZm1hbi9mbWFuX2R0c2VjLmMgfCAyICstDQogIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZtYW4vZm1hbl9kdHNlYy5jIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZtYW4vZm1hbl9kdHNlYy5jDQppbmRleCAzYzg3
ODIwY2EyMDIuLjM0NjJmMmI3ODY4MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mbWFuL2ZtYW5fZHRzZWMuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZtYW4vZm1hbl9kdHNlYy5jDQpAQCAtMTQzMSw3ICsxNDMxLDcg
QEAgaW50IGR0c2VjX2luaXRpYWxpemF0aW9uKHN0cnVjdCBtYWNfZGV2aWNlICptYWNfZGV2
LA0KICAJZHRzZWMtPmR0c2VjX2Rydl9wYXJhbS0+dHhfcGFkX2NyYyA9IHRydWU7DQogIA0K
ICAJcGh5X25vZGUgPSBvZl9wYXJzZV9waGFuZGxlKG1hY19ub2RlLCAidGJpLWhhbmRsZSIs
IDApOw0KLQlpZiAoIXBoeV9ub2RlIHx8IG9mX2RldmljZV9pc19hdmFpbGFibGUocGh5X25v
ZGUpKSB7DQorCWlmICghcGh5X25vZGUgfHwgIW9mX2RldmljZV9pc19hdmFpbGFibGUocGh5
X25vZGUpKSB7DQogIAkJb2Zfbm9kZV9wdXQocGh5X25vZGUpOw0KICAJCWVyciA9IC1FSU5W
QUw7DQogIAkJZGV2X2Vycl9wcm9iZShtYWNfZGV2LT5kZXYsIGVyciwNCi0tIA0KMi4zNy4x
DQo=
--------------A7HSVuJRDRvEP86jN2HygWpt
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-dpaa-Fix-dtsec-check-for-PCS-availability.patch"
Content-Disposition: attachment;
 filename="0001-net-dpaa-Fix-dtsec-check-for-PCS-availability.patch"
Content-Transfer-Encoding: base64

RnJvbSAzODk4YzYyMTA2MDI1MjA5YjI2NTI3YWQxNTE2YjMzOWVlYmI2MmYxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFuZ2EyQGdtYWlsLmNv
bT4KRGF0ZTogU3VuLCAxIEphbiAyMDIzIDEzOjAwOjIxIC0wNTAwClN1YmplY3Q6IFtQQVRD
SF0gbmV0OiBkcGFhOiBGaXggZHRzZWMgY2hlY2sgZm9yIFBDUyBhdmFpbGFiaWxpdHkKCldl
IHdhbnQgdG8gZmFpbCBpZiB0aGUgUENTIGlzIG5vdCBhdmFpbGFibGUsIG5vdCBpZiBpdCBp
cyBhdmFpbGFibGUuIEZpeAp0aGlzIGNvbmRpdGlvbi4KCkZpeGVzOiA1ZDkzY2ZjZjczNjAg
KCJuZXQ6IGRwYWE6IENvbnZlcnQgdG8gcGh5bGluayIpClJlcG9ydGVkLWJ5OiBDaHJpc3Rp
YW4gWmlnb3R6a3kgPGluZm9AeGVub3NvZnQuZGU+ClNpZ25lZC1vZmYtYnk6IFNlYW4gQW5k
ZXJzb24gPHNlYW5nYTJAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2Zy
ZWVzY2FsZS9mbWFuL2ZtYW5fZHRzZWMuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9mbWFuL2ZtYW5fZHRzZWMuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mbWFuL2ZtYW5fZHRzZWMuYwppbmRleCAzYzg3ODIwY2EyMDIuLjM0
NjJmMmI3ODY4MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxl
L2ZtYW4vZm1hbl9kdHNlYy5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9mbWFuL2ZtYW5fZHRzZWMuYwpAQCAtMTQzMSw3ICsxNDMxLDcgQEAgaW50IGR0c2VjX2lu
aXRpYWxpemF0aW9uKHN0cnVjdCBtYWNfZGV2aWNlICptYWNfZGV2LAogCWR0c2VjLT5kdHNl
Y19kcnZfcGFyYW0tPnR4X3BhZF9jcmMgPSB0cnVlOwogCiAJcGh5X25vZGUgPSBvZl9wYXJz
ZV9waGFuZGxlKG1hY19ub2RlLCAidGJpLWhhbmRsZSIsIDApOwotCWlmICghcGh5X25vZGUg
fHwgb2ZfZGV2aWNlX2lzX2F2YWlsYWJsZShwaHlfbm9kZSkpIHsKKwlpZiAoIXBoeV9ub2Rl
IHx8ICFvZl9kZXZpY2VfaXNfYXZhaWxhYmxlKHBoeV9ub2RlKSkgewogCQlvZl9ub2RlX3B1
dChwaHlfbm9kZSk7CiAJCWVyciA9IC1FSU5WQUw7CiAJCWRldl9lcnJfcHJvYmUobWFjX2Rl
di0+ZGV2LCBlcnIsCi0tIAoyLjM3LjEKCg==

--------------A7HSVuJRDRvEP86jN2HygWpt--
