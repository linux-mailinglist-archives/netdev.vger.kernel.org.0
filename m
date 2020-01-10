Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB9613708C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgAJPDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:03:00 -0500
Received: from mout.gmx.net ([212.227.17.21]:39105 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgAJPC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 10:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578668575;
        bh=kZ3xcx/BgGe1lC8ogxR++j0zk1Anuq1aifgKKJqrg7w=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=AuLLC4LS/f3pP3Nyz1PEzNOQGXQkobyjjv5xs0FQ8QLbkmC7pXi6LSQoxSMJrTu6X
         P6uHB25vf6t4CvivhpKIysGaDYG5l9OOc5X7OQvNrTDWiXpZs8RYZlQvH2Cp1Vao6h
         +hcwuvXbdVZJuR+BjZ5tYhNmkIYMyRrn2btAUKJU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([84.242.21.85]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MvK0X-1jgw6Z2ZDV-00rFnm; Fri, 10
 Jan 2020 16:02:55 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <20200110114433.GZ25745@shell.armlinux.org.uk>
 <7b6f143a-7bdb-90be-00f6-9e81e21bde4e@gmx.net>
 <20200110125305.GB25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
Date:   Fri, 10 Jan 2020 15:02:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200110125305.GB25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: base64
Content-Language: en-GB
X-Provags-ID: V03:K1:znMhP8CBk2SzrfBjNhOshUR5mHI2s+85+lNC4fVv+hohOo0AEvV
 Hie3ASUzSLJHv06MWs9NipxNrm9ZtdxCbN3NTiOpoe9GMdm1AvhOzO3h9R8XJ8PsyBpUEub
 eS3Eiy2F2KLYzvFoDvBs0C8h0Qjtn07sMzkzTjU0HZaQTdfeN4l+vlZWDc0cdPn+62oSTYH
 ymGLIrrinBK19xdMtgqtg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dGhCKhn5o+w=:5uLZVnjeiLM9R2dIYUjsHK
 +6wf3f5iMrE+ZR/h0e/s9EYyWwO8W2kquw+lFQmmqbNiVWQvSS2x+JhPGplGbBiA0mLYvocsv
 aWN3enR0J3dQXYrdo83nGPwZdg3dr+VjNYHblGvqqWXj4EiSI9SDaRK/zUMEv+uuyoss+3Xzh
 0SpFyvYDPZE9qVMjXmMZdkJ7qW0sqkoU0LyBgfPQsg93HylPoMaf4LGalclEm+Aqu19IBt/Ze
 cImkR22WVqMNI5PHHL/RvbQkir3FyeDH4zL6KkS1wo1t6J6O4AMmM9ZWIREHzgeH6ggcsSYYK
 5XgzB3R4G05cGrKFWc/CBMa3wVXn0eNsqazbOZUeo1+3uroqIdHUMQacLUntXs6jmyXaVN68r
 mk/814gJ3E4l3U8XTvhlHBL1XONUi5BP5mXWP7AvKvaCxIvymd7ii8WFnDbFIhvYfpXbpdJB1
 4C3v51GovNgQkNrd6MxNNj3kKwrGYfiQuIh3HsTpakO1LZE3ztfPH/JTuxh3WZ2T9N5tsWpxq
 tD8MdBji+cIxcAQWyxSqGJtrK5GR8cEO4ltH4A8Qy+t1Z90dbbCFzpZPdjJD5AK2L3dBzI/Bw
 DGSpGiLRP8Xt1sQGu9Pnwrb5fsK5BoxU1I8DGg1j1ZoWlN4sBzw6UH1DFd/l92KTJ30hPSJ/c
 boul9/HB6IwcZIUSCGicptCRM6LK2aJY7sY81YKg5KwcQZurBeFk1xzh4y7BskE3epsOCyKvm
 OZsn7t+IpY7AICktvsPNH45INZa79Y8qob4hVxXHDU6LdxsbmcW7++k6nW0QXVB/B8Pn/kLd1
 H8Vd6R5XrR1u4vcY9nsGNojjQOGLFqFbSFEP+s9i5NX7LOw5sPEx3hap/M2pXmNFyBobJ5r2a
 ODhIIYf3y3dr9PFiDePyCseapX1AFIgGhJHBwb84bfizzRzTOv+6WmW3kqK7+4tZrzVHBgiuc
 LBu/453mRTz9uKlsLcTTXJAZdmKPbtv4U340jR+LFH+Cn5drbWlqJb5/eAxPU2UHS9W4XnNCr
 ZoDz84oB1jcMwFfzOLfT+j3w6UOCvIDc1xPRZTuNHUzorj/234vS+jGWEorNn1JMFZiWkftpK
 vQCsvM4DlQ5gMdNmlzMZrRIyMDUsyuHI8TfTo4hsoRINySdjfcAzAray8oOx6rgYzqfIPTfy+
 GPsstUjg/JkUmGtJJPHOFPnjcb/Yk/Fnx6MPEwUuHjbA/knM695iZgxY7Ti10JdhdVhc/d2k8
 c9SqwrVSxUyew8izcgTItzLId5qznfxseAIncCQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMDEvMjAyMCAxMjo1MywgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIHdy
b3RlOg0KPg0KPj4+IFdoaWNoIGlzIGFsc28gaW5kaWNhdGluZyBldmVyeXRoaW5nIGlzIGNv
cnJlY3QuICBXaGVuIHRoZSBwcm9ibGVtDQo+Pj4gb2NjdXJzLCBjaGVjayB0aGUgc3RhdGUg
b2YgdGhlIHNpZ25hbHMgYWdhaW4gYXMgY2xvc2UgYXMgcG9zc2libGUNCj4+PiB0byB0aGUg
ZXZlbnQgLSBpdCBkZXBlbmRzIGhvdyBsb25nIHRoZSB0cmFuc2NlaXZlciBrZWVwcyBpdA0K
Pj4+IGFzc2VydGVkLiAgWW91IHdpbGwgcHJvYmFibHkgZmluZCB0eC1mYXVsdCBpcyBpbmRp
Y2F0aW5nDQo+Pj4gImluICBoaSBJUlEiLg0KPj4ganVzdCBkaXNjb3ZlcmVkIHVzZXJsYW5k
IC0gZ3Bpb2luZm8gcGNhOTUzOCAtIHdoaWNoIHNlZW1zIG1vcmUgdmVyYm9zZQ0KPj4NCj4+
IGdwaW9jaGlwMiAtIDggbGluZXM6DQo+PiAgwqDCoMKgwqDCoMKgwqAgbGluZcKgwqAgMDrC
oMKgwqDCoMKgIHVubmFtZWTCoMKgICJ0eC1mYXVsdCLCoMKgIGlucHV0wqAgYWN0aXZlLWhp
Z2ggW3VzZWRdDQo+PiAgwqDCoMKgwqDCoMKgwqAgbGluZcKgwqAgMTrCoMKgwqDCoMKgIHVu
bmFtZWQgInR4LWRpc2FibGUiwqAgb3V0cHV0wqAgYWN0aXZlLWhpZ2ggW3VzZWRdDQo+PiAg
wqDCoMKgwqDCoMKgwqAgbGluZcKgwqAgMjrCoMKgwqDCoMKgIHVubmFtZWQgInJhdGUtc2Vs
ZWN0MCIgaW5wdXQgYWN0aXZlLWhpZ2ggW3VzZWRdDQo+PiAgwqDCoMKgwqDCoMKgwqAgbGlu
ZcKgwqAgMzrCoMKgwqDCoMKgIHVubmFtZWTCoMKgwqDCoMKgwqDCoCAibG9zIsKgwqAgaW5w
dXTCoCBhY3RpdmUtaGlnaCBbdXNlZF0NCj4+ICDCoMKgwqDCoMKgwqDCoCBsaW5lwqDCoCA0
OsKgwqDCoMKgwqAgdW5uYW1lZMKgwqAgIm1vZC1kZWYwIsKgwqAgaW5wdXTCoMKgIGFjdGl2
ZS1sb3cgW3VzZWRdDQo+PiAgwqDCoMKgwqDCoMKgwqAgbGluZcKgwqAgNTrCoMKgwqDCoMKg
IHVubmFtZWTCoMKgwqDCoMKgwqAgdW51c2VkwqDCoCBpbnB1dMKgIGFjdGl2ZS1oaWdoDQo+
PiAgwqDCoMKgwqDCoMKgwqAgbGluZcKgwqAgNjrCoMKgwqDCoMKgIHVubmFtZWTCoMKgwqDC
oMKgwqAgdW51c2VkwqDCoCBpbnB1dMKgIGFjdGl2ZS1oaWdoDQo+PiAgwqDCoMKgwqDCoMKg
wqAgbGluZcKgwqAgNzrCoMKgwqDCoMKgIHVubmFtZWTCoMKgwqDCoMKgwqAgdW51c2VkwqDC
oCBpbnB1dMKgIGFjdGl2ZS1oaWdoDQo+Pg0KPj4gVGhlIGFib3ZlIGlzIGRlcGljdGluZyB0
aGUgY3VycmVudCBzdGF0ZSB3aXRoIHRoZSBtb2R1bGUgd29ya2luZywgaS5lLiBiZWluZw0K
Pj4gb25saW5lLiBXaWxsIGRvIHNvbWUgdGVzdGluZyBhbmQgcmVwb3J0IGJhY2ssIG5vdCBz
dXJlIHlldCBob3cgdG8ga2VlcCBhDQo+PiBjbG9zZSB3YXRjaCByZWxhdGluZyB0byB0aGUg
ZmFpbHVyZSBldmVudHMuDQo+IEhvd2V2ZXIsIHRoYXQgZG9lc24ndCBnaXZlIHRoZSBjdXJy
ZW50IGxldmVscyBvZiB0aGUgaW5wdXRzLCBzbyBpdCdzDQo+IHVzZWxlc3MgZm9yIHRoZSBw
dXJwb3NlIEkndmUgYXNrZWQgZm9yLg0KDQpGYWlyIGVub3VnaC4gT3BlcmF0aW9uYWwgKG9u
bGluZSkgc3RhdGUNCg0KZ3Bpb2NoaXAyOiBHUElPcyA1MDQtNTExLCBwYXJlbnQ6IGkyYy84
LTAwNzEsIHBjYTk1MzgsIGNhbiBzbGVlcDoNCiDCoGdwaW8tNTA0ICggfHR4LWZhdWx0wqDC
oMKgwqAgKSBpbsKgIGxvIElSUQ0KIMKgZ3Bpby01MDUgKCB8dHgtZGlzYWJsZcKgwqAgKSBv
dXQgbG8NCiDCoGdwaW8tNTA2ICggfHJhdGUtc2VsZWN0MCApIGluwqAgbG8NCiDCoGdwaW8t
NTA3ICggfGxvc8KgwqDCoMKgwqDCoMKgwqDCoCApIGluwqAgbG8gSVJRDQogwqBncGlvLTUw
OCAoIHxtb2QtZGVmMMKgwqDCoMKgICkgaW7CoCBsbyBJUlENCg0KQW5kIHRoZSBzYW1lIHJl
bWFpbmVkICh1bmNoYW5nZWQpIGR1cmluZy9hZnRlciB0aGUgZXZlbnRzIChhcyBjbG9zZWx5
IEkgDQp3YXMgYWJsZSB0byBtb25pdG9yKSAtPiBtb2R1bGUgdHJhbnNtaXQgZmF1bHQgaW5k
aWNhdGVkDQoNCktlcHQgYW4gZXllIG9uIHRoZSBsaW5rIHN0YXRlIG9mIHRoZSBOSUMgKGV0
aDIpIGFzIHdlbGwgd2l0aCAtIGlwIG1vIGwgDQpkZXYgZXRoMiAtIGFuZCBpdCBkb2VzIG5v
dCBjb21lIHVwIGVpdGhlciB3aXRoIHRob3NlIHRyYW5zbWl0IGZhdWx0cyBhbmQgDQpvbmx5
IGdldHMgYmFjayBvbmxpbmUgb25jZSB0aGUgdHJhbnNtaXQgZmF1bHRzIGFyZSBjbGVhcmVk
Lg0KDQpBdCBsb3NzIHJlYWxseSwgc2luY2UgaXQgc2VlbXMgdGhlIFNGUCBpcyBub3QgZXho
aWJpdGluZyBhbnkgbWlzY2hpZXZvdXMgDQpiZWhhdmlvdXIuIEl0IGRvZXMgbm90IGV2ZW4g
cmVwcm9kdWNlIHJlbGlhYmx5LCBqdXN0IG5vdyBpdCB0b29rIGEgDQpjb3VwbGUgb2YgYXR0
ZW1wdHMgdG8gaW52b2tlIHRoZSB0cmFuc21pdCBmYXVsdCBhbmQgb3RoZXIgdGltZXMgaXQg
ZG9lcyANCnN0cmFpZ2h0IGF3YXkuDQpTdXBwb3NlIHRoZXJlIGNvdWxkIGJlIGFsd2F5cyBh
IGhhcmR3YXJlIGRlZmVjdCB0aG91Z2ggaXQgc2VlbXMgc29tZXdoYXQgDQp1bmxpa2VseS4g
VGhhdCBzYWlkLCBJIGRvIG5vdCBoYXZlIGFub3RoZXIgc3VjaCBtb2R1bGUgYXZhaWxhYmxl
IHRvIHN3YXAgDQpmb3IgdGVzdGluZy4NCg0KDQoNCg0KDQo=
