Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3357622340
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 05:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKIEy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 23:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKIEyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 23:54:25 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D3113DF9;
        Tue,  8 Nov 2022 20:54:24 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so780242pjc.3;
        Tue, 08 Nov 2022 20:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KttG/G7QZdqFudKGtDOLxVn89SKxAVK2Xc8GTHyWUy4=;
        b=PEpujnkpEf4hxuIgh18WhhG3I5qagFG/zXK4c6qNG2s8rk5qTLl7zezZAkqR2jcgoW
         gGY8s73DTHoBKtQC5NnifsXOwcokDmw8VKUKtBC7MHLVzXcJlvK+yoiB1YXX/oVvMofN
         f7tEm/qYUtqXnjzPf8v0yfFP7NUr9kpd3DJv0dkjP9RYGw95r4oVchbADr8d2V8kX2Pz
         az1zQG6W+XU6JgcnJKlclvJJEEcZyZze2Ycj54w0R8ut9JMqSPTssuUyjyG8WObuW14A
         T83MrG+xmTzvA9LWK2ynBxelO63DCuTRE9H/pLQseTjtXlQS7gqvF1FfKDnMX2Fp3Fh/
         Uqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KttG/G7QZdqFudKGtDOLxVn89SKxAVK2Xc8GTHyWUy4=;
        b=nmBiZZegOo2Tb5O2ym+IV0TYABIMoQITqum+rRZIkRg1yGutap+bY+BvQCkis6piZj
         W/zV58jKeERXMBSi/w2sooJ7z2/FAeDIb1ZmZDoyLBM/ZPnUGQaNdcpMhO7osyrBycMj
         r3/H3vGpGDLFTILFJvX4hhZIE75tye7guAtRCmsf4ZQZValgA++9iJSSpd5HFzbs1OO2
         WA4/lqqiS+ysWDla4z0aT0cL4HvLAVYzryhNm/DFECvVGsQWF4wm9t1s+EIvazMtuhwo
         gy2OoK30jc3DZDc37IEyqKZzCBBUs3Q9HAg4xHlG361v/wXi9qdcpkK/1RxTNp/zKZkm
         QMEQ==
X-Gm-Message-State: ACrzQf1QoNgc9dK3gk/vZcYpflO/4ZpM4vDdkhMhsNxjSCaYhghispfq
        t3phJ3zBjMfx7vCrz/zZYuM=
X-Google-Smtp-Source: AMsMyM7BKLnYJ3enwiISFIFYdUqlEvHFvmU187F6r+S0kQ02Oh0vH3GuvHYZXRHJ7j/FeLnR0jZDBQ==
X-Received: by 2002:a17:90b:4ac5:b0:213:e936:a843 with SMTP id mh5-20020a17090b4ac500b00213e936a843mr51166255pjb.156.1667969664051;
        Tue, 08 Nov 2022 20:54:24 -0800 (PST)
Received: from [10.1.1.173] ([220.244.252.98])
        by smtp.gmail.com with ESMTPSA id e3-20020aa798c3000000b0056b9d9e2521sm7510644pfm.177.2022.11.08.20.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 20:54:23 -0800 (PST)
Message-ID: <6cd8f4cc-416d-29a1-78c5-73a29847c219@gmail.com>
Date:   Wed, 9 Nov 2022 15:54:16 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Content-Language: en-AU
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <Y2rEKOXDqLvL++hR@electric-eye.fr.zoreil.com>
From:   Albert Zhou <albert.zhou.50@gmail.com>
Autocrypt: addr=albert.zhou.50@gmail.com; keydata=
 xjMEYkX5gxYJKwYBBAHaRw8BAQdAsW8QQjKnmpKC5G1d1QFYNvd9ddMxwYZs+xTT0dyqvtbN
 JkFsYmVydCBaaG91IDxhbGJlcnQuemhvdS41MEBnbWFpbC5jb20+wosEExYIADMWIQRLx2w8
 czp1EBJaieEhj+NExaaGfQUCYkX5gwIbAwULCQgHAgYVCAkKCwIFFgIDAQAACgkQIY/jRMWm
 hn2rKAEAlOVVAsYIpmGTEng+e/HHT7JJjCjcX4lh+pFZdUy2DGgBAM/EwKNYoNB43H5EJpb8
 I68MS+ZZSQ3swJWAu1OJKXIJzjgEYkX5gxIKKwYBBAGXVQEFAQEHQNk/Nf/E1Uttgm29quUB
 Xgc9RDwqKTHbtHLS5SOkZzhUAwEIB8J4BBgWCAAgFiEES8dsPHM6dRASWonhIY/jRMWmhn0F
 AmJF+YMCGwwACgkQIY/jRMWmhn0KRwD7Bv1kWYB2m8c5tRQUg7i3zIaJ4kpfqMj4bwYQ9xEk
 e3oA/11CMCzdPMcoveB279og31mtUISG5mXMDJmiE4y61akN
In-Reply-To: <Y2rEKOXDqLvL++hR@electric-eye.fr.zoreil.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------qpfB0AxETvfbGHB9mMT5l59l"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------qpfB0AxETvfbGHB9mMT5l59l
Content-Type: multipart/mixed; boundary="------------INkb0O1ZCz5UZMBZRtnxX4ki";
 protected-headers="v1"
From: Albert Zhou <albert.zhou.50@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 Hayes Wang <hayeswang@realtek.com>
Message-ID: <6cd8f4cc-416d-29a1-78c5-73a29847c219@gmail.com>
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <Y2rEKOXDqLvL++hR@electric-eye.fr.zoreil.com>
In-Reply-To: <Y2rEKOXDqLvL++hR@electric-eye.fr.zoreil.com>

--------------INkb0O1ZCz5UZMBZRtnxX4ki
Content-Type: multipart/mixed; boundary="------------ZsaOIHxnY1aBFy0edaTxbuWp"

--------------ZsaOIHxnY1aBFy0edaTxbuWp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMS8yMiAwODowMywgRnJhbmNvaXMgUm9taWV1IHdyb3RlOg0KPiBBbGJlcnQgWmhv
dSA8YWxiZXJ0Lnpob3UuNTBAZ21haWwuY29tPiA6DQo+PiBUaGlzIHBhdGNoIGludGVncmF0
ZXMgdGhlIHZlcnNpb24tdHdvIHI4MTUyIGRyaXZlcnMgZnJvbSBSZWFsdGVrIGludG8NCj4+
IHRoZSBrZXJuZWwuIEkgYW0gbmV3IHRvIGtlcm5lbCBkZXZlbG9wbWVudCwgc28gYXBvbG9n
aWVzIGlmIEkgbWFrZQ0KPj4gbmV3YmllIG1pc3Rha2VzLg0KPiANCj4gV2hpbGUgaXQgbWFr
ZXMgc2Vuc2UgdG8gbWluaW1pemUgZGlmZmVyZW5jZXMgYmV0d2VubiBSZWFsdGVrJ3MgaW4t
aG91c2UNCj4gZHJpdmVyIGFuZCBrZXJuZWwgcjgxNTIgZHJpdmVyLCBpdCBkb2VzIG5vdCBt
ZWFuIHRoYXQgdGhlIG91dC1vZi10cmVlDQo+IGRyaXZlciBpcyBzdWl0YWJsZSBmb3IgYSBz
dHJhaWdodCBrZXJuZWwgaW5jbHVzaW9uLg0KPiANCj4gSWYgeW91IHdhbnQgdGhpbmdzIHRv
IG1vdmUgZm9yd2FyZCBpbiBhIG5vdCB0b28gcGFpbmZ1bCB3YXksIHlvdSBzaG91bGQNCj4g
c3BsaXQgdGhlIG1vcmUgdGhhbiA2NTAga28gcGF0Y2ggaW50byBzbWFsbGVyLCBtb3JlIGZv
Y3VzZWQgcGF0Y2hlcw0KPiAoaHVnZSBwYXRjaGVzIGFsc28gbWFrZXMgYmlzZWN0aW9uIG1p
bGRseSBlZmZlY3RpdmUgYnR3KS4NCj4gDQo+IEluIGl0cyBjdXJyZW50IGZvcm0sIHRoZSBz
dWJtaXNzaW9uIGlzIGltaG8gYSBiaXQgYWJyYXNpdmUgdG8gcmV2aWV3Lg0KPg0KDQpIaSBG
cmFuY29pcywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIEFzIEkgd2FzIG5vdCBpbnZv
bHZlZCBpbiB0aGUgZGV2ZWxvcG1lbnQsIGl0DQp3aWxsIGJlIGRpZmZpY3VsdCBmb3IgbWUg
dG8gYWNoaWV2ZSB0aGlzLiBJIHdpbGwgdHJ5IGNvbnRhY3QgdGhlDQpkZXZlbG9wZXJzIGF0
IFJlYWx0ZWsgdG8gc2VlIGlmIHRoZXkgY2FuIGFzc2lzdC4NCg0KSSB3YXMgdW5kZXIgdGhl
IGZhbHNlIGltcHJlc3Npb24sIHRoYXQgaW5kZWVkIHRoZSBSZWFsdGVrIGRyaXZlciBjb3Vs
ZA0Kc2ltcGx5IGJlIGluY2x1ZGVkIGluIHRoZSBrZXJuZWwuIEJ1dCBub3cgSSBzZWUgdGhh
dCBpcyBub3QgdGhlIGNhc2UuDQoNCkJlc3QsDQoNCkFsYmVydCBaaG91DQoNCiAgDQo+IFsu
Li5dDQo+PiBBbGJlcnQgWmhvdSAoNSk6DQo+PiAgICBuZXQ6IG1vdmUgYmFjayBuZXRpZl9z
ZXRfZ3NvX21heCBoZWxwZXJzDQo+PiAgICByODE1MjogdXBkYXRlIHRvIHZlcnNpb24gdHdv
DQo+IA0KPiBUaGlzIGNvZGUgbWlzdXNlcyBtdXRleCBpbiB7cmVhZCwgd3JpdGV9X21paV93
b3JkLg0KPiANCj4gSXQgaW5jbHVkZXMgY29kZSBhbmQgZGF0YSB0aGF0IHNob3VsZCBiZSBt
b3ZlZCB0byBmaXJtd2FyZSBmaWxlcy4NCj4gDQo+PiAgICByODE1MjogcmVtb3ZlIGJhY2t3
YXJkcyBjb21wYXRpYmlsaXR5DQo+IA0KPiBCYWNrd2FyZHMgY29tcGF0aWJpbGl0eSBjb2Rl
IHNob3VsZCBoYWQgYmVlbiBhdm9pZGVkIGluIHRoZSBmaXJzdA0KPiBwbGFjZS4NCj4gDQo+
IFsuLi5dDQo+PiAgICByODE1MjogcmVtb3ZlIHJlZHVuZGFudCBjb2RlDQo+IA0KPiBTYW1l
IHRoaW5nLg0KPiANCg==
--------------ZsaOIHxnY1aBFy0edaTxbuWp
Content-Type: application/pgp-keys; name="OpenPGP_0x218FE344C5A6867D.asc"
Content-Disposition: attachment; filename="OpenPGP_0x218FE344C5A6867D.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEYkX5gxYJKwYBBAHaRw8BAQdAsW8QQjKnmpKC5G1d1QFYNvd9ddMxwYZs+xTT
0dyqvtbNJkFsYmVydCBaaG91IDxhbGJlcnQuemhvdS41MEBnbWFpbC5jb20+wosE
ExYIADMWIQRLx2w8czp1EBJaieEhj+NExaaGfQUCYkX5gwIbAwULCQgHAgYVCAkK
CwIFFgIDAQAACgkQIY/jRMWmhn2rKAEAlOVVAsYIpmGTEng+e/HHT7JJjCjcX4lh
+pFZdUy2DGgBAM/EwKNYoNB43H5EJpb8I68MS+ZZSQ3swJWAu1OJKXIJzjgEYkX5
gxIKKwYBBAGXVQEFAQEHQNk/Nf/E1Uttgm29quUBXgc9RDwqKTHbtHLS5SOkZzhU
AwEIB8J4BBgWCAAgFiEES8dsPHM6dRASWonhIY/jRMWmhn0FAmJF+YMCGwwACgkQ
IY/jRMWmhn0KRwD7Bv1kWYB2m8c5tRQUg7i3zIaJ4kpfqMj4bwYQ9xEke3oA/11C
MCzdPMcoveB279og31mtUISG5mXMDJmiE4y61akN
=3D+2qf
-----END PGP PUBLIC KEY BLOCK-----

--------------ZsaOIHxnY1aBFy0edaTxbuWp--

--------------INkb0O1ZCz5UZMBZRtnxX4ki--

--------------qpfB0AxETvfbGHB9mMT5l59l
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRLx2w8czp1EBJaieEhj+NExaaGfQUCY2syeAUDAAAAAAAKCRAhj+NExaaGfWk0
AP9nkKnxnS4mOesRT3+QvlZ5UXMPfLbzQ7ZbrGQOA+ZpsQEAm5Jf/enYbMUBs7sIkVavCtMLP7bD
doXiO/+5Nc6dvgw=
=Gzc0
-----END PGP SIGNATURE-----

--------------qpfB0AxETvfbGHB9mMT5l59l--
