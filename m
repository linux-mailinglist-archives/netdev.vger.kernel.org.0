Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3864D4560AB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhKRQlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhKRQlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:41:15 -0500
Received: from mx0a-00206401.pphosted.com (mx0a-00206401.pphosted.com [IPv6:2620:100:9001:15::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B68C061574;
        Thu, 18 Nov 2021 08:38:15 -0800 (PST)
Received: from pps.filterd (m0207806.ppops.net [127.0.0.1])
        by mx0b-00206401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AI7OpVB017462;
        Thu, 18 Nov 2021 08:37:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=default; bh=YYpfFPIIj9dhYIEnrzBE9rYOMhsJGQIWQLhSa7arJlQ=;
 b=tSzVPPqdYjsMjFd2pp1W3cTAKDijV2oP/CPrrYaMjacgEv2bGpvox7Hw2Y7W4CPbPxF7
 5WryxV/i6wgHzVrs3xYFMqRjM6VpgvQD90SikQpAWumKeKNSE13FgAAa29BD8pq0ui/t
 AsKK6XAzAEtAkukfyeLMq/z2PLtHBMkC45UU/b/RVYQvmZ40MALjd3krt0rS7QpD40nK
 wI0Q4DOt6aU+23BPVL1c6bspwUhchErCpNgJWdFxOQOPlVZyf85tZFa01fXl7YEX2Oz+
 hcDHLslVJ9QOhqZX4+iSa9jP0wOodh1MCa/Rwveqq6ASMStdgnUDdnBzlCdh1ZsM1K/J FA== 
Received: from 04wpexch04.crowdstrike.sys (dragosx.crowdstrike.com [208.42.231.60])
        by mx0b-00206401.pphosted.com (PPS) with ESMTPS id 3cd6vchrdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 08:37:58 -0800
Received: from 04wpexch03.crowdstrike.sys (10.100.11.93) by
 04wpexch04.crowdstrike.sys (10.100.11.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Thu, 18 Nov 2021 16:37:56 +0000
Received: from 04wpexch03.crowdstrike.sys ([fe80::79d6:26ee:13ba:99d2]) by
 04wpexch03.crowdstrike.sys ([fe80::79d6:26ee:13ba:99d2%5]) with mapi id
 15.02.0922.019; Thu, 18 Nov 2021 16:37:56 +0000
From:   Martin Kelly <martin.kelly@crowdstrike.com>
To:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrii@kernel.org" <andrii@kernel.org>
Subject: RE: Re: Re: Clarification on bpftool dual licensing
Thread-Topic: Re: Re: Clarification on bpftool dual licensing
Thread-Index: AdfcmkxrvUCOA0cnRAq025lID2M8fg==
Date:   Thu, 18 Nov 2021 16:37:55 +0000
Deferred-Delivery: Thu, 18 Nov 2021 16:37:29 +0000
Message-ID: <cb8074f8c8554ca480d6bb57f79535fc@crowdstrike.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.100.11.84]
x-disclaimer: USA
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIE5vdiAxNywgMjAyMSBhdCA0OjMyIFBNIE1hcnRpbiBLZWxseQ0KPiA8bWFydGlu
LmtlbGx5QGNyb3dkc3RyaWtlLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+DQo+ID4gPiBPbiBUdWUs
IE5vdiAxNiwgMjAyMSBhdCAyOjE2IEFNIERhbmllbCBCb3JrbWFubg0KPiA8ZGFuaWVsQGlvZ2Vh
cmJveC5uZXQ+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gT24gMTEvMTUvMjEgNzoy
MCBQTSwgTWFydGluIEtlbGx5IHdyb3RlOg0KPiA+ID4gPiA+IEhpLA0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gSSBoYXZlIGEgcXVlc3Rpb24gcmVnYXJkaW5nIHRoZSBkdWFsIGxpY2Vuc2luZyBwcm92
aXNpb24gb2YgYnBmdG9vbC4gSQ0KPiA+ID4gPiA+IHVuZGVyc3RhbmQgdGhhdCBicGZ0b29sIGNh
biBiZSBkaXN0cmlidXRlZCBhcyBlaXRoZXIgR1BMIDIuMCBvciBCU0QgMi0NCj4gPiA+IGNsYXVz
ZS4NCj4gPiA+ID4gPiBUaGF0IHNhaWQsIGJwZnRvb2wgY2FuIGFsc28gYXV0by1nZW5lcmF0ZSBC
UEYgY29kZSB0aGF0IGdldHMgc3BlY2lmaWVkDQo+IGlubGluZQ0KPiA+ID4gPiA+IGluIHRoZSBz
a2VsZXRvbiBoZWFkZXIgZmlsZSwgYW5kIGl0J3MgcG9zc2libGUgdGhhdCB0aGUgQlBGIGNvZGUg
Z2VuZXJhdGVkDQo+IGlzDQo+ID4gPiA+ID4gR1BMLiBXaGF0IEknbSB3b25kZXJpbmcgaXMgd2hh
dCBoYXBwZW5zIGlmIGJwZnRvb2wgZ2VuZXJhdGVzIEdQTC0NCj4gbGljZW5zZWQNCj4gPiA+IEJQ
Rg0KPiA+ID4gPiA+IGNvZGUgaW5zaWRlIHRoZSBza2VsZXRvbiBoZWFkZXIsIHNvIHRoYXQgeW91
IGdldCBhIGhlYWRlciBsaWtlIHRoaXM6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBzb21ldGhpbmcu
c2tlbC5oOg0KPiA+ID4gPiA+IC8qIHRoaXMgZmlsZSBpcyBCU0QgMi1jbGF1c2UsIGJ5IG5hdHVy
ZSBvZiBkdWFsIGxpY2Vuc2luZyAqLw0KPiA+ID4gPg0KPiA+ID4gPiBGd2l3LCB0aGUgZ2VuZXJh
dGVkIGhlYWRlciBjb250YWlucyBhbiBTUERYIGlkZW50aWZpZXI6DQo+ID4gPiA+DQo+ID4gPiA+
ICAgLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChMR1BMLTIuMSBPUiBCU0QtMi1DbGF1c2Up
ICovDQo+ID4gPiA+ICAgLyogVEhJUyBGSUxFIElTIEFVVE9HRU5FUkFURUQhICovDQo+ID4gPiA+
DQo+ID4gPiA+ID4gLyogVEhJUyBGSUxFIElTIEFVVE9HRU5FUkFURUQhICovDQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiAvKiBzdGFuZGFyZCBza2VsZXRvbiBkZWZpbml0aW9ucyAqLw0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4gLi4uDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBzLT5kYXRhX3N6ID0gWFhYOw0K
PiA+ID4gPiA+IHMtPmRhdGEgPSAodm9pZCAqKSJcDQo+ID4gPiA+ID4gPGVCUEYgYnl0ZWNvZGUs
IHByb2R1Y2VkIGJ5IEdQTCAyLjAgc291cmNlcywgc3BlY2lmaWVkIGluIGJpbmFyeT4NCj4gPiA+
ID4gPiAiOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gTXkgZ3Vlc3MgaXMgdGhhdCwgYmFzZWQgb24g
dGhlIGNob2ljZSB0byBkdWFsLWxpY2Vuc2UgYnBmdG9vbCwgdGhlIGhlYWRlcg0KPiBpcw0KPiA+
ID4gPiA+IG1lYW50IHRvIHN0aWxsIGJlIEJTRCAyLWNsYXVzZSwgYW5kIHRoZSBzLT5kYXRhIGlu
bGluZSBjb2RlJ3MgR1BMIGxpY2Vuc2UNCj4gaXMNCj4gPiA+ID4gPiBub3QgbWVhbnQgdG8gY2hh
bmdlIHRoZSBsaWNlbnNpbmcgb2YgdGhlIGhlYWRlciBpdHNlbGYsIGJ1dCBJIHdhbnRlZCB0bw0K
PiA+ID4NCj4gPiA+IFllcywgZGVmaW5pdGVseSB0aGF0IGlzIHRoZSBpbnRlbnQgKGJ1dCBub3Qg
YSBsYXd5ZXIgZWl0aGVyKS4NCj4gPg0KPiA+ICBUaGFua3MgZXZlcnlvbmUsIHRoYXQncyB3aGF0
IEkgYXNzdW1lZCBhcyB3ZWxsLiBBbnkgb2JqZWN0aW9uIHRvIGEgcGF0Y2gNCj4gY2xhcmlmeWlu
ZyB0aGlzIG1vcmUgZXhwbGljaXRseT8NCj4gPg0KPiA+IE9uZSBvdGhlciwgcmVsYXRlZCBxdWVz
dGlvbjogdm1saW51eC5oIChnZW5lcmF0ZWQgYnkgImJwZnRvb2wgYnRmIGR1bXAgZmlsZQ0KPiAv
c3lzL2tlcm5lbC9idGYvdm1saW51eCBmb3JtYXQgYyIpLCBkb2VzIG5vdCBjdXJyZW50bHkgY29u
dGFpbiBhIGxpY2Vuc2UNCj4gZGVjbGFyYXRpb24uIEkgYXNzdW1lIHRoaXMgd291bGQgaGF2ZSB0
byBiZSBhIEdQTCBoZWFkZXIsIHNpbmNlIHZtbGludXguaA0KPiByZWZlcmVuY2VzIG1hbnkgR1BM
J2QgTGludXgga2VybmVsIHN0cnVjdHMgYW5kIHNpbWlsYXIsIHRob3VnaCBhZ2FpbiBJJ20gbm90
IGENCj4gbGF3eWVyIGFuZCB0aGVyZWZvcmUgYW0gbm90IGNlcnRhaW4uIFdvdWxkIHlvdSBhbGwg
YWdyZWUgd2l0aCB0aGlzPyBJZiBzbywgYW55DQo+IG9iamVjdGlvbiB0byBhIHBhdGNoIGFkZGlu
ZyBhbiBTUERYIGxpbmUgdG8gdGhlIGdlbmVyYXRlZCB2bWxpbnV4Lmg/DQo+DQo+IElzIHZtbGlu
dXggRFdBUkYgZGF0YSBHUEwnZWQ/IEkgY2VydGFpbmx5IGhvcGUgbm90LiBTbyB2bWxpbnV4LmgN
Cj4gc2hvdWxkbid0IGJlIGxpY2Vuc2VkIHVuZGVyIEdQTC4NCg0KSSBoYXZlIG5vIGlkZWE7IEkg
aGFkIGFzc3VtZWQgdGhhdCBhIHN0cnVjdCBkZWZpbml0aW9uIGNvbWluZyBmcm9tIGEgR1BMLWxp
Y2Vuc2VkIGhlYWRlciB3b3VsZCBoYXZlIHRvIGJlIEdQTCwgYnV0IGFnYWluLCBub3QgYSBsYXd5
ZXIsIGFuZCBJIGNvdWxkIHRvdGFsbHkgYmUgd3JvbmcuIElmIG5vdCBHUEwgdGhvdWdoLCB3aGF0
IHdvdWxkIHRoZSBsaWNlbnNlIGJlPyBJcyBpdCBqdXN0ICJvdXRwdXQgb2YgYSBwcm9ncmFtIiBh
bmQgdGhlcmVmb3JlIGxpY2Vuc2UtbGVzcywgZXZlbiB0aG91Z2ggdGhlIG91dHB1dCBoYXBwZW5z
IHRvIGJlIGNvZGU/DQo=
