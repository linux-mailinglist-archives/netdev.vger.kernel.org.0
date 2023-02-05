Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4EB68AFE5
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjBENQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBENQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:16:13 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BD71E5C8;
        Sun,  5 Feb 2023 05:16:11 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso9035738wms.0;
        Sun, 05 Feb 2023 05:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsetZs904yH5wUej+MTDDUQhu6pK8xMj7rT0RlaTPqI=;
        b=C2Tp13arsdeOOUzh7REij6BeZIKFJRtLOyQsxkOQTK5JL7vz0kOD/Kfu+H1VsKEpnb
         9nKXORNvfZVsDO0Cuucta92K5YirWSPDBgKIXKlZJuCw9xZUZta2vFCYu55b6czkLdUK
         5QexkmW0qHJsepvRuhtMvQCtO9AMwPVkyEQQdC7idDK9ju8P6MgfBgsZIH6BIwXSPOT4
         Fkt72RibQcQAa12Zlzg+iT8Q9+rMkQ75aiXmDtcc7ka4l+aMiDVjDF/kbHykZ5utK7Uc
         /zHKSKA+48y7p0F5/bAh1xfsGSUTARKIe9CRkMjtdf3NJ9ituf7lODY2yxGJD3Z813ZJ
         N1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lsetZs904yH5wUej+MTDDUQhu6pK8xMj7rT0RlaTPqI=;
        b=ubw54Y6fTtUPnMa0uynkbK0XBVfaIDAyoVMhlpccQWBLGPAnZ+8y6JABWCJ6jvrq3S
         Ojbq/byQvEgC8og2KRy/zDfW0WWMP9KoPidwnSLO5tui1cymbktIjIrFGxc74RmVss0n
         xr6uzIzVRiq00yVjJ1agK9WSFYc3CaBm2wydURpsmDqvZTw76X0tBZ6IGE2MZMttcCIB
         wgvMyndTt7WoFWZDoS+2mykmAURYS9GDDD3RoJuYSNcNk+/BpV1SIXwlLa7tw8Gnh53k
         OExRY5o8a9XLhw5tpjQomIM2sQsFpzHf7L+URuY4560OMK80joTyEe3+UCYs8EeydTua
         UtCQ==
X-Gm-Message-State: AO0yUKWsaOQnrZNex/t3CZf+vKZLcr8whX/5qO0VaXjqD0GbxoYmZiFF
        xoXa1AO+QV7Hjb8UGoavtziIrK4/x0A=
X-Google-Smtp-Source: AK7set9mzS7IWV8ZFUAbnn44KoxAydJg9gxS/5KLfCNXDaUEyZBQjB1PgpHcYacmygbLaqEcXKs1sw==
X-Received: by 2002:a1c:ed11:0:b0:3da:50b0:e96a with SMTP id l17-20020a1ced11000000b003da50b0e96amr15593029wmh.29.1675602969909;
        Sun, 05 Feb 2023 05:16:09 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id s24-20020a05600c319800b003dfe5190376sm7606062wmp.35.2023.02.05.05.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Feb 2023 05:16:09 -0800 (PST)
Message-ID: <d6682d52-25b3-a79f-c4db-6d720986b273@gmail.com>
Date:   Sun, 5 Feb 2023 14:16:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] ip.7: Document IP_LOCAL_PORT_RANGE socket option
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
References: <20230201123634.284689-1-jakub@cloudflare.com>
Content-Language: en-US
From:   Alejandro Colomar <alx.manpages@gmail.com>
In-Reply-To: <20230201123634.284689-1-jakub@cloudflare.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------q883Kcke8GjHVqEQr8mx6Ahd"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------q883Kcke8GjHVqEQr8mx6Ahd
Content-Type: multipart/mixed; boundary="------------xQtU6nzVAgqDham4q4y09TWn";
 protected-headers="v1"
From: Alejandro Colomar <alx.manpages@gmail.com>
To: Jakub Sitnicki <jakub@cloudflare.com>,
 Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-man@vger.kernel.org, netdev@vger.kernel.org,
 kernel-team@cloudflare.com
Message-ID: <d6682d52-25b3-a79f-c4db-6d720986b273@gmail.com>
Subject: Re: [PATCH] ip.7: Document IP_LOCAL_PORT_RANGE socket option
References: <20230201123634.284689-1-jakub@cloudflare.com>
In-Reply-To: <20230201123634.284689-1-jakub@cloudflare.com>

--------------xQtU6nzVAgqDham4q4y09TWn
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgSmFrdWIsDQoNCk9uIDIvMS8yMyAxMzozNiwgSmFrdWIgU2l0bmlja2kgd3JvdGU6DQo+
IExpbnV4IGNvbW1pdCA5MWQwYjc4YzUxNzcgKCJpbmV0OiBBZGQgSVBfTE9DQUxfUE9SVF9S
QU5HRSBzb2NrZXQgb3B0aW9uIikNCj4gaW50cm9kdWNlZCBhIG5ldyBzb2NrZXQgb3B0aW9u
IGF2YWlsYWJsZSBmb3IgQUZfSU5FVCBhbmQgQUZfSU5FVDYgc29ja2V0cy4NCj4gDQo+IE9w
dGlvbiB3aWxsIGJlIGF2YWlsYWJsZSBzdGFydGluZyBmcm9tIExpbnV4IDYuMy4gRG9jdW1l
bnQgaXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKYWt1YiBTaXRuaWNraSA8amFrdWJAY2xv
dWRmbGFyZS5jb20+DQo+IC0tLQ0KPiBTdWJtaXR0aW5nIHRoaXMgbWFuIHBhZ2UgdXBkYXRl
IGFzIHRoZSBhdXRob3Igb2YgdGhlIGZlYXR1cmUuDQo+IA0KPiBXZSBkaWQgYSB0ZWNobmlj
YWwgcmV2aWV3IG9mIHRoZSBtYW4gcGFnZSB0ZXh0IHRvZ2V0aGVyIHdpdGggdGhlIGNvZGUg
WzFdLg0KDQpUaGUgZm9ybWF0dGluZyBMR1RNLiAgQ291bGQgeW91IHBsZWFzZSByZXNlbmQg
d2hlbiBpdCBhcnJpdmVzIHRvIExpbnVzJ3MgdHJlZT8NCg0KQ2hlZXJzLA0KDQpBbGV4DQoN
Cj4gDQo+IFsxXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIxMjIxLXNvY2tv
cHQtcG9ydC1yYW5nZS12Ni0wLWJlMjU1Y2MwZTUxZkBjbG91ZGZsYXJlLmNvbS8NCj4gLS0t
DQo+ICAgbWFuNy9pcC43IHwgMjEgKysrKysrKysrKysrKysrKysrKysrDQo+ICAgMSBmaWxl
IGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9tYW43L2lw
LjcgYi9tYW43L2lwLjcNCj4gaW5kZXggZjY5YWYxYjMyLi5mMTY2YzNiNTcgMTAwNjQ0DQo+
IC0tLSBhL21hbjcvaXAuNw0KPiArKysgYi9tYW43L2lwLjcNCj4gQEAgLTQzOSw2ICs0Mzks
MjcgQEAgYW5kDQo+ICAgLkIgSVBfVE9TDQo+ICAgYXJlIGlnbm9yZWQuDQo+ICAgLlRQDQo+
ICsuQlIgSVBfTE9DQUxfUE9SVF9SQU5HRSAiIChzaW5jZSBMaW51eCA2LjMpIg0KPiArU2V0
IG9yIGdldCB0aGUgcGVyLXNvY2tldCBkZWZhdWx0IGxvY2FsIHBvcnQgcmFuZ2UuIFRoaXMg
b3B0aW9uIGNhbiBiZSB1c2VkIHRvDQo+ICtjbGFtcCBkb3duIHRoZSBnbG9iYWwgbG9jYWwg
cG9ydCByYW5nZSwgZGVmaW5lZCBieSB0aGUNCj4gKy5JIGlwX2xvY2FsX3BvcnRfcmFuZ2UN
Cj4gKy5JIC9wcm9jDQo+ICtpbnRlcmZhY2UgZGVzY3JpYmVkIGJlbG93LCBmb3IgYSBnaXZl
biBzb2NrZXQuDQo+ICsuSVANCj4gK1RoZSBvcHRpb24gdGFrZXMgYW4NCj4gKy5JIHVpbnQz
Ml90DQo+ICt2YWx1ZSB3aXRoIHRoZSBoaWdoIDE2IGJpdHMgc2V0IHRvIHRoZSB1cHBlciBy
YW5nZSBib3VuZCwgYW5kIHRoZSBsb3cgMTYgYml0cw0KPiArc2V0IHRvIHRoZSBsb3dlciBy
YW5nZSBib3VuZC4gUmFuZ2UgYm91bmRzIGFyZSBpbmNsdXNpdmUuIFRoZSAxNi1iaXQgdmFs
dWVzDQo+ICtzaG91bGQgYmUgaW4gaG9zdCBieXRlIG9yZGVyLg0KPiArLklQDQo+ICtUaGUg
bG93ZXIgYm91bmQgaGFzIHRvIGJlIGxlc3MgdGhhbiB0aGUgdXBwZXIgYm91bmQgd2hlbiBi
b3RoIGJvdW5kcyBhcmUgbm90DQo+ICt6ZXJvLiBPdGhlcndpc2UsIHNldHRpbmcgdGhlIG9w
dGlvbiBmYWlscyB3aXRoIEVJTlZBTC4NCj4gKy5JUA0KPiArSWYgZWl0aGVyIGJvdW5kIGlz
IG91dHNpZGUgb2YgdGhlIGdsb2JhbCBsb2NhbCBwb3J0IHJhbmdlLCBvciBpcyB6ZXJvLCB0
aGVuIHRoYXQNCj4gK2JvdW5kIGhhcyBubyBlZmZlY3QuDQo+ICsuSVANCj4gK1RvIHJlc2V0
IHRoZSBzZXR0aW5nLCBwYXNzIHplcm8gYXMgYm90aCB0aGUgdXBwZXIgYW5kIHRoZSBsb3dl
ciBib3VuZC4NCj4gKy5UUA0KPiAgIC5CUiBJUF9NU0ZJTFRFUiAiIChzaW5jZSBMaW51eCAy
LjQuMjIgLyAyLjUuNjgpIg0KPiAgIFRoaXMgb3B0aW9uIHByb3ZpZGVzIGFjY2VzcyB0byB0
aGUgYWR2YW5jZWQgZnVsbC1zdGF0ZSBmaWx0ZXJpbmcgQVBJLg0KPiAgIEFyZ3VtZW50IGlz
IGFuDQoNCi0tIA0KPGh0dHA6Ly93d3cuYWxlamFuZHJvLWNvbG9tYXIuZXMvPg0KR1BHIGtl
eSBmaW5nZXJwcmludDogQTkzNDg1OTRDRTMxMjgzQTgyNkZCREQ4RDU3NjMzRDQ0MUUyNUJC
NQ0K

--------------xQtU6nzVAgqDham4q4y09TWn--

--------------q883Kcke8GjHVqEQr8mx6Ahd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6jqH8KTroDDkXfJAnowa+77/2zIFAmPfrBAACgkQnowa+77/
2zJXlQ/9Em0msQJoz2hEqrcW1oKVf59XSIbiornYqTodh9wmN0ppujFJSmtCZlIx
LC7M78El47LNiPVc2qhpwGe53HGP5b/lNGeZ+bLe5bO5EBcrGclbm50SKHSQ6+MA
NonC0/jsWv16J6v6PCqYRd8jYF0ZYptqblFDJKoYtMoCqXAyTEPwwMN0caH/DliB
cIfLl0WfjX6xvdCp5G3EDsMBRUwWmspjOXeFxjWU1sAoYQRydf7p8JiiR57FIO37
pHZK83nFRkSqVNnZmAFi0ifZL/KcJyiMIGsa24CEcdmMoFMMEVCFGBWdhlvbIxoi
U3RoxDr1QNk+y/tOJ9h3VLrfchiOMf/uUOB4ZzCTsSzz4oejcWRecv89kVQrnlwV
Q/2cRB5t41nkXi0GBZ7jhiGK1qUs2iwEK9afxosfJvzF+jsvsN4OV4ZfzdUmdyf8
JJ77FJrXtNt7r8ZWB52W9oIM23EqcaDAvwqTB5Vxa4K+X1rvXSx5CaPHSKCQytZz
DwKYhmZOJcAliccdapvXBFw/C3p6JOqhz9palx+8lFIqByIDk3MtHQwMV3yg+fUf
omypxwLKFNrddeFpOripFEGFdkJ99w1jA4k6F+nJsqruAkea3a1ov4XeM/xZ1qu0
KY9tfmQefKCt+aF4zFMjGUTcLwvVKzhw8uB8FvSuhzShMvwTYZo=
=0Jjt
-----END PGP SIGNATURE-----

--------------q883Kcke8GjHVqEQr8mx6Ahd--
