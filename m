Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE75B856A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiINJpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiINJpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:45:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C778912ADF
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:45:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 59B3F5CBED;
        Wed, 14 Sep 2022 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663148715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yKfeJbs5hDA1o+ehIbGNBCxMhbUIcPjrCsvY/2cHkGk=;
        b=gooCARLUKZSIjud7D9AvrBfUKSxeZksVlb1RPSheoj5JXZuC6n4xxoF2y/Bl2cLj/9vkCS
        Csxu/Vg/YTJmb1z73Vk/AfJYgj4NJ3QRg9WewurGmr3JC2oHB9IMwDqIjLDMNQCuithW2e
        iXb91qGHh60wkR8BwkvqSMgYBt3URJ8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D32E134B3;
        Wed, 14 Sep 2022 09:45:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id n/4WBKuiIWM8NAAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 14 Sep 2022 09:45:15 +0000
Message-ID: <f42951ae-bbca-bd19-d2aa-e82a6e6d5396@suse.com>
Date:   Wed, 14 Sep 2022 11:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net] xen-netback: only remove 'hotplug-status' when the
 vif is actually destroyed
Content-Language: en-US
To:     Paul Durrant <pdurrant@amazon.com>, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
References: <20220901115554.16996-1-pdurrant@amazon.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220901115554.16996-1-pdurrant@amazon.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------mKgRau0TPHWuTQ3U8s6OtcMJ"
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------mKgRau0TPHWuTQ3U8s6OtcMJ
Content-Type: multipart/mixed; boundary="------------CFFRyEQ0whO2VsENi2DVBvXQ";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Paul Durrant <pdurrant@amazon.com>, netdev@vger.kernel.org,
 xen-devel@lists.xenproject.org
Cc: Wei Liu <wei.liu@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= <marmarek@invisiblethingslab.com>
Message-ID: <f42951ae-bbca-bd19-d2aa-e82a6e6d5396@suse.com>
Subject: Re: [PATCH net] xen-netback: only remove 'hotplug-status' when the
 vif is actually destroyed
References: <20220901115554.16996-1-pdurrant@amazon.com>
In-Reply-To: <20220901115554.16996-1-pdurrant@amazon.com>

--------------CFFRyEQ0whO2VsENi2DVBvXQ
Content-Type: multipart/mixed; boundary="------------Ku6rUqdbMST8shpZCHASxAtE"

--------------Ku6rUqdbMST8shpZCHASxAtE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDEuMDkuMjIgMTM6NTUsIFBhdWwgRHVycmFudCB3cm90ZToNCj4gUmVtb3ZpbmcgJ2hv
dHBsdWctc3RhdHVzJyBpbiBiYWNrZW5kX2Rpc2Nvbm5lY3RlZCgpIG1lYW5zIHRoYXQgaXQg
d2lsbCBiZQ0KPiByZW1vdmVkIGV2ZW4gaW4gdGhlIGNhc2UgdGhhdCB0aGUgZnJvbnRlbmQg
dW5pbGF0ZXJhbGx5IGRpc2Nvbm5lY3RzICh3aGljaA0KPiBpdCBpcyBmcmVlIHRvIGRvIGF0
IGFueSB0aW1lKS4gVGhlIGNvbnNlcXVlbmNlIG9mIHRoaXMgaXMgdGhhdCwgd2hlbiB0aGUN
Cj4gZnJvbnRlbmQgYXR0ZW1wdHMgdG8gcmUtY29ubmVjdCwgdGhlIGJhY2tlbmQgZ2V0cyBz
dHVjayBpbiAnSW5pdFdhaXQnDQo+IHJhdGhlciB0aGFuIG1vdmluZyBzdHJhaWdodCB0byAn
Q29ubmVjdGVkJyAod2hpY2ggaXQgY2FuIGRvIGJlY2F1c2UgdGhlDQo+IGhvdHBsdWcgc2Ny
aXB0IGhhcyBhbHJlYWR5IHJ1bikuDQo+IEluc3RlYWQsIHRoZSAnaG90cGx1Zy1zdGF0dXMn
IG1vZGUgc2hvdWxkIGJlIHJlbW92ZWQgaW4gbmV0YmFja19yZW1vdmUoKQ0KPiBpLmUuIHdo
ZW4gdGhlIHZpZiByZWFsbHkgaXMgZ29pbmcgYXdheS4NCj4gDQo+IEZpeGVzOiAwZjQ1NThh
ZTkxODcgKCJSZXZlcnQgInhlbi1uZXRiYWNrOiByZW1vdmUgJ2hvdHBsdWctc3RhdHVzJyBv
bmNlIGl0IGhhcyBzZXJ2ZWQgaXRzIHB1cnBvc2UiIikNCj4gU2lnbmVkLW9mZi1ieTogUGF1
bCBEdXJyYW50IDxwZHVycmFudEBhbWF6b24uY29tPg0KDQpSZXZpZXdlZC1ieTogSnVlcmdl
biBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJnZW4NCg==
--------------Ku6rUqdbMST8shpZCHASxAtE
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------Ku6rUqdbMST8shpZCHASxAtE--

--------------CFFRyEQ0whO2VsENi2DVBvXQ--

--------------mKgRau0TPHWuTQ3U8s6OtcMJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMhoqoFAwAAAAAACgkQsN6d1ii/Ey8Z
Xgf+Pl5pBGReldtMqSYSmITrQFpThIYU5cj2ulvyltkDXipWyYnAUcPbt00S5TUfmno+hNcLL/tj
nZHMmmacifcOMWTVmLc2y9BC6DRITsBFukQRZFVOXGm7CwW/U+Nm497MeRXqKYz8O6l8G/DP3nLc
Etkn2lcT0pyyWfwG7xOlYE0VhhWkRf++agkpVbwUbvnMS+lng3T6qJWcaijMAxrk2cge9QSQ9FNp
io8vrNHT2jfcyYXsd/7koB0eQC8AVPSrky89/U31dbkhlO8PU+RpeXQ/75AZyB6kG1SuJrwPOnJc
55k883J/k5MrgmaoLMNp8kOzFN2+cyzVnuKhPGkEhA==
=LrKm
-----END PGP SIGNATURE-----

--------------mKgRau0TPHWuTQ3U8s6OtcMJ--
