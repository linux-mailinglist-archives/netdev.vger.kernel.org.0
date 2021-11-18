Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9874551FC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbhKRBLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbhKRBLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:11:17 -0500
X-Greylist: delayed 2139 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Nov 2021 17:08:18 PST
Received: from mx0a-00206401.pphosted.com (mx0a-00206401.pphosted.com [IPv6:2620:100:9001:15::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962E1C061570;
        Wed, 17 Nov 2021 17:08:18 -0800 (PST)
Received: from pps.filterd (m0207806.ppops.net [127.0.0.1])
        by mx0b-00206401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AHIGOmd007251;
        Wed, 17 Nov 2021 16:32:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crowdstrike.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=default; bh=E9sLE13DG/10KzQQ/ubPchdVW3nTVeEooj1hU69PEOM=;
 b=OZrapIq3/9N3J/XFg0Me7yFTX84MjZeiBmVFw1E9RwpLE4mnnyINMdx+3UGPkBkQ5y6n
 XmS2X/TIUW3cvpisx48WDdwslgyQALz5aVPddQJRY+6tTe2SSFtOu8M70oi6m9lrO4W+
 zaLIaGBVRghyv770sDW6T+UJivW9QoiFzZZNwBH0uHv4xv+32f3b5p3HCpp6x81NObWk
 gZ7RM0VGacxpHnBBiuB4lQPms3Epd7q2FbpUDcsXij1PYJSm0f+XyZD2L3uzL2TEvmnB
 wyRfshK7gaeNX3cmOwuqruTXJmS8qN/Rkjs8B0npRgno1Ll3BvMuk7e/m0Z7deqk+41G ZQ== 
Received: from 04wpexch03.crowdstrike.sys (dragosx.crowdstrike.com [208.42.231.60])
        by mx0b-00206401.pphosted.com (PPS) with ESMTPS id 3cd6vcgh4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 16:32:18 -0800
Received: from 04wpexch03.crowdstrike.sys (10.100.11.93) by
 04wpexch03.crowdstrike.sys (10.100.11.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Thu, 18 Nov 2021 00:32:17 +0000
Received: from 04wpexch03.crowdstrike.sys ([fe80::79d6:26ee:13ba:99d2]) by
 04wpexch03.crowdstrike.sys ([fe80::79d6:26ee:13ba:99d2%5]) with mapi id
 15.02.0922.019; Thu, 18 Nov 2021 00:32:17 +0000
From:   Martin Kelly <martin.kelly@crowdstrike.com>
To:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrii@kernel.org" <andrii@kernel.org>
Subject: RE: Re: Clarification on bpftool dual licensing
Thread-Topic: Re: Clarification on bpftool dual licensing
Thread-Index: AdfcC7I4ay3ZuRCwQHqFumJ1n8mnnw==
Date:   Thu, 18 Nov 2021 00:31:52 +0000
Deferred-Delivery: Thu, 18 Nov 2021 00:31:43 +0000
Message-ID: <a126299d31954240a7490428feccb5b1@crowdstrike.com>
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
 definitions=2021-11-17_09,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pg0KPiBPbiBUdWUsIE5vdiAxNiwgMjAyMSBhdCAyOjE2IEFNIERhbmllbCBCb3JrbWFubiA8ZGFu
aWVsQGlvZ2VhcmJveC5uZXQ+DQo+IHdyb3RlOg0KPiA+DQo+ID4gT24gMTEvMTUvMjEgNzoyMCBQ
TSwgTWFydGluIEtlbGx5IHdyb3RlOg0KPiA+ID4gSGksDQo+ID4gPg0KPiA+ID4gSSBoYXZlIGEg
cXVlc3Rpb24gcmVnYXJkaW5nIHRoZSBkdWFsIGxpY2Vuc2luZyBwcm92aXNpb24gb2YgYnBmdG9v
bC4gSQ0KPiA+ID4gdW5kZXJzdGFuZCB0aGF0IGJwZnRvb2wgY2FuIGJlIGRpc3RyaWJ1dGVkIGFz
IGVpdGhlciBHUEwgMi4wIG9yIEJTRCAyLQ0KPiBjbGF1c2UuDQo+ID4gPiBUaGF0IHNhaWQsIGJw
ZnRvb2wgY2FuIGFsc28gYXV0by1nZW5lcmF0ZSBCUEYgY29kZSB0aGF0IGdldHMgc3BlY2lmaWVk
IGlubGluZQ0KPiA+ID4gaW4gdGhlIHNrZWxldG9uIGhlYWRlciBmaWxlLCBhbmQgaXQncyBwb3Nz
aWJsZSB0aGF0IHRoZSBCUEYgY29kZSBnZW5lcmF0ZWQgaXMNCj4gPiA+IEdQTC4gV2hhdCBJJ20g
d29uZGVyaW5nIGlzIHdoYXQgaGFwcGVucyBpZiBicGZ0b29sIGdlbmVyYXRlcyBHUEwtbGljZW5z
ZWQNCj4gQlBGDQo+ID4gPiBjb2RlIGluc2lkZSB0aGUgc2tlbGV0b24gaGVhZGVyLCBzbyB0aGF0
IHlvdSBnZXQgYSBoZWFkZXIgbGlrZSB0aGlzOg0KPiA+ID4NCj4gPiA+IHNvbWV0aGluZy5za2Vs
Lmg6DQo+ID4gPiAvKiB0aGlzIGZpbGUgaXMgQlNEIDItY2xhdXNlLCBieSBuYXR1cmUgb2YgZHVh
bCBsaWNlbnNpbmcgKi8NCj4gPg0KPiA+IEZ3aXcsIHRoZSBnZW5lcmF0ZWQgaGVhZGVyIGNvbnRh
aW5zIGFuIFNQRFggaWRlbnRpZmllcjoNCj4gPg0KPiA+ICAgLyogU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IChMR1BMLTIuMSBPUiBCU0QtMi1DbGF1c2UpICovDQo+ID4gICAvKiBUSElTIEZJTEUg
SVMgQVVUT0dFTkVSQVRFRCEgKi8NCj4gPg0KPiA+ID4gLyogVEhJUyBGSUxFIElTIEFVVE9HRU5F
UkFURUQhICovDQo+ID4gPg0KPiA+ID4gLyogc3RhbmRhcmQgc2tlbGV0b24gZGVmaW5pdGlvbnMg
Ki8NCj4gPiA+DQo+ID4gPiAuLi4NCj4gPiA+DQo+ID4gPiBzLT5kYXRhX3N6ID0gWFhYOw0KPiA+
ID4gcy0+ZGF0YSA9ICh2b2lkICopIlwNCj4gPiA+IDxlQlBGIGJ5dGVjb2RlLCBwcm9kdWNlZCBi
eSBHUEwgMi4wIHNvdXJjZXMsIHNwZWNpZmllZCBpbiBiaW5hcnk+DQo+ID4gPiAiOw0KPiA+ID4N
Cj4gPiA+IE15IGd1ZXNzIGlzIHRoYXQsIGJhc2VkIG9uIHRoZSBjaG9pY2UgdG8gZHVhbC1saWNl
bnNlIGJwZnRvb2wsIHRoZSBoZWFkZXIgaXMNCj4gPiA+IG1lYW50IHRvIHN0aWxsIGJlIEJTRCAy
LWNsYXVzZSwgYW5kIHRoZSBzLT5kYXRhIGlubGluZSBjb2RlJ3MgR1BMIGxpY2Vuc2UgaXMNCj4g
PiA+IG5vdCBtZWFudCB0byBjaGFuZ2UgdGhlIGxpY2Vuc2luZyBvZiB0aGUgaGVhZGVyIGl0c2Vs
ZiwgYnV0IEkgd2FudGVkIHRvDQo+DQo+IFllcywgZGVmaW5pdGVseSB0aGF0IGlzIHRoZSBpbnRl
bnQgKGJ1dCBub3QgYSBsYXd5ZXIgZWl0aGVyKS4NCg0KIFRoYW5rcyBldmVyeW9uZSwgdGhhdCdz
IHdoYXQgSSBhc3N1bWVkIGFzIHdlbGwuIEFueSBvYmplY3Rpb24gdG8gYSBwYXRjaCBjbGFyaWZ5
aW5nIHRoaXMgbW9yZSBleHBsaWNpdGx5Pw0KDQpPbmUgb3RoZXIsIHJlbGF0ZWQgcXVlc3Rpb246
IHZtbGludXguaCAoZ2VuZXJhdGVkIGJ5ICJicGZ0b29sIGJ0ZiBkdW1wIGZpbGUgL3N5cy9rZXJu
ZWwvYnRmL3ZtbGludXggZm9ybWF0IGMiKSwgZG9lcyBub3QgY3VycmVudGx5IGNvbnRhaW4gYSBs
aWNlbnNlIGRlY2xhcmF0aW9uLiBJIGFzc3VtZSB0aGlzIHdvdWxkIGhhdmUgdG8gYmUgYSBHUEwg
aGVhZGVyLCBzaW5jZSB2bWxpbnV4LmggcmVmZXJlbmNlcyBtYW55IEdQTCdkIExpbnV4IGtlcm5l
bCBzdHJ1Y3RzIGFuZCBzaW1pbGFyLCB0aG91Z2ggYWdhaW4gSSdtIG5vdCBhIGxhd3llciBhbmQg
dGhlcmVmb3JlIGFtIG5vdCBjZXJ0YWluLiBXb3VsZCB5b3UgYWxsIGFncmVlIHdpdGggdGhpcz8g
SWYgc28sIGFueSBvYmplY3Rpb24gdG8gYSBwYXRjaCBhZGRpbmcgYW4gU1BEWCBsaW5lIHRvIHRo
ZSBnZW5lcmF0ZWQgdm1saW51eC5oPw0K
