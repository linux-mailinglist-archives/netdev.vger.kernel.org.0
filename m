Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E60303086
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbhAYXvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:51:00 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:49297 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbhAYVMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:12:39 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 7CD16200F4B1;
        Mon, 25 Jan 2021 22:11:35 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7CD16200F4B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1611609095;
        bh=wD4fIaJYrczPpSMJRVDbjFtKdrupqrerE1JjV2L1JHo=;
        h=From:Subject:Date:References:To:In-Reply-To:Cc:From;
        b=Jed/ruVyw+OkDdBfYXPf2bE/rwSRfNSUi3zxmmMCch34BXe3eciRy2s7b3HOPFtiV
         1mF7aesvQQC8uHOtC16NGjxaa0XIBJR+Aq5yN+vpiRigvhOYqM3vJj45jk1H+yLpo6
         bJt2/2n36v4J1Pe+zyQxDy7TzZ60pJ/n6BePhaNizP2kHQyAbsXV2io8S1xaxzz29Y
         ZzDM1cu1WrLgEKrC9qMDEwX+kOs7JHgtiUKIUtKVnHXsJzFJJq3XV6dyoJvEignZFI
         IPh4AJ/jxOxwezlYwXK8+8aEfo2b3qL1sdrn/lCio3xlrKpuNjsxrIuUJXlCq4z05E
         9kbhgYKA/oobw==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 73125129E932;
        Mon, 25 Jan 2021 22:11:35 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zDGAhtky_ebp; Mon, 25 Jan 2021 22:11:35 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 560FE129E925;
        Mon, 25 Jan 2021 22:11:35 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
MIME-Version: 1.0
Subject: Re: [PATCH net 1/1] uapi: fix big endian definition of ipv6_rpl_sr_hdr
Message-Id: <6FEDA1B9-14CC-4EC5-A41D-A38599C8CDBD@uliege.be>
Date:   Mon, 25 Jan 2021 22:11:35 +0100 (CET)
References: <20210121220044.22361-1-justin.iurman@uliege.be> <20210121220044.22361-2-justin.iurman@uliege.be> <20210123205444.5e1df187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <55663307.1072450.1611482265804.JavaMail.zimbra@uliege.be> <fd7957e7-ab5c-d2c2-9338-76879563460e@gmail.com> <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <20210125113231.3fac0e10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, alex aring <alex.aring@gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain;
        charset=utf-8
X-Originating-IP: [80.200.25.38]
X-Mailer: Zimbra 8.8.15_GA_3980 (MobileSync - Apple-iPhone8C2/1607.102)
Thread-Topic: uapi: fix big endian definition of ipv6_rpl_sr_hdr
Thread-Index: h/CbTaUD+funzCR4mb2fxxCsIaxPPQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gTGUgMjUgamFudi4gMjAyMSDDoCAyMDozMiwgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz4gYSDDqWNyaXQgOg0KPiANCj4+IE9uIFN1biwgMjQgSmFuIDIwMjEgMTE6NTc6MDMg
LTA3MDAgRGF2aWQgQWhlcm4gd3JvdGU6DQo+PiBPbiAxLzI0LzIxIDI6NTcgQU0sIEp1c3RpbiBJ
dXJtYW4gd3JvdGU6DQo+Pj4+IERlOiAiSmFrdWIgS2ljaW5za2kiIDxrdWJhQGtlcm5lbC5vcmc+
DQo+Pj4+IMOAOiAiSnVzdGluIEl1cm1hbiIgPGp1c3Rpbi5pdXJtYW5AdWxpZWdlLmJlPg0KPj4+
PiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZywgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldCwgImFsZXgg
YXJpbmciIDxhbGV4LmFyaW5nQGdtYWlsLmNvbT4NCj4+Pj4gRW52b3nDqTogRGltYW5jaGUgMjQg
SmFudmllciAyMDIxIDA1OjU0OjQ0DQo+Pj4+IE9iamV0OiBSZTogW1BBVENIIG5ldCAxLzFdIHVh
cGk6IGZpeCBiaWcgZW5kaWFuIGRlZmluaXRpb24gb2YgaXB2Nl9ycGxfc3JfaGRyICANCj4+PiAN
Cj4+Pj4+IE9uIFRodSwgMjEgSmFuIDIwMjEgMjM6MDA6NDQgKzAxMDAgSnVzdGluIEl1cm1hbiB3
cm90ZTogIA0KPj4+Pj4gRm9sbG93aW5nIFJGQyA2NTU0IFsxXSwgdGhlIGN1cnJlbnQgb3JkZXIg
b2YgZmllbGRzIGlzIHdyb25nIGZvciBiaWcNCj4+Pj4+IGVuZGlhbiBkZWZpbml0aW9uLiBJbmRl
ZWQsIGhlcmUgaXMgaG93IHRoZSBoZWFkZXIgbG9va3MgbGlrZToNCj4+Pj4+IA0KPj4+Pj4gKy0r
LSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSst
Ky0rLSsNCj4+Pj4+IHwgIE5leHQgSGVhZGVyICB8ICBIZHIgRXh0IExlbiAgfCBSb3V0aW5nIFR5
cGUgIHwgU2VnbWVudHMgTGVmdCB8DQo+Pj4+PiArLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSst
Ky0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKw0KPj4+Pj4gfCBDbXBySSB8IENt
cHJFIHwgIFBhZCAgfCAgICAgICAgICAgICAgIFJlc2VydmVkICAgICAgICAgICAgICAgIHwNCj4+
Pj4+ICstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0r
LSstKy0rLSstKy0rDQo+Pj4+PiANCj4+Pj4+IFRoaXMgcGF0Y2ggcmVvcmRlcnMgZmllbGRzIHNv
IHRoYXQgYmlnIGVuZGlhbiBkZWZpbml0aW9uIGlzIG5vdyBjb3JyZWN0Lg0KPj4+Pj4gDQo+Pj4+
PiAgWzFdIGh0dHBzOi8vdG9vbHMuaWV0Zi5vcmcvaHRtbC9yZmM2NTU0I3NlY3Rpb24tMw0KPj4+
Pj4gDQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBKdXN0aW4gSXVybWFuIDxqdXN0aW4uaXVybWFuQHVs
aWVnZS5iZT4gIA0KPj4+PiANCj4+Pj4gQXJlIHlvdSBzdXJlPyBUaGlzIGxvb2tzIHJpZ2h0IHRv
IG1lLiAgDQo+Pj4gDQo+Pj4gQUZBSUssIHllcy4gRGlkIHlvdSBtZWFuIHRoZSBvbGQgKGN1cnJl
bnQpIG9uZSBsb29rcyByaWdodCwgb3IgdGhlIG5ldyBvbmU/IA0KPiANCj4gT2xkIG9uZSAvIGV4
aXN0aW5nIGlzIGNvcnJlY3QuDQo+IA0KPj4+IElmIHlvdSBtZWFudCB0aGUgb2xkL2N1cnJlbnQg
b25lLCB3ZWxsLCBJIGRvbid0IHVuZGVyc3RhbmQgd2h5IHRoZSBiaWcgZW5kaWFuIGRlZmluaXRp
b24gd291bGQgbG9vayBsaWtlIHRoaXM6DQo+Pj4gDQo+Pj4gI2VsaWYgZGVmaW5lZChfX0JJR19F
TkRJQU5fQklURklFTEQpDQo+Pj4gICAgX191MzIgICAgcmVzZXJ2ZWQ6MjAsDQo+Pj4gICAgICAg
IHBhZDo0LA0KPj4+ICAgICAgICBjbXByaTo0LA0KPj4+ICAgICAgICBjbXByZTo0Ow0KPj4+IA0K
Pj4+IFdoZW4gdGhlIFJGQyBkZWZpbmVzIHRoZSBoZWFkZXIgYXMgZm9sbG93czoNCj4+PiANCj4+
PiArLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0r
LSstKy0rLSstKw0KPj4+IHwgQ21wckkgfCBDbXByRSB8ICBQYWQgIHwgICAgICAgICAgICAgICBS
ZXNlcnZlZCAgICAgICAgICAgICAgICB8DQo+Pj4gKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0r
LSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSstKy0rLSsNCj4+PiANCj4+PiBUaGUgbGl0
dGxlIGVuZGlhbiBkZWZpbml0aW9uIGxvb2tzIGZpbmUuIEJ1dCwgd2hlbiBpdCBjb21lcyB0byBi
aWcgZW5kaWFuLCB5b3UgZGVmaW5lIGZpZWxkcyBhcyB5b3Ugc2VlIHRoZW0gb24gdGhlIHdpcmUg
d2l0aCB0aGUgc2FtZSBvcmRlciwgcmlnaHQ/IFNvIHRoZSBjdXJyZW50IGJpZyBlbmRpYW4gZGVm
aW5pdGlvbiBtYWtlcyBubyBzZW5zZS4gSXQgbG9va3MgbGlrZSBpdCB3YXMgYSB3cm9uZyBtaXgg
d2l0aCB0aGUgbGl0dGxlIGVuZGlhbiBjb252ZXJzaW9uLg0KPiANCj4gV2VsbCwgeW91IGRvbid0
IGxpc3QgdGhlIGJpdCBwb3NpdGlvbnMgaW4gdGhlIHF1b3RlIGZyb20gdGhlIFJGQywgYW5kDQo+
IEknbSBub3QgZmFtaWxpYXIgd2l0aCB0aGUgSUVURiBwYXJsb3IuIEknbSBvbmx5DQoNCkluZGVl
ZCwgc29ycnkgZm9yIHRoYXQuIEJpdCBwb3NpdGlvbnMgYXJlIGF2YWlsYWJsZSBpZiB5b3UgZm9s
bG93IHRoZSBsaW5rIHRvIHRoZSBSRkMgSSByZWZlcmVuY2VkIGluIHRoZSBwYXRjaC4gSXQgaXMg
YWx3YXlzIGRlZmluZWQgYXMgbmV0d29yayBieXRlIG9yZGVyIGJ5IGRlZmF1bHQgKD1CRSkuDQoN
Cj4gY29tcGFyaW5nIHRoZSBMRQ0KPiBkZWZpbml0aW9uIHdpdGggdGhlIEJFLiBJZiB5b3UgY2xh
aW0gdGhlIEJFIGlzIHdyb25nLCB0aGVuIHRoZSBMRSBpcw0KPiB3cm9uZywgdG9vLg0KDQpBY3R1
YWxseSwgbm8sIGl04oCZcyBub3QuIElmIHlvdSBoYXZlIGEgbG9vayBhdCB0aGUgaGVhZGVyIGRl
ZmluaXRpb24gZnJvbSB0aGUgUkZDLCB5b3UgY2FuIHNlZSB0aGF0IHRoZSBMRSBpcyBjb3JyZWN0
ICh2YWxpZCB0cmFuc2xhdGlvbiBmcm9tIEJFLCB0aGUgKm5ldyogQkUgaW4gdGhpcyBwYXRjaCku
DQoNCj4+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvcnBsLmggYi9pbmNsdWRl
L3VhcGkvbGludXgvcnBsLmgNCj4+Pj4+IGluZGV4IDFkY2NiNTVjZjhjNi4uNzA4YWRkZGY5ZjEz
IDEwMDY0NA0KPj4+Pj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3JwbC5oDQo+Pj4+PiArKysg
Yi9pbmNsdWRlL3VhcGkvbGludXgvcnBsLmgNCj4+Pj4+IEBAIC0yOCwxMCArMjgsMTAgQEAgc3Ry
dWN0IGlwdjZfcnBsX3NyX2hkciB7DQo+Pj4+PiAgICAgICAgcGFkOjQsDQo+Pj4+PiAgICAgICAg
cmVzZXJ2ZWQxOjE2Ow0KPj4+Pj4gI2VsaWYgZGVmaW5lZChfX0JJR19FTkRJQU5fQklURklFTEQp
DQo+Pj4+PiAtICAgIF9fdTMyICAgIHJlc2VydmVkOjIwLA0KPj4+Pj4gKyAgICBfX3UzMiAgICBj
bXByaTo0LA0KPj4+Pj4gKyAgICAgICAgY21wcmU6NCwNCj4+Pj4+ICAgICAgICBwYWQ6NCwNCj4+
Pj4+IC0gICAgICAgIGNtcHJpOjQsDQo+Pj4+PiAtICAgICAgICBjbXByZTo0Ow0KPj4+Pj4gKyAg
ICAgICAgcmVzZXJ2ZWQ6MjA7DQo+Pj4+PiAjZWxzZQ0KPj4+Pj4gI2Vycm9yICAiUGxlYXNlIGZp
eCA8YXNtL2J5dGVvcmRlci5oPiINCj4+Pj4+ICNlbmRpZiAgDQo+PiANCj4+IGNyb3NzLWNoZWNr
aW5nIHdpdGggb3RoZXIgaGVhZGVycyAtIHRjcCBhbmQgdnhsYW4tZ3BlIC0gdGhpcyBwYXRjaCBs
b29rcw0KPj4gY29ycmVjdC4NCj4gDQo+IFdoYXQgYXJlIHlvdSBjcm9zcy1jaGVja2luZz8NCg==
