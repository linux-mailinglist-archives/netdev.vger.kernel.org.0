Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A73669162
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjAMImr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjAMImo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:42:44 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A03F440;
        Fri, 13 Jan 2023 00:42:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 194845F9CE;
        Fri, 13 Jan 2023 08:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673599361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tn3pIfSFHMAaGKQ0wQUSfqNv0AGtcMDyvx2yhx14BF0=;
        b=MBsoXy0wcYRuu5Kue6BMjCgXARbLAQJk/VqHt/iRhBK/bRgiyNe3k4gp7pxwcWeA9Prop8
        0LWEQCTjczPkK6TNNGra7mg+eBfY55utQL9Jn6L51VSgQbXfGxhIbgKJVvsCSotb6xj7PO
        MzBrd1PP9y6Cw1gLuSs/QaesbmCQqdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673599361;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tn3pIfSFHMAaGKQ0wQUSfqNv0AGtcMDyvx2yhx14BF0=;
        b=KMHxhaL8EgbXJidfcT6tY9VYHXtg6yeHkf4K0/qQRdT4IXh1TR+M3BSMDznQC/FV3qw32A
        SabK8ITT6F9QxHBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F046713913;
        Fri, 13 Jan 2023 08:42:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8zonOoAZwWMhXQAAMHmgww
        (envelope-from <cahu@suse.de>); Fri, 13 Jan 2023 08:42:40 +0000
Message-ID: <5ab09d55233d1ba5969bd6a02214046c24145527.camel@suse.de>
Subject: Re: [PATCH] rndis_wlan: Prevent buffer overflow in rndis_query_oid
From:   cahu <cahu@suse.de>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>, kvalo@kernel.org,
        jussi.kivilinna@iki.fi, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 13 Jan 2023 09:42:40 +0100
In-Reply-To: <20230110173007.57110-1-szymon.heidrich@gmail.com>
References: <20230110173007.57110-1-szymon.heidrich@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VPz1AUbM/19UkYX6m/ao"
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-VPz1AUbM/19UkYX6m/ao
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

TWl0cmUgYXNzaWduZWQgQ1ZFLTIwMjMtMjM1NTkgZm9yIHRoaXMuCgpPbiBUdWUsIDIwMjMtMDEt
MTAgYXQgMTg6MzAgKzAxMDAsIFN6eW1vbiBIZWlkcmljaCB3cm90ZToKPiBTaW5jZSByZXNwbGVu
IGFuZCByZXNwb2ZmcyBhcmUgc2lnbmVkIGludGVnZXJzIHN1ZmZpY2llbnRseQo+IGxhcmdlIHZh
bHVlcyBvZiB1bnNpZ25lZCBpbnQgbGVuIGFuZCBvZmZzZXQgbWVtYmVycyBvZiBSTkRJUwo+IHJl
c3BvbnNlIHdpbGwgcmVzdWx0IGluIG5lZ2F0aXZlIHZhbHVlcyBvZiBwcmlvciB2YXJpYWJsZXMu
Cj4gVGhpcyBtYXkgYmUgdXRpbGl6ZWQgdG8gYnlwYXNzIGltcGxlbWVudGVkIHNlY3VyaXR5IGNo
ZWNrcwo+IHRvIGVpdGhlciBleHRyYWN0IG1lbW9yeSBjb250ZW50cyBieSBtYW5pcHVsYXRpbmcg
b2Zmc2V0IG9yCj4gb3ZlcmZsb3cgdGhlIGRhdGEgYnVmZmVyIHZpYSBtZW1jcHkgYnkgbWFuaXB1
bGF0aW5nIGJvdGgKPiBvZmZzZXQgYW5kIGxlbi4KPiAKPiBBZGRpdGlvbmFsbHkgYXNzdXJlIHRo
YXQgc3VtIG9mIHJlc3BsZW4gYW5kIHJlc3BvZmZzIGRvZXMgbm90Cj4gb3ZlcmZsb3cgc28gYnVm
ZmVyIGJvdW5kYXJpZXMgYXJlIGtlcHQuCj4gCj4gRml4ZXM6IDgwZjhjNWI0MzRmOSAoInJuZGlz
X3dsYW46IGNvcHkgb25seSB1c2VmdWwgZGF0YSBmcm9tCj4gcm5kaXNfY29tbWFuZCByZXNwb25k
IikKPiBTaWduZWQtb2ZmLWJ5OiBTenltb24gSGVpZHJpY2ggPHN6eW1vbi5oZWlkcmljaEBnbWFp
bC5jb20+Cj4gLS0tCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9ybmRpc193bGFuLmMgfCA0ICsr
LS0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4g
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JuZGlzX3dsYW4uYwo+IGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvcm5kaXNfd2xhbi5jCj4gaW5kZXggODJhNzQ1OGUwLi5kN2ZjMDUz
MjggMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvcm5kaXNfd2xhbi5jCj4gKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvcm5kaXNfd2xhbi5jCj4gQEAgLTY5Nyw3ICs2OTcsNyBA
QCBzdGF0aWMgaW50IHJuZGlzX3F1ZXJ5X29pZChzdHJ1Y3QgdXNibmV0ICpkZXYsCj4gdTMyIG9p
ZCwgdm9pZCAqZGF0YSwgaW50ICpsZW4pCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3Qgcm5kaXNfcXVlcnlfY8KgwqDCoMKgKmdldF9jOwo+IMKgwqDCoMKgwqDCoMKgwqB9
IHU7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQsIGJ1ZmxlbjsKPiAtwqDCoMKgwqDCoMKgwqBp
bnQgcmVzcGxlbiwgcmVzcG9mZnMsIGNvcHlsZW47Cj4gK8KgwqDCoMKgwqDCoMKgdTMyIHJlc3Bs
ZW4sIHJlc3BvZmZzLCBjb3B5bGVuOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGJ1ZmxlbiA9ICps
ZW4gKyBzaXplb2YoKnUuZ2V0KTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGJ1ZmxlbiA8IENPTlRS
T0xfQlVGRkVSX1NJWkUpCj4gQEAgLTc0MCw3ICs3NDAsNyBAQCBzdGF0aWMgaW50IHJuZGlzX3F1
ZXJ5X29pZChzdHJ1Y3QgdXNibmV0ICpkZXYsCj4gdTMyIG9pZCwgdm9pZCAqZGF0YSwgaW50ICps
ZW4pCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290
byBleGl0X3VubG9jazsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoKHJlc3BsZW4gKyByZXNwb2Zmcykg
PiBidWZsZW4pIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHJlc3BsZW4g
PiAoYnVmbGVuIC0gcmVzcG9mZnMpKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgLyogRGV2aWNlIHdvdWxkIGhhdmUgcmV0dXJuZWQgbW9yZSBkYXRh
IGlmCj4gYnVmZmVyIHdvdWxkCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICogaGF2ZSBiZWVuIGJpZyBlbm91Z2guIENvcHkganVzdCB0aGUgYml0cwo+
IHRoYXQgd2UgZ290Lgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqLwoK


--=-VPz1AUbM/19UkYX6m/ao
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEWHPP0YwOptScu/bEBioQFhUFoIoFAmPBGYAACgkQBioQFhUF
oIq8Fw/7B0kVO8rQxfWzvp1yuDw5oZzC7LfD+HqZA+YuXPFVXN14QADsJ3In8pqY
xm212/XkTvexbrERAn/G9YsdaBTqLd8ewZu26Jv8qX2dsCv/TB2+3bNcmNd4LjBI
zE3IQkHZ2qfNHjjfJE4smlvB0xzdlDCzTSHsFMvWVkhDbsxmKtzT5nMUhBKLLTxi
xa+MBrBDk6D+O/XVo1K0iqAQ1yYBa+gja3Eri1Grr94KlIZV4WndqjzhuBGNRqH3
qDxtimX02jtO8hNuIAVHBOlVsrR5HhDLNf98LPynmoNP6e+q7grKSzS2AeXxCJpc
UfTy1x4ble2rQSluMQMvQsV8ljp5Gq1ZD5hZF3xWn+t4UV8zVWeekTXdIvpCQkWL
MlcBnRhKpTeq8QB/jlHMb9ca/IbYb6/TQcOUaEjl2ArZS9/hmPfbpZsUqnqaj/gF
AlMejXU9jJvGjv9K/30lRwwc0suRvx74RE80/2OaPHtDulIQNQcZ/oykPFlucHNa
+/tE8+GANHzZMbd0FeW4UTeiqPC1UeiBnu0le/zyRaxoOWBAH4se2iJ4Ze/nDUi/
JW6v0AfY5JZjV0P39PZ8e7E8eouZkIf/9/E3iSbNyol+VtqzyInGjo+9IwVZXzo+
U4XL9M2JdBl5LxISS0YW3UwUWB8Muurts2oqaV/ZCaPnC6Kazhk=
=ktM3
-----END PGP SIGNATURE-----

--=-VPz1AUbM/19UkYX6m/ao--
