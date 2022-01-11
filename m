Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F7F48ACCC
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 12:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbiAKLkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 06:40:12 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33904 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbiAKLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 06:40:12 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 007211F3BA;
        Tue, 11 Jan 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641901211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hu9yh0NTZIrOTv2yobLAEgOChSVCw5ux5AM6GsPbBCM=;
        b=eFLSf/b0jLI14BDLXTV7umL8kh2VbVXgqWz9Zteh+o/1g4MW1s7FAmnA4q2r41zBiYruNR
        SQCRGEo5FjtA6kctsS+ap7+TI9SW5EwEKqmRoZOHXscRoV2wlhsS7AoZHzKvzxfyV3wGl0
        /EQw01HZmPSsoG4t4SSq46mQHYxY+qA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641901211;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hu9yh0NTZIrOTv2yobLAEgOChSVCw5ux5AM6GsPbBCM=;
        b=+SwoFrKjyHsSsz11+UflDNr3OyN4U/3YvFLIDgxo93qHySymgtrdvVCCFGrm9J8Et0F7qg
        ZHgp+Nxlfky5ObDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AB81E13DD6;
        Tue, 11 Jan 2022 11:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AqTGKJps3WFBCQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 11 Jan 2022 11:40:10 +0000
Message-ID: <f7bd672f-dfa8-93fa-e101-e57b90faeb1e@suse.de>
Date:   Tue, 11 Jan 2022 12:40:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Phyr Starter
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Cc:     nvdimm@lists.linux.dev, linux-rdma@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>,
        dri-devel@lists.freedesktop.org, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <YdyKWeU0HTv8m7wD@casper.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TUMr3QAK8x0Ry03YInQSssDP"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TUMr3QAK8x0Ry03YInQSssDP
Content-Type: multipart/mixed; boundary="------------FSfCP6lzbOH6mRnDQRWz0fCp";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-rdma@vger.kernel.org,
 John Hubbard <jhubbard@nvidia.com>, dri-devel@lists.freedesktop.org,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Jason Gunthorpe <jgg@nvidia.com>,
 netdev@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
 Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>
Message-ID: <f7bd672f-dfa8-93fa-e101-e57b90faeb1e@suse.de>
Subject: Re: Phyr Starter
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
In-Reply-To: <YdyKWeU0HTv8m7wD@casper.infradead.org>

--------------FSfCP6lzbOH6mRnDQRWz0fCp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTAuMDEuMjIgdW0gMjA6MzQgc2NocmllYiBNYXR0aGV3IFdpbGNveDoNCj4g
VExEUjogSSB3YW50IHRvIGludHJvZHVjZSBhIG5ldyBkYXRhIHR5cGU6DQo+IA0KPiBzdHJ1
Y3QgcGh5ciB7DQo+ICAgICAgICAgIHBoeXNfYWRkcl90IGFkZHI7DQo+ICAgICAgICAgIHNp
emVfdCBsZW47DQo+IH07DQoNCkRpZCB5b3UgbG9vayBhdCBzdHJ1Y3QgZG1hX2J1Zl9tYXA/
IFsxXQ0KDQpGb3IgZ3JhcGhpY3MgZnJhbWVidWZmZXJzLCB3ZSBoYXZlIHRoZSBwcm9ibGVt
IHRoYXQgdGhlc2UgYnVmZmVycyBjYW4gYmUgDQppbiBJL08gb3Igc3lzdGVtIG1lbW9yeSAo
YW5kIHBvc3NpYmx5IG1vdmUgYmV0d2VlbiB0aGVtKS4gTGludXgnIA0KdHJhZGl0aW9uYWwg
aW50ZXJmYWNlcyAobWVtY3B5X3RvaW8oKSwgZXRjKSBkb24ndCBkZWFsIHdpdGggdGhlIA0K
ZGlmZmVyZW5jZXMgd2VsbC4NCg0KU28gd2UgYWRkZWQgc3RydWN0IGRtYV9idWZfbWFwIGFz
IGFuIGFic3RyYWN0aW9uIHRvIHRoZSBidWZmZXIgYWRkcmVzcy4gDQpUaGVyZSBhcmUgaW50
ZXJmYWNlcyBmb3IgYWNjZXNzaW5nIGFuZCBjb3B5aW5nIHRoZSBkYXRhLiBJIGFsc28gaGF2
ZSBhIA0KcGF0Y2hzZXQgc29tZXdoZXJlIHRoYXQgYWRkcyBjYWNoaW5nIGluZm9ybWF0aW9u
IHRvIHRoZSBzdHJ1Y3R1cmUuIA0Kc3RydWN0IGRtYV9idWZfbWFwIGlzIGZvciBncmFwaGlj
cywgYnV0IHJlYWxseSBqdXN0IGFub3RoZXIgbWVtb3J5IEFQSS4NCg0KV2hlbiB3ZSBpbnRy
b2R1Y2VkIHN0cnVjdCBkbWFfYnVmX21hcCB3ZSB0aG91Z2h0IG9mIGFkZGl0aW9uYWwgdXNl
IA0KY2FzZXMsIGJ1dCBjb3VsZG4ndCByZWFsbHkgZmluZCBhbnkgYXQgdGhlIHRpbWUuIE1h
eWJlIHdoYXQgeW91J3JlIA0KZGVzY3JpYmluZyBpcyB0aGF0IHVzZSBjYXNlIGFuZCBzdHJ1
Y3QgZG1hX2J1Zl9tYXAgY291bGQgYmUgZXh0ZW5kZWQgZm9yIA0KdGhpcyBwdXJwb3NlLg0K
DQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQpbMV0gDQpodHRwczovL2VsaXhpci5ib290bGlu
LmNvbS9saW51eC92NS4xNi9zb3VyY2UvaW5jbHVkZS9saW51eC9kbWEtYnVmLW1hcC5oI0wx
MTUNCg0KPiANCj4gYW5kIHVzZSBpdCB0byByZXBsYWNlIGJpb192ZWMgYXMgd2VsbCBhcyB1
c2luZyBpdCB0byByZXBsYWNlIHRoZSBhcnJheQ0KPiBvZiBzdHJ1Y3QgcGFnZXMgdXNlZCBi
eSBnZXRfdXNlcl9wYWdlcygpIGFuZCBmcmllbmRzLg0KPiANCj4gLS0tDQo+IA0KPiBUaGVy
ZSBhcmUgdHdvIGRpc3RpbmN0IHByb2JsZW1zIEkgd2FudCB0byBhZGRyZXNzOiBkb2luZyBJ
L08gdG8gbWVtb3J5DQo+IHdoaWNoIGRvZXMgbm90IGhhdmUgYSBzdHJ1Y3QgcGFnZSBhbmQg
ZWZmaWNpZW50bHkgZG9pbmcgSS9PIHRvIGxhcmdlDQo+IGJsb2JzIG9mIHBoeXNpY2FsbHkg
Y29udGlndW91cyBtZW1vcnksIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBpdCBoYXMgYQ0KPiBz
dHJ1Y3QgcGFnZS4gIFRoZXJlIGFyZSBzb21lIG90aGVyIGltcHJvdmVtZW50cyB3aGljaCBJ
IHJlZ2FyZCBhcyBtaW5vci4NCj4gDQo+IFRoZXJlIGFyZSBtYW55IHR5cGVzIG9mIG1lbW9y
eSB0aGF0IG9uZSBtaWdodCB3YW50IHRvIGRvIEkvTyB0byB0aGF0IGRvDQo+IG5vdCBoYXZl
IGEgc3RydWN0IHBhZ2UsIHNvbWUgZXhhbXBsZXM6DQo+ICAgLSBNZW1vcnkgb24gYSBncmFw
aGljcyBjYXJkIChvciBvdGhlciBQQ0kgY2FyZCwgYnV0IGdmeCBzZWVtcyB0byBiZQ0KPiAg
ICAgdGhlIHByaW1hcnkgcHJvdmlkZXIgb2YgRFJBTSBvbiB0aGUgUENJIGJ1cyB0b2RheSkN
Cj4gICAtIERBWCwgb3Igb3RoZXIgcG1lbSAodGhlcmUgYXJlIHNvbWUgZmFrZSBwYWdlcyB0
b2RheSwgYnV0IHRoaXMgaXMNCj4gICAgIG1vc3RseSBhIHdvcmthcm91bmQgZm9yIHRoZSBJ
TyBwcm9ibGVtIHRvZGF5KQ0KPiAgIC0gR3Vlc3QgbWVtb3J5IGJlaW5nIGFjY2Vzc2VkIGZy
b20gdGhlIGh5cGVydmlzb3IgKEtWTSBuZWVkcyB0bw0KPiAgICAgY3JlYXRlIHN0cnVjdHBh
Z2VzIHRvIG1ha2UgdGhpcyBoYXBwZW4uICBYZW4gZG9lc24ndCAuLi4pDQo+IEFsbCBvZiB0
aGVzZSBraW5kcyBvZiBtZW1vcmllcyBjYW4gYmUgYWRkcmVzc2VkIGJ5IHRoZSBDUFUgYW5k
IHNvIGFsc28NCj4gYnkgYSBidXMgbWFzdGVyLiAgVGhhdCBpcywgdGhlcmUgaXMgYSBwaHlz
aWNhbCBhZGRyZXNzIHRoYXQgdGhlIENQVQ0KPiBjYW4gdXNlIHdoaWNoIHdpbGwgYWRkcmVz
cyB0aGlzIG1lbW9yeSwgYW5kIHRoZXJlIGlzIGEgd2F5IHRvIGNvbnZlcnQNCj4gdGhhdCB0
byBhIERNQSBhZGRyZXNzIHdoaWNoIGNhbiBiZSBwcm9ncmFtbWVkIGludG8gYW5vdGhlciBk
ZXZpY2UuDQo+IFRoZXJlJ3Mgbm8gaW50ZW50IGhlcmUgdG8gc3VwcG9ydCBtZW1vcnkgd2hp
Y2ggY2FuIGJlIGFjY2Vzc2VkIGJ5IGENCj4gY29tcGxleCBzY2hlbWUgbGlrZSB3cml0aW5n
IGFuIGFkZHJlc3MgdG8gYSBjb250cm9sIHJlZ2lzdGVyIGFuZCB0aGVuDQo+IGFjY2Vzc2lu
ZyB0aGUgbWVtb3J5IHRocm91Z2ggYSBGSUZPOyB0aGlzIGlzIGZvciBtZW1vcnkgd2hpY2gg
Y2FuIGJlDQo+IGFjY2Vzc2VkIGJ5IERNQSBhbmQgQ1BVIGxvYWRzIGFuZCBzdG9yZXMuDQo+
IA0KPiBGb3IgZ2V0X3VzZXJfcGFnZXMoKSBhbmQgZnJpZW5kcywgd2UgY3VycmVudGx5IGZp
bGwgYW4gYXJyYXkgb2Ygc3RydWN0DQo+IHBhZ2VzLCBlYWNoIG9uZSByZXByZXNlbnRpbmcg
UEFHRV9TSVpFIGJ5dGVzLiAgRm9yIGFuIGFwcGxpY2F0aW9uIHRoYXQNCj4gaXMgdXNpbmcg
MUdCIGh1Z2VwYWdlcywgd3JpdGluZyAyXjE4IGVudHJpZXMgaXMgYSBzaWduaWZpY2FudCBv
dmVyaGVhZC4NCj4gSXQgYWxzbyBtYWtlcyBkcml2ZXJzIGhhcmQgdG8gd3JpdGUgYXMgdGhl
eSBoYXZlIHRvIHJlY29hbGVzY2UgdGhlDQo+IHN0cnVjdCBwYWdlcywgZXZlbiB0aG91Z2gg
dGhlIFZNIGNhbiB0ZWxsIGl0IHdoZXRoZXIgdGhvc2UgMl4xOCBwYWdlcw0KPiBhcmUgY29u
dGlndW91cy4NCj4gDQo+IE9uIHRoZSBtaW5vciBzaWRlLCBzdHJ1Y3QgcGh5ciBjYW4gcmVw
cmVzZW50IGFueSBtYXBwYWJsZSBjaHVuayBvZiBtZW1vcnkuDQo+IEEgYmlvX3ZlYyBpcyBs
aW1pdGVkIHRvIDJeMzIgYnl0ZXMsIHdoaWxlIG9uIDY0LWJpdCBtYWNoaW5lcyBhIHBoeXIN
Cj4gY2FuIHJlcHJlc2VudCBsYXJnZXIgdGhhbiA0R0IuICBBIHBoeXIgaXMgdGhlIHNhbWUg
c2l6ZSBhcyBhIGJpb192ZWMNCj4gb24gNjQgYml0ICgxNiBieXRlcyksIGFuZCB0aGUgc2Ft
ZSBzaXplIGZvciAzMi1iaXQgd2l0aCBQQUUgKDEyIGJ5dGVzKS4NCj4gSXQgaXMgc21hbGxl
ciBmb3IgMzItYml0IG1hY2hpbmVzIHdpdGhvdXQgUEFFICg4IGJ5dGVzIGluc3RlYWQgb2Yg
MTIpLg0KPiANCj4gRmluYWxseSwgaXQgbWF5IGJlIHBvc3NpYmxlIHRvIHN0b3AgdXNpbmcg
c2NhdHRlcmxpc3QgdG8gZGVzY3JpYmUgdGhlDQo+IGlucHV0IHRvIHRoZSBETUEtbWFwcGlu
ZyBvcGVyYXRpb24uICBXZSBtYXkgYmUgYWJsZSB0byBnZXQgc3RydWN0DQo+IHNjYXR0ZXJs
aXN0IGRvd24gdG8ganVzdCBkbWFfYWRkcmVzcyBhbmQgZG1hX2xlbmd0aCwgd2l0aCBjaGFp
bmluZw0KPiBoYW5kbGVkIHRocm91Z2ggYW4gZW5jbG9zaW5nIHN0cnVjdC4NCj4gDQo+IEkg
d291bGQgbGlrZSB0byBzZWUgcGh5ciByZXBsYWNlIGJpb192ZWMgZXZlcnl3aGVyZSBpdCdz
IGN1cnJlbnRseSB1c2VkLg0KPiBJIGRvbid0IGhhdmUgdGltZSB0byBkbyB0aGF0IHdvcmsg
bm93IGJlY2F1c2UgSSdtIGJ1c3kgd2l0aCBmb2xpb3MuDQo+IElmIHNvbWVvbmUgZWxzZSB3
YW50cyB0byB0YWtlIHRoYXQgb24sIEkgc2hhbGwgY2hlZXIgZnJvbSB0aGUgc2lkZWxpbmVz
Lg0KPiBXaGF0IEkgZG8gaW50ZW5kIHRvIGRvIGlzOg0KPiANCj4gICAtIEFkZCBhbiBpbnRl
cmZhY2UgdG8gZ3VwLmMgdG8gcGluL3VucGluIE4gcGh5cnMNCj4gICAtIEFkZCBhIHNnX21h
cF9waHlycygpDQo+ICAgICBUaGlzIHdpbGwgdGFrZSBhbiBhcnJheSBvZiBwaHlycyBhbmQg
YWxsb2NhdGUgYW4gc2cgZm9yIHRoZW0NCj4gICAtIFdoYXRldmVyIGVsc2UgSSBuZWVkIHRv
IGRvIHRvIG1ha2Ugb25lIFJETUEgZHJpdmVyIGhhcHB5IHdpdGgNCj4gICAgIHRoaXMgc2No
ZW1lDQo+IA0KPiBBdCB0aGF0IHBvaW50LCBJIGludGVuZCB0byBzdG9wIGFuZCBsZXQgb3Ro
ZXJzIG1vcmUgZmFtaWxpYXIgd2l0aCB0aGlzDQo+IGFyZWEgb2YgdGhlIGtlcm5lbCBjb250
aW51ZSB0aGUgY29udmVyc2lvbiBvZiBkcml2ZXJzLg0KPiANCj4gUC5TLiBJZiB5b3UndmUg
aGFkIHRoZSBQcm9kaWd5IHNvbmcgcnVubmluZyB0aHJvdWdoIHlvdXIgaGVhZCB0aGUgd2hv
bGUNCj4gdGltZSB5b3UndmUgYmVlbiByZWFkaW5nIHRoaXMgZW1haWwgLi4uIEknbSBzb3Jy
eSAvIFlvdSdyZSB3ZWxjb21lLg0KPiBJZiBwZW9wbGUgaW5zaXN0LCB3ZSBjYW4gcmVuYW1l
IHRoaXMgdG8gcGh5c19yYW5nZSBvciBzb21ldGhpbmcgYm9yaW5nLA0KPiBidXQgSSBxdWl0
ZSBsaWtlIHRoZSBzcGVsbGluZyBvZiBwaHlyIHdpdGggdGhlIHByb251bmNpYXRpb24gb2Yg
ImZpcmUiLg0KDQotLSANClRob21hcyBaaW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2
ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5i
ZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3Rldg0K

--------------FSfCP6lzbOH6mRnDQRWz0fCp--

--------------TUMr3QAK8x0Ry03YInQSssDP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHdbJoFAwAAAAAACgkQlh/E3EQov+Ab
pA//eKdztUrkpafjDVZN2ROygr3b8QCA5GvPP8rrhIDvxNRVIT0RoC1H1JN16SyfXJVuPq+wIQ4s
iMN5Gr/FxyWZOKcn5QXxyUceQTIVIIFI8wooOzIueOqUmtf/P/LdPoyZDrDxVfhTbT3u3ZlpDSiV
bNuV6HZhz224KNfBduGcj5kY2MNwFYoDJFrBCv5AYFsfVayRR0K0AAG1+41+e/B5tWNO1tr8pZyD
wJfAntFrq/3vz/vmRt3vzMM8bisUaZfFfgEdWRlBgjduvhwvTUuiid85JF7YmLC4MCvewBiOkwN3
2Ov+XSv01Y3SXoeKUDd6/S8UVJdXg2dyCRJftbaf+WJ5XPSXJ9r4pPb3tPTvIUWFFX7iY3Q3ap50
qS/7bUoQ9Vyl1Krv1QMo5wmg7Jf4ie2yn9TN/Z4HSCpIxuDSs33cGH5vQfrVa33b1K+VHFSOnuh5
wxqguP/iNDWs/9ryASOrg6jFLe/D3nX+RH4OOibqR10sNrU/UrFo5roqRHoKF6EevW/KVXitHZZT
NR+pBzDiX8scl/Akzm1wrxre4RvTBOFpppI+ayaEbjMSEQ8OSOQEm7njmYp6ue699rNcqi2UWT8s
M56FvFE4IbvlfmOGVvyJWA0G61Y2tDkAtJW3MDvyPZcvBSb1gHo7G8sJc9rRp/4fDisa5AHDF7/q
ekc=
=yG12
-----END PGP SIGNATURE-----

--------------TUMr3QAK8x0Ry03YInQSssDP--
