Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACED02FB9A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 14:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfE3McZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 08:32:25 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:56707 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3McY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 08:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559219543; x=1590755543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GMk8+adGK5vN4C/6KWIWty74TJ0xOCCRqK6YeRNytCk=;
  b=JIhhh4Z4khZfsXdXiRKts8wunw7srl3g3KBtfT6qyYUoJiZIZb4it4ul
   Z/6g3PUFm2+6YRIR7730PkqJcEfr/fgmetXOwokhMa6swkynOwwP3CJcy
   UykJuDbt+vw8hg0FJiiNDg4EZJLhaRC/2uBLk+NPbGRHmMW8IjsY49HJr
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,531,1549929600"; 
   d="scan'208";a="398654532"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 30 May 2019 12:32:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 9E5B6C5A7B;
        Thu, 30 May 2019 12:32:20 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 30 May 2019 12:32:20 +0000
Received: from EX13D07UWB001.ant.amazon.com (10.43.161.238) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 30 May 2019 12:32:19 +0000
Received: from EX13D07UWB001.ant.amazon.com ([10.43.161.238]) by
 EX13D07UWB001.ant.amazon.com ([10.43.161.238]) with mapi id 15.00.1367.000;
 Thu, 30 May 2019 12:32:19 +0000
From:   "Agarwal, Anchal" <anchalag@amazon.com>
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        Anchal Agarwal <anchalag@amzn.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>
CC:     "Kamata, Munehisa" <kamatam@amazon.com>,
        Julien Grall <julien.grall@arm.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
        Artem Mygaiev <Artem_Mygaiev@epam.com>
Subject: Re: [Xen-devel] [PATCH] xen/netfront: Remove unneeded .resume
 callback
Thread-Topic: [Xen-devel] [PATCH] xen/netfront: Remove unneeded .resume
 callback
Thread-Index: AQHU3XHlCpbiTAsN1kC5I2kNeHI9laYT5R2AgAOYd4CAB5efmIACqUoAgEvnMYCAFfGGgA==
Date:   Thu, 30 May 2019 12:32:19 +0000
Message-ID: <F76E91F5-0981-4233-A7F9-072B7026D404@amazon.com>
References: <6205819a-af39-8cd8-db87-f3fe047ff064@gmail.com>
 <ecc825e6-89d3-bbd5-5243-5cc66fa93045@oracle.com>
 <b55d4f90-100c-7a2a-9651-c99c06953465@gmail.com>
 <09afcdca-258f-e5ca-5c31-b7fd079eb213@oracle.com>
 <3e868e7a-4872-e8ab-fd2c-90917ad6d593@arm.com>
 <d709d185-5345-c463-3fd1-e711f954e58a@gmail.com>
 <435369ba-ad3b-1d3a-c2f4-babe8bb6189c@amazon.com>
 <fde362d0-dd48-9c9a-e71a-8fb158909551@epam.com>
 <20190325173011.GA20277@kaos-source-ops-60001.pdx1.amazon.com>
 <f5e824de-da57-9574-3813-2668f2932a6e@gmail.com>
 <20190328231928.GA5172@kaos-source-ops-60001.pdx1.amazon.com>
 <48fedb13-5af2-e7cf-d182-0f2bb385dda2@gmail.com>
In-Reply-To: <48fedb13-5af2-e7cf-d182-0f2bb385dda2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.161.145]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AE9E09634A3B34695C563DBA263885A@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NhbmRyLA0KDQrvu78gICAgSGVsbG8sIEFuY2hhbCENCiAgICANCiAgICBPbiAzLzI5
LzE5IDE6MTkgQU0sIEFuY2hhbCBBZ2Fyd2FsIHdyb3RlOg0KICAgIFtzbmlwXQ0KICAgID4+Pj4g
R3JlYXQsIGNvdWxkIHlvdSBwbGVhc2UgbGV0IHVzIGtub3cgd2hhdCBpcyB0aGUgcHJvZ3Jlc3Mg
YW5kIGZ1cnRoZXIgcGxhbnMNCiAgICA+Pj4+IG9uIHRoYXQsIHNvIHdlIGRvIG5vdCB3b3JrIG9u
IHRoZSBzYW1lIGNvZGUgYW5kIGNhbiBjb29yZGluYXRlIG91cg0KICAgID4+Pj4gZWZmb3J0cyBz
b21laG93PyBBbmNoYWwsIGNvdWxkIHlvdSBwbGVhc2Ugc2hlZCBzb21lIGxpZ2h0IG9uIHRoaXM/
DQogICAgPj4+IExvb2tzIGxpa2UgbXkgcHJldmlvdXMgZW1haWwgZGlkIG5vdCBtYWtlIGl0IHRv
IG1haWxpbmcgbGlzdC4gTWF5IGJlIHNvbWUgaXNzdWVzIHdpdGggbXkNCiAgICA+Pj4gZW1haWwg
c2VydmVyIHNldHRpbmdzLiBHaXZpbmcgaXQgYW5vdGhlciBzaG90Lg0KICAgID4+PiBZZXMsIEkg
YW0gd29ya2luZyBvbiB0aG9zZSBwYXRjaGVzIGFuZCBwbGFuIHRvIHJlLXBvc3QgdGhlbSBpbiBh
biBlZmZvcnQgdG8gdXBzdHJlYW0uDQogICAgPj4gVGhpcyBpcyByZWFsbHkgZ3JlYXQsIGxvb2tp
bmcgZm9yd2FyZCB0byBpdDogYW55IGRhdGUgaW4geW91ciBtaW5kDQogICAgPj4gd2hlbiB0aGlz
IGNhbiBoYXBwZW4/DQogICAgPiBOb3QgYSBzcGVjaWZpYyBkYXRlIGJ1dCBtYXkgYmUgaW4gZmV3
IHdlZWtzLiBJIGFtIGN1cnJlbnRseSBzd2FtcGVkIGF0IHdvcmsuDQogICAgPg0KICAgIEFueSBw
cm9ncmVzcyBvbiB0aGlzPw0KDQpZZXMsIGJ1dCBhdCBhIHNuYWlsJ3MgcGFjZS4NCiAgICANCiAg
ICBUaGFuayB5b3UsDQogICAgT2xla3NhbmRyDQoNClRoYW5rcywNCkFuY2hhbCAgICANCg0K
