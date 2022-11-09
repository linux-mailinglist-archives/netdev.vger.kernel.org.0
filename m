Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265C4622A3B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiKILUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKILUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:20:31 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4F0617B;
        Wed,  9 Nov 2022 03:20:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id b62so15989038pgc.0;
        Wed, 09 Nov 2022 03:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lrBsfJmSKV4cwRoLh38yD7n6qhsn+bIUuWaRARzt1RY=;
        b=YPk6I4VdG4LfCmNMzrCFRlh/0vyZTgomLdzdbHOtxC96b+ulhDwwSSNoJxCALRZevF
         DIrNj3jy9h4QzpS8S/uEkDhRiO5wD3ihq858iRJBsVIEdGqqzD3cJd80Ww2jTedIQ4XR
         qlv4RjcXks0sUFGVTr2aLMYFLKAtjV0IImp49XtKG1y6hPLc3icXGpMDoH8gL7gcN1n9
         k8qNRfXVJb3Sj2IFmHQxno4d6+f+8+GxzF227LRaYFYRH3c270AzCey529fwAmkFa2Dy
         GVH/7jq08WZEG1voINOikUP7puNHccmRIHXdQ2JdzHq/D+l2f+82+bjZZYZpOHkSl/Ct
         nLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lrBsfJmSKV4cwRoLh38yD7n6qhsn+bIUuWaRARzt1RY=;
        b=IA3GWTM8kzWgg5ApHzm/7Uzdb1ebi7dJYTX0XLtaENOlPpuA6GBeEfbN4CqmddgnxW
         cwbb96uK9rCWH9T8hWhbFJXnEKsZfbt63+w9VAn3IM1Ql24lnfPn8MP0bqSUG8mk1d2c
         8BMnk5bGGD4p4P8PMtKDX8wh+xK/Er6IS1CrpRh3MRX7bcwFeCjjf1qAUVgmrQCXtkXZ
         jMQVXaWO3HCrQ+4z4oCSwJrBfWOpkDAvuEXzx6XaCkyvm4BnR18wtWibWYEQW4UxkUFK
         Chi0AwKUOfub1VMOVuDWe/I+dyJAtAhO+0ubZHjD23YYgJ6pcOISUN0K56UGmygmnFFp
         GPaw==
X-Gm-Message-State: ANoB5plDPLmRS3ah0TDUp2uYqT9f4u9xNrwXST+j24lTbnrrKxKKoWYd
        1r6aAXAHNrTKZPurTfmlxTE=
X-Google-Smtp-Source: AA0mqf4Hqn0OA1df5YWnPIjGr8Pv2pC3u3+9NxJmxeKub9E3h/zkzNCvFZKdB/Q9GO1tG4BjXXzO5g==
X-Received: by 2002:a05:6a00:24c5:b0:56e:b06c:f97a with SMTP id d5-20020a056a0024c500b0056eb06cf97amr24683808pfv.57.1667992829425;
        Wed, 09 Nov 2022 03:20:29 -0800 (PST)
Received: from [10.1.1.173] ([220.244.252.98])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902a38600b0018685257c0dsm8795343pla.58.2022.11.09.03.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:20:28 -0800 (PST)
Message-ID: <9539bd4d-ee52-5148-73fd-3753dd5a616d@gmail.com>
Date:   Wed, 9 Nov 2022 22:20:21 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
To:     Hayes Wang <hayeswang@realtek.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <77e816857bbd46ec8357134f767be785@realtek.com>
Content-Language: en-AU
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
In-Reply-To: <77e816857bbd46ec8357134f767be785@realtek.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FAvgt7UPn3SkZjIgK9IU0RN6"
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
--------------FAvgt7UPn3SkZjIgK9IU0RN6
Content-Type: multipart/mixed; boundary="------------MgoHGP9020Aw5HuBmfNO49Co";
 protected-headers="v1"
From: Albert Zhou <albert.zhou.50@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
 nic_swsd <nic_swsd@realtek.com>, "davem@davemloft.net"
 <davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
 "kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <9539bd4d-ee52-5148-73fd-3753dd5a616d@gmail.com>
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <77e816857bbd46ec8357134f767be785@realtek.com>
In-Reply-To: <77e816857bbd46ec8357134f767be785@realtek.com>

--------------MgoHGP9020Aw5HuBmfNO49Co
Content-Type: multipart/mixed; boundary="------------CldSIYaYo2LfzVE0L9X4Grcx"

--------------CldSIYaYo2LfzVE0L9X4Grcx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS8xMS8yMiAyMjowMiwgSGF5ZXMgV2FuZyB3cm90ZToNCj4gQWxiZXJ0IFpob3U8YWxi
ZXJ0Lnpob3UuNTBAZ21haWwuY29tPg0KPj4gU2VudDogVHVlc2RheSwgTm92ZW1iZXIgOCwg
MjAyMiAxMTozNCBQTQ0KPj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IFJGQyAwLzVdIFVw
ZGF0ZSByODE1MiB0byB2ZXJzaW9uIHR3bw0KPj4NCj4+IFRoaXMgcGF0Y2ggaW50ZWdyYXRl
cyB0aGUgdmVyc2lvbi10d28gcjgxNTIgZHJpdmVycyBmcm9tIFJlYWx0ZWsgaW50bw0KPj4g
dGhlIGtlcm5lbC4gSSBhbSBuZXcgdG8ga2VybmVsIGRldmVsb3BtZW50LCBzbyBhcG9sb2dp
ZXMgaWYgSSBtYWtlDQo+PiBuZXdiaWUgbWlzdGFrZXMuDQo+IFRoZSBSZWFsdGVrJ3MgaW4t
aG91c2UgZHJpdmVyIGRvZXNuJ3Qgc2F0aXNmeSB0aGUgcnVsZXMgb3IgcmVxdWVzdHMgb2YN
Cj4gTGludXgga2VybmVsLCBzbyBJIGRvbid0IHRoaW5rIHlvdSBjb3VsZCB1c2UgaXQgdG8g
cmVwbGFjZSB0aGUgTGludXgNCj4ga2VybmVsIHI4MTUyIGRyaXZlci4NCj4gDQo+IFRoZSB2
ZXJzaW9uIGlzIHVzZWQgdG8gZGlzdGluZ3Vpc2ggYmV0d2VlbiB0aGUgUmVhbHRlaydzIGlu
LWhvdXNlIGRyaXZlcg0KPiBhbmQgTGludXgga2VybmVsIHI4MTUyIGRyaXZlci4gSXQgZG9l
c24ndCBtZWFuIHlvdSBoYXZlIHRvIHVzZSB2ZXJzaW9uIDIsDQo+IGV2ZW4gdGhlIHZlcnNp
b24gMiBtYXkgY29udGFpbiBtb3JlIGV4cGVyaW1lbnQgZmVhdHVyZXMuDQo+IA0KPiBCZXN0
IFJlZ2FyZHMsDQo+IEhheWVzDQo+IA0KDQpUaGFua3MgZm9yIGNsYXJpZnlpbmcgdGhpcywg
YW5kIHRoYW5rcyBHcmVnIGZvciB5b3VyIGFkdmljZSBpbiB0aGUNCnByZXZpb3VzIG1lc3Nh
Z2UuIEkgd2lsbCBmb2xsb3cgR3JlZydzIGFkdmljZSBhbmQgdHJ5IGFuZCBpZGVudGlmeSB0
aGF0DQpiaXRzIG9mIGNvZGUgdGhhdCBmaXhlcyBteSBpc3N1ZSBvZiBoYXZpbmcgdGhyb3R0
bGVkIGRhdGEtdHJhbnNmZXIgc3BlZWQNCnZpYSBldGhlcm5ldC4NCg0KSWYgeW91IGhhdmUg
c29tZSBraW5kIG9mIGluLWhvdXNlIGNoYW5nZWxvZyB0aGF0IHlvdSBjb3VsZCBtYWtlDQph
dmFpbGFibGUgdG8gbWUsIEkgd291bGQgYmUgZ3JhdGVmdWwuDQoNCkJlc3QsDQoNCkFsYmVy
dA0K
--------------CldSIYaYo2LfzVE0L9X4Grcx
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

--------------CldSIYaYo2LfzVE0L9X4Grcx--

--------------MgoHGP9020Aw5HuBmfNO49Co--

--------------FAvgt7UPn3SkZjIgK9IU0RN6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRLx2w8czp1EBJaieEhj+NExaaGfQUCY2uM9QUDAAAAAAAKCRAhj+NExaaGfWma
AQC0vUM48I+Q0ZIHQtGbtq7R23xogKxccjkYALK4zmDPCgEA0vtzcprWHnZzsfi+1h+FRAloGEGc
CMw1l91GPhUyswc=
=ZV4q
-----END PGP SIGNATURE-----

--------------FAvgt7UPn3SkZjIgK9IU0RN6--
