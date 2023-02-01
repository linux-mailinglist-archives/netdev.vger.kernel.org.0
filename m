Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2382B685FD4
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 07:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBAGhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 01:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBAGhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 01:37:11 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689A0474F4;
        Tue, 31 Jan 2023 22:37:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D29F220A46;
        Wed,  1 Feb 2023 06:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675233425; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqreMaU63+HvaPJyYbP+E09zRQs1MotAZ+weCtSvXXY=;
        b=KAtUum4VQmxRBYNA1hvpEIiOM8cpJyt3czHzy4f4V74+2uJUYMMwEGh6h2NX3fDFCbkT4M
        Jiu0AlvJhbQMVAWU0H+/zDALZgedzxnJNlx/8BOpLoveGAtM5nFoNoyQh3AgiWJGI3BtUG
        qIz9BDTvgNf+FmBj5kT5ZBsPMJ6rDCw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 79B8F13A10;
        Wed,  1 Feb 2023 06:37:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pkBVHJEI2mOcGQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 01 Feb 2023 06:37:05 +0000
Message-ID: <bf452f47-8874-09a9-2d74-6a2ad5bea215@suse.com>
Date:   Wed, 1 Feb 2023 07:37:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] 9p/xen: fix version parsing
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230130113036.7087-1-jgross@suse.com>
 <20230130113036.7087-2-jgross@suse.com> <Y9liesGIeKFkf+tI@corigine.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <Y9liesGIeKFkf+tI@corigine.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Bc52u0iXbOeS7Awm5PwWR7px"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Bc52u0iXbOeS7Awm5PwWR7px
Content-Type: multipart/mixed; boundary="------------0AJrVYBhBKUCFgYheNgv6azH";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
 netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
 Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Message-ID: <bf452f47-8874-09a9-2d74-6a2ad5bea215@suse.com>
Subject: Re: [PATCH 1/2] 9p/xen: fix version parsing
References: <20230130113036.7087-1-jgross@suse.com>
 <20230130113036.7087-2-jgross@suse.com> <Y9liesGIeKFkf+tI@corigine.com>
In-Reply-To: <Y9liesGIeKFkf+tI@corigine.com>

--------------0AJrVYBhBKUCFgYheNgv6azH
Content-Type: multipart/mixed; boundary="------------OJf0pSqot7ghemeu22p9BH9t"

--------------OJf0pSqot7ghemeu22p9BH9t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzEuMDEuMjMgMTk6NDgsIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4gT24gTW9uLCBKYW4g
MzAsIDIwMjMgYXQgMTI6MzA6MzVQTSArMDEwMCwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+
IFdoZW4gY29ubmVjdGluZyB0aGUgWGVuIDlwZnMgZnJvbnRlbmQgdG8gdGhlIGJhY2tlbmQs
IHRoZSAidmVyc2lvbnMiDQo+PiBYZW5zdG9yZSBlbnRyeSB3cml0dGVuIGJ5IHRoZSBiYWNr
ZW5kIGlzIHBhcnNlZCBpbiBhIHdyb25nIHdheS4NCj4+DQo+PiBUaGUgInZlcnNpb25zIiBl
bnRyeSBpcyBkZWZpbmVkIHRvIGNvbnRhaW4gdGhlIHZlcnNpb25zIHN1cHBvcnRlZCBieQ0K
Pj4gdGhlIGJhY2tlbmQgc2VwYXJhdGVkIGJ5IGNvbW1hcyAoZS5nLiAiMSwyIikuIFRvZGF5
IG9ubHkgdmVyc2lvbiAiMSINCj4+IGlzIGRlZmluZWQuIFVuZm9ydHVuYXRlbHkgdGhlIGZy
b250ZW5kIGRvZXNuJ3QgbG9vayBmb3IgIjEiIGJlaW5nDQo+PiBsaXN0ZWQgaW4gdGhlIGVu
dHJ5LCBidXQgaXQgaXMgZXhwZWN0aW5nIHRoZSBlbnRyeSB0byBoYXZlIHRoZSB2YWx1ZQ0K
Pj4gIjEiLg0KPj4NCj4+IFRoaXMgd2lsbCByZXN1bHQgaW4gZmFpbHVyZSBhcyBzb29uIGFz
IHRoZSBiYWNrZW5kIHdpbGwgc3VwcG9ydCBlLmcuDQo+PiB2ZXJzaW9ucyAiMSIgYW5kICIy
Ii4NCj4+DQo+PiBGaXggdGhhdCBieSBzY2FubmluZyB0aGUgZW50cnkgY29ycmVjdGx5Lg0K
Pj4NCj4+IEZpeGVzOiA3MWViZDcxOTIxZTQgKCJ4ZW4vOXBmczogY29ubmVjdCB0byB0aGUg
YmFja2VuZCIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3Vz
ZS5jb20+DQo+IA0KPiBJdCdzIHVuY2xlYXIgaWYgdGhpcyBzZXJpZXMgaXMgdGFyZ2V0ZWQg
YXQgJ25ldCcgb3IgJ25ldC1uZXh0Jy4NCj4gRldJSVcsIEkgZmVlbCBJIGZlZWwgaXQgd291
bGQgYmUgbW9yZSBhcHByb3ByaWF0ZSBmb3IgdGhlIGxhdHRlcg0KPiBhcyB0aGVzZSBkbyBu
b3QgZmVlbCBsaWtlIGJ1ZyBmaXhlczogZmVlbCBmcmVlIHRvIGRpZmZlciBvbiB0aGF0Lg0K
DQpJJ20gZmluZSB3aXRoIG5ldC1uZXh0Lg0KDQpSaWdodCBub3cgdGhlcmUgaXMgbm8gcHJv
YmxlbSB3aXRoIHRoZSBjdXJyZW50IGJlaGF2aW9yLiBUaGlzIHdpbGwNCmNoYW5nZSBvbmx5
IGluIGNhc2UgWGVuIHN0YXJ0cyB0byBzdXBwb3J0IGEgbmV3IHRyYW5zcG9ydCB2ZXJzaW9u
Lg0KDQpGb3IgdGhlIG90aGVyIHBhdGNoIHRoZSBwcm9ibGVtIHdvdWxkIHNob3cgdXAgb25s
eSBpZiBYZW4gc3RhcnRzDQpzdXBwb3J0aW5nIGR5bmFtaWNhbCBhdHRhY2gvZGV0YWNoIG9m
IDlwZnMgZGV2aWNlcywgd2hpY2ggaXMgbm90DQp0aGUgY2FzZSByaWdodCBub3cuDQoNCj4g
DQo+IFJlZ2FyZGxlc3MsDQo+IA0KPiBSZXZpZXdlZC1ieTogU2ltb24gSG9ybWFuIDxzaW1v
bi5ob3JtYW5AY29yaWdpbmUuY29tPg0KPiANCg0KVGhhbmtzLA0KDQoNCkp1ZXJnZW4NCg==

--------------OJf0pSqot7ghemeu22p9BH9t
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------OJf0pSqot7ghemeu22p9BH9t--

--------------0AJrVYBhBKUCFgYheNgv6azH--

--------------Bc52u0iXbOeS7Awm5PwWR7px
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmPaCJEFAwAAAAAACgkQsN6d1ii/Ey+A
ngf8C8BVM0QjWXS/56u02O/hgIZ/IWLXlNK2daPrbeVXUTX0LF61FHmTGBGVko94n5ZRlF/ndN3M
2iOLdQjuOkmiRUd8V7oL75phNuGPuzypcADYqYpdiX5et4cUEJEoXcaGUdSZJEskj5KZ3EuL5uKd
EsOLuz4BnQs40c2V10q0NFhHmy2tyxNONkwlOkXIM9xQtsvLWH3Xlsf1ymNMWNQ9lM23qDTPecxu
YvTP0cRJPnvC3pAw6vOW6cz926gHFmSvyFejSjWYl/rJDGH+QFuSA+uW1bVFrSUvHOp0HqUtO1/X
m9njQAKpEETa1bIAjTq2I2Hz3gflg6gdHRNy8CQWIA==
=66Zo
-----END PGP SIGNATURE-----

--------------Bc52u0iXbOeS7Awm5PwWR7px--
