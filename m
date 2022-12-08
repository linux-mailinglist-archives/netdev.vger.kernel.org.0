Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B7E6468FC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLHGR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHGR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:17:56 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E227D61759;
        Wed,  7 Dec 2022 22:17:53 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6F6A720699;
        Thu,  8 Dec 2022 06:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670480272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oX4UolmNCM5xta77wTwRZ1ZazXWUDNvf+NNR2464c64=;
        b=bidUMpRX4YBgC6QTeDUbdMoPOxwYFxRleuhwBU8OLJwlhX608G9TwrU3poOl89WzN8HDp1
        eGSOi/7XOwcTTdJa6DRLrztMP1dnOJf9Ucvx/0eJJBdkRhQJZNR7LZ/JM06Zr/H37Hl2rk
        h5rur7fib7EHBz1tVtWHUajTgnmdGNE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2537213416;
        Thu,  8 Dec 2022 06:17:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nngbB5CBkWNocQAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 08 Dec 2022 06:17:52 +0000
Message-ID: <f183c51b-6d81-55e7-3433-e20c6d5604f0@suse.com>
Date:   Thu, 8 Dec 2022 07:17:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yang Yingliang <yangyingliang@huawei.com>
References: <20221208082301.5f7483e8@canb.auug.org.au>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20221208082301.5f7483e8@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------q0HI68tj6UKVMXPI5MYyhztQ"
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------q0HI68tj6UKVMXPI5MYyhztQ
Content-Type: multipart/mixed; boundary="------------fGRLUnwug1ho1ZersnhZbJHD";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
 David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <f183c51b-6d81-55e7-3433-e20c6d5604f0@suse.com>
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
References: <20221208082301.5f7483e8@canb.auug.org.au>
In-Reply-To: <20221208082301.5f7483e8@canb.auug.org.au>

--------------fGRLUnwug1ho1ZersnhZbJHD
Content-Type: multipart/mixed; boundary="------------KuD8Ek6F2D08rmC9K79aZ7rS"

--------------KuD8Ek6F2D08rmC9K79aZ7rS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMTIuMjIgMjI6MjMsIFN0ZXBoZW4gUm90aHdlbGwgd3JvdGU6DQo+IEhpIGFsbCwN
Cj4gDQo+IFRvZGF5J3MgbGludXgtbmV4dCBtZXJnZSBvZiB0aGUgbmV0IHRyZWUgZ290IGEg
Y29uZmxpY3QgaW46DQo+IA0KPiAgICBkcml2ZXJzL25ldC94ZW4tbmV0YmFjay9yeC5jDQo+
IA0KPiBiZXR3ZWVuIGNvbW1pdDoNCj4gDQo+ICAgIDc0ZTdlMWVmZGFkNCAoInhlbi9uZXRi
YWNrOiBkb24ndCBjYWxsIGtmcmVlX3NrYigpIHdpdGggaW50ZXJydXB0cyBkaXNhYmxlZCIp
DQo+IA0KPiBmcm9tIExpbnVzJyB0cmVlIGFuZCBjb21taXQ6DQo+IA0KPiAgICA5ZTYyNDY1
MTg1OTIgKCJ4ZW4vbmV0YmFjazogZG9uJ3QgY2FsbCBrZnJlZV9za2IoKSB1bmRlciBzcGlu
X2xvY2tfaXJxc2F2ZSgpIikNCj4gDQo+IGZyb20gdGhlIG5ldCB0cmVlLg0KPiANCj4gSSBm
aXhlZCBpdCB1cCAoSSBqdXN0IHVzZWQgdGhlIHZlcnNpb24gZnJvbSBMaW51cycgdHJlZSkg
YW5kIGNhbiBjYXJyeSB0aGUNCj4gZml4IGFzIG5lY2Vzc2FyeS4gVGhpcyBpcyBub3cgZml4
ZWQgYXMgZmFyIGFzIGxpbnV4LW5leHQgaXMgY29uY2VybmVkLA0KPiBidXQgYW55IG5vbiB0
cml2aWFsIGNvbmZsaWN0cyBzaG91bGQgYmUgbWVudGlvbmVkIHRvIHlvdXIgdXBzdHJlYW0N
Cj4gbWFpbnRhaW5lciB3aGVuIHlvdXIgdHJlZSBpcyBzdWJtaXR0ZWQgZm9yIG1lcmdpbmcu
ICBZb3UgbWF5IGFsc28gd2FudA0KPiB0byBjb25zaWRlciBjb29wZXJhdGluZyB3aXRoIHRo
ZSBtYWludGFpbmVyIG9mIHRoZSBjb25mbGljdGluZyB0cmVlIHRvDQo+IG1pbmltaXNlIGFu
eSBwYXJ0aWN1bGFybHkgY29tcGxleCBjb25mbGljdHMuDQo+IA0KDQpZZXMsIHRoaXMgaXMg
dGhlIGNvcnJlY3Qgc29sdXRpb24uIFRoZSBwYXRjaCBpbiB0aGUgbmV0IHRyZWUgd2FzIG5v
dCBjb21wbGV0ZQ0KYW5kIHRoZSBvdGhlciBwYXRjaCBuZWVkZWQgdG8gcHVzaGVkIGFzIGl0
IGZpeGVzIGEgMC1kYXkgc2VjdXJpdHkgaXNzdWUuDQoNCg0KSnVlcmdlbg0K
--------------KuD8Ek6F2D08rmC9K79aZ7rS
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------KuD8Ek6F2D08rmC9K79aZ7rS--

--------------fGRLUnwug1ho1ZersnhZbJHD--

--------------q0HI68tj6UKVMXPI5MYyhztQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmORgY8FAwAAAAAACgkQsN6d1ii/Ey+d
eAgAhJH61bxkahk9X/mF7o2lIybqFhyniS/HtUKTvs0VN/tf32Yzvl/KXhD8C+yz3Ws5CHBfvvPf
EEwrCgr7zuu1NpzN3UusXRpTQkcu8NMWUMRgHXaOjZ1ka6oilmyMgJfMWW4g93c8HnkS/TZHP61w
kv6MfxLZxub4aif89XBAVD52FBq9a4Oj1YdJgvwyh+3ISpLRTZhNTL3Pp6Som8dhrSYg9jKcLJYa
Qlie0IrJ5h4ifD98Gx8Il8t1dh3ZQIkrWUG2Mt17TSeoDOa4d2D5t4W+yCeZ9z4DEvkJ/AqOpYsB
BTlls4hn/ALQnx0vGidSjMsImmJt8k9WoeuY+ap8Ng==
=tBEY
-----END PGP SIGNATURE-----

--------------q0HI68tj6UKVMXPI5MYyhztQ--
