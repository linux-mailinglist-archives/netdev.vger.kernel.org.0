Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3CD48AF2A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 15:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbiAKOKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 09:10:03 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45176 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiAKOKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 09:10:02 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 31FC51F37C;
        Tue, 11 Jan 2022 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641910201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pEheax8cHUq+PpKPjpFMPLC2jVHfLP6R8ECbdm/214w=;
        b=UusrhdrMkYLh5FAMpnWON1J/QUQoekCssXJOgQ1pmfsgXGaERozSRaR79VcuR3ZzgRcSRt
        L9W4G4K4xRaJ07MmCPUhdtXFYQzt9drKAqXbeAK4XxLI/3VjiqDbGsf5mknLg3/38HtZpe
        Xx0/8fk8uGRmu1Hn726DyKbvybNWoLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641910201;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pEheax8cHUq+PpKPjpFMPLC2jVHfLP6R8ECbdm/214w=;
        b=/p5XzLUxq7TMaydSPAajIcMkJU1LSeopPXWpqtFQEb0vPananL6OSrSLYQAavBlPrcCbkA
        f+w5BNrVySfbanCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD8D713AB2;
        Tue, 11 Jan 2022 14:10:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id I3reNLiP3WH9XgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 11 Jan 2022 14:10:00 +0000
Message-ID: <9486843d-bbef-f7e0-354c-2522ea3f896f@suse.de>
Date:   Tue, 11 Jan 2022 15:10:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Phyr Starter
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     nvdimm@lists.linux.dev, linux-rdma@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>,
        netdev@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <f7bd672f-dfa8-93fa-e101-e57b90faeb1e@suse.de>
 <Yd2MeMT6LXWxJIDd@casper.infradead.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <Yd2MeMT6LXWxJIDd@casper.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------q4YJa809K6MbWZkHsDkLnQxU"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------q4YJa809K6MbWZkHsDkLnQxU
Content-Type: multipart/mixed; boundary="------------JQ28srt10RofHn0a758GsGXI";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: nvdimm@lists.linux.dev, linux-rdma@vger.kernel.org,
 John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org,
 Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
 Joao Martins <joao.m.martins@oracle.com>,
 Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>
Message-ID: <9486843d-bbef-f7e0-354c-2522ea3f896f@suse.de>
Subject: Re: Phyr Starter
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <f7bd672f-dfa8-93fa-e101-e57b90faeb1e@suse.de>
 <Yd2MeMT6LXWxJIDd@casper.infradead.org>
In-Reply-To: <Yd2MeMT6LXWxJIDd@casper.infradead.org>

--------------JQ28srt10RofHn0a758GsGXI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTEuMDEuMjIgdW0gMTQ6NTYgc2NocmllYiBNYXR0aGV3IFdpbGNveDoNCj4g
T24gVHVlLCBKYW4gMTEsIDIwMjIgYXQgMTI6NDA6MTBQTSArMDEwMCwgVGhvbWFzIFppbW1l
cm1hbm4gd3JvdGU6DQo+PiBIaQ0KPj4NCj4+IEFtIDEwLjAxLjIyIHVtIDIwOjM0IHNjaHJp
ZWIgTWF0dGhldyBXaWxjb3g6DQo+Pj4gVExEUjogSSB3YW50IHRvIGludHJvZHVjZSBhIG5l
dyBkYXRhIHR5cGU6DQo+Pj4NCj4+PiBzdHJ1Y3QgcGh5ciB7DQo+Pj4gICAgICAgICAgIHBo
eXNfYWRkcl90IGFkZHI7DQo+Pj4gICAgICAgICAgIHNpemVfdCBsZW47DQo+Pj4gfTsNCj4+
DQo+PiBEaWQgeW91IGxvb2sgYXQgc3RydWN0IGRtYV9idWZfbWFwPyBbMV0NCj4gDQo+IFRo
YW5rcy4gIEkgd2Fzbid0IGF3YXJlIG9mIHRoYXQuICBJdCBkb2Vzbid0IHNlZW0gdG8gYWN0
dWFsbHkgc29sdmUgdGhlDQo+IHByb2JsZW0sIGluIHRoYXQgaXQgZG9lc24ndCBjYXJyeSBh
bnkgbGVuZ3RoIGluZm9ybWF0aW9uLiAgRGlkIHlvdSBtZWFuDQo+IHRvIHBvaW50IG1lIGF0
IGEgZGlmZmVyZW50IHN0cnVjdHVyZT8NCj4gDQoNCkl0J3MgdGhlIHN0cnVjdHVyZSBJIG1l
YW50LiBJdCByZWZlcnMgdG8gYSBidWZmZXIsIHNvIHRoZSBsZW5ndGggY291bGQgDQpiZSBh
ZGRlZC4gRm9yIHNvbWV0aGluZyBtb3JlIHNvcGhpc3RpY2F0ZWQsIGRtYV9idWZfbWFwIGNv
dWxkIGJlIGNoYW5nZWQgDQp0byBkaXN0aW5ndWlzaCBiZXR3ZWVuIHRoZSBidWZmZXIgYW5k
IGFuIGl0ZXJhdG9yIHBvaW50aW5nIGludG8gdGhlIGJ1ZmZlci4NCg0KQnV0IGlmIGl0J3Mg
cmVhbGx5IGRpZmZlcmVudCwgdGhlbiBzbyBiZSBpdC4NCg0KQmVzdCByZWdhcmRzDQpUaG9t
YXMNCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERldmVsb3Bl
cg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxkc3RyLiA1
LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJuYmVyZykN
Ckdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------JQ28srt10RofHn0a758GsGXI--

--------------q4YJa809K6MbWZkHsDkLnQxU
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHdj7gFAwAAAAAACgkQlh/E3EQov+BS
lRAAz+DTGAOsJc2UgiW04AClMKGGbLV3LKjkDNZAa+Hc0xHE/ZEHF83nn9E+5pRFGz+Cfo+CI9Q3
tQc0EWE5IAMeyE+L/LsllOmSyhtSIyaAfYdrW2zTAuDRoSBZ8pCpO4lQwzmkXZ74LEUya5qbBPs/
Py7h077aQI470Yz4IMEpoq+dISWarWoo9XdD7VniouUdWs60YdfGG4Bd9w0AiV1kUC+DMkIZzj1o
qUjZ2R2KvvtSt0a/e52re1sTDbNTYTXYdcIiE3i2komeCBz6uH/pBxbOXdKlThAz2MOcC9PvyN9n
hqNAcSk0m0RPmNI1cm/EiDsb+YJeGBZ/zschwco30nJZ2pE66Ri/b//qf1zCg4l1e8Tx+Py7j3fR
a0opO6MHLSdxa1kodAEwrEhIrzEAyJPqN0tfBFA2h58Kq+vA0l0NwUGTy+tLPt1Po72XINe8Ohxj
OOfFwE1vJbyshQ+YeUtxiJLHvOkyAb3hqjSC8o8rV/CgzheVg9tGHrGfodzOcItHoJ3iyc2zot4E
Qi+zISV4nx2wPLPSjKlpMcbUx0BUeH0rLiOVdruQgLH/Ap63tmx/Ce3XXf+2qpH//vPvCZb22asY
u2S5nzcMTO3X82nqaGF4PMhh5JYvpA9eQ1zoMHZv0l9PPxxC11431rRgJOwuKb0fgoKPuooRmj4r
eoQ=
=vOo8
-----END PGP SIGNATURE-----

--------------q4YJa809K6MbWZkHsDkLnQxU--
