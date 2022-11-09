Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02E8622332
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 05:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiKIEnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 23:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKIEnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 23:43:31 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50A0F72;
        Tue,  8 Nov 2022 20:43:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so827571pjk.1;
        Tue, 08 Nov 2022 20:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xV5hBW0l2Z09j+06red1ceXfmjMnqjvJHRbObNSW4oM=;
        b=doT8KhalO124Y92kFhvz587fdYEAQjaHOj/rJkKxJ+YhrFmT8UeWMMRhHxZaPI6omN
         jG6flakgiJIAAgqZz1t26LxXJ6Lnhu6K1AUL6e4pqf9MjyLJ5mg+QCFK5Q7lXLeKWdzM
         De2+sRN/NWZWBx1OTE+d/QoUFLbN08PdGG3iSoWLSYyZJA6AjcsXSoxVuNSymh7tX0xx
         T+QtsfmYigcyctXSCWexSnd+UjX522KQ98AHtcksawp+UZi9Se7ABtruRRp58H9re7A5
         ieuIS1grAEwHWz4ZNX96zAP1R1ZRv8ox+ZGhyDRR7r5BRtCCQLKSoljVbDjz/6u57IS4
         09GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xV5hBW0l2Z09j+06red1ceXfmjMnqjvJHRbObNSW4oM=;
        b=TcI5AEFneMru+cqdTULvOP1vHjjfZ8bmf3/378X0wcMhFF5Cd6P2aX3pwoNI3pbNTV
         Yogy5yuGon+N0lIhq2ADiRW1frjPvDG4t1G6PfmgIgShSq2pkRt7cQFUj+0xMOt0DxJa
         rnj5uhgbIr02WxThMPv4899GLPMcJ6+nDvvM/8avxSitH7WcvnPG4XQh2nxT/dxx5pLN
         a0tlRbLbobUoo9JcE0vU8+P0T6a6jQyfuC7+5b6bg1U+bveRvOn9dS+moOR/buNz9RwO
         obP3Mdpbbmie4McJOEIofYzqkHYmpImg6wbm+EsxhRe1Xv6qvTgJTUFFlnFELA+/84xQ
         z0vQ==
X-Gm-Message-State: ACrzQf3M1maeP/mi0yaRehXcOz9SbG0SzP+6Yozl1uIlRI+jCGXISxqV
        WXFSB9SrQcYyAC9O+2TlOdo=
X-Google-Smtp-Source: AMsMyM73OG6m10s46rvg3YhIJAw8qLe06iimBkJOeyr07JH8TfWUvhfVSEuS4au7Tu63KPVl5XDzLA==
X-Received: by 2002:a17:90b:38cd:b0:214:184f:4007 with SMTP id nn13-20020a17090b38cd00b00214184f4007mr42666980pjb.82.1667969008267;
        Tue, 08 Nov 2022 20:43:28 -0800 (PST)
Received: from [10.1.1.173] ([220.244.252.98])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79611000000b00565c860bf83sm7235197pfg.150.2022.11.08.20.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 20:43:27 -0800 (PST)
Message-ID: <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
Date:   Wed, 9 Nov 2022 15:43:21 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Content-Language: en-AU
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108125028.35a765be@kernel.org>
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
In-Reply-To: <20221108125028.35a765be@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ZkQ0BEs06RPIG5wzLTb0HDZL"
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
--------------ZkQ0BEs06RPIG5wzLTb0HDZL
Content-Type: multipart/mixed; boundary="------------YE0Vpi45lMVof0TSkDPFARxt";
 protected-headers="v1"
From: Albert Zhou <albert.zhou.50@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org
Message-ID: <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108125028.35a765be@kernel.org>
In-Reply-To: <20221108125028.35a765be@kernel.org>

--------------YE0Vpi45lMVof0TSkDPFARxt
Content-Type: multipart/mixed; boundary="------------N0r1dl0TLXU1SwYeFDWFB3gM"

--------------N0r1dl0TLXU1SwYeFDWFB3gM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMS8yMiAwNzo1MCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgIDkg
Tm92IDIwMjIgMDI6MzM6MzcgKzExMDAgQWxiZXJ0IFpob3Ugd3JvdGU6DQo+PiBUaGlzIHBh
dGNoIGludGVncmF0ZXMgdGhlIHZlcnNpb24tdHdvIHI4MTUyIGRyaXZlcnMgZnJvbSBSZWFs
dGVrIGludG8NCj4+IHRoZSBrZXJuZWwuIEkgYW0gbmV3IHRvIGtlcm5lbCBkZXZlbG9wbWVu
dCwgc28gYXBvbG9naWVzIGlmIEkgbWFrZQ0KPj4gbmV3YmllIG1pc3Rha2VzLg0KPj4NCj4+
IEkgaGF2ZSB0ZXN0ZWQgdGhlIHVwZGF0ZWQgbW9kdWxlIGluIHY2LjEgb24gbXkgbWFjaGlu
ZSwgd2l0aG91dCBhbnkNCj4+IGlzc3Vlcy4NCj4gDQo+IFdoYXQgYXJlIHlvdSB0cnlpbmcg
dG8gYWNoaWV2ZT8gQ29weSBwYXN0aW5nIDE4ayBMb0MgaW50byB0aGUga2VybmVsDQo+IGlu
IGEgc2luZ2xlIHBhdGNoIGlzIGRlZmluaXRlbHkgbm90IHRoZSB3YXkgd2UgZG8gZGV2ZWxv
cG1lbnQuIElmIHRoZXJlDQo+IGFyZSBmZWF0dXJlcyBtaXNzaW5nIGluIHRoZSB1cHN0cmVh
bSBkcml2ZXIsIG9yIHlvdSBzZWUgZGlzY3JlcGFuY2llcw0KPiBpbiB0aGUgb3BlcmF0aW9u
IC0gcGxlYXNlIHByZXBhcmUgdGFyZ2V0ZWQgcGF0Y2hlcy4NCg0KSGkgSmFrdWIsDQoNClRo
ZSB2ZXJzaW9uLW9uZSByODE1MiBtb2R1bGUsIGZvciBzb21lIHJlYXNvbiwgY2Fubm90IG1h
aW50YWluIGhpZ2gNCmRhdGEtdHJhbnNmZXIgc3BlZWRzLiBJIHBlcnNvbmFsbHkgZXhwZXJp
ZW5jZWQgdGhpcyBwcm9ibGVtIG15c2VsZiwgd2hlbg0KSSBib3VnaHQgYSBuZXcgVVNCLUMg
dG8gZXRoZXJuZXQgYWRhcHRlci4gVGhlIHZlcnNpb24tdHdvIG1vZHVsZSBmaXhlcw0KdGhp
cyBpc3N1ZS4NCg0KSSB3YXMgc2VhcmNoaW5nIGZvciBhIHdheSB0byBpbmNsdWRlIHZlcnNp
b24gdHdvIGluIHRoZSBrZXJuZWwsIHNvIHRoYXQNCmZ1dHVyZSB1c2VycyB3b3VsZCBub3Qg
aGF2ZSB0aGlzIGlzc3VlLiBCZWluZyBuZXcgdG8gdGhpcyBwcm9jZXNzLCBJDQpuYe+/vXZl
bHkgY29udGFjdGVkIEdyZWcsIHdobyBhZHZpc2VkIG1lIHRvIHNlbmQgYSBwYXRjaCB0aHJv
dWdoLg0KDQpVbmZvcnR1bmF0ZWx5IG15IGF0dGVtcHRzIGhhdmUgbm90IG1ldCB5b3VyIHN0
YW5kYXJkLiBJIHdpbGwgdHJ5IGFuZA0KcGVyc2lzdCBiZWNhdXNlIEkgd291bGQgbGlrZSB0
byBpbXByb3ZlIHRoZSBrZXJuZWwgaW4gdGhlIGJlc3Qgd2F5Lg0KDQpTaW5jZXJlbHksDQoN
CkFsYmVydCBaaG91DQo=
--------------N0r1dl0TLXU1SwYeFDWFB3gM
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

--------------N0r1dl0TLXU1SwYeFDWFB3gM--

--------------YE0Vpi45lMVof0TSkDPFARxt--

--------------ZkQ0BEs06RPIG5wzLTb0HDZL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRLx2w8czp1EBJaieEhj+NExaaGfQUCY2sv6QUDAAAAAAAKCRAhj+NExaaGfe7N
AP9TT94laKLM1+4Rehhl6E2FONglcLtmG60PGv/2HHupXAD/WcVbAKA5AXUk9A1M/VXJsoKyqjw1
DRFXrlqWo+pSRQA=
=iBHO
-----END PGP SIGNATURE-----

--------------ZkQ0BEs06RPIG5wzLTb0HDZL--
