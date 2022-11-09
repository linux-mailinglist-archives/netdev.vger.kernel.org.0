Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAA362233B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 05:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiKIEvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 23:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKIEvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 23:51:07 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967CB1F9FA;
        Tue,  8 Nov 2022 20:51:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b11so15673675pjp.2;
        Tue, 08 Nov 2022 20:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=osSoXYA242IT5hEkp95ZY3q4fEkBmJUknh4vpxbEop4=;
        b=n+8tJNAMJb8e64DEt+MTXRzepEWvqx2SmzxrEn89wSrPUX91t89qbg/Azg1O8mD3/S
         dCPl8QvEzOltMSvHqJ+m/BWg+jVRyLsQVyXnQdurJLsEE2qgzA4hMu2pWPRxVYC3qvVK
         iPi3VAU57SaClkuYzfHjxwOmcT+3QrORFdGLb2iceBQ25ZAzP719LnBtFIUwMjfCX22D
         CDLafPeAw6na/8eaD7RQ4BPMfFPod37Gww4OLr/Y+IvQvWYJGbntD210o70UFFk8CZpo
         81DQKHCKgn0S/+vjDRKI5ae+QQI0vEcEpvENXR9j7VuWPXjFxKJsQFoJ62ruCJMAvM6+
         Xggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:autocrypt:from:references:cc:to:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=osSoXYA242IT5hEkp95ZY3q4fEkBmJUknh4vpxbEop4=;
        b=D04CkCKPTwqSqc8H9hKgh+m0XdW1ttn/pJP1jsUsTEtCRQsMPt2qDJZyExVwHeN6f2
         a676Er/vBFNgbzKMQUyNq5jDifNgqJo9RT1xxS1H5Lu8vZsERzvlddnzRSyqmjx7mMn4
         hmQK7F7iaIg0hHm6029qO8ywyaO04uFEe6yigxEMJiHI8SC4DHp7lZSCXbuwbQa4uSIA
         S+XpZKmfrf8aaCoZlG1B8b6KHir5EfyAwEdQryKfmC9djTBfALa4HUwQa0lz03PovS0K
         qOc80IbNhzpMNjoEU2fBRTOrasLLMHtHojumeUAYsnrm+9L+ZZLXTmH7GRkha2EZUoq1
         1FJw==
X-Gm-Message-State: ACrzQf3tDnWWbnYFsA0KjZfmsf8apTngcJnni4FTuGTHfIM+wsK8sK5S
        2hdCxlAQ82JkccbqAnqtluM=
X-Google-Smtp-Source: AMsMyM4/f4oLj0Fq+e7TkNuPUUJseLA3ufoo6T/DpKVAsxjvD3Z6bmox52F7WO7PxbkbxFftVgICEg==
X-Received: by 2002:a17:90b:1212:b0:213:a3a4:4d97 with SMTP id gl18-20020a17090b121200b00213a3a44d97mr58891983pjb.225.1667969466081;
        Tue, 08 Nov 2022 20:51:06 -0800 (PST)
Received: from [10.1.1.173] ([220.244.252.98])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902ebc500b001868981a18esm7894388plg.6.2022.11.08.20.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 20:51:05 -0800 (PST)
Message-ID: <370e2420-e875-3543-0128-57f7bce6be40@gmail.com>
Date:   Wed, 9 Nov 2022 15:50:59 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next RFC 2/5] r8152: update to version two
Content-Language: en-AU
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108153342.18979-3-albert.zhou.50@gmail.com>
 <Y2qRyqiVuJ0LwySh@kroah.com>
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
In-Reply-To: <Y2qRyqiVuJ0LwySh@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------zOleDhDKogZTIOmzL4q61xVC"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------zOleDhDKogZTIOmzL4q61xVC
Content-Type: multipart/mixed; boundary="------------SQ216z3ioSk5rqnsIX46zz8n";
 protected-headers="v1"
From: Albert Zhou <albert.zhou.50@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, nic_swsd@realtek.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org
Message-ID: <370e2420-e875-3543-0128-57f7bce6be40@gmail.com>
Subject: Re: [PATCH net-next RFC 2/5] r8152: update to version two
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108153342.18979-3-albert.zhou.50@gmail.com>
 <Y2qRyqiVuJ0LwySh@kroah.com>
In-Reply-To: <Y2qRyqiVuJ0LwySh@kroah.com>

--------------SQ216z3ioSk5rqnsIX46zz8n
Content-Type: multipart/mixed; boundary="------------J0RcHbdyKf2am2PZOGXgPiPy"

--------------J0RcHbdyKf2am2PZOGXgPiPy
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMS8yMiAwNDoyOCwgR3JlZyBLSCB3cm90ZToNCj4+ICAgLy8gU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPj4gICAvKg0KPj4gLSAqICBDb3B5cmlnaHQg
KGMpIDIwMTQgUmVhbHRlayBTZW1pY29uZHVjdG9yIENvcnAuIEFsbCByaWdodHMgcmVzZXJ2
ZWQuDQo+PiArICogIENvcHlyaWdodCAoYykgMjAyMSBSZWFsdGVrIFNlbWljb25kdWN0b3Ig
Q29ycC4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4+ICsgKg0KPj4gKyAqIFRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3INCj4+
ICsgKiBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJs
aWMgTGljZW5zZQ0KPj4gKyAqIHZlcnNpb24gMiBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUg
U29mdHdhcmUgRm91bmRhdGlvbi4NCj4gVG8gc3RhcnQgd2l0aCwgdGhpcyBpcyBub3QgY29y
cmVjdC4gIERvbid0IGFkZCBiYWNrIGxpY2Vuc2UgYm9pbGVyLXBsYXRlDQo+IGNvZGUuDQoN
CkhpIEdyZWcsDQoNCk15IGFwb2xvZ2llcywgSSB3YXMgdW5hd2FyZSBvZiB0aGlzLiBUaGlz
IGNhbiBiZSBlYXNpbHkgcmVtb3ZlZC4NCg0KPiANCj4gQW5kIHlvdSBqdXN0IGNoYW5nZWQg
dGhlIGNvcHlyaWdodCBub3RpY2UgaW5jb3JyZWN0bHksIHRoYXQgaXMgbm90IG9rLg0KPiAN
Cg0KV2hlbiBJIHJlcGxhY2VkIHRoZSB2ZXJzaW9uLW9uZSBjb2RlIHdpdGggdGhlIHZlcnNp
b24tdHdvIGNvZGUsIEkgYXNzdW1lZA0KdGhlIGF1dGhvcnMnIGNvcHlyaWdodCB3b3VsZCBi
ZSBjb3JyZWN0LiBXaGF0IGlzIHRoZSBjb3JyZWN0IGNvcHlyaWdodA0Kbm90aWNlPw0KDQo+
PiArICoNCj4+ICsgKiAgVGhpcyBwcm9kdWN0IGlzIGNvdmVyZWQgYnkgb25lIG9yIG1vcmUg
b2YgdGhlIGZvbGxvd2luZyBwYXRlbnRzOg0KPj4gKyAqICBVUzYsNTcwLDg4NCwgVVM2LDEx
NSw3NzYsIGFuZCBVUzYsMzI3LDYyNS4NCj4gT2ggd293LiAgVGhhdCdzIHBsYXlpbmcgd2l0
aCBmaXJlLi4uDQoNCkRvIHlvdSBiZWxpZXZlIHRoaXMgcHJvaGliaXRzIHRoZSBjb2RlIGZy
b20gYmVpbmcgaW4gdGhlIGtlcm5lbD8gSSBoYWQNCmFzc3VtZWQgdGhlc2UgcmVmZXIgdG8g
dGhlIGhhcmR3YXJlLCB0aGUgZXRoZXJuZXQgYWRhcHRlciwgc2luY2UgdGhlDQpjb2RlIGlz
IGNvdmVyZWQgYnkgR1BMdjIuDQoNCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1oDQo=

--------------J0RcHbdyKf2am2PZOGXgPiPy
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

--------------J0RcHbdyKf2am2PZOGXgPiPy--

--------------SQ216z3ioSk5rqnsIX46zz8n--

--------------zOleDhDKogZTIOmzL4q61xVC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRLx2w8czp1EBJaieEhj+NExaaGfQUCY2sxswUDAAAAAAAKCRAhj+NExaaGfT6b
APoDNv2e73haZh5BDWgyvTTiJIIdm8VY/L9Y19TnVNSdPAEAhfaIsas23dGPrAFhFFIqEjKM3Pf+
YcJpUMXaUqR91A8=
=Q6Lt
-----END PGP SIGNATURE-----

--------------zOleDhDKogZTIOmzL4q61xVC--
