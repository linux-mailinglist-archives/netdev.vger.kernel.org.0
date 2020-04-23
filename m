Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912B91B5B1F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgDWMMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:12:55 -0400
Received: from out20-2.mail.aliyun.com ([115.124.20.2]:52475 "EHLO
        out20-2.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgDWMMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 08:12:55 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2567466|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.035747-0.00152081-0.962732;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03278;MF=mao-linux@maojianwei.com;NM=1;PH=DW;RN=7;RT=7;SR=0;TI=W4_5844326_v5_0A9326FE_1587643970528_o7001c19591;
Received: from WS-web (mao-linux@maojianwei.com[W4_5844326_v5_0A9326FE_1587643970528_o7001c19591]) by e01l07382.eu6 at Thu, 23 Apr 2020 20:12:50 +0800
Date:   Thu, 23 Apr 2020 20:12:50 +0800
From:   "=?UTF-8?B?SmlhbndlaSBNYW8gKE1hbyk=?=" <mao-linux@maojianwei.com>
To:     "Dave Taht" <dave.taht@gmail.com>
Cc:     "netdev" <netdev@vger.kernel.org>, "davem" <davem@davemloft.net>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>, "kuba" <kuba@kernel.org>,
        "lkp" <lkp@intel.com>
Reply-To: "=?UTF-8?B?SmlhbndlaSBNYW8gKE1hbyk=?=" <mao-linux@maojianwei.com>
Message-ID: <83b0fb79-c349-4e64-8d5a-72e913670002.mao-linux@maojianwei.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBuZXQtbmV4dCB2Ml0gbmV0OiBpcHY2OiBzdXBwb3J0IEFwcGxpY2F0aW9u?=
  =?UTF-8?B?LWF3YXJlIElQdjYgTmV0d29yayAoQVBONik=?=
X-Mailer: [Alimail-Mailagent revision 4][W4_5844326][v5][Chrome]
MIME-Version: 1.0
References: <49178de1-75cc-4736-b572-1530a0d5fccf.mao-linux@maojianwei.com> <a9a64f23-ed11-4b8d-b7be-75c686ad87fb.mao-linux@maojianwei.com>,<CAA93jw4imiBa9JBjAs4p5R1bM_asBiTQzKE9zqnNVKRmGB=aYQ@mail.gmail.com>
In-Reply-To: <CAA93jw4imiBa9JBjAs4p5R1bM_asBiTQzKE9zqnNVKRmGB=aYQ@mail.gmail.com>
x-aliyun-mail-creator: W4_5844326_v5_M2ITW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzgxLjAuNDA0NC4xMTMgU2FmYXJpLzUzNy4zNg==3L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwKClRoYW5rcyBmb3IgeW91ciBhdHRlbnRpb24gOikKCjEuIEFQTjYgaGFzIG5vIGFz
c29jaWF0aW9uIHdpdGggc3ByaW5nIGFuZCBvYW0sIGFsdGhvdWdoIG90aGVyIHBlb3BsZSBjYW4K
ZGVzaWduIGFuIEFQTjYtZHJpdmVuIFNSLCBvciBBUE42LWRyaXZlbiBPQU0gc29sdXRpb24uClNv
IHdlIGNhbiBwcm9tb3RlIHRoaXMgbGludXggY29kZSB3b3JrIGZvciBBUE42LgoKMi4gWWVzLCBp
biBoaWdoLWxldmVsLWRlc2lnbiBvZiBBUE42LCB3ZSB3aWxsIGZpbmFsbHkgYnVpbGQgYSB3aG9s
ZSAKQVBONiBzeXN0ZW0vc29sdXRpb24gc2V0IHVwIHdpdGggbGludXggc2VydmVycywgcm91dGVy
cywgc3dpdGNoZXMsIGV0Yy4KQW5kIHdlIGFyZSBhbHNvIGRvaW5nIHRoYXQgdGhpbmcsIGFuZCBs
aW51eCBrZXJuZWwgaXMgc3VyZWx5IG9uZSBrZXkgc3RlcAp0byBidWlsZCB0aGF0LiBCdHcsIGlm
IHlvdSBoYXZlIGludGVyZXN0cyBmb3IgdGhhdCwgeW91J3JlIHdlbGNvbWUgdG8gZW5qb3kKdGhl
IEFQTjYgZGVtbyBpbiAyMDIwIEludGVyb3AgU2hvd05ldCAoaXQgd2lsbCBiZSBoZWxkIG9ubGlu
ZSBmb3IgdGhpcyB5ZWFyKS4KCjMuIEluIHRoaXMgcGF0Y2gsIHdlIGhhdmUgY29uc2lkZXJlZCBh
cmJpdHJhcnkgaW5qZWN0aW9uIHByb2JsZW0KYXMgeW91IG1lbnRpb25lZC4gQW5kIHRoaXMgcGF0
Y2gganVzdCBhbGxvd3MgYXBwbGljYXRpb25zIHRvIGNvbmZpZyB0aHJlZQpmaWVsZHMgKFNMQSwg
QXBwSWQsIGFuZCBVc2VySWQpLCB3aGljaCBhcmUgYWxsb2NhdGVkIGJ5IG5ldHdvcmsgb3BlcmF0
b3IKYW5kIGFwcGxpY2F0aW9uIHNlcnZlciwgbW9yZW92ZXIsIHRoZXkgd2lsbCBiZSB2ZXJpZmll
ZCBieSBuZXR3b3JrIGRldmljZXMKKHJvdXRlci9icmFzL2V0Yy4pLgpJbiBjb25jbHVzaW9uLCBp
biBBUE42LCB0aGlzIHBhdGNoIG1ha2VzIGxpbnV4IGFjdCBhcyBlbmQgZGV2aWNlLApzbyBpdCB3
aWxsIG5vdCBhZmZlY3RlZCBieSB0aGF0IHByb2JsZW0gYW5kIGVuLXJvdXRlIG10dSBwcm9ibGVt
LiA6KQoKVGhhbmtzLApNYW8KCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpGcm9tOkRhdmUgVGFodCA8ZGF2ZS50YWh0QGdt
YWlsLmNvbT4KU3ViamVjdDpSZTogW1BBVENIIG5ldC1uZXh0IHYyXSBuZXQ6IGlwdjY6IHN1cHBv
cnQgQXBwbGljYXRpb24tYXdhcmUgSVB2NiBOZXR3b3JrIChBUE42KQoKYXMgbmVhciBhcyBJIGNh
biB0ZWxsLCB0aGlzIGlzIG5vdCBldmVuIGFuIGFjY2VwdGVkIHdvcmtpbmcgZ3JvdXAgaXRlbQpp
biBpZXRmIDZtYW4uICg/KS4gTm9ybWFsbHkgSSB3ZWxjb21lIHJ1bm5pbmcgY29kZSBsb25nIGJl
Zm9yZSByb3VnaApjb25zZW5zdXMsIGJ1dCBpbiB0aGlzIGNhc2UgSSB3b3VsZCBiZSBpbmNsaW5l
ZCB0byB3YWl0LiBUaGVyZSBhbHNvCnNlZW1zIHRvIGJlIHNvbWUgc29tZXdoYXQgY29uZmxpY3Rp
bmcgaWRlYXMgaW4gc3ByaW5nIGFuZCBvYW0gdGhhdApuZWVkIHdvcmtpbmcgb3V0LgoKSXQgd291
bGQgYmUgZ29vZCB0byBoYXZlIGFuIGV4YW1wbGUgaW1wbGVtZW50YXRpb24gdGhhdCBjb3VsZCBh
Y3R1YWxseQpwYXJzZSBhbmQgImRvIHNtYXJ0IHRoaW5ncyIgd2l0aCB0aGlzIGFkZGl0aW9uYWwg
aGVhZGVyLCBlLmcgYSB0YwpmaWx0ZXIsIGVicGYsIGV0Yy4gSXQgaGFzIHRoZSBzYW1lIGZsYXdz
IGRpZmZzZXJ2IGhhcyBhbHdheXMgaGFkIGluCnRoYXQgYW55IGFwcGxpY2F0aW9uIGNhbiBzZXQg
dGhlc2UgZmllbGRzIGFyYml0cmFyaWx5LCB3aXRoIHRoZQphZGRpdGlvbmFsIGZsYXcgb2YgY2hh
bmdpbmcgdGhlIG10dSBpZiB0aGVzZSBoZWFkZXJzIGFyZSBhZGRlZCBvcgptb2RpZmllZCBlbi1y
b3V0ZS4K
