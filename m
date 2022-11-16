Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFF62C205
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiKPPOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKPPOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:14:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD4EFCEB;
        Wed, 16 Nov 2022 07:13:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso2665076pjc.2;
        Wed, 16 Nov 2022 07:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n7tLc+UQvxVqBIyqQrySb6AdFEBXwpf0lkFD03a8TxQ=;
        b=RCpbhMi8MC59TkYeQJEvk64a2zdy03iPeyXOivT9tWFpYsK7Dz6mtGuiR1l3shDBk7
         PaQJZr+PCZQqaeD4xt5b8ZWu8BvQ5jkxmX1eArLYeyvJlVwiRzqOxGFOVtc7rrO1cqB4
         tJqFB2f9uY9BSzNyOUYZsT9NvIZQ4apDx1/gWXt0iiiNcTEhsmscLjqSsJdgBZTYYL2f
         Qti6/U2QW7WwYqs85XpYWdqYVncofNptxJ7aPmZLi2dzlDOxoS5+qbdBuUQSkY/Hai/Y
         /l/3T6c3LfquTkhMRoV7EqAeh5m6A7ZGO9uKUTTSsvXMLYgVBeLpiDcKTVnr44msegMZ
         UNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n7tLc+UQvxVqBIyqQrySb6AdFEBXwpf0lkFD03a8TxQ=;
        b=arYMIMqS/B5vXwGW7zzCKe/e0ligtp0K1uq2qSp+7MS5mrlct8yaElle19WN2ue85M
         9i9arVVZlDUm5TBqKlvQRHzYnjy0t1cYo2PZOZTIOhq47t0VGcpaH7szmIMvxr4WHqKp
         tOkF+MMMNolbsDNteL+zII3YvMYLtZbVfuI3lH+16G60g6vHUlk6aPQsQTyMuGzeS27Y
         MrPhKjPsaRAA+vwnALCIXgV983bkuKpBJlmpICub4/l6s5+dgBz6hoe34b8QmCrlpn5m
         MImb13LoUlr7/KjWQ0OPTXnClmxoUQLvn/jvyDptGl/sWetsam7CTDoC1G4HfoncoRuy
         sLdQ==
X-Gm-Message-State: ANoB5pkUlbRhPgCF4xrezvr+vdHIXuhyKIIsvtfaUAOYCepMb8kcqzPE
        GR4i4o8ZDbv6+fbSfO/0AUoGhuUnbFA93fk1
X-Google-Smtp-Source: AA0mqf75GyzZ+LVMfUT0NLBlcAVhiuDD9Tsw5ZAj3xoPWGldnK8Mq9yuvavbri3PNX48SV8sNs1x+A==
X-Received: by 2002:a17:90a:fe85:b0:214:132a:2b90 with SMTP id co5-20020a17090afe8500b00214132a2b90mr4169431pjb.195.1668611637122;
        Wed, 16 Nov 2022 07:13:57 -0800 (PST)
Received: from [10.1.1.173] ([220.244.252.98])
        by smtp.gmail.com with ESMTPSA id iz14-20020a170902ef8e00b0018855a22ccfsm12244409plb.91.2022.11.16.07.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 07:13:56 -0800 (PST)
Message-ID: <d43ad04e-8c24-d17c-ef09-984924ad1c4c@gmail.com>
Date:   Thu, 17 Nov 2022 02:13:49 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Content-Language: en-AU
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108125028.35a765be@kernel.org>
 <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
 <20221109104050.49dc17c8@kernel.org>
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
In-Reply-To: <20221109104050.49dc17c8@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------njTGYR2OA6YUVZeDF79buqcX"
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
--------------njTGYR2OA6YUVZeDF79buqcX
Content-Type: multipart/mixed; boundary="------------svdtUPYYUlWd3VTNts1UcqSi";
 protected-headers="v1"
From: Albert Zhou <albert.zhou.50@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
 nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>
Message-ID: <d43ad04e-8c24-d17c-ef09-984924ad1c4c@gmail.com>
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108125028.35a765be@kernel.org>
 <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
 <20221109104050.49dc17c8@kernel.org>
In-Reply-To: <20221109104050.49dc17c8@kernel.org>

--------------svdtUPYYUlWd3VTNts1UcqSi
Content-Type: multipart/mixed; boundary="------------0sZapGHEmoYOcEoWLwmD8NsB"

--------------0sZapGHEmoYOcEoWLwmD8NsB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMTEvMjIgMDU6NDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBXZWQsIDkg
Tm92IDIwMjIgMTU6NDM6MjEgKzExMDAgQWxiZXJ0IFpob3Ugd3JvdGU6DQo+PiBUaGUgdmVy
c2lvbi1vbmUgcjgxNTIgbW9kdWxlLCBmb3Igc29tZSByZWFzb24sIGNhbm5vdCBtYWludGFp
biBoaWdoDQo+PiBkYXRhLXRyYW5zZmVyIHNwZWVkcy4gSSBwZXJzb25hbGx5IGV4cGVyaWVu
Y2VkIHRoaXMgcHJvYmxlbSBteXNlbGYsIHdoZW4NCj4+IEkgYm91Z2h0IGEgbmV3IFVTQi1D
IHRvIGV0aGVybmV0IGFkYXB0ZXIuIFRoZSB2ZXJzaW9uLXR3byBtb2R1bGUgZml4ZXMNCj4+
IHRoaXMgaXNzdWUuDQo+IA0KPiBJIHNlZSwgcGVyaGFwcyBpdCdkIGJlIHBvc3NpYmxlIHRv
IHplcm8gaW4gb24gaG93IHRoZSBkYXRhcGF0aCBvZg0KPiB0aGUgZHJpdmVyIGlzIGltcGxl
bWVudGVkPw0KDQpIaSBhbGwsDQoNCkFmdGVyIGEgbG90IG9mIHRlc3RpbmcsIEkgaGF2ZSBj
b21lIHRvIHRoZSBjb25jbHVzaW9uIHRoYXQgdGhlIHJlYXNvbg0KZm9yIHRoZSBzcGVlZCBk
aWZmZXJlbmNlIGJldHdlZW4gdGhlIHYxIGFuZCB2MiBkcml2ZXIgaXMgYWN0dWFsbHkgdGhl
DQpmaXJtd2FyZS4NCg0KVGhlIHYyIGRyaXZlciBkb2Vzbid0IGV2ZW4gI2luY2x1ZGUgPGxp
bnV4L2Zpcm13YXJlLmg+OyBzbyBpdCBkb2Vzbid0DQpsb2FkIHRoZSBzdGFuZGFyZCBmaXJt
d2FyZSBpbiAvbGliL2Zpcm13YXJlL3J0bF9uaWMuIEl0IHNlZW1zIHRoZQ0KZmlybXdhcmUg
aXMgYWN0dWFsbHkgd3JpdHRlbiBpbiB0aGUgc291cmNlIGFuZCBsb2FkZWQgZGlyZWN0bHku
DQoNClNpbmNlIGZpcm13YXJlIGlzIG5vdCBldmVuIHBhcnQgb2YgdGhlIGtlcm5lbCwgaXQn
cyBwcm9iYWJseQ0KaW5hcHByb3ByaWF0ZSB0byBzdWJtaXQgYSBwYXRjaCB0aGF0IG1vZGlm
aWVzIHRoZSBmaXJtd2FyZSBvZiBhIGRldmljZSwNCndvdWxkIHRoYXQgYmUgY29ycmVjdD8N
Cg0KSWYgdGhhdCdzIHRoZSBjYXNlLCBpdCdzIHByb2JhYmx5IGJlc3QgaWYgUmVhbHRlayBj
YW4gdXBkYXRlIHRoZQ0KZmlybXdhcmUgb24gdGhlIGxpbnV4IGZpcm13YXJlIGdpdC4NCg0K
Tm90IHN1cmUgb3RoZXJ3aXNlIGhvdyB0byBwcm9jZWVkLiBBbnkgc3VnZ2VzdGlvbnM/DQoN
CkJlc3QsDQoNCkFsYmVydA0K
--------------0sZapGHEmoYOcEoWLwmD8NsB
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

--------------0sZapGHEmoYOcEoWLwmD8NsB--

--------------svdtUPYYUlWd3VTNts1UcqSi--

--------------njTGYR2OA6YUVZeDF79buqcX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRLx2w8czp1EBJaieEhj+NExaaGfQUCY3T+LQUDAAAAAAAKCRAhj+NExaaGfX1X
AP4l+Dy+bwL6IE4S1FX1fNU61fNJdh+aZ5b0oUYRRgaPzQD/YT/1jPwzRFptBr4g1sBioyy6NDR3
RpDWIcK+kleTDgQ=
=9O6I
-----END PGP SIGNATURE-----

--------------njTGYR2OA6YUVZeDF79buqcX--
