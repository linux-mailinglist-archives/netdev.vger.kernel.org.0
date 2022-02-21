Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DBD4BD684
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345145AbiBUG16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 01:27:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345143AbiBUG15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 01:27:57 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4243818C;
        Sun, 20 Feb 2022 22:27:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 294BF1F382;
        Mon, 21 Feb 2022 06:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645424853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UY4426qAxxmQ2a9UManO4VFLDik/euHBVCCtWIwUXac=;
        b=IzZDdC5lACReo2lR2HlJ/oKJvtQ+HAWBTb3rEPytQ8H9NA7H/os76KaXlUcC4M3vZh/DcQ
        IH1CBkiZKO7mdedHnfhtmxGypUxnpPoXn0SiZrwH7h3G2hq6pLHzaOxZlceFKLbnl0qzC/
        EF8WyDVAdGnzPwUETAoAUB0n17+SueA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B803C12FC5;
        Mon, 21 Feb 2022 06:27:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zxmAKtQwE2LdOQAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 21 Feb 2022 06:27:32 +0000
Message-ID: <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
Date:   Mon, 21 Feb 2022 07:27:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        "moderated list:XEN HYPERVISOR INTERFACE" 
        <xen-devel@lists.xenproject.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues is
 zeroed
In-Reply-To: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------NbSvRM0BXdfOCmjjjQR4XP0G"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------NbSvRM0BXdfOCmjjjQR4XP0G
Content-Type: multipart/mixed; boundary="------------BcFvWjNSSH2gGq1foKq12Wbr";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Antoine Tenart <atenart@kernel.org>,
 "moderated list:XEN HYPERVISOR INTERFACE" <xen-devel@lists.xenproject.org>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Message-ID: <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues is
 zeroed
References: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
In-Reply-To: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>

--------------BcFvWjNSSH2gGq1foKq12Wbr
Content-Type: multipart/mixed; boundary="------------rVg6F7eL5G4iBBp0YLU80g2c"

--------------rVg6F7eL5G4iBBp0YLU80g2c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAuMDIuMjIgMTQ6NDIsIE1hcmVrIE1hcmN6eWtvd3NraS1Hw7NyZWNraSB3cm90ZToN
Cj4geGVubmV0X2Rlc3Ryb3lfcXVldWVzKCkgcmVsaWVzIG9uIGluZm8tPm5ldGRldi0+cmVh
bF9udW1fdHhfcXVldWVzIHRvDQo+IGRlbGV0ZSBxdWV1ZXMuIFNpbmNlIGQ3ZGFjMDgzNDE0
ZWI1YmI5OWE2ZDJlZDUzZGMyYzFiNDA1MjI0ZTUNCj4gKCJuZXQtc3lzZnM6IHVwZGF0ZSB0
aGUgcXVldWUgY291bnRzIGluIHRoZSB1bnJlZ2lzdHJhdGlvbiBwYXRoIiksDQo+IHVucmVn
aXN0ZXJfbmV0ZGV2KCkgaW5kaXJlY3RseSBzZXRzIHJlYWxfbnVtX3R4X3F1ZXVlcyB0byAw
LiBUaG9zZSB0d28NCj4gZmFjdHMgdG9nZXRoZXIgbWVhbnMsIHRoYXQgeGVubmV0X2Rlc3Ry
b3lfcXVldWVzKCkgY2FsbGVkIGZyb20NCj4geGVubmV0X3JlbW92ZSgpIGNhbm5vdCBkbyBp
dHMgam9iLCBiZWNhdXNlIGl0J3MgY2FsbGVkIGFmdGVyDQo+IHVucmVnaXN0ZXJfbmV0ZGV2
KCkuIFRoaXMgcmVzdWx0cyBpbiBrZnJlZS1pbmcgcXVldWVzIHRoYXQgYXJlIHN0aWxsDQo+
IGxpbmtlZCBpbiBuYXBpLCB3aGljaCB1bHRpbWF0ZWx5IGNyYXNoZXM6DQo+IA0KPiAgICAg
IEJVRzoga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwgYWRkcmVzczogMDAwMDAw
MDAwMDAwMDAwMA0KPiAgICAgICNQRjogc3VwZXJ2aXNvciByZWFkIGFjY2VzcyBpbiBrZXJu
ZWwgbW9kZQ0KPiAgICAgICNQRjogZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQg
cGFnZQ0KPiAgICAgIFBHRCAwIFA0RCAwDQo+ICAgICAgT29wczogMDAwMCBbIzFdIFBSRUVN
UFQgU01QIFBUSQ0KPiAgICAgIENQVTogMSBQSUQ6IDUyIENvbW06IHhlbndhdGNoIFRhaW50
ZWQ6IEcgICAgICAgIFcgICAgICAgICA1LjE2LjEwLTEuMzIuZmMzMi5xdWJlcy54ODZfNjQr
ICMyMjYNCj4gICAgICBSSVA6IDAwMTA6ZnJlZV9uZXRkZXYrMHhhMy8weDFhMA0KPiAgICAg
IENvZGU6IGZmIDQ4IDg5IGRmIGU4IDJlIGU5IDAwIDAwIDQ4IDhiIDQzIDUwIDQ4IDhiIDA4
IDQ4IDhkIGI4IGEwIGZlIGZmIGZmIDQ4IDhkIGE5IGEwIGZlIGZmIGZmIDQ5IDM5IGM0IDc1
IDI2IGViIDQ3IGU4IGVkIGMxIDY2IGZmIDw0OD4gOGIgODUgNjAgMDEgMDAgMDAgNDggOGQg
OTUgNjAgMDEgMDAgMDAgNDggODkgZWYgNDggMmQgNjAgMDEgMDANCj4gICAgICBSU1A6IDAw
MDA6ZmZmZmM5MDAwMGJjZmQwMCBFRkxBR1M6IDAwMDEwMjg2DQo+ICAgICAgUkFYOiAwMDAw
MDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4ODAwZWRhZDAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAw
MDANCj4gICAgICBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiBmZmZmYzkwMDAwYmNmYzMw
IFJESTogMDAwMDAwMDBmZmZmZmZmZg0KPiAgICAgIFJCUDogZmZmZmZmZmZmZmZmZmVhMCBS
MDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAwDQo+ICAgICAgUjEw
OiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMSBSMTI6IGZmZmY4ODgw
MGVkYWQwNTANCj4gICAgICBSMTM6IGZmZmY4ODgwMDY1ZjhmODggUjE0OiAwMDAwMDAwMDAw
MDAwMDAwIFIxNTogZmZmZjg4ODAwNjZjNjY4MA0KPiAgICAgIEZTOiAgMDAwMDAwMDAwMDAw
MDAwMCgwMDAwKSBHUzpmZmZmODg4MGYzMzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAw
MDAwMDANCj4gICAgICBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAw
MDgwMDUwMDMzDQo+ICAgICAgQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDBl
OTk4YzAwNiBDUjQ6IDAwMDAwMDAwMDAzNzA2ZTANCj4gICAgICBDYWxsIFRyYWNlOg0KPiAg
ICAgICA8VEFTSz4NCj4gICAgICAgeGVubmV0X3JlbW92ZSsweDEzZC8weDMwMCBbeGVuX25l
dGZyb250XQ0KPiAgICAgICB4ZW5idXNfZGV2X3JlbW92ZSsweDZkLzB4ZjANCj4gICAgICAg
X19kZXZpY2VfcmVsZWFzZV9kcml2ZXIrMHgxN2EvMHgyNDANCj4gICAgICAgZGV2aWNlX3Jl
bGVhc2VfZHJpdmVyKzB4MjQvMHgzMA0KPiAgICAgICBidXNfcmVtb3ZlX2RldmljZSsweGQ4
LzB4MTQwDQo+ICAgICAgIGRldmljZV9kZWwrMHgxOGIvMHg0MTANCj4gICAgICAgPyBfcmF3
X3NwaW5fdW5sb2NrKzB4MTYvMHgzMA0KPiAgICAgICA/IGtsaXN0X2l0ZXJfZXhpdCsweDE0
LzB4MjANCj4gICAgICAgPyB4ZW5idXNfZGV2X3JlcXVlc3RfYW5kX3JlcGx5KzB4ODAvMHg4
MA0KPiAgICAgICBkZXZpY2VfdW5yZWdpc3RlcisweDEzLzB4NjANCj4gICAgICAgeGVuYnVz
X2Rldl9jaGFuZ2VkKzB4MThlLzB4MWYwDQo+ICAgICAgIHhlbndhdGNoX3RocmVhZCsweGMw
LzB4MWEwDQo+ICAgICAgID8gZG9fd2FpdF9pbnRyX2lycSsweGEwLzB4YTANCj4gICAgICAg
a3RocmVhZCsweDE2Yi8weDE5MA0KPiAgICAgICA/IHNldF9rdGhyZWFkX3N0cnVjdCsweDQw
LzB4NDANCj4gICAgICAgcmV0X2Zyb21fZm9yaysweDIyLzB4MzANCj4gICAgICAgPC9UQVNL
Pg0KPiANCj4gRml4IHRoaXMgYnkgY2FsbGluZyB4ZW5uZXRfZGVzdHJveV9xdWV1ZXMoKSBm
cm9tIHhlbm5ldF9jbG9zZSgpIHRvbywNCj4gd2hlbiByZWFsX251bV90eF9xdWV1ZXMgaXMg
c3RpbGwgYXZhaWxhYmxlLiBUaGlzIGVuc3VyZXMgdGhhdCBxdWV1ZXMgYXJlDQo+IGRlc3Ry
b3llZCB3aGVuIHJlYWxfbnVtX3R4X3F1ZXVlcyBpcyBzZXQgdG8gMCwgcmVnYXJkbGVzcyBv
ZiBob3cNCj4gdW5yZWdpc3Rlcl9uZXRkZXYoKSB3YXMgY2FsbGVkLg0KPiANCj4gT3JpZ2lu
YWxseSByZXBvcnRlZCBhdA0KPiBodHRwczovL2dpdGh1Yi5jb20vUXViZXNPUy9xdWJlcy1p
c3N1ZXMvaXNzdWVzLzcyNTcNCj4gDQo+IEZpeGVzOiBkN2RhYzA4MzQxNGViNWJiOSAoIm5l
dC1zeXNmczogdXBkYXRlIHRoZSBxdWV1ZSBjb3VudHMgaW4gdGhlIHVucmVnaXN0cmF0aW9u
IHBhdGgiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIDUuMTYrDQo+IFNpZ25l
ZC1vZmYtYnk6IE1hcmVrIE1hcmN6eWtvd3NraS1Hw7NyZWNraSA8bWFybWFyZWtAaW52aXNp
YmxldGhpbmdzbGFiLmNvbT4NCj4gDQo+IC0tLQ0KPiBXaGlsZSB0aGlzIGZpeGVzIHRoZSBp
c3N1ZSwgSSdtIG5vdCBzdXJlIGlmIHRoYXQgaXMgdGhlIGNvcnJlY3QgdGhpbmcNCj4gdG8g
ZG8uIHhlbm5ldF9yZW1vdmUoKSBjYWxscyB4ZW5uZXRfZGVzdHJveV9xdWV1ZXMoKSB1bmRl
ciBydG5sX2xvY2ssDQo+IHdoaWNoIG1heSBiZSBpbXBvcnRhbnQgaGVyZT8gSnVzdCBtb3Zp
bmcgeGVubmV0X2Rlc3Ryb3lfcXVldWVzKCkgYmVmb3JlDQoNCkkgY2hlY2tlZCBzb21lIG9m
IHRoZSBjYWxsIHBhdGhzIGxlYWRpbmcgdG8geGVubmV0X2Nsb3NlKCksIGFuZCBhbGwgb2YN
CnRob3NlIGNvbnRhaW5lZCBhbiBBU1NFUlRfUlROTCgpLCBzbyBpdCBzZWVtcyB0aGUgcnRu
bF9sb2NrIGlzIGFscmVhZHkNCnRha2VuIGhlcmUuIENvdWxkIHlvdSB0ZXN0IHdpdGggYWRk
aW5nIGFuIEFTU0VSVF9SVE5MKCkgaW4NCnhlbm5ldF9kZXN0cm95X3F1ZXVlcygpPw0KDQo+
IHVucmVnaXN0ZXJfbmV0ZGV2KCkgaW4geGVubmV0X3JlbW92ZSgpIGRpZCBub3QgaGVscGVk
IC0gaXQgY3Jhc2hlZCBpbg0KPiBhbm90aGVyIHdheSAodXNlLWFmdGVyLWZyZWUgaW4geGVu
bmV0X2Nsb3NlKCkpLg0KDQpZZXMsIHRoaXMgd291bGQgbmVlZCB0byBiYXNpY2FsbHkgZG8g
dGhlIHhlbm5ldF9jbG9zZSgpIGhhbmRsaW5nIGluDQp4ZW5uZXRfZGVzdHJveSgpIGluc3Rl
YWQsIHdoaWNoIEkgYmVsaWV2ZSBpcyBub3QgcmVhbGx5IGFuIG9wdGlvbi4NCg0KSW4gY2Fz
ZSB5b3VyIHRlc3Qgd2l0aCB0aGUgYWRkZWQgQVNTRVJUX1JUTkwoKSBkb2Vzbid0IHNob3cg
YW55DQpwcm9ibGVtIHlvdSBjYW4gYWRkIG15Og0KDQpSZXZpZXdlZC1ieTogSnVlcmdlbiBH
cm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQoNCkp1ZXJnZW4NCg==
--------------rVg6F7eL5G4iBBp0YLU80g2c
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------rVg6F7eL5G4iBBp0YLU80g2c--

--------------BcFvWjNSSH2gGq1foKq12Wbr--

--------------NbSvRM0BXdfOCmjjjQR4XP0G
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmITMNQFAwAAAAAACgkQsN6d1ii/Ey94
WQgAgLn2BBds2BiphVyS8FqnqKLE5lHc6MD7cY6TTpM8+8juiDbtnWdN20ZDydlUC9JTKCBOgVUo
cFllyzPJKX3be+9EPxgTMMlvOdAA+y8rc5QYUzCpCiR9sgwRbv6fhOAo4GGvpHVPIQr2vDLAGT6O
HSWpeED8PVk5T0f4wi72EfqhWyagBHYQK5vgsIN4AQupV9tebpi7Y0WOCUPD83RcPIjARUQQj3vz
RMbUaLQ3QZbHPj/d0sUqsQt0Q0JmVQP8RLTbCL1GySGUcE8bwU2uTWpnzUATB1dHm7kDUvJuC77+
tzv8dsEH7k63ZgmmabY9wM/DzhclOdp/Mf4gpmTNhg==
=iNZp
-----END PGP SIGNATURE-----

--------------NbSvRM0BXdfOCmjjjQR4XP0G--
